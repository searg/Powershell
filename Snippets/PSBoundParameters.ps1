<#

Демонстрация обращения к PSBoundParameters через сплаттинг

Примеры вызова функции:

Get-ComputerInfo
    - функция будет выполнена для локального компьютера, от имени текущего пользователя

Get-ComputerInfo -ComputerName server -Credential
    - функция бужет выполнена для компьютера server, перед выполнением будут запрошены учётные данные
#>

function Get-ComputerInfo
{
	param
	(
	    # Самый нужный параметр
        $ComputerName,

        # Опциональный параметр
        [switch]$Credential,

        # Какой-то ещё параметр
	    $SomethingElse
	)

	# Перед обращением к PSBoundParameters нужно удалить все параметры, которых там не может быть
    $null = $PSBoundParameters.Remove('SomethingElse')

	# Если в запросе указан параметр Credential - спросить учётные данные
    if ($PSBoundParameters.ContainsKey('Credential'))
	{
		$PSBoundParameters.Credential = Get-Credential admin
	}

	$User = Get-WmiObject Win32_ComputerSystem @PSBoundParameters |
		Select-Object -ExpandProperty UserName
	$OS = Get-WmiObject Win32_OperatingSystem @PSBoundParameters |
		Select-Object -ExpandProperty CSName

	$User
	$OS
}