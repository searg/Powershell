# Пример, демонстрирующий как приостановить работу скрипта/функции
# до нажатия любой клавиши

Write-Host 'Press any key to continue...'
$null = [Console]::ReadKey('?')
# или так:
# $null = $host.UI.RawUI.ReadKey()