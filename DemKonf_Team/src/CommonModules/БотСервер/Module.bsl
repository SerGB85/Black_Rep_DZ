// @strict-types

Процедура ВыполнитьОбработкуБотов() Экспорт 
	
	СистемаВзаимодействия.ВыполнитьОбработкуБотов();
	
КонецПроцедуры

Процедура ВывестиПодсказку(ИдентификаторОбсуждения, ИдентификаторБота) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПериодПроверки = Константы.ПериодПроверкиНеотработанныхЗаказов.Получить();
	Если ПериодПроверки = 0 Тогда
		ПериодПроверки = 30;
	КонецЕсли;	
	Задание = РегламентныеЗадания.НайтиПредопределенное("НеотработанныеЗаказы");
	МассивТекстов = Новый Массив();
	МассивТекстов.Добавить(НСтр("ru = 'Также я буду сообщать раз в '", "ru"));
	МассивТекстов.Добавить(Новый ФорматированнаяСтрока(Строка(Задание.Расписание.ПериодПовтораДней) + " ", Новый Шрифт(,, Истина)));
	МассивТекстов.Добавить(СтрокаСЧислом(НСтр("ru = ';день;;дня;дней;дня'", "ru"), Задание.Расписание.ПериодПовтораДней, ВидЧисловогоЗначения.Количественное));
	МассивТекстов.Добавить(НСтр("ru = ' о заказах, которые не закрыты более '", "ru"));
	МассивТекстов.Добавить(Новый ФорматированнаяСтрока(Строка(ПериодПроверки) + " ", Новый Шрифт(,, Истина)));
	МассивТекстов.Добавить(СтрокаСЧислом(НСтр("ru = ';дня;;дней;дней;дней'", "ru"), ПериодПроверки, ВидЧисловогоЗначения.Количественное));
	
	Сообщение = СистемаВзаимодействия.СоздатьСообщение(ИдентификаторОбсуждения);
	Сообщение.Автор = ИдентификаторБота;
	Сообщение.Текст = 
		НСтр("ru = 'Я умею искать товары и контрагентов.'", "ru") + Символы.ПС +
		НСтр("ru = 'Введите наименование контрагента, чтобы получить состояние взаиморасчетов и последние незакрытые заказы.'", "ru") + Символы.ПС +
		НСтр("ru = 'Введите наименование товара, чтобы получить цены и остатки.'", "ru") + Символы.ПС +
		Новый  ФорматированнаяСтрока(МассивТекстов);

	РядКнопок = Сообщение.ПанельКнопок.РядыКнопок.Добавить();
	Кнопка = РядКнопок.Добавить(ДействиеКнопкиПанелиКнопокСообщенияСистемыВзаимодействия.ОбработатьНаКлиенте,
			              	    НСтр("ru = 'Настройка'", "ru"));
	Кнопка.ИмяДействия = "НастройкаБота";
								
	Кнопка = РядКнопок.Добавить(ДействиеКнопкиПанелиКнопокСообщенияСистемыВзаимодействия.ОбработатьНаКлиенте,
			              	    НСтр("ru = 'Проверить сейчас'", "ru"));
	Кнопка.ИмяДействия = "НеотработанныеЗаказы";

	Сообщение.Записать();
	
КонецПроцедуры

Функция ПолучитьИдентификаторОбсуждения(ИдентификаторПользователяСистемыВзаимодействия, 
										ИдентификаторПользователяСистемыВзаимодействияОфисМенеджер) Экспорт
	
	Обсуждение = СистемаВзаимодействия.СоздатьОбсуждение();
	Обсуждение.Групповое = Ложь;
	Обсуждение.Участники.Добавить(ИдентификаторПользователяСистемыВзаимодействия);
	Обсуждение.Участники.Добавить(ИдентификаторПользователяСистемыВзаимодействияОфисМенеджер);
	Обсуждение.Записать();
	
	Возврат Обсуждение.Идентификатор;
	
КонецФункции

Функция ПолучитьИдентификаторБота() Экспорт
	
	Боты = СистемаВзаимодействия.ПолучитьБотов();
	Для Каждого Бот Из Боты Цикл
		
		Если Бот.Метаданные = Метаданные.Боты.ОфисМенеджер Тогда
			Возврат Бот.Пользователь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

Процедура Инициализация() Экспорт
	
	Если НЕ СистемаВзаимодействия.ИспользованиеДоступно() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Создаем пользователей системы взаимодействия
	Для Каждого ПользовательИБ ИЗ ПользователиИнформационнойБазы.ПолучитьПользователей() Цикл	
		
		Если ПользовательИБ.Роли.Содержит(Метаданные.Роли.Администратор) ИЛИ
			 ПользовательИБ.Роли.Содержит(Метаданные.Роли.МенеджерПоЗакупкам) ИЛИ
			 ПользовательИБ.Роли.Содержит(Метаданные.Роли.МенеджерПоПродажам) ИЛИ
			 ПользовательИБ.Роли.Содержит(Метаданные.Роли.Продавец)
		Тогда
			
			Попытка
				
				ИдентификаторПользователяСистемыВзаимодействия =
					СистемаВзаимодействия.ПолучитьИдентификаторПользователя(ПользовательИБ.УникальныйИдентификатор);
				ПользовательСистемыВзаимодействия = 
					СистемаВзаимодействия.ПолучитьПользователя(ИдентификаторПользователяСистемыВзаимодействия);
				
			Исключение		
					
				ПользовательСистемыВзаимодействия = СистемаВзаимодействия.СоздатьПользователя(ПользовательИБ);
				ПользовательСистемыВзаимодействия.Записать();
				
			КонецПопытки;
		
		КонецЕсли;
		
	КонецЦикла;
	
	ВыполнитьОбработкуБотов();
	
	ИдентификаторПользователяСистемыВзаимодействияОфисМенеджер = ПолучитьИдентификаторБота();
	
	// Создаем пользователя для регламентного задания
	ПользовательИнформационнойБазыБот = ПользователиИнформационнойБазы.НайтиПоИмени("ПользовательБот");
	Если ПользовательИнформационнойБазыБот = Неопределено Тогда
		
		ПользовательИнформационнойБазыБот = ПользователиИнформационнойБазы.СоздатьПользователя();
		ПользовательИнформационнойБазыБот.Имя = "ПользовательБот";
		ПользовательИнформационнойБазыБот.ПолноеИмя = "Пользователь бот";
		ПользовательИнформационнойБазыБот.ПоказыватьВСпискеВыбора = Ложь;
		ПользовательИнформационнойБазыБот.Роли.Добавить(Метаданные.Роли.ПользовательБот);
		ПользовательИнформационнойБазыБот.Записать();
		
	КонецЕсли;
	
	// Включаем регламентные задания
	Задание = РегламентныеЗадания.НайтиПредопределенное("НеотработанныеЗаказы");
	Задание.Использование = Истина;
	Задание.ИмяПользователя = "ПользовательБот";
	Задание.Записать();
	
	// Записываем приветственное сообщение
	ПериодПроверки = Константы.ПериодПроверкиНеотработанныхЗаказов.Получить();
	Если ПериодПроверки = 0 Тогда
		
		ПериодПроверки = 30;

	КонецЕсли;
	
	МассивТекстов = Новый Массив();
	МассивТекстов.Добавить(
		Новый ФорматированнаяСтрока(
			НСтр("ru = 'Добро пожаловать!'", "ru"), Новый Шрифт(,,,,,, 120)));
	
	МассивТекстов.Добавить(Символы.ПС);
	
	МассивТекстов.Добавить(НСтр("ru = 'В этом обсуждении можно искать товары и контрагентов.'", "ru"));
	МассивТекстов.Добавить(Символы.ПС);
	МассивТекстов.Добавить(НСтр("ru = 'Введите наименование контрагента, чтобы получить состояние взаиморасчетов и последние незакрытые заказы.'", "ru"));
	МассивТекстов.Добавить(Символы.ПС);
	МассивТекстов.Добавить(НСтр("ru = 'Введите наименование товара, чтобы получить цены и остатки.'", "ru"));
	МассивТекстов.Добавить(Символы.ПС);
	МассивТекстов.Добавить(Символы.ПС);
	МассивТекстов.Добавить(НСтр("ru = 'Также в этом обсуждении бот будет сообщать раз в '", "ru"));
	МассивТекстов.Добавить(Новый ФорматированнаяСтрока(Строка(Задание.Расписание.ПериодПовтораДней) + " ", Новый Шрифт(,, Истина)));
	МассивТекстов.Добавить(СтрокаСЧислом(НСтр("ru = ';день;;дня;дней;дня'", "ru"), Задание.Расписание.ПериодПовтораДней, ВидЧисловогоЗначения.Количественное));
	МассивТекстов.Добавить(НСтр("ru = ' о заказах, которые не закрыты более '", "ru"));
	МассивТекстов.Добавить(Новый ФорматированнаяСтрока(Строка(ПериодПроверки) + " ", Новый Шрифт(,, Истина)));
	МассивТекстов.Добавить(СтрокаСЧислом(НСтр("ru = ';дня;;дней;дней;дней'", "ru"), ПериодПроверки, ВидЧисловогоЗначения.Количественное));
	
	Для Каждого ПользовательИБ ИЗ ПользователиИнформационнойБазы.ПолучитьПользователей() Цикл	
		
		Если ПользовательИБ.Роли.Содержит(Метаданные.Роли.Администратор) ИЛИ
			 ПользовательИБ.Роли.Содержит(Метаданные.Роли.МенеджерПоПродажам)
		Тогда
		
			ИдентификаторПользователяСистемыВзаимодействия =
				СистемаВзаимодействия.ПолучитьИдентификаторПользователя(ПользовательИБ.УникальныйИдентификатор);
		
			ИдентификаторОбсуждения = ПолучитьИдентификаторОбсуждения(
										ИдентификаторПользователяСистемыВзаимодействия,
										ИдентификаторПользователяСистемыВзаимодействияОфисМенеджер);
			
			Сообщение = СистемаВзаимодействия.СоздатьСообщение(ИдентификаторОбсуждения);
			Сообщение.Автор = ИдентификаторПользователяСистемыВзаимодействияОфисМенеджер;
			Сообщение.Текст = Новый ФорматированнаяСтрока(МассивТекстов);

			РядКнопок = Сообщение.ПанельКнопок.РядыКнопок.Добавить();
			Кнопка = РядКнопок.Добавить(ДействиеКнопкиПанелиКнопокСообщенияСистемыВзаимодействия.ОбработатьНаКлиенте,
					              	    НСтр("ru = 'Настройка'", "ru"));
			Кнопка.ИмяДействия = "НастройкаБота";
										
			Кнопка = РядКнопок.Добавить(ДействиеКнопкиПанелиКнопокСообщенияСистемыВзаимодействия.ОбработатьНаКлиенте,
					              	    НСтр("ru = 'Проверить сейчас'", "ru"));
			Кнопка.ИмяДействия = "НеотработанныеЗаказы";

			Сообщение.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура Отключение() Экспорт
	
	// Отключаем регламентные задания
	Задание = РегламентныеЗадания.НайтиПредопределенное("НеотработанныеЗаказы");
	Задание.Использование = Ложь;
	Задание.Записать();

КонецПроцедуры

Процедура НеотработанныеЗаказы() Экспорт
	
	Если НЕ СистемаВзаимодействия.ИспользованиеДоступно() Тогда
		Возврат;
	КонецЕсли;
	
	// Выбираем заказы
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Заказ.Ссылка КАК Ссылка,
	               |	ПРЕДСТАВЛЕНИЕССЫЛКИ(Заказ.Ссылка) КАК СсылкаПредставление,
	               |	Заказ.Сумма КАК Сумма,
	               |	Заказ.Покупатель КАК Покупатель,
	               |	ПРЕДСТАВЛЕНИЕССЫЛКИ(Заказ.Покупатель) КАК ПокупательПредставление
	               |ИЗ
	               |	Документ.Заказ КАК Заказ
	               |ГДЕ
	               |	Заказ.ПометкаУдаления = ЛОЖЬ
	               |	И Заказ.СостояниеЗаказа <> ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказов.Закрыт)
	               |	И Заказ.СостояниеЗаказа <> ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказов.Выполнен)
	               |	И Заказ.Дата < &Дата
	               |УПОРЯДОЧИТЬ ПО
	               |	Заказ.Дата";
	
	ПериодПроверки = Константы.ПериодПроверкиНеотработанныхЗаказов.Получить();
	Если ПериодПроверки = 0 Тогда
		
		ПериодПроверки = 30;

	КонецЕсли;
	
	Запрос.УстановитьПараметр("Дата", НачалоДня(ТекущаяДата()) - ПериодПроверки * 24 * 60 * 60);

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	МассивТекстов = Новый Массив();
	МассивТекстов.Добавить(
		Новый ФорматированнаяСтрока(
			НСтр("ru = 'Заказы, незакрытые более '", "ru"), Новый Шрифт(,,,,,, 120)));
	МассивТекстов.Добавить(
		Новый ФорматированнаяСтрока(Строка(ПериодПроверки) + " ", Новый Шрифт(,, Истина,,,, 120)));
	МассивТекстов.Добавить(
		Новый ФорматированнаяСтрока(
			СтрокаСЧислом(НСтр("ru = ';дня;;дней;дней;дней'", "ru"), ПериодПроверки, ВидЧисловогоЗначения.Количественное),
			Новый Шрифт(,, ,,,, 120)));
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		МассивТекстов.Добавить(Символы.ПС);
		МассивТекстов.Добавить(Новый ФорматированнаяСтрока(Выборка.СсылкаПредставление,,,, ПолучитьНавигационнуюСсылку(Выборка.Ссылка)));
		МассивТекстов.Добавить(" (" + НСтр("ru = 'Сумма: '", "ru") + Формат(Выборка.Сумма, "ЧДЦ=2"));
		МассивТекстов.Добавить("  " + НСтр("ru = 'Покупатель: '", "ru"));
		МассивТекстов.Добавить(Новый ФорматированнаяСтрока(Выборка.ПокупательПредставление,,,, ПолучитьНавигационнуюСсылку(Выборка.Покупатель)));
		МассивТекстов.Добавить(")");
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификаторПользователяСистемыВзаимодействияОфисМенеджер = ПолучитьИдентификаторБота();
		
	ИдентификаторОбсуждения = ПолучитьИдентификаторОбсуждения(
								СистемаВзаимодействия.ИдентификаторТекущегоПользователя(),
								ИдентификаторПользователяСистемыВзаимодействияОфисМенеджер);

	Сообщение = СистемаВзаимодействия.СоздатьСообщение(ИдентификаторОбсуждения);
	Сообщение.Автор = ИдентификаторПользователяСистемыВзаимодействияОфисМенеджер;
	
	Сообщение.Текст = Новый ФорматированнаяСтрока(МассивТекстов);
	РядКнопок = Сообщение.ПанельКнопок.РядыКнопок.Добавить();
	Кнопка = РядКнопок.Добавить(ДействиеКнопкиПанелиКнопокСообщенияСистемыВзаимодействия.ОбработатьНаКлиенте,
			              	    НСтр("ru = 'Настройка'", "ru"));
	Кнопка.ИмяДействия = "НастройкаБота";
								
	Кнопка = РядКнопок.Добавить(ДействиеКнопкиПанелиКнопокСообщенияСистемыВзаимодействия.ОбработатьНаКлиенте,
			              	    НСтр("ru = 'Проверить сейчас'", "ru"));
	Кнопка.ИмяДействия = "НеотработанныеЗаказы";
	Сообщение.Записать();
			
КонецПроцедуры

Процедура ИзменениеНастройки() Экспорт
	
	Если НЕ СистемаВзаимодействия.ИспользованиеДоступно() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПериодПроверки = Константы.ПериодПроверкиНеотработанныхЗаказов.Получить();
	Если ПериодПроверки = 0 Тогда
		
		ПериодПроверки = 30;

	КонецЕсли;
	
	Задание = РегламентныеЗадания.НайтиПредопределенное("НеотработанныеЗаказы");
	
	МассивТекстов = Новый Массив();
	МассивТекстов.Добавить(НСтр("ru = 'Бот будет сообщать раз в '", "ru"));
	МассивТекстов.Добавить(Новый ФорматированнаяСтрока(Строка(Задание.Расписание.ПериодПовтораДней) + " ", Новый Шрифт(,, Истина)));
	МассивТекстов.Добавить(СтрокаСЧислом(НСтр("ru = ';день;;дня;дней;дня'", "ru"), Задание.Расписание.ПериодПовтораДней, ВидЧисловогоЗначения.Количественное));
	МассивТекстов.Добавить(НСтр("ru = ' о заказах, которые не закрыты более '", "ru"));
	МассивТекстов.Добавить(Новый ФорматированнаяСтрока(Строка(ПериодПроверки) + " ", Новый Шрифт(,, Истина)));
	МассивТекстов.Добавить(СтрокаСЧислом(НСтр("ru = ';дня;;дней;дней;дней'", "ru"), ПериодПроверки, ВидЧисловогоЗначения.Количественное));
	
	ИдентификаторПользователяСистемыВзаимодействияОфисМенеджер = ПолучитьИдентификаторБота();
	
	ИдентификаторОбсуждения = ПолучитьИдентификаторОбсуждения(
								СистемаВзаимодействия.ИдентификаторТекущегоПользователя(),
								ИдентификаторПользователяСистемыВзаимодействияОфисМенеджер);
	
	Сообщение = СистемаВзаимодействия.СоздатьСообщение(ИдентификаторОбсуждения);
	Сообщение.Автор = ИдентификаторПользователяСистемыВзаимодействияОфисМенеджер;
	Сообщение.Текст = Новый ФорматированнаяСтрока(МассивТекстов);
	РядКнопок = Сообщение.ПанельКнопок.РядыКнопок.Добавить();
	Кнопка = РядКнопок.Добавить(ДействиеКнопкиПанелиКнопокСообщенияСистемыВзаимодействия.ОбработатьНаКлиенте,
			              	    НСтр("ru = 'Настройка'", "ru"));
	Кнопка.ИмяДействия = "НастройкаБота";
								
	Кнопка = РядКнопок.Добавить(ДействиеКнопкиПанелиКнопокСообщенияСистемыВзаимодействия.ОбработатьНаКлиенте,
			              	    НСтр("ru = 'Проверить сейчас'", "ru"));
	Кнопка.ИмяДействия = "НеотработанныеЗаказы";
	Сообщение.Записать();
	
КонецПроцедуры

Процедура ДобавитьФайлКТовару(Ссылка, Адрес, ИмяФайла, УстановитьКартинку) Экспорт
	
	ХранимыйФайл = Справочники.ХранимыеФайлы.СоздатьЭлемент();
	ХранимыйФайл.Владелец = Ссылка;
	ХранимыйФайл.Наименование = ИмяФайла;
	ХранимыйФайл.ИмяФайла = ИмяФайла;
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
	ХранимыйФайл.ДанныеФайла = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных());
	ХранимыйФайл.Записать(); 

	Если УстановитьКартинку Тогда
		Объект = Ссылка.ПолучитьОбъект();
		Объект.ФайлКартинки = ХранимыйФайл.Ссылка;
		Объект.Записать();
	КонецЕсли;
	
КонецПроцедуры