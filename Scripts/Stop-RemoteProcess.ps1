<#
	.SYNOPSIS

		Скрипт предназдачен, в первую очередь, для остановки процесса на удалённом компьютере.


	.DESCRIPTION

        По умолчанию скрипт ищет указанный процесс на локальном ПК.
        При указании параметра Credential можно задать альтернативные учётные данные для работы.
        Например, учётные данные администратора на удалённом ПК.

        Если имя процесса указать без расширения (например - notepad)
        скрипт спросит нужно-ли дописать расширение (.exe)

        ВНИМАНИЕ!!!
        Если указанный процесс будет найден он будет закрыт без сохранения данных,
        и без запроса/предупреждения.


	.PARAMETER  ProcessName

		Обязательный параметр, задающий имя процесса, котрый нужно завершить.
		Если указать без расширения .exe скрипт спросит нужно-ли его добавить.


	.PARAMETER  ComputerName

		Имя компьютера.
		По умолчанию используется локальный компьютер.


    .PARAMETER  Credential

		Опциональный параметр.
		С его помощью можно задть альтернативные учётные данные для работы.
		Параметр-переключатель: в отличии от стандартного параметра Credential
		не нужно задвать имя пользователя - по умолчанию имя пользователя admin.
		Изменить его можно будет в появившемся стандартном окне.


	.EXAMPLE

		PS C:\> Stop-RemoteProcess -ProcessName notepad

        Первым делом скрипт спросит нужно-ли добавить расширение к имени процесса.
		Затем если на локальном ПК открыт блокнот - он будет закрыт.


	.EXAMPLE

		PS C:\> Stop-RemoteProcess.ps1 -ProcessName winword.exe -ComputerName Server -Credential

		Сначала скрипт попросит ввести учётные от компьютера Server.
		Если на компьютере Server запущен MS Word он будет закрыт без сохранения данных.


	.NOTES

        При выполнении скрипта указанный процесс завершается с потерей всех несохранённых данных.
#>

param
(
    # Имя процесса, который нужно завершить
    [Parameter(Mandatory=$true)]
    [string]$ProcessName,

    # Имя компьютера, на котором нужно завершить процесс
    [string]$ComputerName = $ENV:COMPUTERNAME,

    # Учётные даннные
    [switch]$Credential
)

# Расширение процесса
[string]$Extension = '.exe'

# Проверка включён-ли компьютер
if (-not (Test-Connection $ComputerName -Count 1 -Quiet))
{
    Write-Warning "$ComputerName не доступен"
    break
}

#region Обработка PSBoundParameters
if ($PSBoundParameters.ContainsKey('Credential'))
{
	$PSBoundParameters.Credential = Get-Credential admin
}
$null = $PSBoundParameters.Remove('ProcessName')
#endregion

#region Если имя процесса указано без расширения - спрашиваем дописать-ли расширение
if (-not ($ProcessName.EndsWith($Extension)))
{
    #region Меню с вопросом
    $Title = "$ProcessName указано без расширения."
    $Message = "Добавить расширение ($Extension)?"

    $Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
        "Дописать к имени процесса расширение"
    $No = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
        "Оставить имя процесса как есть"

    $Options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $No)
    $Result = $host.ui.PromptForChoice($Title, $Message, $Options, 0) 

    switch ($Result)
        {
            # Дописываем расширение
            0
            {
			    $Name = "$($ProcessName)"+$Extension
		    }
            # Расширение не дописываем (оставляем имя процесса как есть)
            1
            {
                $Name = $ProcessName
            }
        }
    #endregion
}
# Если расширение есть - ничего не спрашиваем
else
{
    $Name = $ProcessName
}
#endregion

try
{
    # Если процесс есть такой процесс
    if ($Process = Get-WmiObject Win32_Process @PSBoundParameters -Filter "name = '$Name'")
    {
        #region На случай если процессов оказалось несколько
        # Если версия PSv3 и выше
        if ($PSVersionTable.PSVersion.Major -ge 3)
        {
            $Process.Terminate() | Out-Null
        }

        # Для PSv2 (и ниже) прибиваем процессы по одному в цикле
        else
        {
            foreach ($OneProcess in $Process)
            {
                $OneProcess.Terminate() | Out-Null
            }
        }
        #endregion
    }

    else
    {
        Write-Warning "$Name на $ComputerName не запущен"
    }
}

catch
{
    Write-Warning ("{0}: {1}" -f $ComputerName,$_.Exception.Message)
}