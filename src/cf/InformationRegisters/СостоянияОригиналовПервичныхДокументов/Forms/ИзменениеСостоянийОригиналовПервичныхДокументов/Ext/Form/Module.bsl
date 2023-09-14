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

	СостоянияОригиналов = УчетОригиналовПервичныхДокументов.ИспользуемыеСостояния();
	УчетОригиналовПервичныхДокументов.ВывестиНаФормуКомандыСостоянияОригинала(ЭтотОбъект, КомплектПечатныхФорм, СостоянияОригиналов);
		
	ЗаполнитьСписокПечатныхФормПоСсылке();

	Если Параметры.Свойство("Ссылка") Тогда
		Запись.Ссылка = Параметры.Ссылка;
		ФильтрПечатныхФорм = "Все";
		Элементы.НадписьПредупреждение.Заголовок = НСтр("ru='Состояние оригинала документа будет установлено по печатным формам'");
	ИначеЕсли КомплектПечатныхФорм.Количество()= 0 Тогда
		ЗаполнитьВсеПечатныеФормы();
		ФильтрПечатныхФорм = "Все";
		Элементы.НадписьПредупреждение.Заголовок = НСтр("ru='Состояние оригинала документа будет установлено по печатным формам'");
	Иначе
		ФильтрПечатныхФорм = "Отслеживаемые";
	КонецЕсли;	

	УстановитьСсылкуНаОригинал();

	Если КомплектПечатныхФорм.Количество()= 0 Тогда
		ВосстанавливатьФильтр = Ложь;
	Иначе
		ВосстанавливатьФильтр = Истина;
	КонецЕсли;
		
	ВосстановитьНастройки(ВосстанавливатьФильтр);

	УстановитьСсылкуНаОригинал();
	
	УстановитьФильтрПечатныхФорм();
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();

	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КомплектПечатныхФорм.Состояние"); 
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбора.Использование = Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  WebЦвета.СеребристоСерый);
	ЭлементОформления.Использование = Истина;

	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("КомплектПечатныхФормПредставление");
	ПолеОформления.Использование = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	Если ИмяСобытия = "ДобавлениеУдалениеСостоянияОригиналаПервичногоДокумента" Тогда
		Подключаемый_ОбновитьКомандыСостоянияОригинала();
		ОбновитьОтображениеДанных();
	ИначеЕсли ИмяСобытия = "ИзменениеСостоянияОригиналаПервичногоДокумента" 
		Или ИмяСобытия = "ТабличныеДокументыНапечатаны" Тогда
		
		КомплектПечатныхФорм.Очистить();
		ПоказатьОтслеживаемыеНаСервере();
		Если КомплектПечатныхФорм.Количество()=0 Тогда
			 ПоказатьВсеНаСервере();
		КонецЕсли;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СсылкаНаДокументНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(,Запись.Ссылка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура КомплектПечатныхФормВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле.Имя = "ОригиналПолученКартинка" Тогда
		УстановитьСостояниеОригинала("УстановитьОригиналПолучен");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомплектПечатныхФормПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомплектПечатныхФормПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомплектПечатныхФормСостояниеПриИзменении(Элемент)

	КоличествоСдвинуть = 0;

	Для Каждого Строка Из КомплектПечатныхФорм Цикл
		Если ЗначениеЗаполнено(Строка.Состояние) Тогда
			КоличествоСдвинуть = КоличествоСдвинуть+1;
		КонецЕсли;
	КонецЦикла;

	ТекущаяСтрока = Элементы.КомплектПечатныхФорм.ТекущиеДанные;
	НовыйИндекс = КомплектПечатныхФорм.Индекс(ТекущаяСтрока);

	Если Не НовыйИндекс <= КоличествоСдвинуть Тогда
		КоличествоСдвинуть = НовыйИндекс - КоличествоСдвинуть +1;
		КомплектПечатныхФорм.Сдвинуть(НовыйИндекс,-КоличествоСдвинуть);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Элементы.КомплектПечатныхФорм.ТекущиеДанные.Состояние) Тогда
		Элементы.КомплектПечатныхФорм.ТекущиеДанные.ОригиналПолученКартинка = 0;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомплектПечатныхФормСостояниеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если ВыбранноеЗначение = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ОригиналПолучен") Тогда
		Элементы.КомплектПечатныхФорм.ТекущиеДанные.ОригиналПолученКартинка = 1;
	Иначе
		Элементы.КомплектПечатныхФорм.ТекущиеДанные.ОригиналПолученКартинка = 0;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьНеОтслеживаемые();

	УстановитьОбщееСостояние();
	
	СохранитьНастройки();
	
	Если КомплектПечатныхФорм.Количество()<> 0  Тогда
		ЗаписатьСостоянияОригиналовПервичныхДокументов();
		Оповестить("ИзменениеСостоянияОригиналаПервичногоДокумента");
		Закрыть();
		УчетОригиналовПервичныхДокументовКлиент.ОповеститьПользователяОбУстановкеСостояний(1, Запись.Ссылка);
	ИначеЕсли КомплектПечатныхФорм.Количество() = 0 Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьСостояниеОригинала(Команда)

	Если Команда.Имя = "НастройкаСостояний" Тогда
		УчетОригиналовПервичныхДокументовКлиент.ОткрытьФормуНастройкиСостояний();
	Иначе
		УстановитьСостояниеОригинала(Команда.Имя);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКомандыСостоянияОригинала()

	УчетОригиналовПервичныхДокументов.ОбновитьКомандыСостоянияОригинала(ЭтотОбъект,Элементы.КомплектПечатныхФорм);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСостояниеОригинала(Команда)

	НайденноеСостояние = Элементы.Найти(Команда);

	Если Не НайденноеСостояние = Неопределено Тогда
		ИмяСостояния = НайденноеСостояние.Заголовок;
	ИначеЕсли Команда = "УстановитьОригиналПолучен" Тогда
		ИмяСостояния = "Оригинал получен";
	Иначе 
		Возврат;
	КонецЕсли;

	Для Каждого СтрокаСписка Из Элементы.КомплектПечатныхФорм.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.КомплектПечатныхФорм.ДанныеСтроки(СтрокаСписка);

		ДанныеСтроки.Состояние = НайтиСостояниеВСправочнике(ИмяСостояния);
		
		Если ДанныеСтроки.Состояние = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ОригиналПолучен") Тогда
			ДанныеСтроки.ОригиналПолученКартинка = 1;
		Иначе
			ДанныеСтроки.ОригиналПолученКартинка = 0;
		КонецЕсли;

		ДанныеСтроки.Состояние = НайтиСостояниеВСправочнике(ИмяСостояния);
	КонецЦикла;

	Элементы.КомплектПечатныхФорм.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВсе(Команда)

	ПоказатьВсеНаСервере() 

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтслеживаемые(Команда)
	
	ПоказатьОтслеживаемыеНаСервере()
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВручную(Команда)

	Если Не ЗначениеЗаполнено(ПечатнаяФормаВручную) Тогда
		Возврат;
	КонецЕсли;

	ПервичныйДокумент = СтрЗаменить(ПечатнаяФормаВручную," ","");
	
	НайденныеСтроки = КомплектПечатныхФорм.НайтиСтроки(Новый Структура("ИмяМакета",ПервичныйДокумент));

	Если НайденныеСтроки.Количество() > 0 Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'В списке уже есть такая форма.'"));
		Возврат;
	КонецЕсли;

	Элементы.ДобавитьСвою.Скрыть();
	КоличествоСдвинуть = 0;

	Для Каждого Строка Из КомплектПечатныхФорм Цикл
		Если ЗначениеЗаполнено(Строка.Состояние) Тогда
			КоличествоСдвинуть = КоличествоСдвинуть+1;
		КонецЕсли;
	КонецЦикла;

	Если КоличествоСдвинуть = 0 Тогда
		КоличествоСдвинуть = КомплектПечатныхФорм.Количество();
	Иначе
		КоличествоСдвинуть = КомплектПечатныхФорм.Количество() - КоличествоСдвинуть;
	КонецЕсли;

	НоваяСтрока = КомплектПечатныхФорм.Добавить();
	НоваяСтрока.ИмяМакета = ПервичныйДокумент;
	НоваяСтрока.Представление = ПечатнаяФормаВручную;
	НоваяСтрока.Состояние = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ФормаНапечатана");
	НоваяСтрока.Извне = Истина;
	НоваяСтрока.Картинка = 2;
	НоваяСтрока.ОригиналПолученКартинка = 0;

	ПоследняяСтрока = КомплектПечатныхФорм.Количество()-1;

	КомплектПечатныхФорм.Сдвинуть(ПоследняяСтрока,-КоличествоСдвинуть);

	Элементы.КомплектПечатныхФорм.Обновить();
	Элементы.КомплектПечатныхФорм.ВыделенныеСтроки.Очистить();
	Элементы.КомплектПечатныхФорм.ВыделенныеСтроки.Добавить(НоваяСтрока.ПолучитьИдентификатор());

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеТаблицыКомплектПечатныхФорм

&НаСервере
Процедура ЗаполнитьПервоначальныйСписокПечатныхФорм()

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда

		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ОбщегоНазначения.ИмяТаблицыПоСсылке(Запись.Ссылка));
		СписокОбъектов = Новый Массив;
		СписокОбъектов.Добавить(ОбъектМетаданных);

		КоллекцияПечатныхФорм = УправлениеПечатью.КомандыПечатиФормы("ФормаДокумента", СписокОбъектов);
		
		ОбъектМетаданных = ОбщегоНазначения.ИмяТаблицыПоСсылке(Запись.Ссылка);
		ЗапросТаблицаКоманд = ДополнительныеОтчетыИОбработки.НовыйЗапросПоДоступнымКомандам(Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма,ОбъектМетаданных, Истина);
		ТаблицаКоманд = ЗапросТаблицаКоманд.Выполнить().Выгрузить();

		Для Каждого ТекСтрока Из КоллекцияПечатныхФорм Цикл
				НоваяСтрока = КомплектПечатныхФорм.Добавить();
				НоваяСтрока.ИмяМакета =  ТекСтрока.Идентификатор;
				НоваяСтрока.Представление = ТекСтрока.Представление;
				НоваяСтрока.Картинка = 1; 
				НоваяСтрока.ОригиналПолученКартинка = 0;
		КонецЦикла;

		Если ТаблицаКоманд.Количество() > 0 Тогда
			Для Каждого ТекСтрока Из ТаблицаКоманд Цикл

				Если КомплектПечатныхФорм.НайтиСтроки(Новый Структура("ИмяМакета", ТекСтрока.Идентификатор)) = 0 Тогда
					НоваяСтрока = КомплектПечатныхФорм.Добавить();
					НоваяСтрока.ИмяМакета = ТекСтрока.Идентификатор;
					НоваяСтрока.Представление = ТекСтрока.Представление;
					НоваяСтрока.Картинка = 1;
					НоваяСтрока.ОригиналПолученКартинка = 0;
				КонецЕсли;

			КонецЦикла;
		КонецЕсли;

		НенужныеСтроки = КомплектПечатныхФорм.НайтиСтроки(Новый Структура("Представление","Комплект документов на принтер"));
		Для Каждого НеНужнаяСтрока Из НенужныеСтроки Цикл
			КомплектПечатныхФорм.Удалить(НеНужнаяСтрока);
		КонецЦикла;


		НенужныеСтроки = КомплектПечатныхФорм.НайтиСтроки(Новый Структура("Представление","Комплект документов с настройкой..."));
		Для Каждого НеНужнаяСтрока Из НенужныеСтроки Цикл
			КомплектПечатныхФорм.Удалить(НеНужнаяСтрока);
		КонецЦикла;
		
	Иначе
		Возврат;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПечатныхФормПоСсылке()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СостоянияОригиналовПервичныхДокументов.ПервичныйДокумент КАК ПервичныйДокумент,
	               |	СостоянияОригиналовПервичныхДокументов.Состояние КАК Состояние,
	               |	СостоянияОригиналовПервичныхДокументов.ФормаИзвне КАК Извне,
	               |	СостоянияОригиналовПервичныхДокументов.ПервичныйДокументПредставление КАК Представление
	               |ИЗ
	               |	РегистрСведений.СостоянияОригиналовПервичныхДокументов КАК СостоянияОригиналовПервичныхДокументов
	               |ГДЕ
	               |	НЕ СостоянияОригиналовПервичныхДокументов.ОбщееСостояние
	               |	И СостоянияОригиналовПервичныхДокументов.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Запись.Ссылка);

	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		НоваяСтрока = КомплектПечатныхФорм.Добавить();
		НоваяСтрока.ИмяМакета = Выборка.ПервичныйДокумент;
		НоваяСтрока.Представление = Выборка.Представление;
		НоваяСтрока.Состояние = Выборка.Состояние;
		НоваяСтрока.Извне = Выборка.Извне;

		Если Выборка.Извне = Истина Тогда
			НоваяСтрока.Картинка = 2;
		Иначе
			НоваяСтрока.Картинка = 1;
		КонецЕсли;

		Если Выборка.Состояние = Справочники.СостоянияОригиналовПервичныхДокументов.ОригиналПолучен Тогда
			НоваяСтрока.ОригиналПолученКартинка = 1;
		Иначе
			НоваяСтрока.ОригиналПолученКартинка = 0;
		КонецЕсли;

	КонецЦикла;
	
	КомплектПечатныхФорм.Сортировать("Представление");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВсеПечатныеФормы()

	ЗаполнитьСписокПечатныхФормПоСсылке();
	ЗаполнитьПервоначальныйСписокПечатныхФорм();

	УдалитьДубликатыФорм();

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СостоянияОригиналовПервичныхДокументов.ПервичныйДокумент КАК ПервичныйДокумент,
	               |	СостоянияОригиналовПервичныхДокументов.ПервичныйДокументПредставление КАК Представление
	               |ИЗ
	               |	РегистрСведений.СостоянияОригиналовПервичныхДокументов КАК СостоянияОригиналовПервичныхДокументов
	               |ГДЕ
	               |	ТИПЗНАЧЕНИЯ(СостоянияОригиналовПервичныхДокументов.Ссылка) = &Тип
	               |	И СостоянияОригиналовПервичныхДокументов.ДатаПоследнегоИзменения МЕЖДУ &ДатаНачала И &ДатаОкончания
	               |	И СостоянияОригиналовПервичныхДокументов.ФормаИзвне
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	СостоянияОригиналовПервичныхДокументов.ПервичныйДокумент,
	               |	СостоянияОригиналовПервичныхДокументов.ПервичныйДокументПредставление";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Тип","ТИП ("+ОбщегоНазначения.ИмяТаблицыПоСсылке(Запись.Ссылка)+")");
	Запрос.УстановитьПараметр("ДатаНачала",НачалоМесяца(НачалоДня(ТекущаяДатаСеанса())));
	Запрос.УстановитьПараметр("ДатаОкончания",КонецМесяца(КонецДня(ТекущаяДатаСеанса())));

	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		НоваяСтрока = КомплектПечатныхФорм.Добавить();
		НоваяСтрока.ИмяМакета = Выборка.ПервичныйДокумент;
		НоваяСтрока.Представление = Выборка.Представление;
		НоваяСтрока.Извне = Истина;
		НоваяСтрока.Картинка = 2;
		НоваяСтрока.ОригиналПолученКартинка = 0;
	КонецЦикла;
	
	УдалитьДубликатыФорм();
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьНеОтслеживаемые()
	
	Отбор = Новый Структура("Состояние",ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ПустаяСсылка"));
	НайденныеСтроки = КомплектПечатныхФорм.НайтиСтроки(Отбор);
	Для Каждого Строка Из НайденныеСтроки Цикл 
		 КомплектПечатныхФорм.Удалить(Строка);
	КонецЦикла;
	 
КонецПроцедуры
	
&НаСервере
Процедура УдалитьДубликатыФорм()

	Для Каждого Строка Из КомплектПечатныхФорм Цикл
		Отбор = Новый Структура("ИмяМакета",Строка.ИмяМакета);
		НайденныеСтроки = КомплектПечатныхФорм.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество()> 1 Тогда
			Счетчик = НайденныеСтроки.Количество();
			Пока Счетчик > НайденныеСтроки.Количество()-1 Цикл
				КомплектПечатныхФорм.Удалить(НайденныеСтроки[Счетчик-1]);
				Если Не Счетчик = 0 Тогда
					Счетчик = Счетчик-1;
				Иначе
					Продолжить;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПоказатьВсеНаСервере() 

	Элементы.ПоказатьВсе.Пометка = Истина;
	Элементы.ПоказатьОтслеживаемые.Пометка = Ложь;
	ФильтрПечатныхФорм = "Все";
	
	ОчиститьНеОтслеживаемые();
	ЗаполнитьВсеПечатныеФормы();

КонецПроцедуры

&НаСервере
Процедура ПоказатьОтслеживаемыеНаСервере() 

	Элементы.ПоказатьВсе.Пометка = Ложь;
	Элементы.ПоказатьОтслеживаемые.Пометка = Истина;
	ФильтрПечатныхФорм = "Отслеживаемые";
	
	ОчиститьНеОтслеживаемые();
	ЗаполнитьСписокПечатныхФормПоСсылке();
	УдалитьДубликатыФорм();
КонецПроцедуры

&НаСервере
Процедура УстановитьФильтрПечатныхФорм() 
	
	Если ФильтрПечатныхФорм = "Отслеживаемые" Тогда
		ПоказатьОтслеживаемыеНаСервере();
	Иначе 
		ПоказатьВсеНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьСсылкуНаОригинал() 

	// Для отключения проверки конфигурации.
	СвойстваЗаписи = Новый Структура("Ссылка");
	ЗаполнитьЗначенияСвойств(СвойстваЗаписи, Запись);
	
	Документ = СвойстваЗаписи.Ссылка.ПолучитьОбъект();
	ТипДокумента = Метаданные.НайтиПоПолномуИмени(ОбщегоНазначения.ИмяТаблицыПоСсылке(Запись.Ссылка));

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрефиксацияОбъектов") Тогда
		Значения = Новый Структура("Документ,Номер,Дата",СокрЛП(ТипДокумента),
			ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Документ.Номер, Истина, Истина),Формат(Документ.Дата,НСтр("ru='ДЛФ=DD'")));
		СсылкаНаДокумент = НСтр("ru='[Документ] № [Номер] от [Дата]'");
		СсылкаНаДокумент = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(СсылкаНаДокумент,Значения);
	Иначе
		СсылкаНаДокумент = Запись.Ссылка;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция НайтиСостояниеВСправочнике(ИмяСостояния)

	СостояниеОригинала = Справочники.СостоянияОригиналовПервичныхДокументов.НайтиПоНаименованию(ИмяСостояния);

	Возврат СостояниеОригинала

КонецФункции

&НаКлиенте
Процедура УстановитьОбщееСостояние()

	КоличествоЗаписываемых = 0;

	Для Каждого Строка Из КомплектПечатныхФорм Цикл
		Если ЗначениеЗаполнено(Строка.Состояние) Тогда
			КоличествоЗаписываемых = КоличествоЗаписываемых + 1;
		КонецЕсли;
	КонецЦикла;

	Для Каждого Строка Из КомплектПечатныхФорм Цикл
		Если ЗначениеЗаполнено(Строка.Состояние) Тогда
			Отбор = Новый Структура("Состояние",Строка.Состояние);
			НайденныеСтроки = КомплектПечатныхФорм.НайтиСтроки(Отбор);

			Если НайденныеСтроки.Количество() = КомплектПечатныхФорм.Количество() Или КоличествоЗаписываемых = 1  Тогда
				Запись.Состояние = Строка.Состояние;
			Иначе
				Запись.Состояние = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ОригиналыНеВсе");
			КонецЕсли;

			Прервать;
		КонецЕсли;
	КонецЦикла

КонецПроцедуры

&НаСервере
Процедура ЗаписатьСостоянияОригиналовПервичныхДокументов()

	ПроверкаЗаписьСостоянияОригинала = РегистрыСведений.СостоянияОригиналовПервичныхДокументов.СоздатьНаборЗаписей();
	ПроверкаЗаписьСостоянияОригинала.Отбор.Ссылка.Установить(Запись.Ссылка);
	ПроверкаЗаписьСостоянияОригинала.Прочитать(); 

	Если ПроверкаЗаписьСостоянияОригинала.Количество() = 0 Тогда
		РегистрыСведений.СостоянияОригиналовПервичныхДокументов.ЗаписатьОбщееСостояниеОригиналаДокумента(Запись.Ссылка,Запись.Состояние);
	КонецЕсли;

	Если КомплектПечатныхФорм.Количество()<> 0 Тогда
		Для Каждого ПечатнаяФорма Из КомплектПечатныхФорм Цикл

			Если ЗначениеЗаполнено(ПечатнаяФорма.Состояние) Тогда
				ПроверкаЗаписьСостоянияОригинала.Отбор.ПервичныйДокумент.Установить(ПечатнаяФорма.ИмяМакета);
				ПроверкаЗаписьСостоянияОригинала.Прочитать();
				Если ПроверкаЗаписьСостоянияОригинала.Количество() > 0 Тогда

					Если ПроверкаЗаписьСостоянияОригинала[0].Состояние <> ПечатнаяФорма.Состояние Тогда
						РегистрыСведений.СостоянияОригиналовПервичныхДокументов.ЗаписатьСостояниеОригиналаДокументаПоПечатнымФормам(Запись.Ссылка,
							ПечатнаяФорма.ИмяМакета,ПечатнаяФорма.Представление,ПечатнаяФорма.Состояние,ПечатнаяФорма.Извне);
					КонецЕсли;

				Иначе
					РегистрыСведений.СостоянияОригиналовПервичныхДокументов.ЗаписатьСостояниеОригиналаДокументаПоПечатнымФормам(Запись.Ссылка,
						ПечатнаяФорма.ИмяМакета,ПечатнаяФорма.Представление,ПечатнаяФорма.Состояние,ПечатнаяФорма.Извне);
				КонецЕсли;
			КонецЕсли;

		КонецЦикла;
	КонецЕсли;
	РегистрыСведений.СостоянияОригиналовПервичныхДокументов.ЗаписатьОбщееСостояниеОригиналаДокумента(Запись.Ссылка,Запись.Состояние);

КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки(ВосстанавливатьФильтр)

	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("РегистрСведений.СостоянияОригиналовПервичныхДокументов.Форма.ИзменениеСостоянийОригиналовПервичныхДокументов","ФильтрПечатныхФорм");

	Если ВосстанавливатьФильтр Тогда 
		Если ТипЗнч(Настройки) = Тип("Структура") Тогда
			ФильтрПечатныхФорм = Настройки.ФильтрПечатныхФорм;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()

	ИменаСохраняемыхРеквизитов = "ФильтрПечатныхФорм";

	Настройки = Новый Структура(ИменаСохраняемыхРеквизитов);
	ЗаполнитьЗначенияСвойств(Настройки, ЭтотОбъект);

	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("РегистрСведений.СостоянияОригиналовПервичныхДокументов.Форма.ИзменениеСостоянийОригиналовПервичныхДокументов","ФильтрПечатныхФорм",Настройки);

КонецПроцедуры

#КонецОбласти
