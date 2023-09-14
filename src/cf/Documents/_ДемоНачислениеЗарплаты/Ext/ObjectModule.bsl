﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
//
// Параметры:
//   Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения следующая:
	// объект доступен, если доступен Ответственный и ВСЕ физические лица.
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.ЗначениеДоступа = Ответственный;
	
	Для Каждого СтрокаТаблицы Из Зарплата Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.ФизическоеЛицо) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.ЗначениеДоступа = СтрокаТаблицы.ФизическоеЛицо;
	КонецЦикла;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ДанныеЗаполнения = Неопределено Тогда // Ввод нового.
		_ДемоСтандартныеПодсистемы.ПриВводеНовогоЗаполнитьОрганизацию(ЭтотОбъект);
		ПериодРегистрации = НачалоМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	СформироватьДвиженияНачислений();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьДвиженияНачислений()
	
	Движения._ДемоОсновныеНачисления.Записывать = Истина;
	
	Для Каждого Строка Из Зарплата Цикл
		Движение = Движения._ДемоОсновныеНачисления.Добавить();
		
		Движение.ПериодРегистрации = ПериодРегистрации;
		
		Движение.ПериодДействияНачало = НачалоМесяца(ПериодРегистрации);
		Движение.ПериодДействияКонец  = КонецМесяца(ПериодРегистрации);
		
		Движение.ФизическоеЛицо = Строка.ФизическоеЛицо;
		Движение.Организация    = Организация;
		
		Движение.ВидРасчета = ПланыВидовРасчета._ДемоОсновныеНачисления.ОкладПоДням;
		Движение.Результат  = Строка.Сумма;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли