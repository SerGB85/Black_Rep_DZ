// @strict-types

// Функция позволяет пучить значение перечисления статуса транзакции
// по его имени
//
// Параметры :
//  Имя - имя значения перечисления
//
// Возврат :
//  значение перечисления или Неопределено, если имя неверное
Функция СтатусТранзакцииЗаписиЖурналаРегистрацииЗначениеПоИмени(Имя) Экспорт
	ЗначениеПеречисления = Неопределено;
	Если Имя = "Зафиксирована" Тогда
		ЗначениеПеречисления = СтатусТранзакцииЗаписиЖурналаРегистрации.Зафиксирована;
	ИначеЕсли Имя = "НеЗавершена" Тогда
		ЗначениеПеречисления = СтатусТранзакцииЗаписиЖурналаРегистрации.НеЗавершена;
	ИначеЕсли Имя = "НетТранзакции" Тогда
		ЗначениеПеречисления = СтатусТранзакцииЗаписиЖурналаРегистрации.НетТранзакции;
	ИначеЕсли Имя = "Отменена" Тогда
		ЗначениеПеречисления = СтатусТранзакцииЗаписиЖурналаРегистрации.Отменена;
	КонецЕсли;
	Возврат ЗначениеПеречисления;
КонецФункции

// Функция позволяет пучить значение перечисления уровня сообщения
// по его имени
//
// Параметры :
//  Имя - имя значения перечисления
//
// Возврат :
//  значение перечисления или Неопределено, если имя неверное
Функция УровеньЖурналаРегистрацииЗначениеПоИмени(Имя) Экспорт
	ЗначениеПеречисления = Неопределено;
	Если Имя = "Информация" Тогда
		ЗначениеПеречисления = УровеньЖурналаРегистрации.Информация;
	ИначеЕсли Имя = "Ошибка" Тогда
		ЗначениеПеречисления = УровеньЖурналаРегистрации.Ошибка;
	ИначеЕсли Имя = "Предупреждение" Тогда
		ЗначениеПеречисления = УровеньЖурналаРегистрации.Предупреждение;
	ИначеЕсли Имя = "Примечание" Тогда
		ЗначениеПеречисления = УровеньЖурналаРегистрации.Примечание;
	КонецЕсли;
	Возврат ЗначениеПеречисления;
КонецФункции
