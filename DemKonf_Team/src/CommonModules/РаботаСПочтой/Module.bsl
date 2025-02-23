// @strict-types

// Получить профиль и имя отправителя для данной настройки.
//
// Параметры:
// ИмяОтправителя - Строка - в данном параметре возвращается имя отправителя
//				почтового сообщения по умолчанию.
// ИспользоватьIMAP - Булево - в данном параметре признак использования IMAP для работы с почтой.
//
// Возвращаемое значения:
// Объект ИнтернетПочтовыйПрофиль. Набор свойств для соединения с почтовым сервером,
// заполненный текущими настройками (см. соответствующие константы).
Функция ПолучитьПрофиль(ИмяОтправителя = "", ИспользоватьIMAP = Ложь) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Константы.АдресSMTPСервера,
	               |	Константы.ПортSMTP,
	               |	Константы.ПользовательSMTP,
	               |	Константы.ПарольSMTP,
	               |	Константы.АдресPOP3Сервера,
	               |	Константы.ПортPOP3,
	               |	Константы.ПользовательPOP3,
	               |	Константы.ПарольPOP3,
				   |	Константы.АдресIMAPСервера,
				   |	Константы.ПортIMAP,
				   |	Константы.ПользовательIMAP,
				   |	Константы.ПарольIMAP,
				   |	Константы.SSLIMAP,
				   |	Константы.ИспользоватьIMAP,
	               |	Константы.ТаймаутИнтернетПочты,
	               |	Константы.ИмяОтправителяПочтовогоСообщения,
                   |    Константы.SSLPOP3,
                   |    Константы.SSLSMTP,
                   |    Константы.ТолькоЗащищеннаяАутентификацияIMAP,
                   |    Константы.ТолькоЗащищеннаяАутентификацияPOP3,
                   |    Константы.ТолькоЗащищеннаяАутентификацияSMTP                   
	               |ИЗ
	               |	Константы КАК Константы";
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Профиль = Новый ИнтернетПочтовыйПрофиль;
    
	Профиль.АдресСервераSMTP = Выборка.АдресSMTPСервера;
	Профиль.ПортSMTP = Выборка.ПортSMTP;
	Профиль.ИспользоватьSSLSMTP = Выборка.SSLSMTP;
    Профиль.ПарольSMTP = Выборка.ПарольSMTP;
	Профиль.ПользовательSMTP = Выборка.ПользовательSMTP;
	Профиль.ТолькоЗащищеннаяАутентификацияSMTP = 
            Выборка.ТолькоЗащищеннаяАутентификацияSMTP;    
    
	Профиль.АдресСервераIMAP = Выборка.АдресIMAPСервера;
	Профиль.ПортIMAP = Выборка.ПортIMAP;
	Профиль.ИспользоватьSSLIMAP = Выборка.SSLIMAP;
	Профиль.ПользовательIMAP = Выборка.ПользовательIMAP;
	Профиль.ПарольIMAP = Выборка.ПарольIMAP;
	Профиль.ТолькоЗащищеннаяАутентификацияIMAP = 
            Выборка.ТолькоЗащищеннаяАутентификацияIMAP;	
	
	Профиль.АдресСервераPOP3 = Выборка.АдресPOP3Сервера;
	Профиль.ПортPOP3 = Выборка.ПортPOP3;
    Профиль.ИспользоватьSSLPOP3 = Выборка.SSLPOP3;
	Профиль.Пароль = Выборка.ПарольPOP3;
	Профиль.Пользователь = Выборка.ПользовательPOP3;
	Профиль.ТолькоЗащищеннаяАутентификацияPOP3 = 
            Выборка.ТолькоЗащищеннаяАутентификацияPOP3;
	
	Профиль.ВремяОжидания = Выборка.ТаймаутИнтернетПочты;
    
	ИмяОтправителя = Выборка.ИмяОтправителяПочтовогоСообщения;
	ИспользоватьIMAP = Выборка.ИспользоватьIMAP;
    
	Возврат Профиль;
КонецФункции

// Получить идентификаторы ранее загруженных писем.
//
// Возвращаемое значение:
// Массив идентификаторов писем, загруженных в систему.
Функция ПолучитьИдентификаторыЗагруженныхПисем() Экспорт
	Идентификаторы = Новый Массив();
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ Идентификатор ИЗ Справочник.ВходящиеПисьма";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Идентификаторы.Добавить(Выборка.Идентификатор);
	КонецЦикла;
	Возврат Идентификаторы;
КонецФункции

// Получить новые письма из указанного профиля.
//
// Параметры:
// Профиль - ИнтернетПочтовыйПрофиль - описание соединения с почтовым сервером,
// откуда требуется получить электронные письма.
//
// Возвращаемое значение:
// Количество полученных писем.
Функция ПолучитьНовыеПисьма(Профиль, ИспользоватьIMAP, ПочтовыйЯщик) Экспорт
	Почта = Новый ИнтернетПочта;
	
	Попытка
		Если ИспользоватьIMAP Тогда
			Почта.Подключиться(Профиль, ПротоколИнтернетПочты.IMAP);
			Если ПочтовыйЯщик = "" Тогда
				ПочтовыйЯщик = "INBOX";
			КонецЕсли;
			Почта.ТекущийПочтовыйЯщик = ПочтовыйЯщик;
		Иначе;
			Почта.Подключиться(Профиль, ПротоколИнтернетПочты.POP3);
		КонецЕсли;
	Исключение
		Сообщить(НСтр("ru = 'Ошибка при подключении к почтовому серверу. Проверьте настройки.'"));
		Возврат 0;
	КонецПопытки;
	
	ЗагруженныеПисьма = ПолучитьИдентификаторыЗагруженныхПисем();
	ИдентификаторыНовыхПисем = Почта.ПолучитьИдентификаторы(ЗагруженныеПисьма);
	Если ИдентификаторыНовыхПисем.Количество() = 0 Тогда
		Возврат 0;
	КонецЕсли;
	Письма = Почта.Выбрать(Ложь, ИдентификаторыНовыхПисем);
	Для каждого Письмо Из Письма Цикл 
		ПисьмоОбъект = Справочники.ВходящиеПисьма.СоздатьЭлемент();
		ПисьмоОбъект.Идентификатор = Письмо.Идентификатор[0];
		ПисьмоОбъект.Наименование = Письмо.Тема;
		ПисьмоОбъект.Дата = Письмо.ДатаОтправления;
		ПисьмоОбъект.Отправитель = Письмо.Отправитель;		
		Если ИспользоватьIMAP Тогда
		    ПисьмоОбъект.ПочтовыйЯщик = "IMAP/" + ПочтовыйЯщик;
		Иначе
			ПисьмоОбъект.ПочтовыйЯщик = "POP3";
		КонецЕсли;
		Для каждого Элемент Из Письмо.Тексты Цикл
			Если Элемент.ТипТекста = ТипТекстаПочтовогоСообщения.HTML Тогда
				ПисьмоОбъект.ВидСодержимого = Перечисления.ВидСодержимогоВходящегоПисьма.HTML;
				Текст = Элемент.Текст;
				Если Найти(Текст, "<HTML>") = 0 Тогда
					Текст = "<HTML><BODY>" + Текст + "</BODY></HTML>";
				КонецЕсли;
				Вложения = Новый Массив;
				// обрабатываем вложения, что бы правильно сформировать HTML
				Для каждого Вложение Из Письмо.Вложения Цикл
					Ид = "cid:" + Вложение.Идентификатор;
					Если Найти(Текст, Ид) <> 0 Тогда
						Вложения.Добавить(Вложение);
					КонецЕсли;
				КонецЦикла;
				Прервать;
			ИначеЕсли Элемент.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст Тогда
				ПисьмоОбъект.ВидСодержимого = Перечисления.ВидСодержимогоВходящегоПисьма.Текст;
				Текст = Элемент.Текст;
			КонецЕсли;
		КонецЦикла;
		
		
		НачатьТранзакцию();
		ПисьмоОбъект.УстановитьСсылкуНового(Справочники.ВходящиеПисьма.ПолучитьСсылку());
		Если ПисьмоОбъект.ВидСодержимого = Перечисления.ВидСодержимогоВходящегоПисьма.HTML Тогда
			Для каждого Вложение Из Вложения Цикл
				ВложениеОбъект = Справочники.ПочтовыеВложения.СоздатьЭлемент();
				ВложениеОбъект.Владелец = ПисьмоОбъект.ПолучитьСсылкуНового();
				ВложениеОбъект.Наименование = Вложение.Имя;
				ВложениеОбъект.Данные = Новый ХранилищеЗначения(Вложение.Данные, Новый СжатиеДанных());
				ВложениеОбъект.Записать();
				Ид = """cid:" + Вложение.Идентификатор + """";
				НовыйИд = ПолучитьНавигационнуюСсылку(ВложениеОбъект.Ссылка, "Данные");
				Текст = СтрЗаменить(Текст, Ид, "'" + НовыйИд + "'");
			КонецЦикла;	
		КонецЕсли;
		ПисьмоОбъект.Текст = Текст;
		ПисьмоОбъект.Записать();
		ЗафиксироватьТранзакцию();
	КонецЦикла;
	Почта.Отключиться();
	Возврат Письма.Количество();
КонецФункции

// Создать интернет почтовое сообщение.
//
// Параметры:
// Письмо - СправочникСсылка.ИсходящиеПисьма - элемент справочника, на основании которого
//				следует оформить объект системы ИнтернетПочтовоеСообщение для дальнейшей
//				отправки с помощью механизмов интернет почты.
// Отправитель - Строка - имя отправителя почтового сообщения
//
// Возвращаемое значение:
// Объект ИнтернетПочтовоеСообщение. Содержит почтовое сообщение, готовое к отправке.
Функция СоздатьИнтернетПочтовоеСообщение(Письмо, Отправитель) Экспорт
	Перем HTML, Картинки;
	Сообщение = Новый ИнтернетПочтовоеСообщение;
	Сообщение.Тема = Письмо.Наименование;
	Сообщение.Отправитель = Отправитель;
	Для каждого Получатель из Письмо.Получатели Цикл
		ЭлектроннаяПочта = СокрЛП(Получатель.ЭлектроннаяПочта);
		Сообщение.Получатели.Добавить(ЭлектроннаяПочта);
	КонецЦикла;
	
	Содержимое = Письмо.Содержимое.Получить();
	Содержимое.ПолучитьHTML(HTML, Картинки);
	Для Каждого Картинка Из Картинки цикл
		Вложение = Сообщение.Вложения.Добавить(Картинка.Значение.ПолучитьДвоичныеДанные());
		Вложение.Идентификатор = Картинка.Ключ; 
		HTML = СтрЗаменить(HTML, Картинка.Ключ, "cid:" + Вложение.Идентификатор);
	КонецЦикла;		
	
	Текст = Сообщение.Тексты.Добавить(HTML);
	Текст.ТипТекста = ТипТекстаПочтовогоСообщения.HTML;
	Возврат Сообщение;
КонецФункции

// Отправить почтовое сообщение.
//
// Параметры:
// Письмо - СправочникСсылка.ИсходящиеПисьма - письмо, которое необходимо отправить.
//
// Возвращаемое значение:
// Истина - письмо удачно отправлено.
// Ложь - не создан профиль с описанием почтового сервера.
Функция ОтправитьПисьмо(Письмо) Экспорт
	Перем Отправитель;
	Ошибка = "";
	Профиль = ПолучитьПрофиль(Отправитель);
	Если Профиль.АдресСервераSMTP = "" Тогда
		Возврат Ложь;
	КонецЕсли;
	Сообщение = СоздатьИнтернетПочтовоеСообщение(Письмо, Отправитель);
	
	ИнтернетПочта = Новый ИнтернетПочта;
	ИнтернетПочта.Подключиться(Профиль);
	ИнтернетПочта.Послать(Сообщение);
    ИнтернетПочта.Отключиться();
	
	НЗ = РегистрыСведений.СостояниеИсходящихПисем.СоздатьНаборЗаписей();
	НЗ.Отбор.Письмо.Установить(Письмо);
	Запись = НЗ.Добавить();
	Запись.Письмо = Письмо;
	Запись.Отправлено = Истина;
	НЗ.Записать();
	Возврат Истина;
КонецФункции

// Проверить что у письма статус отправлено.
//
// Параметры:
// Письмо - СправочникСсылка.ИсходящиеПисьма - письмо, статус отправки которого необходимо проверить.
//
// Возвращаемое значение:
// Истина - письмо отправлено.
// Ложь - письмо неотправлено.
Функция ПисьмоОтправлено(Письмо) Экспорт
	Отбор = Новый Структура("Письмо", Письмо);
	Возврат РегистрыСведений.СостояниеИсходящихПисем.Получить(Отбор).Отправлено;
КонецФункции

// Подготовить форму ответа на существующее письмо.
//
// Параметры:
// ВходящееПисьмо - СправочникСсылка.ВходящиеПисьма - письмо, на которое следует ответить.
// ИсходящееПисьмо - СправочникСсылка.ИсходящееПисьмо - данные формы для типа СправочникСсылка.ИсходящееПисьмо,
//				расположенные в форме редактора исходящего письма.
// Текст - ФорматированныйДокумент - поле редактора текста письма, расположенное в форме
//				редактора исходящего письма.
Процедура ЗаполнитьОтветНаПисьмо(ВходящееПисьмо, ИсходящееПисьмо, Текст) Экспорт
	ИсходящееПисьмо.Наименование = "Ответ на: " + ВходящееПисьмо.Наименование;
	ИсходящееПисьмо.Получатели.Очистить();
	Стр = ИсходящееПисьмо.Получатели.Добавить();
	Стр.ЭлектроннаяПочта = ВходящееПисьмо.Отправитель;
	HTML = ВходящееПисьмо.Текст;
	Вложения = Новый Структура();
	Если ВходящееПисьмо.ВидСодержимого = Перечисления.ВидСодержимогоВходящегоПисьма.HTML Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Ссылка,
			|	Наименование,
			|	Данные
			|ИЗ
			|	Справочник.ПочтовыеВложения
			|ГДЕ
			|	Владелец = &Владелец";

		Запрос.УстановитьПараметр("Владелец", ВходящееПисьмо);
		Выборка = Запрос.Выполнить().Выбрать();
		НомерКартинки = 1;
		Пока Выборка.Следующий() Цикл
			Ссылка = ПолучитьНавигационнуюСсылку(Выборка.Ссылка, "Данные");
			Имя = "img" + НомерКартинки;
			НомерКартинки = НомерКартинки + 1;
			Данные = Выборка.Данные.Получить();
			HTML = СтрЗаменить(HTML, Ссылка, Имя);
			Вложения.Вставить(Имя, Новый Картинка(Данные));
		КонецЦикла;
	КонецЕсли;
	Текст.УстановитьHTML(HTML, Вложения);
КонецПроцедуры

// Заполнить форму исходящего письма по шаблону.
//
// Параметры:
// ИсходящееПисьмо - СправочникСсылка.ИсходящееПисьмо - данные формы для типа СправочникСсылка.ИсходящееПисьмо,
//				расположенные в форме редактора исходящего письма.
// Текст - ФорматированныйДокумент - поле редактора текста письма, расположенное в форме
//				редактора исходящего письма.
Процедура ЗаполнитьПисьмоПоШаблону(ИсходящееПисьмо, Текст) Экспорт
	ИсходящееПисьмо.Наименование = "Коммерческое предложение ООО “1000 мелочей”";
	КоллекцияПараграфов = Текст.Элементы;
	КоллекцияПараграфов.Добавить().Элементы.Добавить("Для [Контрагент]");
	КоллекцияПараграфов.Добавить();
	КоллекцияПараграфов.Добавить().Элементы.Добавить("Уважаемый [КонтактноеЛицо]!");
	КоллекцияПараграфов.Добавить().Элементы.Добавить("Мы рады сообщить Вам о наших новых ценовых предложениях.");
	КоллекцияПараграфов.Добавить();
	КоллекцияПараграфов.Добавить().Элементы.Добавить("[ДатаПисьма]");
КонецПроцедуры

// Получить список почтовых ящиков на IMAP сервере для учётной записи
//
// Параметры:
// Возвращаемое значение:
// Список почтовых ящиков в виде массива строк.
Функция ПолучитьПочтовыеЯщикиIMAP() Экспорт
	ИспользоватьIMAP = Ложь;
	Профиль = ПолучитьПрофиль(, ИспользоватьIMAP);
	Если НЕ ИспользоватьIMAP Тогда
		Возврат Новый Массив;
	КонецЕсли;
	ИнтернетПочта = Новый ИнтернетПочта;	
    ИнтернетПочта.Подключиться(Профиль, ПротоколИнтернетПочты.IMAP);
	ПочтовыеЯщики = ИнтернетПочта.ПолучитьПочтовыеЯщики();	
	ИнтернетПочта.Отключиться();
	Возврат ПочтовыеЯщики;         
КонецФункции

// Создать почтовый ящик IMAP
//
// Параметры:
// ПочтовыйЯщик - Имя почтового ящика, который предстоит создать.
Процедура СоздатьПочтовыйЯщикIMAP(ПочтовыйЯщик) Экспорт
	Профиль = ПолучитьПрофиль();
	ИнтернетПочта = Новый ИнтернетПочта;
	ИнтернетПочта.Подключиться(Профиль, ПротоколИнтернетПочты.IMAP);
    ИнтернетПочта.СоздатьПочтовыйЯщик(ПочтовыйЯщик);
	ИнтернетПочта.Отключиться();	
КонецПроцедуры

Функция ПроверитьПисьма(ИспользоватьIMAP, ПочтовыйЯщикIMAP) Экспорт
	Количество = 0;
	РаботаСПочтой.ПолучитьПисьма(Количество, ИспользоватьIMAP, ПочтовыйЯщикIMAP);	
	Возврат Количество;
КонецФункции

Функция ПолучитьПисьма(Количество, ИспользоватьIMAP, ПочтовыйЯщикIMAP) Экспорт
	Профиль = РаботаСПочтой.ПолучитьПрофиль();
	Если Профиль.АдресСервераSMTP = "" Тогда
		Возврат Ложь;               
	КонецЕсли;

	Количество = РаботаСПочтой.ПолучитьНовыеПисьма(
	    Профиль, ИспользоватьIMAP, ПочтовыйЯщикIMAP);
	Возврат Истина;
КонецФункции
