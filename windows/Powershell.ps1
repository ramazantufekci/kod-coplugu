<#
#Author:Ramazan TÜFEKÇİ
#Website:https://ramazantufekci.com
#github:ramazantufekci
#aşağıdaki komutlar belirlenen tarihden sonra giriş yapan kullanıcının şifre değiştirme iznini kontrol ederek
#izni yoksa izin verilmesini sağlar
#object id kullanıcıları taşımak için gerekli
#ornek
#Move-ADObject -Identity $userObject.'obj_id' -TargetPath "OU=taşıma yapılacak ou,DC=dc,DC=local"
#>
$users = Get-ADUser -Server DC.local -Filter * | select SamAccountName
$kontrol_tarih = "01.01.2019 00:00:00"
foreach($user in $users)
{
    $userInfo = Get-ADUser -Server DC.local -Properties * -Identity $user.SamAccountName
    $userProp = @{
        'Kullanıcı ismi' = $userInfo.SamAccountName
        'Oluşturulma Tarihi' = $userInfo.whenCreated
        'Şifre Değiştirme Tarihi' = $userInfo.PasswordLastSet
        'Son Login Tarihi' = $userInfo.LastLogonDate
        'obj_id' = $userInfo.ObjectGUID
        'Şifre değiştirme izni' = $userInfo.CannotChangePassword

    }
    $userObject = New-Object PSObject -Property $userProp
    #-gt kontrolu -le olarak değiştirildiğinde kontrol_tarih inden küçük olanları getirir
    if($userObject.'Son Login Tarihi' -gt $kontrol_tarih){
        if($userObject.'Şifre değiştirme' -eq $true){
        #kullanıcının şifre değiştirme iznini değiştirir
        Set-ADUser -Identity $userObject.'Kullanıcı ismi' -CannotChangePassword $false
        #bilgileri export eder.
        #$userObject | select 'Kullanıcı ismi','Oluşturulma Tarihi','Şifre Değiştirme Tarihi','Son Login Tarihi','obj_id','Şifre değiştirme'|Export-Csv -Append "Rapor.csv" -NoTypeInformation -Delimiter ";" -Encoding UTF8
        }
    }
}
