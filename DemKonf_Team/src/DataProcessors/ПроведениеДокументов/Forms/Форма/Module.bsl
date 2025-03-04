// @strict-types


&НаКлиенте
Процедура ПровестиВыполнить(Команда)
	ВыполнитьПроведение();
КонецПроцедуры

&НаКлиенте
Асинх Процедура ВыполнитьПроведение()
	Если Объект.ВыбранныеДокументы.Количество() = 0 Тогда
		Ждать ПредупреждениеАсинх(
			НСтр("ru = 'Не выбраны документы!'", "ru"));
		Возврат;
	КонецЕсли;	
	Если НЕ ЗначениеЗаполнено(ДатаНачала) ИЛИ НЕ ЗначениеЗаполнено(ДатаОкончания) Тогда
		Ждать ПредупреждениеАсинх(
			НСтр("ru = 'Неверный интервал!'", "ru"));
		Возврат;
	КонецЕсли;	
	Если ДатаНачала > ДатаОкончания Тогда
		Ждать ПредупреждениеАсинх(
			НСтр("ru = 'Неверный интервал!'", "ru"));
		Возврат;
	КонецЕсли;	
	//Проведение документов в цикле по дням выбранного интервала
	КоличествоПроведенных = 0;
	ДатаПроведения = ДатаНачала;
	Пока ДатаПроведения <= ДатаОкончания Цикл
		ОбработкаПрерыванияПользователя();
		Состояние(НСтр("ru = 'Выполняется проведение за '", "ru") 
			+ Формат(ДатаПроведения, "ДЛФ=DD") 
			+ Символы.ПС 
			+ НСтр("ru = 'Проведено '", "ru") 
			+ КоличествоПроведенных);
				  
		//Вызов проведения на сервере за один день		  
		ТекущееКоличествоПроведенных = 0;		  
		ПровестиНаСервере(ДатаПроведения, ТекущееКоличествоПроведенных);
		КоличествоПроведенных = КоличествоПроведенных + ТекущееКоличествоПроведенных;
		ДатаПроведения = ДатаПроведения + 24 * 60 * 60;	
	КонецЦикла;
	Состояние(НСтр("ru = 'Проведение документов завершено'", "ru")
		+ Символы.ПС 
		+ НСтр("ru = 'Проведено '", "ru") 
		+ КоличествоПроведенных);
КонецПроцедуры

//Проведение документов за один день 
&НаСервере
Процедура ПровестиНаСервере(ДатаПроведения, ТекущееКоличествоПроведенных)
	Обработка = РеквизитФормыВЗначение("Объект");
	Обработка.Провести(ДатаПроведения, КонецДня(ДатаПроведения), ТекущееКоличествоПроведенных);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДатаНачала = НачалоДня(ТекущаяДата());
	ДатаОкончания = НачалоДня(ТекущаяДата());
	Проводить = "Проведенные";
	
	//Подготовка списка видов документов
	Обработка = РеквизитФормыВЗначение("Объект");
	Обработка.ЗаполнитьСписок();
	ЗначениеВРеквизитФормы(Обработка, "Объект");
КонецПроцедуры

//Исключание документов из списка выбранных
&НаКлиенте
Процедура Исключить()
	Для каждого ИдентификаторЭлемента Из Элементы.ВыбранныеДокументы.ВыделенныеСтроки Цикл
		Объект.ВыбранныеДокументы.Удалить(Объект.ВыбранныеДокументы.НайтиПоИдентификатору(ИдентификаторЭлемента)); 
	КонецЦикла;	
КонецПроцедуры

//Добавление документов в список выбранных
&НаКлиенте
Процедура Добавить()
	Для каждого ИдентификаторЭлемента Из Элементы.СписокДокументов.ВыделенныеСтроки Цикл
		Элемент = Объект.СписокДокументов.НайтиПоИдентификатору(ИдентификаторЭлемента);
		Если Объект.ВыбранныеДокументы.НайтиПоЗначению(Элемент.Значение) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;	
		Объект.ВыбранныеДокументы.Добавить(Элемент.Значение, Элемент.Представление);
	КонецЦикла;	
	Объект.ВыбранныеДокументы.СортироватьПоПредставлению();
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Исключить();
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Добавить();
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВыполнить()
	Исключить();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВыполнить()
	Добавить();
КонецПроцедуры
