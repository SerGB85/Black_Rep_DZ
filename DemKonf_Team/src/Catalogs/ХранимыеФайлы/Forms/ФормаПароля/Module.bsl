// @strict-types

&НаКлиенте
Перем МенеджерСертификатов Экспорт;

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Пароль = МенеджерСертификатов.ПарольДоступаКЗакрытомуКлючу;
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	МенеджерСертификатов.ПарольДоступаКЗакрытомуКлючу = Пароль;
	Закрыть(КодВозвратаДиалога.ОК);
КонецПроцедуры
