# Пример работы с вложенными хеш-таблицами

$User = @{}
$User.Name = 'Иван'
$User.LastName = 'Иванов'

# Элемент хеш-таблицы, содержащий хеш-таблицу
$User.Address = @{}
$User.Address.StreetAddress = 'Московское ш., 101, кв.101'
$User.Address.City = 'Крыжополь'
$User.Address.PostalCode = 101101

# Элемент хеш-таблицы, содержащий массив
$User.PhoneNumbers = New-Object "object[]" 2
$User.PhoneNumbers[0] = '111 123-1234'
$User.PhoneNumbers[1] = '222 123-4567'

# Обращение к элементам хеш-таблицы
$User.Address
$User.Address.StreetAddress
$User.Address.City

$User.PhoneNumbers
$User.PhoneNumbers[1]