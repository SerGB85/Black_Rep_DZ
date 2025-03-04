///////////////////////////////////////////////////////////////////////
// Модуль содержит процедуры и функции работы с агрегатами, используемые
// регламентными заданиями

// @strict-types


// Регламентное задание ОбновлениеАгрегатовПродаж.
// Параметры: 
//  Нет
Процедура ОбновлениеАгрегатовПродаж() Экспорт
	Если РегистрыНакопления.Продажи.ПолучитьРежимАгрегатов()
		 И  РегистрыНакопления.Продажи.ПолучитьИспользованиеАгрегатов() Тогда
		 
		РегистрыНакопления.Продажи.ОбновитьАгрегаты(Истина);
	КонецЕсли
КонецПроцедуры

// Регламентное задание ПерестроениеАгрегатовПродаж.
// Параметры: 
//  Нет
Процедура ПерестроениеАгрегатовПродаж() Экспорт
	Если РегистрыНакопления.Продажи.ПолучитьРежимАгрегатов()
		И РегистрыНакопления.Продажи.ПолучитьИспользованиеАгрегатов() Тогда
		
		РегистрыНакопления.Продажи.ПерестроитьИспользованиеАгрегатов();
	КонецЕсли
КонецПроцедуры