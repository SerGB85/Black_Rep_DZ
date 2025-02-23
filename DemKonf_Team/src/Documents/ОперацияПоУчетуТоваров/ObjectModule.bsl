//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ 
// 

// @strict-types


// Обработчик копирования документа выполняет также копирование движений
Процедура ПриКопировании(ОбъектКопирования)
	ОбъектКопирования.Движения.ТоварныеЗапасы.Прочитать();
    Для каждого ИсхЗапись Из ОбъектКопирования.Движения.ТоварныеЗапасы Цикл
		Запись = Движения.ТоварныеЗапасы.Добавить();
		Запись.ВидДвижения = ИсхЗапись.ВидДвижения;
		Запись.Товар = ИсхЗапись.Товар;
		Запись.Склад = ИсхЗапись.Склад;
		Запись.Количество = ИсхЗапись.Количество;
	КонецЦикла;
КонецПроцедуры

// Обработчик события, предшествующего записи, устанавливает всем
// движениям дату самого документа
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Для каждого Запись Из Движения.ТоварныеЗапасы Цикл
		Запись.Период = Дата;
	КонецЦикла;	
	
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Заказ.Дата,
		|	Заказ.Номер
		|ИЗ
		|	Документ.Заказ КАК Заказ
		|ГДЕ
		|	Заказ.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
	КонецЦикла;
	
КонецПроцедуры	
	