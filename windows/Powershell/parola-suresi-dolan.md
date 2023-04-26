Import-Module ActiveDirectory
 
$DaysWithinExpiration = 10
 
$MaxPwdAge   = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days
$expiredDate = (Get-Date).addDays(-$MaxPwdAge)
 
$emailDate = (Get-Date).addDays(-($MaxPwdAge - $DaysWithinExpiration))
 
$ExpiredUsers = Get-ADUser -Filter {(PasswordLastSet -lt $emailDate) -and (PasswordLastSet -gt $expiredDate) -and (PasswordNeverExpires -eq $false) -and (Enabled -eq $true)} -Properties PasswordNeverExpires, PasswordLastSet, Mail | select samaccountname, PasswordLastSet, @{name = "DaysUntilExpired"; Expression = {$_.PasswordLastSet - $ExpiredDate | select -ExpandProperty Days}}, @{name = "EmailAddress"; Expression = {$_.mail}} | Sort-Object PasswordLastSet
 
$ExpiredUsers
