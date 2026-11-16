# ad-structure.ps1 - Phase 4 : OU, groupes et comptes de entreprise.test
# Relancable sans risque : ce qui existe deja n'est pas recree.
param([string]$CsvPath = "C:\Scripts\users.csv")

Import-Module ActiveDirectory
$domain   = Get-ADDomain
$domainDN = $domain.DistinguishedName
$root     = "OU=Entreprise,$domainDN"
$services = "Comptabilite","Commercial","Operations","RH","Direction","Informatique"

function Add-OU($Name, $Path) {
    $dn = "OU=$Name,$Path"
    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$dn'")) {
        New-ADOrganizationalUnit -Name $Name -Path $Path
        Write-Host "OU creee : $dn" -ForegroundColor Green
    }
}

# 1. Les OU
Add-OU "Entreprise" $domainDN
foreach ($ou in "Utilisateurs","Postes","Serveurs","Groupes") { Add-OU $ou $root }
foreach ($s in $services) { Add-OU $s "OU=Utilisateurs,$root" }

# 2. Les groupes (modele AGDLP)
$groupsOU = "OU=Groupes,$root"
foreach ($s in $services) {
    $gg = "GG_$s"
    if (-not (Get-ADGroup -Filter "Name -eq '$gg'")) {
        New-ADGroup -Name $gg -GroupScope Global -GroupCategory Security -Path $groupsOU
        Write-Host "Groupe cree : $gg" -ForegroundColor Green
    }
    foreach ($droit in "RW","RO") {
        $dl = "DL_FS_${s}_$droit"
        if (-not (Get-ADGroup -Filter "Name -eq '$dl'")) {
            New-ADGroup -Name $dl -GroupScope DomainLocal -GroupCategory Security -Path $groupsOU
            Write-Host "Groupe cree : $dl" -ForegroundColor Green
        }
    }
    Add-ADGroupMember -Identity "DL_FS_${s}_RW" -Members $gg
}

# 3. Les comptes
$password = Read-Host -AsSecureString "Mot de passe initial des comptes"
$adminsDomaine = Get-ADGroup -Identity "$($domain.DomainSID)-512"

foreach ($u in Import-Csv $CsvPath -Delimiter ";") {
    $sam    = ("$($u.Prenom).$($u.Nom)").ToLower()
    $ouUser = "OU=$($u.Service),OU=Utilisateurs,$root"
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$sam'")) {
        New-ADUser -Name "$($u.Prenom) $($u.Nom)" -GivenName $u.Prenom -Surname $u.Nom `
            -SamAccountName $sam -UserPrincipalName "$sam@$($domain.DNSRoot)" `
            -Department $u.Service -Path $ouUser -AccountPassword $password `
            -Enabled $true -ChangePasswordAtLogon $true
        Write-Host "Compte cree : $sam" -ForegroundColor Green
    }
    Add-ADGroupMember -Identity "GG_$($u.Service)" -Members $sam

    if ($u.Admin -eq "Oui") {
        $adm = ("adm-$($u.Prenom)").ToLower()
        if (-not (Get-ADUser -Filter "SamAccountName -eq '$adm'")) {
            New-ADUser -Name "ADM $($u.Prenom) $($u.Nom)" -SamAccountName $adm `
                -UserPrincipalName "$adm@$($domain.DNSRoot)" -Path $ouUser `
                -AccountPassword $password -Enabled $true -ChangePasswordAtLogon $true
            Write-Host "Compte admin cree : $adm" -ForegroundColor Yellow
        }
        Add-ADGroupMember -Identity $adminsDomaine -Members $adm
    }
}

# 4. Les nouveaux PC arrivent dans l'OU Postes, et les PC existants y sont ranges
redircmp "OU=Postes,$root" | Out-Null
Get-ADComputer -Filter "Name -like 'PC-*'" |
    Where-Object { $_.DistinguishedName -notlike "*,OU=Postes,$root" } |
    Move-ADObject -TargetPath "OU=Postes,$root"

Write-Host "Termine." -ForegroundColor Cyan