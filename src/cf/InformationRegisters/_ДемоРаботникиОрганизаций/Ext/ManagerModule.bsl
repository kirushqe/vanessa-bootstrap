﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Вызывается ПослеЗаменыСсылок (см. ОбщегоНазначения.ЗаменитьСсылки)
//
// Параметры:
//  Результат - Структура:
//		* ЕстьОшибки - Булево
//		* ОчередьКНепосредственномуУдалению - Массив из ЛюбаяСсылка
//		* Ошибки - ТаблицаЗначений:
//			** Ссылка - ЛюбаяСсылка
//			** ОбъектОшибки - ЛюбойОбъект
//			** ПредставлениеОбъектаОшибки - Строка
//			** ТипОшибки - Строка
//			** ТекстОшибки - Строка
//  ПараметрыВыполнения	 - см. ОбщегоНазначения.ПараметрыЗаменыСсылок
//  ТаблицаПоиска		 - ТаблицаЗначений
//
Процедура ЗаменитьСсылки(Результат, Знач ПараметрыВыполнения, Знач ТаблицаПоиска) Экспорт
	
	УспешныеЗамены = ПараметрыВыполнения.УспешныеЗамены;
	
	ТипКолонок = Новый ОписаниеТипов("СправочникСсылка._ДемоФизическиеЛица");
	ТаблицаЗаменФизЛиц = Новый ТаблицаЗначений;
	ТаблицаЗаменФизЛиц.Колонки.Добавить("Оригинал", ТипКолонок);
	ТаблицаЗаменФизЛиц.Колонки.Добавить("Дубль", ТипКолонок);
	
	ТипКолонок = Новый ОписаниеТипов("СправочникСсылка._ДемоОрганизации");
	ТаблицаЗаменОрганизаций = Новый ТаблицаЗначений;
	ТаблицаЗаменОрганизаций.Колонки.Добавить("Оригинал", ТипКолонок);
	ТаблицаЗаменОрганизаций.Колонки.Добавить("Дубль", ТипКолонок);
	
	Для каждого ДубльОригинал Из ПараметрыВыполнения.УспешныеЗамены Цикл
		
		Если ТипЗнч(ДубльОригинал.Значение) = Тип("СправочникСсылка._ДемоОрганизации") Тогда
			
			ПараЗамены = ТаблицаЗаменОрганизаций.Добавить();	
			ПараЗамены.Оригинал = ДубльОригинал.Значение;		
			ПараЗамены.Дубль = ДубльОригинал.Ключ;		
			
		ИначеЕсли ТипЗнч(ДубльОригинал.Значение) = Тип("СправочникСсылка._ДемоФизическиеЛица") Тогда	
			
			ПараЗамены = ТаблицаЗаменФизЛиц.Добавить();	
			ПараЗамены.Оригинал = ДубльОригинал.Значение;		
			ПараЗамены.Дубль = ДубльОригинал.Ключ;		

		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаЗаменФизлица", ТаблицаЗаменФизЛиц); 
	Запрос.УстановитьПараметр("ТаблицаЗаменОрганизаций", ТаблицаЗаменОрганизаций); 
	УстановитьПривилегированныйРежим(Истина);
	Запрос.Текст = ТекстЗапросаПоискаДублейЗаписей();
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			ТребуетсяУдаление = ВыборкаДетальныеЗаписи.КоличествоОдинаковыхЗаписейПослеЗамены = 2;
			Если ТребуетсяУдаление Тогда
				
				Набор = РегистрыСведений._ДемоРаботникиОрганизаций.СоздатьНаборЗаписей();
				Набор.Отбор.Период.Установить(ВыборкаДетальныеЗаписи.Период);
				Набор.Отбор.Организация.Установить(ЗначениеСУчетомЗамены(ВыборкаДетальныеЗаписи.Организация, ТаблицаЗаменОрганизаций));
				Набор.Отбор.ФизическоеЛицо.Установить(ЗначениеСУчетомЗамены(ВыборкаДетальныеЗаписи.ФизическоеЛицо, ТаблицаЗаменФизЛиц));
				Набор.Прочитать();
				Набор.Очистить();
				Набор.Записать();
				
			Иначе	
				
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить("РегистрСведений._ДемоРаботникиОрганизаций");
				ЭлементБлокировки.УстановитьЗначение("Период", ВыборкаДетальныеЗаписи.Период);
				ЭлементБлокировки.УстановитьЗначение("Организация", ВыборкаДетальныеЗаписи.Организация);
				ЭлементБлокировки.УстановитьЗначение("ФизическоеЛицо", ВыборкаДетальныеЗаписи.ФизическоеЛицо);
				ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
				Блокировка.Заблокировать();
				
				НаборДоЗамены = РегистрыСведений._ДемоРаботникиОрганизаций.СоздатьНаборЗаписей();
				НаборДоЗамены.Отбор.Период.Установить(ВыборкаДетальныеЗаписи.Период);
				НаборДоЗамены.Отбор.Организация.Установить(ВыборкаДетальныеЗаписи.Организация);
				НаборДоЗамены.Отбор.ФизическоеЛицо.Установить(ВыборкаДетальныеЗаписи.ФизическоеЛицо);
				НаборДоЗамены.Прочитать();
				
				НаборПослеЗамены = РегистрыСведений._ДемоРаботникиОрганизаций.СоздатьНаборЗаписей();
				НаборПослеЗамены.Отбор.Период.Установить(ВыборкаДетальныеЗаписи.Период);
				НаборПослеЗамены.Отбор.Организация.Установить(ЗначениеСУчетомЗамены(ВыборкаДетальныеЗаписи.Организация, ТаблицаЗаменОрганизаций));
				НаборПослеЗамены.Отбор.ФизическоеЛицо.Установить(ЗначениеСУчетомЗамены(ВыборкаДетальныеЗаписи.ФизическоеЛицо, ТаблицаЗаменФизЛиц));
				
				Для каждого ЗаписьДоЗамены Из НаборДоЗамены Цикл
					
					ЗаписьПослеЗамены = НаборПослеЗамены.Добавить();
					ЗаполнитьЗначенияСвойств(ЗаписьПослеЗамены, ЗаписьДоЗамены);
					ЗаписьПослеЗамены.ФизическоеЛицо = ЗначениеСУчетомЗамены(ВыборкаДетальныеЗаписи.ФизическоеЛицо, ТаблицаЗаменФизЛиц);
					ЗаписьПослеЗамены.Организация = ЗначениеСУчетомЗамены(ВыборкаДетальныеЗаписи.Организация, ТаблицаЗаменОрганизаций);
					
				КонецЦикла;
				
				НаборДоЗамены.Очистить();
				НаборДоЗамены.Записать();
				НаборПослеЗамены.Записать();
				
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
		КонецПопытки;
		
	КонецЦикла;

КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗначениеСУчетомЗамены(Значение, УспешныеЗамены)

	Перем Результат;
	 
	ПараЗамены = УспешныеЗамены.Найти(Значение, "Дубль");
	Если ПараЗамены = Неопределено Тогда
		Результат = Значение;
	Иначе
		Результат = ПараЗамены.Оригинал;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Функция ТекстЗапросаПоискаДублейЗаписей()
	
	Возврат "ВЫБРАТЬ
	        |	ТаблицаЗамен.Оригинал КАК Оригинал,
	        |	ТаблицаЗамен.Дубль КАК Дубль
	        |ПОМЕСТИТЬ ТаблицаЗаменФизлица
	        |ИЗ
	        |	&ТаблицаЗаменФизлица КАК ТаблицаЗамен
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	ТаблицаЗамен.Дубль КАК Дубль,
	        |	ТаблицаЗамен.Оригинал КАК Оригинал
	        |ПОМЕСТИТЬ ТаблицаЗаменОрганизаций
	        |ИЗ
	        |	&ТаблицаЗаменОрганизаций КАК ТаблицаЗамен
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	Таб.Период КАК Период,
	        |	Таб.Организация КАК Организация,
	        |	Таб.ФизическоеЛицо КАК ФизическоеЛицо,
	        |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Таб.ТипЗаписи) КАК КоличествоОдинаковыхЗаписейПослеЗамены
	        |ИЗ
	        |	(ВЫБРАТЬ
	        |		_ДемоРаботникиОрганизаций.Период КАК Период,
	        |		_ДемоРаботникиОрганизаций.Организация КАК Организация,
	        |		_ДемоРаботникиОрганизаций.ФизическоеЛицо КАК ФизическоеЛицо,
	        |		_ДемоРаботникиОрганизаций.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	        |		_ДемоРаботникиОрганизаций.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
	        |		_ДемоРаботникиОрганизаций.ТабельныйНомер КАК ТабельныйНомер,
	        |		""Оригинал"" КАК ТипЗаписи
	        |	ИЗ
	        |		РегистрСведений._ДемоРаботникиОрганизаций КАК _ДемоРаботникиОрганизаций
	        |	ГДЕ
	        |		(_ДемоРаботникиОрганизаций.ФизическоеЛицо В
	        |					(ВЫБРАТЬ
	        |						ТаблицаЗамен.Оригинал КАК Оригинал
	        |					ИЗ
	        |						ТаблицаЗаменФизлица КАК ТаблицаЗамен)
	        |				ИЛИ _ДемоРаботникиОрганизаций.Организация В
	        |					(ВЫБРАТЬ
	        |						ТаблицаЗамен.Оригинал КАК Оригинал
	        |					ИЗ
	        |						ТаблицаЗаменОрганизаций КАК ТаблицаЗамен))
	        |	
	        |	ОБЪЕДИНИТЬ ВСЕ
	        |	
	        |	ВЫБРАТЬ
	        |		_ДемоРаботникиОрганизаций.Период,
	        |		ВЫБОР
	        |			КОГДА ТаблицаЗаменОрганизаций.Оригинал ЕСТЬ NULL
	        |				ТОГДА _ДемоРаботникиОрганизаций.Организация
	        |			ИНАЧЕ ТаблицаЗаменОрганизаций.Дубль
	        |		КОНЕЦ,
	        |		ВЫБОР
	        |			КОГДА ТаблицаЗаменФизЛиц.Оригинал ЕСТЬ NULL
	        |				ТОГДА _ДемоРаботникиОрганизаций.ФизическоеЛицо
	        |			ИНАЧЕ ТаблицаЗаменФизЛиц.Дубль
	        |		КОНЕЦ,
	        |		_ДемоРаботникиОрганизаций.ПодразделениеОрганизации,
	        |		_ДемоРаботникиОрганизаций.ЗанимаемыхСтавок,
	        |		_ДемоРаботникиОрганизаций.ТабельныйНомер,
	        |		""Дубль""
	        |	ИЗ
	        |		РегистрСведений._ДемоРаботникиОрганизаций КАК _ДемоРаботникиОрганизаций
	        |			ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаЗаменФизлица КАК ТаблицаЗаменФизЛиц
	        |			ПО _ДемоРаботникиОрганизаций.ФизическоеЛицо = ТаблицаЗаменФизЛиц.Дубль
	        |			ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаЗаменОрганизаций КАК ТаблицаЗаменОрганизаций
	        |			ПО _ДемоРаботникиОрганизаций.Организация = ТаблицаЗаменОрганизаций.Дубль
	        |	ГДЕ
	        |		(НЕ ТаблицаЗаменФизЛиц.Оригинал ЕСТЬ NULL
	        |				ИЛИ НЕ ТаблицаЗаменОрганизаций.Оригинал ЕСТЬ NULL)) КАК Таб
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	Таб.Период,
	        |	Таб.Организация,
	        |	Таб.ФизическоеЛицо";

КонецФункции

#КонецОбласти

#КонецЕсли
