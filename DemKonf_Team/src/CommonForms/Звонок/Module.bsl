// @strict-types

&НаКлиенте
Процедура Позвонить(Команда)
	
#Если МобильныйКлиент Тогда 
		СредстваТелефонии.НабратьНомер(Данные, Ложь);
#КонецЕсли
    
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Данные = Параметры.Данные;
	Текст = Параметры.Текст;
	
КонецПроцедуры
