//////////////////////////////////////////////////////////////////////////////// 
// ПРОЦЕДУРЫ И ФУНКЦИИ 
// 

// @strict-types


// Заполнение параметров подключения драйвера сканера и их сохранение в хранилище настроек. 
// 
// Параметры: 
//  ТипОС           	– Строка – тип операционной системы.  (IN)
//  ВыбранныеПараметры  – Структура – исходные данные для подключения. (IN)
//  АдресДрайвераСканера - Строка адрес вненшей компоненты сканера
// 
// Возвращаемое значение: 
//  Нет.
&НаСервере
Процедура СохранитьПараметрыПодключенияСканера(ТипОС, ВыбранныеПараметры)

	Параметры = Новый Структура();
	Параметры.Вставить("БитДанных", ВыбранныеПараметры.БитДанных);
	Параметры.Вставить("Скорость", ВыбранныеПараметры.Скорость);
	Параметры.Вставить("Порт", ВыбранныеПараметры.Порт);
	
	Если ТипОС = "Windows" Тогда
		
		ХранилищеОбщихНастроек.Сохранить("ТекущиеНастройкиСканераWindows",,Параметры);
		
	ИначеЕсли ТипОС = "Linux" Тогда
	
		ХранилищеОбщихНастроек.Сохранить("ТекущиеНастройкиСканераLinux",,Параметры);
		
	КонецЕсли;

КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ
//

// обработка команды настройки сканера штрихкодов
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// Обновление текуших настроек сканера 
	
	// Откроем форму настройки торгового оборудования
	Оповещение = Новый ОписаниеОповещения("ОбработкаКомандыЗавершение", ЭтотОбъект);
	ОткрытьФорму("Справочник.НастройкиТорговогоОборудования.ФормаВыбора",
		Новый Структура("РежимВыбора", Истина),,,,,
		Оповещение, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКомандыЗавершение(ВыбранныеНастройки, Параметры) Экспорт

	// если настройки выбраны - осуществляем попытку подключения сканера
	Если ВыбранныеНастройки <> Неопределено Тогда
		
		СисИнфо = Новый СистемнаяИнформация;
		
		Если СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 ИЛИ СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
			
			ТипОС = "Windows";
			
		ИначеЕсли СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86 ИЛИ СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
			
			ТипОС = "Linux";
			
		КонецЕсли;
		
		СохранитьПараметрыПодключенияСканера(ТипОС, ВыбранныеНастройки);
		// Применение новых настроек подключения сканера штрихкодов
		Оп = Новый ОписаниеОповещения("ПослеОтключенияСканераШтрихкодов", ЭтотОбъект);
		РаботаСТорговымОборудованием.НачатьОтключениеСканераШтрихкодов(Оп);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтключенияСканераШтрихкодов(Результат, Параметры) Экспорт
	РаботаСТорговымОборудованием.НачатьПодключениеСканераШтрихкодов();
КонецПроцедуры
