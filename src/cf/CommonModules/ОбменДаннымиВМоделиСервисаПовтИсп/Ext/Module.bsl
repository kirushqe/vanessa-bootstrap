﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает Истину, если синхронизация данных в модели сервиса поддерживается
//
Функция СинхронизацияДанныхПоддерживается() Экспорт
	
	Возврат ПланыОбменаСинхронизацииДанных().Количество() > 0;
	
КонецФункции

// Возвращает коллекцию планов обмена, используемых для синхронизации.
//
// План обмена для организации синхронизации данных в модели сервиса должен:
// - быть подключенным к подсистеме обмена данными БСП,
// - быть разделенным,
// - быть планом обмена Не РИБ,
// - использоваться для обмена в модели сервиса (ПланОбменаИспользуетсяВМоделиСервиса = Истина).
//
Функция ПланыОбменаСинхронизацииДанных() Экспорт
	
	Результат = Новый Массив;
	
	Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
		
		Если Не ПланОбмена.РаспределеннаяИнформационнаяБаза
			И ОбменДаннымиПовтИсп.ПланОбменаИспользуетсяВМоделиСервиса(ПланОбмена.Имя)
			И ОбменДаннымиСервер.ЭтоРазделенныйПланОбменаБСП(ПланОбмена.Имя) Тогда
			
			Результат.Добавить(ПланОбмена.Имя);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает ссылку на объект WSПрокси сервиса обмена версии 1.0.6.5.
//
// Возвращаемое значение:
//   WSПрокси
//
Функция ПолучитьWSПроксиСервисаОбмена() Экспорт
	
	Результат = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		МодульРаботаВМоделиСервисаБТСПовтИсп = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервисаБТСПовтИсп");
		МодульНастройкиТранспортаОбменаСообщениями = ОбщегоНазначения.ОбщийМодуль("РегистрыСведений.НастройкиТранспортаОбменаСообщениями");
		
		НастройкиТранспорта = МодульНастройкиТранспортаОбменаСообщениями.НастройкиТранспортаWS(
			МодульРаботаВМоделиСервисаБТСПовтИсп.КонечнаяТочкаМенеджераСервиса());
		
		СтруктураНастроек = Новый Структура;
		СтруктураНастроек.Вставить("WSURLВебСервиса",   НастройкиТранспорта.WSURLВебСервиса);
		СтруктураНастроек.Вставить("WSИмяПользователя", НастройкиТранспорта.WSИмяПользователя);
		СтруктураНастроек.Вставить("WSПароль",          НастройкиТранспорта.WSПароль);
		СтруктураНастроек.Вставить("WSИмяСервиса",      "ManageApplicationExchange_1_0_6_5");
		СтруктураНастроек.Вставить("WSURLПространстваИменСервиса", "http://www.1c.ru/SaaS/1.0/WS/ManageApplicationExchange_1_0_6_5");
		СтруктураНастроек.Вставить("WSТаймаут", 20);
		
		Результат = ОбменДаннымиСервер.ПолучитьWSПроксиПоПараметрамПодключения(СтруктураНастроек);
	КонецЕсли;
	
	Если Результат = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка получения web-сервиса обмена данными управляющего приложения.'");
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Возвращает ссылку на объект WSПрокси корреспондента, идентифицируемого узлом плана обмена.
//
// Параметры:
//   УзелИнформационнойБазы - ПланОбменаСсылка.
//   СтрокаСообщенияОбОшибке - Строка - текст сообщения об ошибке.
//
// Возвращаемое значение:
//   WSПрокси
//
Функция ПолучитьWSПроксиКорреспондента(УзелИнформационнойБазы, СтрокаСообщенияОбОшибке = "") Экспорт
	
	СтруктураНастроек = РегистрыСведений.НастройкиТранспортаОбменаОбластиДанных.НастройкиТранспортаWS(УзелИнформационнойБазы);
	СтруктураНастроек.Вставить("WSИмяСервиса", "RemoteAdministrationOfExchange");
	СтруктураНастроек.Вставить("WSURLПространстваИменСервиса", "http://www.1c.ru/SaaS/1.0/WS/RemoteAdministrationOfExchange");
	СтруктураНастроек.Вставить("WSТаймаут", 20);
	
	Возврат ОбменДаннымиСервер.ПолучитьWSПроксиПоПараметрамПодключения(СтруктураНастроек, СтрокаСообщенияОбОшибке);
	
КонецФункции

// Возвращает ссылку на объект WSПрокси версии 2.0.1.6 корреспондента, идентифицируемого узлом плана обмена.
//
// Параметры:
//   УзелИнформационнойБазы - ПланОбменаСсылка.
//   СтрокаСообщенияОбОшибке - Строка - текст сообщения об ошибке.
//
// Возвращаемое значение:
//   WSПрокси
//
Функция ПолучитьWSПроксиКорреспондента_2_0_1_6(УзелИнформационнойБазы, СтрокаСообщенияОбОшибке = "") Экспорт
	
	СтруктураНастроек = РегистрыСведений.НастройкиТранспортаОбменаОбластиДанных.НастройкиТранспортаWS(УзелИнформационнойБазы);
	СтруктураНастроек.Вставить("WSИмяСервиса", "RemoteAdministrationOfExchange_2_0_1_6");
	СтруктураНастроек.Вставить("WSURLПространстваИменСервиса", "http://www.1c.ru/SaaS/1.0/WS/RemoteAdministrationOfExchange_2_0_1_6");
	СтруктураНастроек.Вставить("WSТаймаут", 20);
	
	Возврат ОбменДаннымиСервер.ПолучитьWSПроксиПоПараметрамПодключения(СтруктураНастроек, СтрокаСообщенияОбОшибке);
КонецФункции

// Возвращает ссылку на объект WSПрокси версии 2.1.6.1 корреспондента, идентифицируемого узлом плана обмена.
//
Функция ПолучитьWSПроксиКорреспондента_2_1_6_1(УзелИнформационнойБазы, СтрокаСообщенияОбОшибке = "") Экспорт
	
	СтруктураНастроек = РегистрыСведений.НастройкиТранспортаОбменаОбластиДанных.НастройкиТранспортаWS(УзелИнформационнойБазы);
	СтруктураНастроек.Вставить("WSИмяСервиса", "RemoteAdministrationOfExchange_2_1_6_1");
	СтруктураНастроек.Вставить("WSURLПространстваИменСервиса", "http://www.1c.ru/SaaS/1.0/WS/RemoteAdministrationOfExchange_2_1_6_1");
	СтруктураНастроек.Вставить("WSТаймаут", 20);
	
	Возврат ОбменДаннымиСервер.ПолучитьWSПроксиПоПараметрамПодключения(СтруктураНастроек, СтрокаСообщенияОбОшибке);
КонецФункции

// Возвращает ссылку на объект WSПрокси версии 2.4.5.1 корреспондента, идентифицируемого узлом плана обмена.
//
Функция ПолучитьWSПроксиКорреспондента_2_4_5_1(УзелИнформационнойБазы, СтрокаСообщенияОбОшибке = "") Экспорт
	
	СтруктураНастроек = РегистрыСведений.НастройкиТранспортаОбменаОбластиДанных.НастройкиТранспортаWS(УзелИнформационнойБазы);
	СтруктураНастроек.Вставить("WSИмяСервиса", "RemoteAdministrationOfExchange_2_4_5_1");
	СтруктураНастроек.Вставить("WSURLПространстваИменСервиса", "http://www.1c.ru/SaaS/1.0/WS/RemoteAdministrationOfExchange_2_4_5_1");
	СтруктураНастроек.Вставить("WSТаймаут", 20);
	
	Возврат ОбменДаннымиСервер.ПолучитьWSПроксиПоПараметрамПодключения(СтруктураНастроек, СтрокаСообщенияОбОшибке);
КонецФункции

// Возвращает Истину, если этот план обмена используется для синхронизации данных в модели сервиса.
//
Функция ЭтоПланОбменаСинхронизацииДанных(Знач ИмяПланаОбмена) Экспорт
	
	Возврат ПланыОбменаСинхронизацииДанных().Найти(ИмяПланаОбмена) <> Неопределено;
	
КонецФункции

#КонецОбласти
