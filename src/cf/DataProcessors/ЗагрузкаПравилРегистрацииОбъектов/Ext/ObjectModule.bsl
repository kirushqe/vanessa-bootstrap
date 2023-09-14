﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем Регистрация Экспорт; // Структура, содержащая параметры регистрации.
Перем ПравилаРегистрацииОбъектов Экспорт; // Таблица значений с правилами регистрации объектов.
Перем ФлагОшибки Экспорт; // глобальный флаг ошибки

Перем ТипСтрока;
Перем ТипБулево;
Перем ТипЧисло;
Перем ТипДата;

Перем ЗначениеПустойДаты;
Перем ШаблонДереваОтборПоСвойствамПланаОбмена;  // Шаблон дерева значений для правил регистрации по свойствам Плана
                                                // обмена.
Перем ШаблонДереваОтборПоСвойствамОбъекта;      // Шаблон дерева значений для правил регистрации по свойствам Объекта.
Перем БулевоЗначениеКорневойГруппыСвойств; // Булево значение для корневой группы свойств.
Перем СообщенияОбОшибках; // Соответствие. Ключ - код ошибки,  Значение - описание ошибки.

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции.

// Выполняет синтаксический анализ XML-файла с правилами регистрации. Заполняет значения коллекций по данным файла;
// Подготавливает зачитанные правила для проигрывателя ПРО ("компиляция" правил).
//
// Параметры:
//  ИмяФайла         - Строка - полное имя файла в локальной файловой системе, в котором содержатся правила.
//  ТолькоИнформация - Булево - признак того, что необходимо зачитать только заголовок файла и информацией о правилах;
//                              (значение по умолчанию - Ложь).
//
Процедура ЗагрузитьПравила(Знач ИмяФайла, ТолькоИнформация = Ложь) Экспорт
	
	ФлагОшибки = Ложь;
	
	Если ПустаяСтрока(ИмяФайла) Тогда
		СообщитьОбОшибкеОбработки(4);
		Возврат;
	КонецЕсли;
	
	// Выполняем инициализацию коллекций для правил.
	Регистрация                             = ИнициализацияРегистрации();
	ПравилаРегистрацииОбъектов              = Обработки.ЗагрузкаПравилРегистрацииОбъектов.ИнициализацияТаблицыПРО();
	ШаблонДереваОтборПоСвойствамПланаОбмена = Обработки.ЗагрузкаПравилРегистрацииОбъектов.ИнициализацияТаблицыОтборПоСвойствамПланаОбмена();
	ШаблонДереваОтборПоСвойствамОбъекта     = Обработки.ЗагрузкаПравилРегистрацииОбъектов.ИнициализацияТаблицыОтборПоСвойствамОбъекта();
	
	// ЗАГРУЗКА ПРАВИЛ РЕГИСТРАЦИИ
	Попытка
		ЗагрузитьРегистрациюИзФайла(ИмяФайла, ТолькоИнформация);
	Исключение
		
		// фиксируем ошибку
		СообщитьОбОшибкеОбработки(2, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
	// Выходим, если чтение правил из файла завершено с ошибками.
	Если ФлагОшибки Тогда
		Возврат;
	КонецЕсли;
	
	Если ТолькоИнформация Тогда
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРАВИЛ ДЛЯ ПРОИГРЫВАТЕЛЯ ПРО
	
	Для Каждого ПРО Из ПравилаРегистрацииОбъектов Цикл
		
		ПодготовитьПравилоРегистрацииПоСвойствамПланаОбмена(ПРО);
		
		ПодготовитьПравилоРегистрацииПоСвойствамОбъекта(ПРО);
		
	КонецЦикла;
	
	ПравилаРегистрацииОбъектов.ЗаполнитьЗначения(Регистрация.ИмяПланаОбмена, "ИмяПланаОбмена");
	
КонецПроцедуры

// Подготавливает строку с информацией о правилах на основании зачитанных данных из XML-файла.
//
// Возвращаемое значение:
//   Строка - строка с информацией о правилах.
//
Функция ИнформацияОПравилах() Экспорт
	
	// Возвращаемое значение функции.
	СтрокаИнформации = "";
	
	Если ФлагОшибки Тогда
		Возврат СтрокаИнформации;
	КонецЕсли;
	
	СтрокаИнформации = НСтр("ru = 'Правила регистрации объектов этой информационной базы (%1) от %2'");
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаИнформации,
		ПолучитьПредставлениеКонфигурацииИзПравилРегистрации(),
		Формат(Регистрация.ДатаВремяСоздания, "ДЛФ = дд"));
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Загрузка правил регистрации объектов (ПРО).

Процедура ЗагрузитьРегистрациюИзФайла(ИмяФайла, ТолькоИнформация)
	
	// открываем файл для чтения
	Попытка
		Правила = Новый ЧтениеXML();
		Правила.ОткрытьФайл(ИмяФайла);
		Правила.Прочитать();
	Исключение
		Правила = Неопределено;
		СообщитьОбОшибкеОбработки(1, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	
	Попытка
		ЗагрузитьРегистрацию(Правила, ТолькоИнформация);
	Исключение
		СообщитьОбОшибкеОбработки(2, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Правила.Закрыть();
	Правила = Неопределено;
	
КонецПроцедуры

// Осуществляет загрузку правил регистрации в соответствии с форматом.
//
// Параметры:
//  
Процедура ЗагрузитьРегистрацию(Правила, ТолькоИнформация)
	
	Если Не ((Правила.ЛокальноеИмя = "ПравилаРегистрации") 
		И (Правила.ТипУзла = ТипУзлаXML.НачалоЭлемента)) Тогда
		
		// Ошибка формата правил
		СообщитьОбОшибкеОбработки(3);
		
		Возврат;
		
	КонецЕсли;
	
	Пока Правила.Прочитать() Цикл
		
		ИмяУзла = Правила.ЛокальноеИмя;
		ТипУзла = Правила.ТипУзла;
		
		// Реквизиты регистрации
		Если ИмяУзла = "ВерсияФормата" Тогда
			
			Регистрация.ВерсияФормата = одЗначениеЭлемента(Правила, ТипСтрока);
			
		ИначеЕсли ИмяУзла = "Ид" Тогда
			
			Регистрация.Ид = одЗначениеЭлемента(Правила, ТипСтрока);
			
		ИначеЕсли ИмяУзла = "Наименование" Тогда
			
			Регистрация.Наименование = одЗначениеЭлемента(Правила, ТипСтрока);
			
		ИначеЕсли ИмяУзла = "ДатаВремяСоздания" Тогда
			
			Регистрация.ДатаВремяСоздания = одЗначениеЭлемента(Правила, ТипДата);
			
		ИначеЕсли ИмяУзла = "ПланОбмена" Тогда
			
			// атрибуты для плана обмена
			Регистрация.ИмяПланаОбмена = одАтрибут(Правила, ТипСтрока, "Имя");
			
			Регистрация.ПланОбмена = одЗначениеЭлемента(Правила, ТипСтрока);
			
		ИначеЕсли ИмяУзла = "Комментарий" Тогда
			
			Регистрация.Комментарий = одЗначениеЭлемента(Правила, ТипСтрока);
			
		ИначеЕсли ИмяУзла = "Конфигурация" Тогда
			
			// атрибуты конфигурации
			Регистрация.ВерсияПлатформы     = одАтрибут(Правила, ТипСтрока, "ВерсияПлатформы");
			Регистрация.ВерсияКонфигурации  = одАтрибут(Правила, ТипСтрока, "ВерсияКонфигурации");
			Регистрация.СинонимКонфигурации = одАтрибут(Правила, ТипСтрока, "СинонимКонфигурации");
			
			// наименование конфигурации
			Регистрация.Конфигурация = одЗначениеЭлемента(Правила, ТипСтрока);
			
		ИначеЕсли ИмяУзла = "ПравилаРегистрацииОбъектов" Тогда
			
			Если ТолькоИнформация Тогда
				
				Прервать; // Выход; если необходимо выполнить загрузку только информации о регистрации.
				
			Иначе
				
				// Проверка загрузки ПРО для требуемого плана обмена.
				ВыполнитьПроверкуНаличияПланаОбмена();
				
				Если ФлагОшибки Тогда
					Прервать; // Выход; загрузку не выполняем, если в правилах указан не тот план обмена.
				КонецЕсли;
				
				ЗагрузитьПравилаРегистрации(Правила);
				
			КонецЕсли;
			
		ИначеЕсли (ИмяУзла = "ПравилаРегистрации") И (ТипУзла = ТипУзлаXML.КонецЭлемента) Тогда
			
			Прервать; // выход
			
		Иначе
			
			одПропустить(Правила);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Осуществляет загрузку правил регистрации в соответствии с форматом правил обмена.
//
// Параметры:
//  Правила - ЧтениеXML - объект типа ЧтениеXML.
//
Процедура ЗагрузитьПравилаРегистрации(Правила)
	
	Пока Правила.Прочитать() Цикл
		
		ИмяУзла = Правила.ЛокальноеИмя;
		
		Если ИмяУзла = "Правило" Тогда
			
			ЗагрузитьПравилоРегистрации(Правила);
			
		ИначеЕсли ИмяУзла = "Группа" Тогда
			
			ЗагрузитьГруппуПравилРегистрации(Правила);
			
		ИначеЕсли (ИмяУзла = "ПравилаРегистрацииОбъектов") И (Правила.ТипУзла = ТипУзлаXML.КонецЭлемента) Тогда
			
			Прервать;
			
		Иначе
			
			одПропустить(Правила);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Параметры:
//   ТаблицаПравил - ТаблицаЗначений - таблица правил регистрации.
// 
Функция НовоеПравилоРегистрации(ТаблицаПравил)
	
	Возврат ТаблицаПравил.Добавить();
	
КонецФункции

// Осуществляет загрузку правила регистрации объектов.
//
// Параметры:
//  Правила  - ЧтениеXML - объект типа ЧтениеXML.
//
Процедура ЗагрузитьПравилоРегистрации(Правила)
	
	// Правила с установленным признаком "Отключить" не грузим.
	Отключить = одАтрибут(Правила, ТипБулево, "Отключить");
	Если Отключить Тогда
		одПропустить(Правила);
		Возврат;
	КонецЕсли;
	
	// Правила с ошибками не грузим.
	Валидное = одАтрибут(Правила, ТипБулево, "Валидное");
	Если Не Валидное Тогда
		одПропустить(Правила);
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = НовоеПравилоРегистрации(ПравилаРегистрацииОбъектов);
	
	Пока Правила.Прочитать() Цикл
		
		ИмяУзла = Правила.ЛокальноеИмя;
		
		Если ИмяУзла = "ОбъектНастройки" Тогда
			
			НоваяСтрока.ОбъектНастройки = одЗначениеЭлемента(Правила, ТипСтрока);
			
		ИначеЕсли ИмяУзла = "ОбъектМетаданныхИмя" Тогда
			
			НоваяСтрока.ОбъектМетаданныхИмя = одЗначениеЭлемента(Правила, ТипСтрока);
			
		ИначеЕсли ИмяУзла = "РеквизитРежимаВыгрузки" Тогда
			
			НоваяСтрока.ИмяРеквизитаФлага = одЗначениеЭлемента(Правила, ТипСтрока);
			
		ИначеЕсли ИмяУзла = "ОтборПоСвойствамПланаОбмена" Тогда
			
			// Инициализируем коллекцию свойств для текущего ПРО.
			НоваяСтрока.ОтборПоСвойствамПланаОбмена = ШаблонДереваОтборПоСвойствамПланаОбмена.Скопировать();
			
			ЗагрузитьДеревоОтбораПоСвойствамПланаОбмена(Правила, НоваяСтрока.ОтборПоСвойствамПланаОбмена);
			
		ИначеЕсли ИмяУзла = "ОтборПоСвойствамОбъекта" Тогда
			
			// Инициализируем коллекцию свойств для текущего ПРО.
			НоваяСтрока.ОтборПоСвойствамОбъекта = ШаблонДереваОтборПоСвойствамОбъекта.Скопировать();
			
			ЗагрузитьДеревоОтбораПоСвойствамОбъекта(Правила, НоваяСтрока.ОтборПоСвойствамОбъекта);
			
		ИначеЕсли ИмяУзла = "ПередОбработкой" Тогда
			
			НоваяСтрока.ПередОбработкой = одЗначениеЭлемента(Правила, ТипСтрока);
			
			НоваяСтрока.ЕстьОбработчикПередОбработкой = Не ПустаяСтрока(НоваяСтрока.ПередОбработкой);
			
		ИначеЕсли ИмяУзла = "ПриОбработке" Тогда
			
			НоваяСтрока.ПриОбработке = одЗначениеЭлемента(Правила, ТипСтрока);
			
			НоваяСтрока.ЕстьОбработчикПриОбработке = Не ПустаяСтрока(НоваяСтрока.ПриОбработке);
			
		ИначеЕсли ИмяУзла = "ПриОбработкеДополнительный" Тогда
			
			НоваяСтрока.ПриОбработкеДополнительный = одЗначениеЭлемента(Правила, ТипСтрока);
			
			НоваяСтрока.ЕстьОбработчикПриОбработкеДополнительный = Не ПустаяСтрока(НоваяСтрока.ПриОбработкеДополнительный);
			
		ИначеЕсли ИмяУзла = "ПослеОбработки" Тогда
			
			НоваяСтрока.ПослеОбработки = одЗначениеЭлемента(Правила, ТипСтрока);
			
			НоваяСтрока.ЕстьОбработчикПослеОбработки = Не ПустаяСтрока(НоваяСтрока.ПослеОбработки);
			
		ИначеЕсли (ИмяУзла = "Правило") И (Правила.ТипУзла = ТипУзлаXML.КонецЭлемента) Тогда
			
			Прервать;
			
		Иначе
			
			одПропустить(Правила);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Параметры:
//  Правила - ЧтениеXML - объект типа ЧтениеXML.
//  ДеревоЗначений - ДеревоЗначений - дерево правил регистрации объекта.
//
Процедура ЗагрузитьДеревоОтбораПоСвойствамПланаОбмена(Правила, ДеревоЗначений)
	
	СтрокиДЗ = ДеревоЗначений.Строки;
	
	Пока Правила.Прочитать() Цикл
		
		ИмяУзла = Правила.ЛокальноеИмя;
		ТипУзла = Правила.ТипУзла;
		
		Если ИмяУзла = "ЭлементОтбора" Тогда
			
			ЗагрузитьЭлементОтбораПланаОбмена(Правила, СтрокиДЗ.Добавить());
			
		ИначеЕсли ИмяУзла = "Группа" Тогда
			
			ЗагрузитьГруппуЭлементовОтбораПланаОбмена(Правила, СтрокиДЗ.Добавить());
			
		ИначеЕсли (ИмяУзла = "ОтборПоСвойствамПланаОбмена") И (ТипУзла = ТипУзлаXML.КонецЭлемента) Тогда
			
			Прервать; // выход
			
		Иначе
			
			одПропустить(Правила);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Параметры:
//  Правила - ЧтениеXML - объект типа ЧтениеXML.
//  ДеревоЗначений - ДеревоЗначений - дерево правил регистрации объекта.
//
Процедура ЗагрузитьДеревоОтбораПоСвойствамОбъекта(Правила, ДеревоЗначений)
	
	СтрокиДЗ = ДеревоЗначений.Строки;
	
	Пока Правила.Прочитать() Цикл
		
		ИмяУзла = Правила.ЛокальноеИмя;
		ТипУзла = Правила.ТипУзла;
		
		Если ИмяУзла = "ЭлементОтбора" Тогда
			
			ЗагрузитьЭлементОтбораОбъекта(Правила, СтрокиДЗ.Добавить());
			
		ИначеЕсли ИмяУзла = "Группа" Тогда
			
			ЗагрузитьГруппуЭлементовОтбораОбъекта(Правила, СтрокиДЗ.Добавить());
			
		ИначеЕсли (ИмяУзла = "ОтборПоСвойствамОбъекта") И (ТипУзла = ТипУзлаXML.КонецЭлемента) Тогда
			
			Прервать; // выход
			
		Иначе
			
			одПропустить(Правила);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Осуществляет загрузку правила регистрации объекта по свойству.
//
// Параметры:
// 
Процедура ЗагрузитьЭлементОтбораПланаОбмена(Правила, НоваяСтрока)
	
	НоваяСтрока.ЭтоГруппа = Ложь;
	
	Пока Правила.Прочитать() Цикл
		
		ИмяУзла = Правила.ЛокальноеИмя;
		ТипУзла = Правила.ТипУзла;
		
		Если ИмяУзла = "СвойствоОбъекта" Тогда
			
			Если НоваяСтрока.ЭтоСтрокаКонстанты Тогда
				
				НоваяСтрока.ЗначениеКонстанты = одЗначениеЭлемента(Правила, Тип(НоваяСтрока.ТипСвойстваОбъекта));
				
			Иначе
				
				НоваяСтрока.СвойствоОбъекта = одЗначениеЭлемента(Правила, ТипСтрока);
				
			КонецЕсли;
			
		ИначеЕсли ИмяУзла = "СвойствоПланаОбмена" Тогда
			
			// Свойство может быть свойством шапки или свойством ТЧ
			// если это свойство ТЧ, то переменная ПолноеНаименованиеСвойства
			// содержит наименование ТЧ и наименование свойства.
			// Название ТЧ записано в квадратных скобках "[...]".
			// Например, "[Организации].Организация".
			ПолноеНаименованиеСвойства = одЗначениеЭлемента(Правила, ТипСтрока);
			
			ИмяТабличнойЧастиПланаОбмена = "";
			
			ПозСкобки1 = СтрНайти(ПолноеНаименованиеСвойства, "[");
			
			Если ПозСкобки1 <> 0 Тогда
				
				ПозСкобки2 = СтрНайти(ПолноеНаименованиеСвойства, "]");
				
				ИмяТабличнойЧастиПланаОбмена = Сред(ПолноеНаименованиеСвойства, ПозСкобки1 + 1, ПозСкобки2 - ПозСкобки1 - 1);
				
				ПолноеНаименованиеСвойства = Сред(ПолноеНаименованиеСвойства, ПозСкобки2 + 2);
				
			КонецЕсли;
			
			НоваяСтрока.ПараметрУзла                = ПолноеНаименованиеСвойства;
			НоваяСтрока.ТабличнаяЧастьПараметраУзла = ИмяТабличнойЧастиПланаОбмена;
			
		ИначеЕсли ИмяУзла = "ВидСравнения" Тогда
			
			НоваяСтрока.ВидСравнения = одЗначениеЭлемента(Правила, ТипСтрока);
			
		ИначеЕсли ИмяУзла = "ЭтоСтрокаКонстанты" Тогда
			
			НоваяСтрока.ЭтоСтрокаКонстанты = одЗначениеЭлемента(Правила, ТипБулево);
			
		ИначеЕсли ИмяУзла = "ТипСвойстваОбъекта" Тогда
			
			НоваяСтрока.ТипСвойстваОбъекта = одЗначениеЭлемента(Правила, ТипСтрока);
			
		ИначеЕсли (ИмяУзла = "ЭлементОтбора") И (ТипУзла = ТипУзлаXML.КонецЭлемента) Тогда
			
			Прервать; // выход
			
		Иначе
			
			одПропустить(Правила);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Осуществляет загрузку правила регистрации объекта по свойству.
//
// Параметры:
// 
Процедура ЗагрузитьЭлементОтбораОбъекта(Правила, НоваяСтрока)
	
	НоваяСтрока.ЭтоГруппа = Ложь;
	
	Пока Правила.Прочитать() Цикл
		
		ИмяУзла = Правила.ЛокальноеИмя;
		ТипУзла = Правила.ТипУзла;
		
		Если ИмяУзла = "СвойствоОбъекта" Тогда
			
			НоваяСтрока.СвойствоОбъекта = одЗначениеЭлемента(Правила, ТипСтрока);
			
		ИначеЕсли ИмяУзла = "ЗначениеКонстанты" Тогда
			
			Если ПустаяСтрока(НоваяСтрока.ВидЭлементаОтбора) Тогда
				
				НоваяСтрока.ВидЭлементаОтбора = ОбменДаннымиСервер.ЭлементОтбораСвойствоЗначениеКонстанты();
				
			КонецЕсли;
			
			Если НоваяСтрока.ВидЭлементаОтбора = ОбменДаннымиСервер.ЭлементОтбораСвойствоЗначениеКонстанты() Тогда
				
				// только примитивные типы
				НоваяСтрока.ЗначениеКонстанты = одЗначениеЭлемента(Правила, Тип(НоваяСтрока.ТипСвойстваОбъекта));
				
			ИначеЕсли НоваяСтрока.ВидЭлементаОтбора = ОбменДаннымиСервер.ЭлементОтбораСвойствоАлгоритмЗначения() Тогда
				
				НоваяСтрока.ЗначениеКонстанты = одЗначениеЭлемента(Правила, ТипСтрока); // строка
				
			Иначе
				
				НоваяСтрока.ЗначениеКонстанты = одЗначениеЭлемента(Правила, ТипСтрока); // строка
				
			КонецЕсли;
			
		ИначеЕсли ИмяУзла = "ВидСравнения" Тогда
			
			НоваяСтрока.ВидСравнения = одЗначениеЭлемента(Правила, ТипСтрока);
			
		ИначеЕсли ИмяУзла = "ТипСвойстваОбъекта" Тогда
			
			НоваяСтрока.ТипСвойстваОбъекта = одЗначениеЭлемента(Правила, ТипСтрока);
			
		ИначеЕсли ИмяУзла = "Вид" Тогда
			
			НоваяСтрока.ВидЭлементаОтбора = одЗначениеЭлемента(Правила, ТипСтрока);
			
		ИначеЕсли (ИмяУзла = "ЭлементОтбора") И (ТипУзла = ТипУзлаXML.КонецЭлемента) Тогда
			
			Прервать; // выход
			
		Иначе
			
			одПропустить(Правила);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Осуществляет загрузку группы правил регистрации объекта по свойству.
//
// Параметры:
//  Правила  - ЧтениеXML - объект типа ЧтениеXML.
//  НоваяСтрока - СтрокаДереваЗначений - строка дерева правил регистрации объекта.
//
Процедура ЗагрузитьГруппуЭлементовОтбораПланаОбмена(Правила, НоваяСтрока)
	
	НоваяСтрока.ЭтоГруппа = Истина;
	
	Пока Правила.Прочитать() Цикл
		
		ИмяУзла = Правила.ЛокальноеИмя;
		ТипУзла = Правила.ТипУзла;
		
		Если ИмяУзла = "ЭлементОтбора" Тогда
			
			ЗагрузитьЭлементОтбораПланаОбмена(Правила, НоваяСтрока.Строки.Добавить());
		
		ИначеЕсли (ИмяУзла = "Группа") И (ТипУзла = ТипУзлаXML.НачалоЭлемента) Тогда
			
			ЗагрузитьГруппуЭлементовОтбораПланаОбмена(Правила, НоваяСтрока.Строки.Добавить());
			
		ИначеЕсли ИмяУзла = "БулевоЗначениеГруппы" Тогда
			
			НоваяСтрока.БулевоЗначениеГруппы = одЗначениеЭлемента(Правила, ТипСтрока);
			
		ИначеЕсли (ИмяУзла = "Группа") И (ТипУзла = ТипУзлаXML.КонецЭлемента) Тогда
			
			Прервать; // выход
			
		Иначе
			
			одПропустить(Правила);
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

// Осуществляет загрузку группы правил регистрации объекта по свойству.
//
// Параметры:
//  Правила  - ЧтениеXML - объект типа ЧтениеXML.
//  НоваяСтрока - СтрокаДереваЗначений - строка дерева правил регистрации объекта.
//
Процедура ЗагрузитьГруппуЭлементовОтбораОбъекта(Правила, НоваяСтрока)
	
	НоваяСтрока.ЭтоГруппа = Истина;
	
	Пока Правила.Прочитать() Цикл
		
		ИмяУзла = Правила.ЛокальноеИмя;
		ТипУзла = Правила.ТипУзла;
		
		Если ИмяУзла = "ЭлементОтбора" Тогда
			
			ЗагрузитьЭлементОтбораОбъекта(Правила, НоваяСтрока.Строки.Добавить());
		
		ИначеЕсли (ИмяУзла = "Группа") И (ТипУзла = ТипУзлаXML.НачалоЭлемента) Тогда
			
			ЗагрузитьГруппуЭлементовОтбораОбъекта(Правила, НоваяСтрока.Строки.Добавить());
			
		ИначеЕсли ИмяУзла = "БулевоЗначениеГруппы" Тогда
			
			БулевоЗначениеГруппы = одЗначениеЭлемента(Правила, ТипСтрока);
			
			НоваяСтрока.ЭтоОператорИ = (БулевоЗначениеГруппы = "И");
			
		ИначеЕсли (ИмяУзла = "Группа") И (ТипУзла = ТипУзлаXML.КонецЭлемента) Тогда
			
			Прервать; // выход
			
		Иначе
			
			одПропустить(Правила);
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

Процедура ЗагрузитьГруппуПравилРегистрации(Правила)
	
	Пока Правила.Прочитать() Цикл
		
		ИмяУзла = Правила.ЛокальноеИмя;
		
		Если ИмяУзла = "Правило" Тогда
			
			ЗагрузитьПравилоРегистрации(Правила);
			
		ИначеЕсли ИмяУзла = "Группа" И Правила.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			ЗагрузитьГруппуПравилРегистрации(Правила);
			
		ИначеЕсли ИмяУзла = "Группа" И Правила.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
		
			Прервать;
			
		Иначе
			
			одПропустить(Правила);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Компиляция правил регистрации объектов (ПРО) по свойствам Плана обмена.

Процедура ПодготовитьПравилоРегистрацииПоСвойствамПланаОбмена(ПРО)
	
	ПравилоПустое = (ПРО.ОтборПоСвойствамПланаОбмена.Строки.Количество() = 0);
	
	СвойстваОбъекта = Новый Структура;
	
	ТекстВыборкиПолей = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПланОбменаОсновнаяТаблица.Ссылка КАК Ссылка";
	
	// Таблица с именами источников данных - табличных частей плана обмена.
	ТаблицаДанных = ДанныеПРО(ПРО.ОтборПоСвойствамПланаОбмена.Строки);
	
	ТекстТаблицДанных = ПолучитьТекстТаблицДанныхДляПРО(ТаблицаДанных);
	
	Если ПравилоПустое Тогда
		
		ТекстУсловия = "Истина";
		
	Иначе
		
		ТекстУсловия = ПолучитьТекстУсловияДляГруппыСвойств(ПРО.ОтборПоСвойствамПланаОбмена.Строки, БулевоЗначениеКорневойГруппыСвойств, 0, СвойстваОбъекта);
		
	КонецЕсли;
	
	ТекстЗапроса = ТекстВыборкиПолей + Символы.ПС 
	             + "ИЗ"  + Символы.ПС + ТекстТаблицДанных + Символы.ПС
	             + "ГДЕ" + Символы.ПС + ТекстУсловия
	             + Символы.ПС + "[ОбязательныеУсловия]";
	//
	
	// Присваиваем полученные значения переменных.
	ПРО.ТекстЗапроса    = ТекстЗапроса;
	ПРО.СвойстваОбъекта = СвойстваОбъекта;
	ПРО.СвойстваОбъектаСтрокой = ПолучитьСвойстваОбъектаСтрокой(СвойстваОбъекта);
	
КонецПроцедуры

Функция ПолучитьТекстУсловияДляГруппыСвойств(СвойстваГруппы, БулевоЗначениеГруппы, Знач Смещение, СвойстваОбъекта)
	
	СтрокаСмещения = "";
	
	// Получаем строку смещения для группы свойств.
	Для НомерИтерации = 0 По Смещение Цикл
		СтрокаСмещения = СтрокаСмещения + " ";
	КонецЦикла;
	
	ТекстУсловия = "";
	
	Для Каждого ПРПС Из СвойстваГруппы Цикл
		
		Если ПРПС.ЭтоГруппа Тогда
			
			ПрефиксУсловия = ?(ПустаяСтрока(ТекстУсловия), "", Символы.ПС + СтрокаСмещения + БулевоЗначениеГруппы + " ");
			
			ТекстУсловия = ТекстУсловия + ПрефиксУсловия + ПолучитьТекстУсловияДляГруппыСвойств(ПРПС.Строки, ПРПС.БулевоЗначениеГруппы, Смещение + 10, СвойстваОбъекта);
			
		Иначе
			
			ПрефиксУсловия = ?(ПустаяСтрока(ТекстУсловия), "", Символы.ПС + СтрокаСмещения + БулевоЗначениеГруппы + " ");
			
			ТекстУсловия = ТекстУсловия + ПрефиксУсловия + ПолучитьТекстУсловияДляСвойства(ПРПС, СвойстваОбъекта);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ТекстУсловия = "(" + ТекстУсловия + Символы.ПС 
				 + СтрокаСмещения + ")";
	
	Возврат ТекстУсловия;
	
КонецФункции

Функция ПолучитьТекстТаблицДанныхДляПРО(ТаблицаДанных)
	
	ТекстТаблицДанных = "ПланОбмена." + Регистрация.ИмяПланаОбмена + " КАК ПланОбменаОсновнаяТаблица";
	
	Для Каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		
		СинонимТаблицы = Регистрация.ИмяПланаОбмена + СтрокаТаблицы.Имя;
		
		ТекстТаблицДанных = ТекстТаблицДанных + Символы.ПС + Символы.ПС + "ЛЕВОЕ СОЕДИНЕНИЕ" + Символы.ПС
		                 + "ПланОбмена." + Регистрация.ИмяПланаОбмена + "." + СтрокаТаблицы.Имя + " КАК " + СинонимТаблицы + "" + Символы.ПС
		                 + "ПО ПланОбменаОсновнаяТаблица.Ссылка = " + СинонимТаблицы + ".Ссылка";
		
	КонецЦикла;
	
	Возврат ТекстТаблицДанных;
	
КонецФункции

Функция ДанныеПРО(СвойстваГруппы)
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("Имя");
	
	Для Каждого ПРПС Из СвойстваГруппы Цикл
		
		Если ПРПС.ЭтоГруппа Тогда
			
			// Получаем таблицу данных для нижнего уровня иерархии.
			ТаблицаДанныхГруппы = ДанныеПРО(ПРПС.Строки);
			
			// Добавляем полученные строки в таблицу данных верхнего уровня иерархии.
			Для Каждого СтрокаТаблицыГруппы Из ТаблицаДанныхГруппы Цикл
				
				ЗаполнитьЗначенияСвойств(ТаблицаДанных.Добавить(), СтрокаТаблицыГруппы);
				
			КонецЦикла;
			
		Иначе
			
			ИмяТаблицы = ПРПС.ТабличнаяЧастьПараметраУзла;
			
			// Если имя таблицы пустое, то это свойство шапки узла; игнорируем.
			Если Не ПустаяСтрока(ИмяТаблицы) Тогда
				
				СтрокаТаблицы = ТаблицаДанных.Добавить();
				СтрокаТаблицы.Имя = ИмяТаблицы;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// сворачиваем таблицу
	ТаблицаДанных.Свернуть("Имя");
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ПолучитьТекстУсловияДляСвойства(Правило, СвойстваОбъекта)
	
	ВидСравненияПравила = Правило.ВидСравнения;
	
	// Необходимо инвертировать вид сравнения,
	// потому что таблицы Плана обмена и регистрируемого Объекта расположены по разному
	// в конфигурации КД 2.0 при настройке ПРО и в запросе к Планам обмена в данном модуле.
	ИнвертироватьВидСравнения(ВидСравненияПравила);
	
	ТекстОператора = ПолучитьТекстОператораСравнения(ВидСравненияПравила);
	
	СинонимТаблицы = ?(ПустаяСтрока(Правило.ТабличнаяЧастьПараметраУзла),
	                              "ПланОбменаОсновнаяТаблица",
	                               Регистрация.ИмяПланаОбмена + Правило.ТабличнаяЧастьПараметраУзла);
	//
	
	// В качестве литерала параметра запроса может быть как сам параметр запроса, так и значение константы.
	//
	// Пример:
	// СвойствоПланаОбмена <вид сравнения> &СвойствоОбъекта_МоеСвойство
	// СвойствоПланаОбмена <вид сравнения> ДАТАВРЕМЯ(1987,10,19,0,0,0).
	
	Если Правило.ЭтоСтрокаКонстанты Тогда
		
		ТипЗначенияКонстанты = ТипЗнч(Правило.ЗначениеКонстанты);
		
		Если ТипЗначенияКонстанты = ТипБулево Тогда // Булево
			
			ЛитералПараметраЗапроса = Формат(Правило.ЗначениеКонстанты, "БЛ=Ложь; БИ=Истина");
			
		ИначеЕсли ТипЗначенияКонстанты = ТипЧисло Тогда // Число
			
			ЛитералПараметраЗапроса = Формат(Правило.ЗначениеКонстанты, "ЧРД=.; ЧН=0; ЧГ=0; ЧО=1");
			
		ИначеЕсли ТипЗначенияКонстанты = ТипДата Тогда // Дата
			
			СтрокаГод     = Формат(Год(Правило.ЗначениеКонстанты),     "ЧН=0; ЧГ=0");
			СтрокаМесяц   = Формат(Месяц(Правило.ЗначениеКонстанты),   "ЧН=0; ЧГ=0");
			СтрокаДень    = Формат(День(Правило.ЗначениеКонстанты),    "ЧН=0; ЧГ=0");
			СтрокаЧас     = Формат(Час(Правило.ЗначениеКонстанты),     "ЧН=0; ЧГ=0");
			СтрокаМинута  = Формат(Минута(Правило.ЗначениеКонстанты),  "ЧН=0; ЧГ=0");
			СтрокаСекунда = Формат(Секунда(Правило.ЗначениеКонстанты), "ЧН=0; ЧГ=0");
			
			ЛитералПараметраЗапроса = "ДАТАВРЕМЯ("
			+ СтрокаГод + ","
			+ СтрокаМесяц + ","
			+ СтрокаДень + ","
			+ СтрокаЧас + ","
			+ СтрокаМинута + ","
			+ СтрокаСекунда
			+ ")";
			
		Иначе // Строка
			
			// строку заключаем в кавычки
			ЛитералПараметраЗапроса = """" + Правило.ЗначениеКонстанты + """";
			
		КонецЕсли;
		
	Иначе
		
		КлючСвойстваОбъекта = СтрЗаменить(Правило.СвойствоОбъекта, ".", "_");
		
		ЛитералПараметраЗапроса = "&СвойствоОбъекта_" + КлючСвойстваОбъекта + "";
		
		СвойстваОбъекта.Вставить(КлючСвойстваОбъекта, Правило.СвойствоОбъекта);
		
	КонецЕсли;
	
	ТекстУсловия = СинонимТаблицы + "." + Правило.ПараметрУзла + " " + ТекстОператора + " " + ЛитералПараметраЗапроса;
	
	Возврат ТекстУсловия;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Компиляция правил регистрации объектов (ПРО) по свойствам Объекта.

Процедура ПодготовитьПравилоРегистрацииПоСвойствамОбъекта(ПРО)
	
	ПРО.ПравилоПоСвойствамОбъектаПустое = (ПРО.ОтборПоСвойствамОбъекта.Строки.Количество() = 0);
	
	// Пустое правило не обрабатываем.
	Если ПРО.ПравилоПоСвойствамОбъектаПустое Тогда
		Возврат;
	КонецЕсли;
	
	СвойстваОбъекта = Новый Структура;
	
	ЗаполнитьСтруктуруСвойствОбъекта(ПРО.ОтборПоСвойствамОбъекта, СвойстваОбъекта);
	
КонецПроцедуры

Процедура ЗаполнитьСтруктуруСвойствОбъекта(ДеревоЗначений, СвойстваОбъекта)
	
	Для Каждого СтрокаДерева Из ДеревоЗначений.Строки Цикл
		
		Если СтрокаДерева.ЭтоГруппа Тогда
			
			ЗаполнитьСтруктуруСвойствОбъекта(СтрокаДерева, СвойстваОбъекта);
			
		Иначе
			
			СтрокаДерева.КлючСвойстваОбъекта = СтрЗаменить(СтрокаДерева.СвойствоОбъекта, ".", "_");
			
			СвойстваОбъекта.Вставить(СтрокаДерева.КлючСвойстваОбъекта, СтрокаДерева.СвойствоОбъекта);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные служебные процедуры и функции.

Процедура СообщитьОбОшибкеОбработки(Код = -1, ОписаниеОшибки = "")
	
	// Взводим глобальный флаг ошибки.
	ФлагОшибки = Истина;
	
	Если СообщенияОбОшибках = Неопределено Тогда
		СообщенияОбОшибках = ИнициализацияСообщений();
	КонецЕсли;
	
	СтрокаСообщения = СообщенияОбОшибках[Код];
	
	СтрокаСообщения = ?(СтрокаСообщения = Неопределено, "", СтрокаСообщения);
	
	Если Не ПустаяСтрока(ОписаниеОшибки) Тогда
		
		СтрокаСообщения = СтрокаСообщения + Символы.ПС + ОписаниеОшибки;
		
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(КлючСообщенияЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,, СтрокаСообщения);
	
КонецПроцедуры

Процедура ИнвертироватьВидСравнения(ВидСравнения)
	
	Если      ВидСравнения = "Больше"         Тогда ВидСравнения = "Меньше";
	ИначеЕсли ВидСравнения = "БольшеИлиРавно" Тогда ВидСравнения = "МеньшеИлиРавно";
	ИначеЕсли ВидСравнения = "Меньше"         Тогда ВидСравнения = "Больше";
	ИначеЕсли ВидСравнения = "МеньшеИлиРавно" Тогда ВидСравнения = "БольшеИлиРавно";
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьПроверкуНаличияПланаОбмена()
	
	Если ТипЗнч(Регистрация) <> Тип("Структура") Тогда
		
		СообщитьОбОшибкеОбработки(0);
		Возврат;
		
	КонецЕсли;
	
	Если Регистрация.ИмяПланаОбмена <> ИмяПланаОбменаДляЗагрузки Тогда
		
		ОписаниеОшибки = НСтр("ru = 'В правилах регистрации указан план обмена %1, а загрузка выполняется для плана обмена %2'");
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОписаниеОшибки, Регистрация.ИмяПланаОбмена, ИмяПланаОбменаДляЗагрузки);
		СообщитьОбОшибкеОбработки(5, ОписаниеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьТекстОператораСравнения(Знач ВидСравнения = "Равно")
	
	// Возвращаемое значение функции по умолчанию.
	ТекстОператора = "=";
	
	Если      ВидСравнения = "Равно"          Тогда ТекстОператора = "=";
	ИначеЕсли ВидСравнения = "НеРавно"        Тогда ТекстОператора = "<>";
	ИначеЕсли ВидСравнения = "Больше"         Тогда ТекстОператора = ">";
	ИначеЕсли ВидСравнения = "БольшеИлиРавно" Тогда ТекстОператора = ">=";
	ИначеЕсли ВидСравнения = "Меньше"         Тогда ТекстОператора = "<";
	ИначеЕсли ВидСравнения = "МеньшеИлиРавно" Тогда ТекстОператора = "<=";
	КонецЕсли;
	
	Возврат ТекстОператора;
КонецФункции

Функция ПолучитьПредставлениеКонфигурацииИзПравилРегистрации()
	
	ИмяКонфигурации = "";
	Регистрация.Свойство("СинонимКонфигурации", ИмяКонфигурации);
	
	Если Не ЗначениеЗаполнено(ИмяКонфигурации) Тогда
		Возврат "";
	КонецЕсли;
	
	ТочнаяВерсия = "";
	Регистрация.Свойство("ВерсияКонфигурации", ТочнаяВерсия);
	
	Если ЗначениеЗаполнено(ТочнаяВерсия) Тогда
		
		ТочнаяВерсия = ОбщегоНазначенияКлиентСервер.ВерсияКонфигурацииБезНомераСборки(ТочнаяВерсия);
		
		ИмяКонфигурации = ИмяКонфигурации + " версия " + ТочнаяВерсия;
		
	КонецЕсли;
	
	Возврат ИмяКонфигурации;
		
КонецФункции

Функция ПолучитьСвойстваОбъектаСтрокой(СвойстваОбъекта)
	
	Результат = "";
	
	Для Каждого Элемент Из СвойстваОбъекта Цикл
		
		Результат = Результат + Элемент.Значение + " КАК " + Элемент.Ключ + ", ";
		
	КонецЦикла;
	
	// Удаляем последние два символа.
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Результат, 2);
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Для работы с объектом XMLЧтение.

// Читает значение атрибута по имени из указанного объекта, приводит значение
// к указанному примитивному типу.
//
// Параметры:
//   Объект      - ЧтениеXML - объект, спозиционированный на начале элемента,
//                 атрибут которого требуется получить.
//   Тип         - Тип - тип атрибута.
//   Имя         - Строка - имя атрибута.
//
// Возвращаемое значение:
//   Произвольный - значение атрибута полученное по имени и приведенное к указанному типу.
//
Функция одАтрибут(Объект, Тип, Имя)
	
	СтрЗначение = СокрП(Объект.ПолучитьАтрибут(Имя));
	
	Если Не ПустаяСтрока(СтрЗначение) Тогда
		
		Возврат XMLЗначение(Тип, СтрЗначение);
		
	Иначе
		Если Тип = ТипСтрока Тогда
			Возврат "";
			
		ИначеЕсли Тип = ТипБулево Тогда
			Возврат Ложь;
			
		ИначеЕсли Тип = ТипЧисло Тогда
			Возврат 0;
			
		ИначеЕсли Тип = ТипДата Тогда
			Возврат ЗначениеПустойДаты;
			
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Читает текст элемента и приводит значение к указанному типу.
//
// Параметры:
//  Объект           - ЧтениеXML - объект, из которого осуществляется чтение.
//  Тип              - Тип - тип получаемого значения.
//  ИскатьПоСвойству - Строка - для ссылочных типов может быть указано свойство, по которому
//                     следует искать объект: "Код", "Наименование", <ИмяРеквизита>, "Имя" (предопределенного значения).
//
// Возвращаемое значение:
//   Произвольный - значение xml-элемента, приведенное к соответствующему типу.
//
Функция одЗначениеЭлемента(Объект, Тип, ИскатьПоСвойству="")

	Значение = "";
	Имя      = Объект.ЛокальноеИмя;

	Пока Объект.Прочитать() Цикл
		
		ИмяУзла = Объект.ЛокальноеИмя;
		ТипУзла = Объект.ТипУзла;
		
		Если ТипУзла = ТипУзлаXML.Текст Тогда
			
			Значение = СокрП(Объект.Значение);
			
		ИначеЕсли (ИмяУзла = Имя) И (ТипУзла = ТипУзлаXML.КонецЭлемента) Тогда
			
			Прервать;
			
		Иначе
			
			Возврат Неопределено;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат XMLЗначение(Тип, Значение)
	
КонецФункции

// Пропускает узлы xml до конца указанного элемента (по умолчанию текущего).
//
// Параметры:
//  Объект   - объект типа ЧтениеXML.
//  Имя      - имя узла, до конца которого пропускаем элементы.
//
Процедура одПропустить(Объект, Имя = "")
	
	КоличествоВложений = 0; // Количество одноименных вложений.
	
	Если ПустаяСтрока(Имя) Тогда
	
		Имя = Объект.ЛокальноеИмя;
	
	КонецЕсли;
	
	Пока Объект.Прочитать() Цикл
		
		ИмяУзла = Объект.ЛокальноеИмя;
		ТипУзла = Объект.ТипУзла;
		
		Если ИмяУзла = Имя Тогда
			
			Если ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
				
				Если КоличествоВложений = 0 Тогда
					Прервать;
				Иначе
					КоличествоВложений = КоличествоВложений - 1;
				КонецЕсли;
				
			ИначеЕсли ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				
				КоличествоВложений = КоличествоВложений + 1;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Локальные служебные функции-свойства.

Функция КлючСообщенияЖурналаРегистрации()
	
	Возврат ОбменДаннымиСервер.СобытиеЖурналаРегистрацииЗагрузкаПравилДляОбменаДанными();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Инициализация реквизитов и модульных переменных.

// Инициализирует реквизиты обработки и модульные переменные.
//
// Параметры:
//  Нет.
// 
Процедура ИнициализацияРеквизитовИМодульныхПеременных()
	
	ФлагОшибки = Ложь;
	
	// Типы
	ТипСтрока            = Тип("Строка");
	ТипБулево            = Тип("Булево");
	ТипЧисло             = Тип("Число");
	ТипДата              = Тип("Дата");
	
	ЗначениеПустойДаты = Дата('00010101');
	
	БулевоЗначениеКорневойГруппыСвойств = "И"; // Булево значение для корневой группы свойств.
	
КонецПроцедуры

// Инициализирует структуру регистрации.
//
// Параметры:
//  Нет.
// 
Функция ИнициализацияРегистрации()
	
	Регистрация = Новый Структура;
	Регистрация.Вставить("ВерсияФормата",       "");
	Регистрация.Вставить("Ид",                  "");
	Регистрация.Вставить("Наименование",        "");
	Регистрация.Вставить("ДатаВремяСоздания",   ЗначениеПустойДаты);
	Регистрация.Вставить("ПланОбмена",          "");
	Регистрация.Вставить("ИмяПланаОбмена",      "");
	Регистрация.Вставить("Комментарий",         "");
	
	// параметры конфигурации
	Регистрация.Вставить("ВерсияПлатформы",     "");
	Регистрация.Вставить("ВерсияКонфигурации",  "");
	Регистрация.Вставить("СинонимКонфигурации", "");
	Регистрация.Вставить("Конфигурация",        "");
	
	Возврат Регистрация;
	
КонецФункции

// Инициализирует переменную, содержащую соответствия кодов сообщений их описаниям.
//
// Параметры:
//  Нет.
// 
Функция ИнициализацияСообщений()
	
	Сообщения = Новый Соответствие;
	КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	
	Сообщения.Вставить(0, НСтр("ru = 'Внутренняя ошибка'", КодОсновногоЯзыка));
	Сообщения.Вставить(1, НСтр("ru = 'Ошибка открытия файла правил'", КодОсновногоЯзыка));
	Сообщения.Вставить(2, НСтр("ru = 'Ошибка при загрузке правил'", КодОсновногоЯзыка));
	Сообщения.Вставить(3, НСтр("ru = 'Ошибка формата правил'", КодОсновногоЯзыка));
	Сообщения.Вставить(4, НСтр("ru = 'Ошибка при получении файла правил для чтения'", КодОсновногоЯзыка));
	Сообщения.Вставить(5, НСтр("ru = 'Загружаемые правила регистрации не предназначены для текущего плана обмена.'", КодОсновногоЯзыка));
	
	Возврат Сообщения;
	
КонецФункции

#КонецОбласти

#Область Инициализация

ИнициализацияРеквизитовИМодульныхПеременных();

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли