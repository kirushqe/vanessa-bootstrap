﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.БизнесПроцесс) Тогда
		БизнесПроцесс = Параметры.БизнесПроцесс;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьКартуМаршрута();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БизнесПроцессПриИзменении(Элемент)
	ОбновитьКартуМаршрута();
КонецПроцедуры

&НаКлиенте
Процедура КартаМаршрутаВыбор(Элемент)
	ОткрытьСписокЗадачТочкиМаршрута();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьВыполнить(Команда)
	ОбновитьКартуМаршрута();   
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиВыполнить(Команда)
	ОткрытьСписокЗадачТочкиМаршрута();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьКартуМаршрута()
	
	Если ЗначениеЗаполнено(БизнесПроцесс) Тогда
		КартаМаршрута = БизнесПроцесс.ПолучитьОбъект().ПолучитьКартуМаршрута();
	ИначеЕсли БизнесПроцесс <> Неопределено Тогда
		КартаМаршрута = БизнесПроцессы[БизнесПроцесс.Метаданные().Имя].ПолучитьКартуМаршрута();
		Возврат;
	Иначе
		КартаМаршрута = Новый ГрафическаяСхема;
		Возврат;
	КонецЕсли;
	
	ЕстьСостояние = БизнесПроцесс.Метаданные().Реквизиты.Найти("Состояние") <> Неопределено;
	СвойстваБизнесПроцесса = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		БизнесПроцесс, "Автор,Дата,ДатаЗавершения,Завершен,Стартован" 
		+ ?(ЕстьСостояние, ",Состояние", ""));
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СвойстваБизнесПроцесса);
	Если СвойстваБизнесПроцесса.Завершен Тогда
		Статус = НСтр("ru = 'Завершен'");
		Элементы.ГруппаСтатус.ТекущаяСтраница = Элементы.ГруппаЗавершен;
	ИначеЕсли СвойстваБизнесПроцесса.Стартован Тогда
		Статус = НСтр("ru = 'Стартован'");
		Элементы.ГруппаСтатус.ТекущаяСтраница = Элементы.ГруппаНеЗавершен;
	Иначе	
		Статус = НСтр("ru = 'Не стартован'");
		Элементы.ГруппаСтатус.ТекущаяСтраница = Элементы.ГруппаНеЗавершен;
	КонецЕсли;
	Если ЕстьСостояние Тогда
		Статус = Статус + ", " + НРег(Состояние);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокЗадачТочкиМаршрута()

#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
	ПоказатьПредупреждение(,НСтр("ru = 'Для корректной работы необходим режим тонкого или толстого клиента.'"));
	Возврат;
#КонецЕсли
	ОчиститьСообщения();
	ТекЭлемент = Элементы.КартаМаршрута.ТекущийЭлемент;

	Если Не ЗначениеЗаполнено(БизнесПроцесс) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Необходимо указать бизнес-процесс.'"),,
			"БизнесПроцесс");
		Возврат;
	КонецЕсли;
	
	Если ТекЭлемент = Неопределено 
		Или	НЕ (ТипЗнч(ТекЭлемент) = Тип("ЭлементГрафическойСхемыДействие")
		Или ТипЗнч(ТекЭлемент) = Тип("ЭлементГрафическойСхемыВложенныйБизнесПроцесс")) Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Для просмотра списка задач необходимо выбрать точку действия или вложенный бизнес-процесс карты маршрута.'"),,
			"КартаМаршрута");
		Возврат;
	КонецЕсли;

	ЗаголовокФормы = НСтр("ru = 'Задачи по точке маршрута бизнес-процесса'");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура("БизнесПроцесс,ТочкаМаршрута", БизнесПроцесс, ТекЭлемент.Значение));
	ПараметрыФормы.Вставить("ЗаголовокФормы", ЗаголовокФормы);
	ПараметрыФормы.Вставить("ПоказыватьЗадачи", 0);
	ПараметрыФормы.Вставить("ВидимостьОтборов", Ложь);
	ПараметрыФормы.Вставить("БлокировкаОкнаВладельца", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормы.Вставить("Задача", Строка(ТекЭлемент.Значение));
	ПараметрыФормы.Вставить("БизнесПроцесс", Строка(БизнесПроцесс));
	ОткрытьФорму("Задача.ЗадачаИсполнителя.ФормаСписка", ПараметрыФормы, ЭтотОбъект, БизнесПроцесс);

КонецПроцедуры

#КонецОбласти
