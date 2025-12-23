Import-Module ActiveDirectory -ErrorAction SilentlyContinue

$Users = Import-Csv .\Documents\users.csv
$Partial_DNpath = "OU=_Users,DC=helplab,DC=local"
$Password_Def = (ConvertTo-SecureString "password123!" -AsPlainText -force) # Note: ConvertTo-SecureString is not secure for storing passwords 

foreach ($User in $Users) {
    $DNpath = "OU=$($User.OU),$Partial_DNpath" # Specify Domain Name path for user
    
    # Create AD User account
    try {
        New-ADUser -SamAccountName $User.SamAccountName -Name $User.SamAccountName -AccountPassword $Password_Def -ChangePasswordAtLogon $true -Path $DNpath -Enabled $true
    }
    catch [System.Object] {
        Write-Host "ERROR: Unable to create user $($User.SamAccountName), $_"
    }
    
    # Add User to security group
    try {
        Add-ADGroupMember -Identity $User.Group -Members $User.SamAccountName
    }
    catch [System.Object]{
        Write-Host "ERROR: Unable to add $($User.SamAccountName) to group, $_"
    }
}
