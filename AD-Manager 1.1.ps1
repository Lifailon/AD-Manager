#region edit lists
$d0 = $env:userdnsdomain
$d0 = $d0 -split "\."
$d1 = $d0[0]
$d2 = $d0[1]

$path_list = @(
"OU=users,DC=$d1,DC=$d2"
"OU=users,OU=test,DC=$d1,DC=$d2"
)

$company_list = @(
"АО"
"ООО"
)
#endregion

#region runas-adm
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{
$arguments = "& '" +$myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb RunAs -ArgumentList $arguments
Break
}
#endregion

#region functions-main
function variable-main {
$global:login = $textbox_login.Text
$global:password = $textbox_password.Text
$global:family = $textbox_family.Text
$global:name = $textbox_name.Text
$global:telephone = $textbox_telephone.Text
$global:description = $textbox_description.Text
$global:department = $textbox_department.Text
$global:office = $textbox_office.Text
$global:company = $ComboBox_Company.Text
$global:path = $ComboBox_path.Text
}

function translit {
param([string]$inString)
$Translit = @{
[char]'а' = "a"
[char]'А' = "A"
[char]'б' = "b"
[char]'Б' = "B"
[char]'в' = "v"
[char]'В' = "V"
[char]'г' = "g"
[char]'Г' = "G"
[char]'д' = "d"
[char]'Д' = "D"
[char]'е' = "e"
[char]'Е' = "E"
[char]'ё' = "yo"
[char]'Ё' = "Yo"
[char]'ж' = "zh"
[char]'Ж' = "Zh"
[char]'з' = "z"
[char]'З' = "Z"
[char]'и' = "i"
[char]'И' = "I"
[char]'й' = "j"
[char]'Й' = "J"
[char]'к' = "k"
[char]'К' = "K"
[char]'л' = "l"
[char]'Л' = "L"
[char]'м' = "m"
[char]'М' = "M"
[char]'н' = "n"
[char]'Н' = "N"
[char]'о' = "o"
[char]'О' = "O"
[char]'п' = "p"
[char]'П' = "P"
[char]'р' = "r"
[char]'Р' = "R"
[char]'с' = "s"
[char]'С' = "S"
[char]'т' = "t"
[char]'Т' = "T"
[char]'у' = "u"
[char]'У' = "U"
[char]'ф' = "f"
[char]'Ф' = "F"
[char]'х' = "h"
[char]'Х' = "H"
[char]'ц' = "c"
[char]'Ц' = "C"
[char]'ч' = "ch"
[char]'Ч' = "Ch"
[char]'ш' = "sh"
[char]'Ш' = "Sh"
[char]'щ' = "sch"
[char]'Щ' = "Sch"
[char]'ъ' = ""
[char]'Ъ' = ""
[char]'ы' = "y"
[char]'Ы' = "Y"
[char]'ь' = ""
[char]'Ь' = ""
[char]'э' = "e"
[char]'Э' = "E"
[char]'ю' = "yu"
[char]'Ю' = "Yu"
[char]'я' = "ya"
[char]'Я' = "Ya"
}
$outCHR = ""
foreach ($CHR in $inCHR = $inString.ToCharArray())
{
if ($Translit[$CHR] -cne $Null )
{$outCHR += $Translit[$CHR]}
else
{$outCHR += $CHR}
}
$global:translit_out = $outCHR
}

function save-file {
$SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
$SaveFileDialog.Filter = "Report (*.txt)|*.txt"
$SaveFileDialog.FileName = "$family $name"
$SaveFileDialog.InitialDirectory = "$env:USERPROFILE\desktop\"
$SaveFileDialog.Title = "Save report"
$SaveFileDialog.ShowDialog()
$global:path_out = $SaveFileDialog.FileNames
}
#endregion

#region forms-main
Add-Type -assembly System.Windows.Forms

$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ="AD Manager"
$main_form.Width = 1313
$main_form.Height = 900
$main_form.Font = "Arial,12"
$main_form.AutoSize = $false
$main_form.FormBorderStyle = "FixedSingle"
$main_form.StartPosition = "CenterScreen"
$main_form.ShowIcon = $False

$TabControl = New-Object System.Windows.Forms.TabControl
$TabControl.Location = New-Object System.Drawing.Point(1,115)
$TabControl.Size = New-Object System.Drawing.Size(1294,720)

$TabPage_User = New-Object System.Windows.Forms.TabPage
$TabPage_User.Text = "Creat User"
$TabControl.Controls.Add($TabPage_User)

$TabPage_Group = New-Object System.Windows.Forms.TabPage
$TabPage_Group.Text = "Add Groups"
$TabControl.Controls.Add($TabPage_Group)

$TabPage_Check = New-Object System.Windows.Forms.TabPage
$TabPage_Check.Text = "View Users"
$TabControl.Controls.Add($TabPage_Check)

$TabPage_Host = New-Object System.Windows.Forms.TabPage
$TabPage_Host.Text = "View Hosts"
$TabControl.Controls.Add($TabPage_Host)

$main_form.Controls.add($TabControl)

$GroupBox_Login = New-Object System.Windows.Forms.GroupBox
$GroupBox_Login.Location = New-Object System.Drawing.Point(10,5)
$GroupBox_Login.Text = "Login"
$GroupBox_Login.AutoSize = $true

$textbox_login = New-Object System.Windows.Forms.TextBox
$textbox_login.Location  = New-Object System.Drawing.Point(10,40)
$textbox_login.Width = 200
$GroupBox_Login.Controls.Add($textbox_login)

$main_form.Controls.Add($GroupBox_Login)
#endregion

#region creat-user-key
$label_password = New-Object System.Windows.Forms.Label
$label_password.Location = New-Object System.Drawing.Point(10,15)
$label_password.Text = "Password:"
$label_password.AutoSize = $true
$TabPage_User.Controls.Add($label_password)

$textbox_password = New-Object System.Windows.Forms.TextBox
$textbox_password.Location = New-Object System.Drawing.Point(12,40)
$textbox_password.Width = 180
$TabPage_User.Controls.Add($textbox_password)

$label_family = New-Object System.Windows.Forms.Label
$label_family.Location = New-Object System.Drawing.Point(10,75)
$label_family.Text = "Family:"
$label_family.AutoSize = $true
$TabPage_User.Controls.Add($label_family)

$textbox_family = New-Object System.Windows.Forms.TextBox
$textbox_family.Location = New-Object System.Drawing.Point(12,100)
$textbox_family.Width = 180
$TabPage_User.Controls.Add($textbox_family)

$label_name = New-Object System.Windows.Forms.Label
$label_name.Location = New-Object System.Drawing.Point(10,135)
$label_name.Text = "Name:"
$label_name.AutoSize = $true
$TabPage_User.Controls.Add($label_name)

$textbox_name = New-Object System.Windows.Forms.TextBox
$textbox_name.Location = New-Object System.Drawing.Point(12,160)
$textbox_name.Width = 180
$TabPage_User.Controls.Add($textbox_name)

$label_telephone = New-Object System.Windows.Forms.Label
$label_telephone.Location = New-Object System.Drawing.Point(10,195)
$label_telephone.Text = "Telephone:"
$label_telephone.AutoSize = $true
$TabPage_User.Controls.Add($label_telephone)

$textbox_telephone = New-Object System.Windows.Forms.TextBox
$textbox_telephone.Location = New-Object System.Drawing.Point(12,220)
$textbox_telephone.Width = 180
$TabPage_User.Controls.Add($textbox_telephone)

$label_description = New-Object System.Windows.Forms.Label
$label_description.Location = New-Object System.Drawing.Point(10,255)
$label_description.Text = "Description:"
$label_description.AutoSize = $true
$TabPage_User.Controls.Add($label_description)

$textbox_description = New-Object System.Windows.Forms.TextBox
$textbox_description.Location = New-Object System.Drawing.Point(12,280)
$textbox_description.Width = 180
$TabPage_User.Controls.Add($textbox_description)

$label_department = New-Object System.Windows.Forms.Label
$label_department.Location = New-Object System.Drawing.Point(10,315)
$label_department.Text = "Department:"
$label_department.AutoSize = $true
$TabPage_User.Controls.Add($label_department)

$textbox_department = New-Object System.Windows.Forms.TextBox
$textbox_department.Location = New-Object System.Drawing.Point(12,340)
$textbox_department.Width = 180
$TabPage_User.Controls.Add($textbox_department)

$label_office = New-Object System.Windows.Forms.Label
$label_office.Location = New-Object System.Drawing.Point(10,375)
$label_office.Text = "Office:"
$label_office.AutoSize = $true
$TabPage_User.Controls.Add($label_office)

$textbox_office = New-Object System.Windows.Forms.TextBox
$textbox_office.Location = New-Object System.Drawing.Point(12,400)
$textbox_office.Width = 180
$TabPage_User.Controls.Add($textbox_office)

$label_company = New-Object System.Windows.Forms.Label
$label_company.Location = New-Object System.Drawing.Point(10,435)
$label_company.Text = "Company:"
$label_company.AutoSize = $true
$TabPage_User.Controls.Add($label_company)

$ComboBox_Company = New-Object System.Windows.Forms.ComboBox
$ComboBox_Company.Location = New-Object System.Drawing.Point(10,460)
$ComboBox_Company.Width = 183
$TabPage_User.Controls.Add($ComboBox_Company)
foreach ($f in $company_list) {$ComboBox_Company.Items.Add($f)}

$label_path = New-Object System.Windows.Forms.Label
$label_path.Location = New-Object System.Drawing.Point(10,495)
$label_path.Text = "Path:"
$label_path.AutoSize = $true
$TabPage_User.Controls.Add($label_path)

$ComboBox_path = New-Object System.Windows.Forms.ComboBox
$ComboBox_path.Location = New-Object System.Drawing.Point(10,520)
$ComboBox_path.Width = 183
$TabPage_User.Controls.Add($ComboBox_path)
foreach ($f in $path_list) {$ComboBox_path.Items.Add($f)}
#endregion

#region creat-user-button
Add-Type -AssemblyName System.Web

$button_generate = New-Object System.Windows.Forms.Button
$button_generate.Text = "Generate"
$button_generate.Location = New-Object System.Drawing.Point(210,38)
$button_generate.Size = New-Object System.Drawing.Size(100,30)
$TabPage_User.Controls.Add($button_generate)

$button_generate.add_Click({
$pass = [System.Web.Security.Membership]::GeneratePassword(10,1)
$textbox_password.Text = $pass
})

$button_translate = New-Object System.Windows.Forms.Button
$button_translate.Text = "Translate"
$button_translate.Location = New-Object System.Drawing.Point(210,98)
$button_translate.Size = New-Object System.Drawing.Size(100,30)
$TabPage_User.Controls.Add($button_translate)

$button_translate.Add_Click({
$name_trans = $textbox_family.text
translit $name_trans
$translit_name = $translit_out
$textbox_login.text = $translit_name
})

$button_creat_user = New-Object System.Windows.Forms.Button
$button_creat_user.Text = "Creat User"
$button_creat_user.Font = "Arial,14"
$button_creat_user.Location = New-Object System.Drawing.Point(9,560)
$button_creat_user.Size = New-Object System.Drawing.Size(185,50)
$TabPage_User.Controls.Add($button_creat_user)

$button_creat_user.Add_Click({
variable-main
$pass = ConvertTo-SecureString -String $password -AsPlainText -Force
$global:creat_out = New-ADUser -Name "$family $name" -SamAccountName "$login" -SurName "$family" -GivenName "$name" `
-DisplayName "$family $name" -Enabled $true -AccountPassword $pass -Description "$description" -Department "$department" `
-Office "$office" -Company "$company" -OtherAttributes @{'telephoneNumber'="$telephone"} -Path "$path" -Verbose 
})

$button_report = New-Object System.Windows.Forms.Button
$button_report.Text = "Print Report"
$button_report.Font = "Arial,14"
$button_report.Location = New-Object System.Drawing.Point(9,620)
$button_report.Size = New-Object System.Drawing.Size(185,50)
$TabPage_User.Controls.Add($button_report)

$button_report.Add_Click({
variable-main

$report_out = "Учетная запись нового пользователя.
Компания: $company
ФИО: $family $name
Должность: $description
Отдел: $department
Расположение: $office
Номер телефона: $telephone

Логин для входа в систему: $login
Пароль: $password
"

save-file
$report_out > $path_out
$Status.Text = "Отчет сохранен: $path_out"
})
#endregion

#region exchange
$button_exch_list = New-Object System.Windows.Forms.Button
$button_exch_list.Text = "Review"
$button_exch_list.Location = New-Object System.Drawing.Point(340,37)
$button_exch_list.Size = New-Object System.Drawing.Size(90,30)
$TabPage_User.Controls.Add($button_exch_list)

$button_exch_list.add_Click({
$exch_list = Get-ADGroupMember -Identity "Exchange Servers" | where {$_.objectClass -match "computer"} | select -ExpandProperty Name
foreach ($f in $exch_list) {$ComboBox_exchange_server.Items.Add($f)}

$exch_list_count = $exch_list.count
$Status.Text = "Exchange Servers group: $exch_list_count computers"
})

$label_exchange_server = New-Object System.Windows.Forms.Label
$label_exchange_server.Location = New-Object System.Drawing.Point(340,75)
$label_exchange_server.Text = "Exchange Server:"
$label_exchange_server.AutoSize = $true
$TabPage_User.Controls.Add($label_exchange_server)

$ComboBox_exchange_server = New-Object System.Windows.Forms.ComboBox
$ComboBox_exchange_server.Location = New-Object System.Drawing.Point(342,100)
$ComboBox_exchange_server.Width = 200
$TabPage_User.Controls.Add($ComboBox_exchange_server)

$button_exch_db = New-Object System.Windows.Forms.Button
$button_exch_db.Text = "Select"
$button_exch_db.Location = New-Object System.Drawing.Point(550,98)
$button_exch_db.Size = New-Object System.Drawing.Size(90,30)
$TabPage_User.Controls.Add($button_exch_db)

$button_exch_db.add_Click({
$ListBox_database.Items.Clear()
$exch_server = $ComboBox_exchange_server.Text
$exch_session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$exch_server/PowerShell/
$db_list = icm -Session $exch_session {Get-MailboxDatabase} | select -ExpandProperty Name
foreach ($f in $db_list) {$ListBox_database.Items.Add($f)}
Remove-PSSession $exch_session
$db_count = $db_list.Count
$Status.Text = "Database count $db_count to server $exch_server"
})

$label_database = New-Object System.Windows.Forms.Label
$label_database.Location = New-Object System.Drawing.Point(340,135)
$label_database.Text = "Database:"
$label_database.AutoSize = $true
$TabPage_User.Controls.Add($label_database)

$ListBox_database = New-Object System.Windows.Forms.ListBox
$ListBox_database.Location = New-Object System.Drawing.Point(342,160)
$ListBox_database.Size = New-Object System.Drawing.Size(298,460)
$TabPage_User.Controls.add($ListBox_database)

$button_creat_mailbox = New-Object System.Windows.Forms.Button
$button_creat_mailbox.Text = "Creat Mailbox"
$button_creat_mailbox.Font = "Arial,14"
$button_creat_mailbox.Location = New-Object System.Drawing.Point(342,620)
$button_creat_mailbox.Size = New-Object System.Drawing.Size(185,50)
$TabPage_User.Controls.Add($button_creat_mailbox)

$button_creat_mailbox.Add_Click({
[string]$login_usr = $textbox_login.Text
[string]$select_db = $ListBox_database.selectedItem
[string]$exch_server = $ComboBox_exchange_server.Text

$exch_session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$exch_server/PowerShell/
Import-PSSession $exch_session -DisableNameChecking
Enable-Mailbox -Identity "$login_usr" -Database "$select_db"
Remove-PSSession $exch_session
})
#endregion

#region groups
function user-group {
variable-main
$usr_groups = Get-AdUser -Identity $login -Properties memberof | Select -expandproperty memberof
$usr_groups = $usr_groups -replace "(,OU=.+)"
$usr_groups = $usr_groups -replace "(CN=)"
$CheckedListBox_user.Items.Clear()
foreach ($g in $usr_groups) {$CheckedListBox_user.Items.ADD("$g")}
}

function view-user {
$select_group_for_view_users = $CheckedListBox.selectedItem
$CheckedListBox_users_in_group.Items.Clear()
$users_in_group = Get-ADGroupMember -Identity $select_group_for_view_users | Select -ExpandProperty SamAccountName
foreach ($usr in $users_in_group) {$CheckedListBox_users_in_group.Items.ADD("$usr")}
}

$button_all_groups = New-Object System.Windows.Forms.Button
$button_all_groups.Text = "All groups"
$button_all_groups.Font = "Arial,14"
$button_all_groups.Location = New-Object System.Drawing.Point(10,10)
$button_all_groups.Size = New-Object System.Drawing.Size(130,35)
$TabPage_Group.Controls.Add($button_all_groups)

$button_all_groups.add_Click({
$CheckedListBox.Items.Clear()
$global:group_list = Get-ADGroup -Filter * | select -ExpandProperty name
foreach ($g in $group_list) {$CheckedListBox.Items.ADD("$g")}

$count_group = $group_list.count
$Status.Text = "Count domain groups: $count_group"
})

$TextBox_Search_Group = New-Object System.Windows.Forms.TextBox
$TextBox_Search_Group.Location = New-Object System.Drawing.Point(10,56)
$TextBox_Search_Group.Size = New-Object System.Drawing.Size(400,30)
$TextBox_Search_Group.Font = "Arial,14"
$TextBox_Search_Group.MultiLine = $True
$TabPage_Group.Controls.Add($TextBox_Search_Group)

$TextBox_Search_Group.Add_TextChanged({
$search_text_group = $TextBox_Search_Group.Text
$search_group = @($group_list | Where {$_ -match "$search_text_group"})
$CheckedListBox.Items.Clear()
foreach ($g in $search_group) {$CheckedListBox.Items.ADD("$g")}

$count_group = $search_group.count
$Status.Text = "Count domain groups: $count_group"
})

$CheckedListBox = New-Object System.Windows.Forms.CheckedListBox
$CheckedListBox.Location = New-Object System.Drawing.Point(10,100)
$CheckedListBox.Size = New-Object System.Drawing.size(400,530)
$TabPage_Group.Controls.Add($CheckedListBox)

$button_add_group = New-Object System.Windows.Forms.Button
$button_add_group.Text = "Add user"
$button_add_group.Font = "Arial,14"
$button_add_group.Location = New-Object System.Drawing.Point(10,640)
$button_add_group.Size = New-Object System.Drawing.Size(130,35)
$TabPage_Group.Controls.Add($button_add_group)

$button_add_group.add_Click({
variable-main
$select_group = $CheckedListBox.CheckedItems
foreach ($g in $select_group) {
Add-ADGroupMember -Identity $g -Members $login -verbose
}
user-group

$select_count_add = $select_group.count
$Status.Text = "User $login added to $select_count_add groups"
})

$button_user_groups = New-Object System.Windows.Forms.Button
$button_user_groups.Text = "User groups"
$button_user_groups.Font = "Arial,14"
$button_user_groups.Location = New-Object System.Drawing.Point(430,10)
$button_user_groups.Size = New-Object System.Drawing.Size(130,35)
$TabPage_Group.Controls.Add($button_user_groups)

$button_user_groups.add_Click({
user-group
})

$CheckedListBox_user = New-Object System.Windows.Forms.CheckedListBox
$CheckedListBox_user.Location = New-Object System.Drawing.Point(430,55)
$CheckedListBox_user.Size = New-Object System.Drawing.size(400,585)
$TabPage_Group.Controls.Add($CheckedListBox_user)

$button_del_group = New-Object System.Windows.Forms.Button
$button_del_group.Text = "Remove groups"
$button_del_group.Font = "Arial,14"
$button_del_group.Location = New-Object System.Drawing.Point(430,640)
$button_del_group.Size = New-Object System.Drawing.Size(160,35)
$TabPage_Group.Controls.Add($button_del_group)

$button_del_group.add_Click({
variable-main
$select_group_user = $CheckedListBox_user.CheckedItems
foreach ($g in $select_group_user) {
Remove-ADGroupMember -Identity $g -Members $login -Confirm:$false
}
user-group
})

$CheckedListBox_users_in_group = New-Object System.Windows.Forms.CheckedListBox
$CheckedListBox_users_in_group.Location = New-Object System.Drawing.Point(850,55)
$CheckedListBox_users_in_group.Size = New-Object System.Drawing.size(400,585)
$TabPage_Group.Controls.Add($CheckedListBox_users_in_group)

$button_check_users_in_group = New-Object System.Windows.Forms.Button
$button_check_users_in_group.Text = "View users"
$button_check_users_in_group.Font = "Arial,14"
$button_check_users_in_group.Location = New-Object System.Drawing.Point(145,640)
$button_check_users_in_group.Size = New-Object System.Drawing.Size(130,35)
$TabPage_Group.Controls.Add($button_check_users_in_group)

$button_check_users_in_group.add_Click({
view-user
})

$button_remove_users_in_group = New-Object System.Windows.Forms.Button
$button_remove_users_in_group.Text = "Remove users"
$button_remove_users_in_group.Font = "Arial,14"
$button_remove_users_in_group.Location = New-Object System.Drawing.Point(850,640)
$button_remove_users_in_group.Size = New-Object System.Drawing.Size(150,35)
$TabPage_Group.Controls.Add($button_remove_users_in_group)

$button_remove_users_in_group.add_Click({
variable-main
$select_group_for_view_users = $CheckedListBox.selectedItem
$select_users_in_group = $CheckedListBox_users_in_group.CheckedItems
foreach ($usr in $select_users_in_group) {
Remove-ADGroupMember -Identity $select_group_for_view_users -Members $usr -Confirm:$false
}
view-user
})
#endregion

#region users
$dgv_usr = New-Object System.Windows.Forms.DataGridView
$dgv_usr.Location = New-Object System.Drawing.Point(220,50)
$dgv_usr.Size = New-Object System.Drawing.Size(1055,625)
$dgv_usr.AutoSizeColumnsMode = "Fill" 
$dgv_usr.Font = "$Font,10"
$dgv_usr.AutoSize = $false
$dgv_usr.MultiSelect = $false
$dgv_usr.ReadOnly = $true
$TabPage_Check.Controls.Add($dgv_usr)

$GroupBox_Users = New-Object System.Windows.Forms.GroupBox
$GroupBox_Users.Location = New-Object System.Drawing.Point(10,5)
$GroupBox_Users.Size = New-Object System.Drawing.Size(200,670)
$GroupBox_Users.AutoSize = $false
$TabPage_Check.Controls.Add($GroupBox_Users)

$textbox_day = New-Object System.Windows.Forms.TextBox
$textbox_day.Location = New-Object System.Drawing.Point(10,25)
$textbox_day.text = 365
$textbox_day.Width = 100
$GroupBox_Users.Controls.add($textbox_day)

$RadioButton_new_user = New-Object System.Windows.Forms.RadioButton
$RadioButton_new_user.Location = New-Object System.Drawing.Point(10,60)
$RadioButton_new_user.Text = "New users"
$RadioButton_new_user.AutoSize = $true
$GroupBox_Users.Controls.Add($RadioButton_new_user)

$RadioButton_logon_user = New-Object System.Windows.Forms.RadioButton
$RadioButton_logon_user.Location = New-Object System.Drawing.Point(10,90)
$RadioButton_logon_user.Text = "Last logon"
$RadioButton_logon_user.AutoSize = $true
$GroupBox_Users.Controls.Add($RadioButton_logon_user)

$RadioButton_passwordlastset_user = New-Object System.Windows.Forms.RadioButton
$RadioButton_passwordlastset_user.Location = New-Object System.Drawing.Point(10,120)
$RadioButton_passwordlastset_user.Text = "Password last set"
$RadioButton_passwordlastset_user.AutoSize = $true
$GroupBox_Users.Controls.Add($RadioButton_passwordlastset_user)

$RadioButton_enabled_user = New-Object System.Windows.Forms.RadioButton
$RadioButton_enabled_user.Location = New-Object System.Drawing.Point(10,150)
$RadioButton_enabled_user.Text = "Enabled users"
$RadioButton_enabled_user.AutoSize = $true
$GroupBox_Users.Controls.Add($RadioButton_enabled_user)

$RadioButton_disabled_user = New-Object System.Windows.Forms.RadioButton
$RadioButton_disabled_user.Location = New-Object System.Drawing.Point(10,180)
$RadioButton_disabled_user.Text = "Disabled users"
$RadioButton_disabled_user.AutoSize = $true
$GroupBox_Users.Controls.Add($RadioButton_disabled_user)

$button_check = New-Object System.Windows.Forms.Button
$button_check.Text = "Check"
$button_check.Font = "Arial,14"
$button_check.Location = New-Object System.Drawing.Point(10,210)
$button_check.Size = New-Object System.Drawing.Size(130,35)
$GroupBox_Users.Controls.Add($button_check)

$button_check.add_Click({
$button_check.Enabled = $false
$days = $textbox_day.text
$data_new = (Get-Date).adddays(- $days)

if ($RadioButton_new_user.Checked -eq $true) {
$global:result_user = Get-ADUser -filter {(Created -ge $data_new)} -Properties Created,Enabled,Mail,LockedOut,PasswordNeverExpires,PasswordExpired,LastLogonDate | select `
@{Label="Login"; Expression={$_.SamAccountName}},Name,Mail,Enabled,LockedOut,PasswordNeverExpires,PasswordExpired,LastLogonDate,Created | sort -Descending Created
}

if ($RadioButton_logon_user.Checked -eq $true) {
$global:result_user = Get-ADUser -filter {(LastLogonDate -le $data_new)} -Properties Created,Enabled,Mail,LockedOut,PasswordNeverExpires,PasswordExpired,LastLogonDate | select `
@{Label="Login"; Expression={$_.SamAccountName}},Name,Mail,Enabled,LockedOut,PasswordNeverExpires,PasswordExpired,LastLogonDate,Created | sort LastLogonDate
}

if ($RadioButton_passwordlastset_user.Checked -eq $true) {
$global:result_user = Get-ADUser -filter {(passwordlastset -le $data_new) -and (Enabled -eq "True")} -Properties PasswordLastSet,Enabled,Mail,LockedOut,PasswordNeverExpires,PasswordExpired,LastLogonDate | select `
@{Label="Login"; Expression={$_.SamAccountName}},Name,Mail,Enabled,LockedOut,PasswordNeverExpires,PasswordExpired,LastLogonDate,PasswordLastSet | sort -Descending passwordlastset
}

if ($RadioButton_enabled_user.Checked -eq $true) {
$global:result_user = Get-ADUser -Filter {(Enabled -eq "True")} -Properties Modified,Enabled,Mail,LockedOut,PasswordNeverExpires,PasswordExpired,LastLogonDate | select `
@{Label="Login"; Expression={$_.SamAccountName}},Name,Mail,Enabled,LockedOut,PasswordNeverExpires,PasswordExpired,LastLogonDate,Modified | sort -Descending Modified
}

if ($RadioButton_disabled_user.Checked -eq $true) {
$global:result_user = Get-ADUser -Filter {(Enabled -eq "False")} -Properties Modified,Enabled,mail,LockedOut,PasswordNeverExpires,PasswordExpired,LastLogonDate | select `
@{Label="Login"; Expression={$_.SamAccountName}},Name,Mail,Enabled,LockedOut,PasswordNeverExpires,PasswordExpired,LastLogonDate,Modified | sort -Descending Modified
}

$list = New-Object System.collections.ArrayList
$list.AddRange($result_user)
$dgv_usr.DataSource = $list

$count_user = $result_user.count
$Status.Text = "Count users: $count_user"
$button_check.Enabled = $True
})

$TextBox_Search_User = New-Object System.Windows.Forms.TextBox
$TextBox_Search_User.Location = New-Object System.Drawing.Point(220,15)
$TextBox_Search_User.Size = New-Object System.Drawing.Size(500,25)
$TextBox_Search_User.MultiLine = $True
$TabPage_Check.Controls.Add($TextBox_Search_User)

$TextBox_Search_User.Add_TextChanged({
$search_text_user = $TextBox_Search_User.Text
$search_usr = @($result_user | Where {$_.Name -match "$search_text_user"})
$temp = $search_usr
$list = New-Object System.collections.ArrayList
$list.AddRange($temp)
$dgv_usr.DataSource = $list
$count_user = $search_usr.count
$Status.Text = "Count users: $count_user"
})

$line_box = New-Object System.Windows.Forms.TextBox
$line_box.Location = New-Object System.Drawing.Point(0,252)
$line_box.Size = New-Object System.Drawing.Size(200,1)
$line_box.BackColor = "Silver"
$line_box.MultiLine = $True
$GroupBox_Users.Controls.Add($line_box)

$button_unlocked = New-Object System.Windows.Forms.Button
$button_unlocked.Text = "Unlocked"
$button_unlocked.Font = "Arial,14"
$button_unlocked.Location = New-Object System.Drawing.Point(10,260)
$button_unlocked.Size = New-Object System.Drawing.Size(130,35)
$GroupBox_Users.Controls.Add($button_unlocked)

$button_unlocked.add_Click({
$user_selected = $dgv_usr.SelectedCells.Value
Get-ADUser -Identity $user_selected | Unlock-ADAccount
})

$button_enable = New-Object System.Windows.Forms.Button
$button_enable.Text = "Enable"
$button_enable.Font = "Arial,14"
$button_enable.Location = New-Object System.Drawing.Point(10,300)
$button_enable.Size = New-Object System.Drawing.Size(130,35)
$GroupBox_Users.Controls.Add($button_enable)

$button_enable.add_Click({
$user_selected = $dgv_usr.SelectedCells.Value
Enable-ADAccount -Identity $user_selected -verbose
})

$button_disable = New-Object System.Windows.Forms.Button
$button_disable.Text = "Disable"
$button_disable.Font = "Arial,14"
$button_disable.Location = New-Object System.Drawing.Point(10,340)
$button_disable.Size = New-Object System.Drawing.Size(130,35)
$GroupBox_Users.Controls.Add($button_disable)

$button_disable.add_Click({
$user_selected = $dgv_usr.SelectedCells.Value
Disable-ADAccount -Identity $user_selected -verbose
})

$TextBox_Pass_User = New-Object System.Windows.Forms.TextBox
$TextBox_Pass_User.Font = "Arial,16"
$TextBox_Pass_User.Multiline = $true
$TextBox_Pass_User.WordWrap = $true
$TextBox_Pass_User.PasswordChar = "*"
$TextBox_Pass_User.Location  = New-Object System.Drawing.Point(10,380)
$TextBox_Pass_User.Size = New-Object System.Drawing.Size(180,35)
$GroupBox_Users.Controls.Add($TextBox_Pass_User)

$button_ChangePass = New-Object System.Windows.Forms.Button
$button_ChangePass.Text = "Change password"
$button_ChangePass.Font = "Arial,14"
$button_ChangePass.Location = New-Object System.Drawing.Point(10,420)
$button_ChangePass.Size = New-Object System.Drawing.Size(180,40)
$GroupBox_Users.Controls.Add($button_ChangePass)

$button_ChangePass.add_Click({
$new_pass = $TextBox_Pass_User.Text
$user_selected = $dgv_usr.SelectedCells.Value
Set-ADAccountPassword $user_selected -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $new_pass -Force -Verbose) –PassThru
})

#$button_ChangePassLogon = New-Object System.Windows.Forms.Button
#$button_ChangePassLogon.Text = "Change password logon"
#$button_ChangePassLogon.Font = "Arial,16"
#$button_ChangePassLogon.Location = New-Object System.Drawing.Point(820,640)
#$button_ChangePassLogon.Size = New-Object System.Drawing.Size(260,40)
#$TabPage_Check.Controls.Add($button_ChangePassLogon)
#
#$button_ChangePassLogon.add_Click({
#$user_selected = $dgv_usr.SelectedCells.Value
#Get-ADUser $user_selected | Set-ADUser -PasswordNeverExpires $false
#Set-ADUser -Identity $user_selected -ChangePasswordAtLogon $True -verbose
#})
#endregion

#region hosts
$dgv_hosts = New-Object System.Windows.Forms.DataGridView
$dgv_hosts.Location = New-Object System.Drawing.Point(10,100)
$dgv_hosts.Size = New-Object System.Drawing.Size(1265,575)
$dgv_hosts.AutoSizeColumnsMode = "Fill" 
$dgv_hosts.Font = "$Font,10"
$dgv_hosts.AutoSize = $false
$dgv_hosts.MultiSelect = $false
$dgv_hosts.ReadOnly = $true
$TabPage_Host.Controls.Add($dgv_hosts)

$button_view_hosts = New-Object System.Windows.Forms.Button
$button_view_hosts.Text = "View"
$button_view_hosts.Font = "Arial,14"
$button_view_hosts.Location = New-Object System.Drawing.Point(10,15)
$button_view_hosts.Size = New-Object System.Drawing.Size(100,35)
$TabPage_Host.Controls.Add($button_view_hosts)

$button_view_hosts.add_Click({
$button_view_hosts.Enabled = $false

$global:comp = Get-ADComputer -Filter * -Properties * | select @{Label="Status"; Expression={
if ($_.Enabled -eq "True") {$_.Enabled -replace "True","Active"} else {$_.Enabled -replace "False","Blocked"}
}}, Name, IPv4Address, OperatingSystem, @{Label="UserOwner"; Expression={$_.ManagedBy -replace "(CN=|,.+)"}
},Created | sort -Descending Created

$dgv_hosts.Rows.Clear()
$dgv_hosts.DataSource = $null
$dgv_hosts.ColumnCount = 6
$dgv_hosts.Columns[0].Name = "Status"
$dgv_hosts.Columns[1].Name = "Host Name"
$dgv_hosts.Columns[2].Name = "IP address"
$dgv_hosts.Columns[3].Name = "Operating System"
$dgv_hosts.Columns[4].Name = "User Owner"
$dgv_hosts.Columns[5].Name = "Date created"

$ping_out = foreach ($comps in $comp) {
$comp_status = $comps.Status
$comp_name = $comps.Name
$comp_ip = $comps.IPv4Address
$comp_os = $comps.OperatingSystem
$comp_usr = $comps.UserOwner
$comp_date = $comps.Created
$dgv_hosts.Rows.Add("$comp_status","$comp_name","$comp_ip","$comp_os","$comp_usr","$comp_date")
}

$count_hosts = $comp.count
$Status.Text = "Count hosts: $count_hosts"
$button_view_hosts.Enabled = $True
})

$TextBox_Search_Host = New-Object System.Windows.Forms.TextBox
$TextBox_Search_Host.Location = New-Object System.Drawing.Point(10,65)
$TextBox_Search_Host.Size = New-Object System.Drawing.Size(500,25)
$TextBox_Search_Host.MultiLine = $True
$TabPage_Host.Controls.Add($TextBox_Search_Host)

$TextBox_Search_Host.Add_TextChanged({
$search_text_host = $TextBox_Search_Host.Text
$search_host = @($comp | Where {$_.Name -match "$search_text_host"})
$temp = $search_host

$dgv_hosts.Rows.Clear()
$dgv_hosts.DataSource = $null
$dgv_hosts.ColumnCount = 6
$dgv_hosts.Columns[0].Name = "Status"
$dgv_hosts.Columns[1].Name = "Host Name"
$dgv_hosts.Columns[2].Name = "IP address"
$dgv_hosts.Columns[3].Name = "Operating System"
$dgv_hosts.Columns[4].Name = "User Owner"
$dgv_hosts.Columns[5].Name = "Date created"

$ping_out = foreach ($comps in $temp) {
$comp_status = $comps.Status
$comp_name = $comps.Name
$comp_ip = $comps.IPv4Address
$comp_os = $comps.OperatingSystem
$comp_usr = $comps.UserOwner
$comp_date = $comps.Created
$dgv_hosts.Rows.Add("$comp_status","$comp_name","$comp_ip","$comp_os","$comp_usr","$comp_date")
}

$count_hosts = $temp.count
$Status.Text = "Count hosts: $count_hosts"
})

$button_ping_hosts = New-Object System.Windows.Forms.Button
$button_ping_hosts.Text = "Ping"
$button_ping_hosts.Font = "Arial,14"
$button_ping_hosts.Location = New-Object System.Drawing.Point(120,15)
$button_ping_hosts.Size = New-Object System.Drawing.Size(100,35)
$TabPage_Host.Controls.Add($button_ping_hosts)
### ping hosts
$button_ping_hosts.add_Click({
$button_ping_hosts.Enabled = $false

$list_srv = Get-ADComputer -Filter {enabled -eq "true"} -Properties IPv4Address | select name,IPv4Address
foreach ($lists in $list_srv) {
if ($lists.IPv4Address -ne $null) {$list_new += @($lists)}
}
$list_new_count = $list_new.count

$dgv_hosts.Rows.Clear()
$dgv_hosts.DataSource = $null
$dgv_hosts.ColumnCount = 3
$dgv_hosts.Columns[0].Name = "Host name"
$dgv_hosts.Columns[1].Name = "IP address"
$dgv_hosts.Columns[2].Name = "Ping status"

$ping_out = foreach ($srv in $list_new) {
$host_name = $srv.Name
$host_ip = $srv.IPv4Address
$status_ping = ping -v 4 -n 2 -l 16 -w 50 $host_name
if ($status_ping -match "ttl") {
$dgv_hosts.Rows.Add("$host_name","$host_ip","Available")
$Status_avail += @($host_name)
} else {
$dgv_hosts.Rows.Add("$host_name","$host_ip","Not available")
$Status_not += @($host_name)
}

$status_all += @($srv)
$status_all_count = $status_all.count
$Status_avail_count = $Status_avail.count
$Status_not_count = $Status_not.count
$Status.Text = "Hosts: $status_all_count of $list_new_count (Available: $Status_avail_count | Not available: $Status_not_count)"
}

$button_ping_hosts.Enabled = $True
})
###
#endregion

#region status
$StatusStrip = New-Object System.Windows.Forms.StatusStrip
$Status = New-Object System.Windows.Forms.ToolStripStatusLabel
$main_form.Controls.Add($statusStrip)
$StatusStrip.Items.Add($Status)
$Status.Text = "Version 1.1"

$main_form.ShowDialog()
#endregion