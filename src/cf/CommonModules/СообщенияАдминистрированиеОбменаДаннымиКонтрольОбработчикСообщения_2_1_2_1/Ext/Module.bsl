﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Пространство имен версии интерфейса сообщений.
//
// Возвращаемое значение:
//   Строка - пространство имен.
//
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/ExchangeAdministration/Control";
	
КонецФункции

// Версия интерфейса сообщений, обслуживаемая обработчиком.
//
// Возвращаемое значение:
//   Строка - версия интерфейса сообщений.
//
Функция Версия() Экспорт
	
	Возврат "2.1.2.1";
	
КонецФункции

// Базовый тип для сообщений версии.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - базовый тип тела сообщения.
//
Функция БазовыйТип() Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		ВызватьИсключение НСтр("ru = 'Отсутствует менеджер сервиса.'");
	КонецЕсли;
	
	МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
	
	Возврат МодульСообщенияВМоделиСервиса.ТипТело();
	
КонецФункции

// Выполняет обработку входящих сообщений модели сервиса
//
// Параметры:
//   Сообщение   - ОбъектXDTO - входящее сообщение.
//   Отправитель - ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, соответствующий отправителю сообщения.
//   СообщениеОбработано - Булево - флаг успешной обработки сообщения. Значение данного параметра необходимо
//                         установить равным Истина в том случае, если сообщение было успешно прочитано в данном обработчике.
//
Процедура ОбработатьСообщениеМоделиСервиса(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
	
	СообщениеОбработано = Истина;
	
	Словарь = СообщенияАдминистрированиеОбменаДаннымиКонтрольИнтерфейс;
	ТипСообщения = Сообщение.Body.Тип();
	
	Если ТипСообщения = Словарь.СообщениеНастройкиСинхронизацииДанныхПолучены(Пакет()) Тогда
		ОбменДаннымиВМоделиСервиса.СохранитьДанныеСессии(Сообщение, ПредставлениеОперацииПолученияНастроек());
	ИначеЕсли ТипСообщения = Словарь.СообщениеОшибкаПолученияНастроекСинхронизацииДанных(Пакет()) Тогда
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьНеуспешноеВыполнениеСессии(Сообщение, ПредставлениеОперацииПолученияНастроек());
	ИначеЕсли ТипСообщения = Словарь.СообщениеВключениеСинхронизацииУспешноЗавершено(Пакет()) Тогда
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьУспешноеВыполнениеСессии(Сообщение, ПредставлениеВключениеСинхронизации());
	ИначеЕсли ТипСообщения = Словарь.СообщениеСинхронизацияУспешноОтключена(Пакет()) Тогда
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьУспешноеВыполнениеСессии(Сообщение, ПредставлениеОтключениеСинхронизации());
	ИначеЕсли ТипСообщения = Словарь.СообщениеОшибкаВключенияСинхронизации(Пакет()) Тогда
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьНеуспешноеВыполнениеСессии(Сообщение, ПредставлениеВключениеСинхронизации());
	ИначеЕсли ТипСообщения = Словарь.СообщениеОшибкаОтключенияСинхронизации(Пакет()) Тогда
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьНеуспешноеВыполнениеСессии(Сообщение, ПредставлениеОтключениеСинхронизации());
	ИначеЕсли ТипСообщения = Словарь.СообщениеСинхронизацияЗавершена(Пакет()) Тогда
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьУспешноеВыполнениеСессии(Сообщение, ПредставлениеВыполнениеСинхронизации());
	Иначе
		СообщениеОбработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПредставлениеОперацииПолученияНастроек()
	
	Возврат НСтр("ru = 'Получение настроек синхронизации данных из Менеджера сервиса.'");
	
КонецФункции

Функция ПредставлениеВключениеСинхронизации()
	
	Возврат НСтр("ru = 'Включение синхронизации данных в Менеджере сервиса.'");
	
КонецФункции

Функция ПредставлениеОтключениеСинхронизации()
	
	Возврат НСтр("ru = 'Отключение синхронизации данных в Менеджере сервиса.'");
	
КонецФункции

Функция ПредставлениеВыполнениеСинхронизации()
	
	Возврат НСтр("ru = 'Выполнение синхронизации данных по запросу пользователя.'");
	
КонецФункции

#КонецОбласти
