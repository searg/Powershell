# Код ниже показывает как реализовать меню
# Доступные варианты да (Yes) и нет (No)
# Другие варианты не принимаются
# http://technet.microsoft.com/en-us/library/ff730939.aspx

$Title = "Запрос подтверждения"
$Message = "Ты действительно хочешь сделать это?"

$Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
    "Да, хочу."
$No = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
    "Нет, не хочу."

$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $No)
$Result = $host.ui.PromptForChoice($Title, $Message, $Options, 0) 

switch ($Result)
    {
        # Действия, если "Yes"
        0
        {
			Write-Host -ForegroundColor Green "OK! Мы сделали это!"
		}
        # Действия, если "No"
        1
        {
			Write-Host -ForegroundColor Red "Нет, так нет"
		}
    }