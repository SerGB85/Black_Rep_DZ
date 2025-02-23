// @strict-types

// Операция начала обмена
// проверяет, что нужный узел добавлен в план и правильно инициализирован
//
// Параметры:
//  КодУзла	– идентификатор данного узла, используется как код узла плана обмена
//  НаименованиеМобильногоКомпьютера - читаемое представление данного узла, не обязательно, изменяемое, используется как наименование узла плана обмена
//  НомерОтправленного - номер последнего отправленного пакета, предназначен для восстановления обмена, если узел был удален
//  НомерПринятого - номер последнего принятого пакета, предназначен для восстановления обмена, если узел был удален
//
// Возвращаемое значение:
//  нет
//
Функция НачатьОбмен(КодУзла, НаименованиеМобильногоКомпьютера, НомерОтправленного, НомерПринятого, Версия)
    
    Если Число(Версия) <> 6 Тогда
        
        ВызватьИсключение(НСтр("ru='Требуется обновление мобильного приложения!'"));
        
    КонецЕсли;
        
    Возврат ОбменМобильныеВызовПК.НачатьОбмен(КодУзла,
			                       НаименованиеМобильногоКомпьютера,
			                       НомерПринятого,
			                       НомерОтправленного);
КонецФункции

// Операция получения данных
// получает пакет изменений предназначенных для данного узла
//
// Параметры:
//  КодУзла	– код узла, с которым идет обмен
//
// Возвращаемое значение:
//  ХранилищеЗначения, в которое помещен пакет обмена
//
Функция ПолучитьДанные(КодУзла)
	
    УзелОбмена = ПланыОбмена.Мобильные.НайтиПоКоду(КодУзла); 
    
    Если УзелОбмена.Пустая() Тогда
        ВызватьИсключение(НСтр("ru='Неизвестное устройство - '") + КодУзла);
    КонецЕсли;
	
    Возврат ОбменМобильныеОбщее.СформироватьПакетОбмена(УзелОбмена);
    
КонецФункции

// Операция записи данных
// записывает пакет изменений принятых от данного узла
//
// Параметры:
//  КодУзла	– код узла, с которым идет обмен
//  ДанныеМобильногоПриложения - ХранилищеЗначения, в которое помещен пакет обмена
//
// Возвращаемое значение:
//  нет
//
Функция ЗаписатьДанные(КодУзла, ДанныеМобильногоПриложения)

    УзелОбмена = ПланыОбмена.Мобильные.НайтиПоКоду(КодУзла); 
    
    Если УзелОбмена.Пустая() Тогда
        ВызватьИсключение(НСтр("ru='Неизвестное устройство - '") + КодУзла);
    КонецЕсли;
	
    ОбменМобильныеОбщее.ПринятьПакетОбмена(УзелОбмена, ДанныеМобильногоПриложения);
    
КонецФункции

// Операция удаленного получения отчета
//
// Параметры:
//  Настройки	– настройки отчета, структура сериализованная в XDTO 
//
// Возвращаемое значение:
//  ТабличныйДокумент - сформированный отчет, сериализованный в XDTO 
//
Функция ПолучитьОтчет(Настройки, СтрокаИнформацииРасшифровки)
    
    ИнформацияРасшифровки = Неопределено;
    ТабличныйДокумент = ОбменМобильныеПереопределяемый.СформироватьОтчет(Настройки, ИнформацияРасшифровки);
    СтрокаИнформацииРасшифровки = СериализаторXDTO.ЗаписатьXDTO(ИнформацияРасшифровки);
    Возврат СериализаторXDTO.ЗаписатьXDTO(ТабличныйДокумент);
    
КонецФункции

Функция НовыйИдентификаторПодписчикаУведомлений(КодУзла, ИдентификаторXDTO)
	
    Идентификатор = СериализаторXDTO.ПрочитатьXDTO(ИдентификаторXDTO);
	УзелОбмена = ПланыОбмена.Мобильные.НайтиПоКоду(КодУзла); 
	
	Если УзелОбмена.Пустая() Тогда
	    ВызватьИсключение(НСтр("ru='Неизвестное устройство - '") + КодУзла);
	КонецЕсли;
	
	Справочники.МобильныеУстройства.НовыйИдентификаторПодписчикаУведомлений(УзелОбмена, Идентификатор); 
	
КонецФункции

Функция ВыполнитьОбменДанными(КодУзла, ДанныеМобильногоПриложения)
	
    Возврат ОбменМобильныеВызовПК.ВыполнитьОбменДанными(КодУзла, ДанныеМобильногоПриложения);
	
КонецФункции
