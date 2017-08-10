# Изменение атрибутов файла/каталога
# В скрипте представлена функция, изменяющая атрибут(ы) и её вызов
# Эту функцию при необходимости можно подставлять в скрипты (например, при резервном копировании)


<# ----------- ПРИМЕРЫ ВЫЗОВА -----------

Switch-FileAttribute -Path C:\readme.txt -Attribute Archive
Switch-FileAttribute -Path C:\readme.txt -Attribute Archive, ReadOnly
'С:\readme.txt' | .\Switch-FileAttributes.ps1 -Attribute Archive, ReadOnly, Hidden

# Для всех файлов в каталоге
$Files = Get-ChildItem C:\Windows -Force
foreach($File in $Files)
{
    Switch-FileAttributes.ps1 -Path $File.FullName -Attribute Hidden
}

#>

[CmdletBinding()]
param
(
    # Путь к файлу
    [Parameter(Mandatory=$true,
    ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true)]
    [String]
    $Path,

    # Атрибут файла, который нужно изменить
    [Parameter(Mandatory=$true)]
    [System.IO.FileAttributes]
    $Attribute
)

# Функция, реализующая переключение атрибутов
Function Switch-FilesystemItemAttribute
{
    param
    (
        # Путь к файлу/каталогу
        [Parameter(Mandatory=$true)]
        [String]
        $Path,

        # Атрибут, который нужно изменить
        [Parameter(Mandatory=$true)]
        [System.IO.FileAttributes]
        $Attribute
    )

    # Получаем файл/каталог, для которого нужно изменить атрибуты
    $Item = Get-Item $Path -Force

    # Переключаем значение указанного атрибута
    $Attributes = $Item.Attributes -bxor $Attribute
    
    # Устанавливаем новые атрибуты
    [System.IO.File]::SetAttributes($Item, $Attributes)
}

# Вызов функции - переключение атрибута
Switch-FilesystemItemAttribute -Path $Path -Attribute $Attribute