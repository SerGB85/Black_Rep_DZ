// @strict-types


Процедура ПередЗаписью(Отказ)
	Подписи = Подпись.Получить();
	Если ТипЗнч(Подписи) = Тип("Массив") И Подписи.Количество() > 0 Тогда
		Подписан = Истина;
	Иначе 
		Подписан = Ложь;
	КонецЕсли;
КонецПроцедуры
