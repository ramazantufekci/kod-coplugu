Set-ExecutionPolicy RemoteSigned
$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

Import-PSSession $Session -DisableNameChecking

$mailbox = Get-Mailbox -RecipientTypeDetails UserMailbox
foreach($mail in $mailbox)
{
    if($mail.Office -eq "Muhasebe")
    {
        write-host $mail.Name
        $yap = Set-Mailbox -Identity $mail.UserPrincipalName -CustomAttribute1 "Muhasebe"
        write-host $yap
    }
}
