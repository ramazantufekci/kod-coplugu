Tek gereksinim, AD’de depolanan bilgileri sorgulayabilmek için Active Directory Powershell modülüne ihtiyacınız olmasıdır. Ayrıca, e-posta gönder parametresini kullanmayı planlıyorsanız, kendi smtp sunucunuzdan gönderebilmek için 88-92 satırlarını değiştirmeniz gerekecektir.
```powershell
Function Get-PasswordExpirationDate {
#requires -Module ActiveDirectory
<#
.EXAMPLE
    Get-PasswordExpirationDate 15
 
.EXAMPLE
    Get-PasswordExpirationDate -DaysWithinExpiration 10 -SendEmail
 
.EXAMPLE
    Get-PasswordExpirationDate -SamAccountName Username1, username2
 
#>
 
    [CmdletBinding(DefaultParameterSetName="AllAccounts")]
    param(
        [Parameter(
            Position = 0,
            Mandatory = $false,
            ParameterSetName = "AllAccounts"
        )]
        [ValidateRange(1,365)]
        [int]       $DaysWithinExpiration = 10,
 
 
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "AllAccounts"
        )]
        [switch]    $SendEmail,
 
 
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "SpecificAccounts",
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
            )]
        [string[]]  $SamAccountName
    )
 
    BEGIN {}
 
    PROCESS {
        #Calculating the expired date from the domain's default password policy. -- Do Not Modify --
        $MaxPwdAge   = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days
        $expiredDate = (Get-Date).addDays(-$MaxPwdAge)
 
        #Calculating the number of days until you would like to begin notifying the users. -- Do Not Modify --
        $emailDate = (Get-Date).addDays(-($MaxPwdAge - $DaysWithinExpiration))
 
        #Since specific accounts were specified we'll output their password expiration dates regardless if they are within the expiration date
        if ($PSBoundParameters.ContainsKey("SamAccountName")) {
            foreach ($User in $SamAccountName) {
                try {
                    $ADObject = Get-ADUser $User -Properties PasswordNeverExpires, PasswordLastSet, EmailAddress
                    if ($ADObject.PasswordNeverExpires -eq $true) {
                        $DaysUntilExpired = "NeverExpire"
                      } else {
                        $DaysUntilExpired = $ADObject.PasswordLastSet - $ExpiredDate | select -ExpandProperty Days
                    }
                    [PSCustomObject]@{
                        SamAccountName   = $ADObject.samaccountname.toLower()
                        PasswordLastSet  = $ADObject.PasswordLastSet
                        DaysUntilExpired = $DaysUntilExpired
                        EmailAddress     = $ADObject.EmailAddress
                    }
                } catch {
                    Write-Error $_.Exception.Message
                }
            }
        } else {
            $ExpiredAccounts = Get-ADUser -Filter {(PasswordLastSet -lt $EmailDate) -and (PasswordLastSet -gt $ExpiredDate) -and (PasswordNeverExpires -eq $false) -and (Enabled -eq $true)} -Properties PasswordNeverExpires, PasswordLastSet, EmailAddress
            foreach ($ADObject in $ExpiredAccounts) {
                try {
                    $DaysUntilExpired = $ADObject.PasswordLastSet - $ExpiredDate | select -ExpandProperty Days
                    if ($PSBoundParameters.ContainsKey("SendEmail") -and $null -ne $ADObject.EmailAddress) {
                        #Setting up email parameters to send a notification email to the user
                        $From       = "test@babur.com"
                        $Subject    = "Parola süreniz " + $DaysUntilExpired + " gün içinde dolacak."
                        $Body       = "Merhaba,`n`n Bu mail parola süreniz  " + $DaysUntilExpired + " gün içinde dolacağı için tarafınıza iletilmiştir.`n`nLütfen hizmet kesintisi yaşamamak adına parolanızı değiştiriniz..`n`nTeşekkürler,`nBilgi Teknolojileri Departmanı"
                        $smtpServer = "mail.babur.com"
                        #$CC        =  "cc1@babur.com", "cc2@babur.com"
 
                        Send-MailMessage -To $($ADObject.EmailAddress) -From $From -Subject $Subject -BodyAsHtml $Body -SmtpServer $SmtpServer #-Priority High -Cc $CC
                    }
                    [PSCustomObject]@{
                        SamAccountName   = $ADObject.samaccountname.toLower()
                        PasswordLastSet  = $ADObject.PasswordLastSet
                        DaysUntilExpired = $DaysUntilExpired
                        EmailAddress     = $ADObject.EmailAddress
                    }
                } catch {
                    Write-Error $_.Exception.Message
                }
            }
        }
    }
 
    END {}
 
}
```
```powershell
get-PasswordExpirationDate -DaysWithinExpiration 10 -SendEmail
```
