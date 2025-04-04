// @strict-types


//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ 
// 

Процедура ОбработкаПроведения(Отказ, Режим)
	// Формирование движения регистра накопления Взаиморасчеты
	Движения.Взаиморасчеты.Записывать = Истина;
	Движение = Движения.Взаиморасчеты.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Контрагент = Покупатель;
	Движение.Валюта = Валюта;
	Движение.Сумма = Сумма;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РасходТовара") Тогда
		Валюта = ДанныеЗаполнения.Валюта;
		Покупатель = ДанныеЗаполнения.Покупатель;
		Организация = ДанныеЗаполнения.Организация;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Контрагенты") Тогда
		
		ЗапросПоКонтрагенту = Новый Запрос("ВЫБРАТЬ
		                                   |	Контрагенты.ЭтоГруппа
		                                   |ИЗ
		                                   |	Справочник.Контрагенты КАК Контрагенты
		                                   |ГДЕ
		                                   |	Контрагенты.Ссылка = &КонтрагентСсылка");
		ЗапросПоКонтрагенту.УстановитьПараметр("КонтрагентСсылка", ДанныеЗаполнения);
		Выборка = ЗапросПоКонтрагенту.Выполнить().Выбрать();
		Если Выборка.Следующий() И Выборка.ЭтоГруппа Тогда
			Возврат;
		КонецЕсли;
		
		Покупатель = ДанныеЗаполнения.Ссылка;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	//Удалим из списка проверяемых реквизитов валюту, если по организации не ведется 
	//валютный учет
	Если НЕ ПолучитьФункциональнуюОпцию("ВалютныйУчет", Новый Структура("Организация", Организация)) Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Валюта"));
	КонецЕсли;	
	
КонецПроцедуры
