﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ПрограммноеЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЗаполнитьПеременныеДляПроверкиТелефонаИЭлектроннойПочты(ЭтотОбъект);

	Сертификат = Параметры.Сертификат;

	// "Изменение" - полная проверка, "Подтверждение" - только проверка новых телефонов
	РежимПроверки = "Изменение";
	Если Параметры.Свойство("РежимПроверки") Тогда
		РежимПроверки = Параметры.РежимПроверки;
	КонецЕсли;

	Если РежимПроверки = "Изменение" Тогда
		Результат = СервисКриптографии.ПолучитьНастройкиПолученияВременныхПаролей(СервисКриптографииСлужебный.Идентификатор(Сертификат));
		ТелефонДляПаролей = Результат.Телефон;
		ЭлектроннаяПочтаДляПаролей = Результат.ЭлектроннаяПочта;
	Иначе
		Элементы.ТелефонДляПаролей.АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;

	ПроверкаТелефонДляПаролей.ИсходноеЗначение = ТелефонДляПаролей;
	ПроверкаЭлектроннаяПочтаДляПаролей.ИсходноеЗначение = ЭлектроннаяПочтаДляПаролей;

	УстановитьНадписи();

	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьТекстыПолей", 0.1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если ПрограммноеЗакрытие <> Истина Тогда
		ПрограммноеЗакрытие = Истина;
		Отказ = Истина;

		ЗакрытьФорму();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПояснениеПодтвержденияИзмененияТелефонаОбработкаНавигационнойСсылки(Элемент,
		НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Сертификат", Сертификат);
	ПараметрыФормы.Вставить("НовыйТелефон", "");

	Если ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено Тогда
		ПараметрыФормы.Вставить("НовыйТелефон", ТелефонДляПаролей);
		ПараметрыФормы.Вставить("ИдентификаторПроверки", ПроверкаТелефонДляПаролей.ИдентификаторПроверки);
	КонецЕсли;

	ОткрытьФорму("ОбщаяФорма.ИзменениеНомераТелефона", ПараметрыФормы, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ТелефонДляПаролейПриИзменении(Элемент)

	ТелефонДляПаролейИзменениеТекстаРедактирования(Элемент, Элемент.ТекстРедактирования, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ТелефонДляПаролейИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)

	ОчиститьСообщения();

	Представление = ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьПредставлениеТелефона(Текст);
	ТелефонДляПаролей = Представление;

	ПроверкаТелефонДляПаролей.ЗначениеВведено = ЗначениеЗаполнено(Представление)
		И Представление <> ПроверкаТелефонДляПаролей.ИсходноеЗначение;
	Если Не ЗначениеЗаполнено(Представление) Тогда
		ТелефонДляПаролей = Текст;
	КонецЕсли;

	ОтключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета");
	ОтключитьОбработчикОжидания("Подключаемый_ОбновитьТелефонДляПаролей");
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьТелефонДляПаролей", 1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура КодПодтвержденияТелефонПриИзменении(Элемент)

	КодПодтвержденияТелефонИзменениеТекстаРедактирования(Элемент, Элемент.ТекстРедактирования, Истина);

КонецПроцедуры

&НаКлиенте
Процедура КодПодтвержденияТелефонИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)

	Если СтрДлина(СокрЛП(Текст)) = 6 Тогда
		КодПодтверждения = СокрЛП(Текст);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьКодПодтверждения", 0.5, Истина);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЭлектроннаяПочтаДляПаролейПриИзменении(Элемент)

	ЭлектроннаяПочтаДляПаролейИзменениеТекстаРедактирования(Элемент, Элемент.ТекстРедактирования, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ЭлектроннаяПочтаДляПаролейИзменениеТекстаРедактирования(Элемент,
		Текст, СтандартнаяОбработка)

	Представление = СокрЛП(Текст);
	ЭлектроннаяПочтаДляПаролей = Представление;

	ПроверкаЭлектроннаяПочтаДляПаролей.ЗначениеВведено = ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(Представление)
		И Представление <> ПроверкаТелефонДляПаролей.ИсходноеЗначение;

	ОтключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета");
	ОтключитьОбработчикОжидания("Подключаемый_ОбновитьЭлектроннаяПочтаДляПаролей");
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьЭлектроннаяПочтаДляПаролей", 1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура КодПодтвержденияЭлектроннаяПочтаПриИзменении(Элемент)

	КодПодтвержденияЭлектроннаяПочтаИзменениеТекстаРедактирования(Элемент, Элемент.ТекстРедактирования, Истина);

КонецПроцедуры

&НаКлиенте
Процедура КодПодтвержденияЭлектроннаяПочтаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)

	Если СтрДлина(СокрЛП(Текст)) = 6 Тогда
		КодПодтверждения = СокрЛП(Текст);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьКодПодтверждения", 0.5, Истина);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КодПодтвержденияТелефонСтарыйПриИзменении(Элемент)

	КодПодтвержденияТелефонСтарыйИзменениеТекстаРедактирования(Элемент, Элемент.ТекстРедактирования, Истина);

КонецПроцедуры

&НаКлиенте
Процедура КодПодтвержденияТелефонСтарыйИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)

	Если СтрДлина(СокрЛП(Текст)) = 6 Тогда
		КодПодтверждения = СокрЛП(Текст);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьКодПодтверждения", 0.5, Истина);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьНомер(Команда)

	ОтправитьКодПодтвержденияТелефонДляПаролей();

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьКодПовторноТелефон(Команда)

	ОтправитьКодПодтвержденияТелефонДляПаролей();

КонецПроцедуры

&НаКлиенте
Процедура ОтменитьИзменениеТелефонаНажатие(Элемент)

	ПроверкаТелефонДляПаролей = ПроверкаТелефонДляПаролей(Ложь, Ложь, "", Ложь, Ложь, ПроверкаТелефонДляПаролей.ИсходноеЗначение);
	ТелефонДляПаролей = ПроверкаТелефонДляПаролей.ИсходноеЗначение;
	Таймер = 0;
	ОтключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета");
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьТекстыПолей", 0.1, Истина);
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьАдрес(Команда)

	ОтправитьКодПодтвержденияЭлектроннаяПочтаДляПаролей();

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьКодПовторноЭлектроннаяПочта(Команда)

	ОтправитьКодПодтвержденияЭлектроннаяПочтаДляПаролей();

КонецПроцедуры

&НаКлиенте
Процедура ОтменитьИзменениеПочтыНажатие(Элемент)

	ПроверкаЭлектроннаяПочтаДляПаролей = ПроверкаТелефонДляПаролей(Ложь, Ложь, "", Ложь, Ложь, ПроверкаЭлектроннаяПочтаДляПаролей.ИсходноеЗначение);
	ЭлектроннаяПочтаДляПаролей = ПроверкаЭлектроннаяПочтаДляПаролей.ИсходноеЗначение;
	Таймер = 0;
	ОтключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета");
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьТекстыПолей", 0.1, Истина);
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьИзменение(Команда)

	ОтправитьКодПодтвержденияТелефонСтарый();

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьКодПовторноТелефонСтарый(Команда)

	ОтправитьКодПодтвержденияТелефонСтарый();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьПеременныеДляПроверкиТелефонаИЭлектроннойПочты(Форма)

	Форма.ПроверкаТелефонДляПаролей = ПроверкаТелефонДляПаролей(Ложь, Ложь, "", Ложь, Ложь, "");
	Форма.ПроверкаЭлектроннаяПочтаДляПаролей = ПроверкаТелефонДляПаролей(Ложь, Ложь, "", Ложь, Ложь, "");
	Форма.ПроверкаТелефонСтарый = ПроверкаТелефонДляПаролей(Ложь, Ложь, "", Ложь, Ложь, "");

КонецПроцедуры

&НаСервере
Процедура УстановитьНадписи()

	Если РежимПроверки = "Изменение" Тогда
		ПояснениеПодтвержденияИзменений = НСтр("ru = 'Изменения необходимо будет подтвердить, введя код отправленный на %1.
			|Если этот телефон больше не доступен, то воспользуйтесь <a href = ""#Инструкция"">инструкцией</a>.'");
		ПояснениеПодтвержденияИзменений = СтрШаблон(ПояснениеПодтвержденияИзменений, ПроверкаТелефонДляПаролей.ИсходноеЗначение);
		ЗаголовокПояснения = НСтр("ru = 'Для изменения телефона и/или адреса электронной почты укажите их новые значения в полях ниже.'");
		ЗаголовокФормы = НСтр("ru = 'Настройки получения временных паролей'");
		ЗаголовокСтарогоТелефона = СтрШаблон(НСтр("ru = 'Код отправлен на
			|%1:'"), ПроверкаТелефонДляПаролей.ИсходноеЗначение);
	Иначе
		ПояснениеПодтвержденияИзменений = НСтр("ru = 'Необходимо будет ввести номер телефона и его подтвердить, введя отправленный код.'") + Символы.ПС;
		ЗаголовокПояснения = НСтр("ru = 'Для подтверждения телефона и/или адреса электронной почты укажите их значения в полях ниже.'");
		ЗаголовокФормы = НСтр("ru = 'Подтверждение настроек для получения временных паролей'");
		ЗаголовокСтарогоТелефона = "";
	КонецЕсли;

	ЭтаФорма.Заголовок = ЗаголовокФормы;
	Элементы.ДекорацияЗаголовок.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(ЗаголовокПояснения);
	Элементы.ЗаголовокСтарогоНомера.Заголовок = ЗаголовокСтарогоТелефона;
	Элементы.ПояснениеПодтвержденияИзменений.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(ПояснениеПодтвержденияИзменений);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;

	// Телефон для паролей
	Элементы.КартинкаТелефонПроверен.Видимость = Форма.ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено;
	Элементы.ПроверитьНомер.Видимость = Форма.ПроверкаТелефонДляПаролей.ЗначениеВведено
		И Не Форма.ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено
		И Не Форма.ПроверкаТелефонДляПаролей.ВыполняетсяПроверка;
	Элементы.ТелефонДляПаролей.ТолькоПросмотр = ЗначениеЗаполнено(Форма.ПроверкаТелефонДляПаролей.ИдентификаторПроверки);
	Элементы.ГруппаКодПодтвержденияТелефон.Видимость = Форма.ПроверкаТелефонДляПаролей.ВыполняетсяПроверка
		И Не Форма.ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено;

	Элементы.ОтправитьКодПовторноТелефон.Видимость = Не Форма.ПроверкаТелефонДляПаролей.КодОтправлен;
	Элементы.НадписьОбратногоОтсчетаТелефон.Видимость = Форма.ПроверкаТелефонДляПаролей.КодОтправлен;

	// Электронная почта для паролей
	Элементы.КартинкаЭлектроннаяПочтаПроверена.Видимость = Форма.ПроверкаЭлектроннаяПочтаДляПаролей.ПодтверждениеВыполнено;
	Элементы.ПроверитьАдрес.Видимость = Форма.ПроверкаЭлектроннаяПочтаДляПаролей.ЗначениеВведено
		И Не Форма.ПроверкаЭлектроннаяПочтаДляПаролей.ПодтверждениеВыполнено
		И Не Форма.ПроверкаЭлектроннаяПочтаДляПаролей.ВыполняетсяПроверка;
	Элементы.ЭлектроннаяПочтаДляПаролей.ТолькоПросмотр = ЗначениеЗаполнено(Форма.ПроверкаЭлектроннаяПочтаДляПаролей.ИдентификаторПроверки);
	Элементы.ГруппаКодПодтвержденияЭлектроннаяПочта.Видимость = Форма.ПроверкаЭлектроннаяПочтаДляПаролей.ВыполняетсяПроверка
		И Не Форма.ПроверкаЭлектроннаяПочтаДляПаролей.ПодтверждениеВыполнено;

	Элементы.ОтправитьКодПовторноЭлектроннаяПочта.Видимость = Не Форма.ПроверкаЭлектроннаяПочтаДляПаролей.КодОтправлен;
	Элементы.НадписьОбратногоОтсчетаЭлектроннаяПочта.Видимость = Форма.ПроверкаЭлектроннаяПочтаДляПаролей.КодОтправлен;

	// Подтверждение изменений
	Если Форма.РежимПроверки = "Изменение" Тогда
		МожноПодтвердитьИзменения = Форма.ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено
			ИЛИ Форма.ПроверкаЭлектроннаяПочтаДляПаролей.ПодтверждениеВыполнено
			ИЛИ Форма.ПроверкаЭлектроннаяПочтаДляПаролей.ИсходноеЗначение <> Форма.ЭлектроннаяПочтаДляПаролей
			И Не ЗначениеЗаполнено(Форма.ЭлектроннаяПочтаДляПаролей)
			И Не Форма.ПроверкаТелефонСтарый.ПодтверждениеВыполнено
			И Не Форма.ПроверкаТелефонДляПаролей.ВыполняетсяПроверка
			И Не Форма.ПроверкаЭлектроннаяПочтаДляПаролей.ВыполняетсяПроверка;
	Иначе
		МожноПодтвердитьИзменения = Форма.ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено
			И Не Форма.ПроверкаТелефонДляПаролей.ВыполняетсяПроверка
			И Не Форма.ПроверкаЭлектроннаяПочтаДляПаролей.ВыполняетсяПроверка
			И (НЕ ЗначениеЗаполнено(Форма.ЭлектроннаяПочтаДляПаролей) 
			ИЛИ Форма.ПроверкаЭлектроннаяПочтаДляПаролей.ПодтверждениеВыполнено);
	КонецЕсли;
	Элементы.ПодтвердитьИзменения.Видимость = МожноПодтвердитьИзменения;
	Элементы.ПодтвердитьИзменения.Доступность = Не Форма.ПроверкаТелефонСтарый.ВыполняетсяПроверка;

	Элементы.ОтправитьКодПовторноТелефонСтарый.Видимость = Не Форма.ПроверкаТелефонСтарый.КодОтправлен;
	Элементы.НадписьОбратногоОтсчетаТелефонСтарый.Видимость = Форма.ПроверкаТелефонСтарый.КодОтправлен;

	Элементы.ГруппаЗаголовкаИКодаСтарогоНомера.Видимость = Форма.ПроверкаТелефонСтарый.ВыполняетсяПроверка
		И МожноПодтвердитьИзменения И Форма.РежимПроверки = "Изменение";

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьТекстыПолей()

	Элементы.ТелефонДляПаролей.ОбновитьТекстРедактирования();
	Элементы.ЭлектроннаяПочтаДляПаролей.ОбновитьТекстРедактирования();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОбратногоОтсчета()

	Таймер = Таймер - 1;
	Если Таймер >= 0 Тогда
		НадписьОбратногоОтсчета = СтрШаблон(НСтр("ru = 'Запросить код повторно можно будет через %1 сек.'"), Таймер);
		ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета", 1, Истина);
	Иначе
		НадписьОбратногоОтсчета = "";
		ПроверкаТелефонДляПаролей.КодОтправлен = Ложь;
		ПроверкаЭлектроннаяПочтаДляПаролей.КодОтправлен = Ложь;
		ПроверкаТелефонСтарый.КодОтправлен = Ложь;
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьТелефонДляПаролей()

	Элементы.ПроверитьНомер.Видимость = ПроверкаТелефонДляПаролей.ЗначениеВведено;
	Если ПроверкаТелефонДляПаролей.ЗначениеВведено Тогда
		Элементы.ТелефонДляПаролей.ОбновитьТекстРедактирования();
		ОтключитьОбработчикОжидания("Подключаемый_АктивироватьКнопкуПроверитьНомер");
		ПодключитьОбработчикОжидания("Подключаемый_АктивироватьКнопкуПроверитьНомер", 0.1, Истина);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АктивироватьКнопкуПроверитьНомер()

	ТекущийЭлемент = Элементы.ПроверитьНомер;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьКодПодтверждения()

	ОчиститьСообщения();

	КодПодтверждения = СокрЛП(КодПодтверждения);
	Если СтрДлина(КодПодтверждения) = 6 Тогда

		Результат = Неопределено;

		Если ПроверкаТелефонДляПаролей.ВыполняетсяПроверка Тогда
			Результат = ПроверитьТелефонПоКодуНаСервере(ПроверкаТелефонДляПаролей.ИдентификаторПроверки, КодПодтверждения);
			Если Результат.Выполнено Тогда
				ПроверкаТелефонДляПаролей.ВыполняетсяПроверка = Ложь;
				ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено = Истина;
			КонецЕсли;
		ИначеЕсли ПроверкаТелефонСтарый.ВыполняетсяПроверка Тогда
			Результат = ПроверитьТелефонСтарыйПоКодуНаСервере(ПроверкаТелефонСтарый.ИдентификаторПроверки, КодПодтверждения);
			Если Результат.Выполнено Тогда
				ПроверкаТелефонСтарый.ВыполняетсяПроверка = Ложь;
				ПроверкаТелефонСтарый.ПодтверждениеВыполнено = Истина;

				ОписаниеОповещения = Новый ОписаниеОповещения("ЗакрытьФормуПослеПодтвержденияСтарогоНомера", ЭтотОбъект);

				Если ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено
						И ПроверкаЭлектроннаяПочтаДляПаролей.ПодтверждениеВыполнено Тогда
					ТекстПредупреждения = НСтр("ru = 'Ваш номер телефона и адрес электронной почты успешно изменены'");
				ИначеЕсли ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено Тогда
					ТекстПредупреждения = НСтр("ru = 'Ваш номер телефона успешно изменен'");
				Иначе
					ТекстПредупреждения = НСтр("ru = 'Ваш адрес электронной почты успешно изменен'");
				КонецЕсли;
				ПоказатьПредупреждение(ОписаниеОповещения, ТекстПредупреждения);
			КонецЕсли;
		ИначеЕсли ПроверкаЭлектроннаяПочтаДляПаролей.ВыполняетсяПроверка Тогда
			Результат = ПроверитьЭлектроннуюПочтуПоКодуНаСервере(ПроверкаЭлектроннаяПочтаДляПаролей.ИдентификаторПроверки, КодПодтверждения);
			Если Результат.Выполнено Тогда
				ПроверкаЭлектроннаяПочтаДляПаролей.ВыполняетсяПроверка = Ложь;
				ПроверкаЭлектроннаяПочтаДляПаролей.ПодтверждениеВыполнено = Истина;
			КонецЕсли;
		КонецЕсли;

		Если Результат <> Неопределено Тогда
			Если Результат.Выполнено Тогда
				ОтключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета");
				УправлениеФормой(ЭтотОбъект);
			Иначе
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ОписаниеОшибки, , "КодПодтверждения");
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьТелефонПоКодуНаСервере(Идентификатор, КодПодтверждения)

	Возврат МенеджерСервисаКриптографии.ПроверитьТелефонПоКоду(Идентификатор, КодПодтверждения);

КонецФункции

&НаСервереБезКонтекста
Функция ПроверитьЭлектроннуюПочтуПоКодуНаСервере(Идентификатор, КодПодтверждения)

	Возврат МенеджерСервисаКриптографии.ПроверитьЭлектроннуюПочтуПоКоду(Идентификатор, КодПодтверждения);

КонецФункции

&НаКлиенте
Процедура Подключаемый_ОбновитьЭлектроннаяПочтаДляПаролей()

	Элементы.ПроверитьАдрес.Видимость = ПроверкаЭлектроннаяПочтаДляПаролей.ЗначениеВведено;
	ЗначениеОчищено = (ПроверкаЭлектроннаяПочтаДляПаролей.ИсходноеЗначение <> ЭлектроннаяПочтаДляПаролей
		И Не ЗначениеЗаполнено(ЭлектроннаяПочтаДляПаролей))
		ИЛИ (РежимПроверки <> "Изменение" И НЕ ЗначениеЗаполнено(ЭлектроннаяПочтаДляПаролей));
	Если ПроверкаЭлектроннаяПочтаДляПаролей.ЗначениеВведено ИЛИ ЗначениеОчищено Тогда
		Элементы.ЭлектроннаяПочтаДляПаролей.ОбновитьТекстРедактирования();
		ОтключитьОбработчикОжидания("Подключаемый_АктивироватьКнопкуПроверитьАдрес");
		ПодключитьОбработчикОжидания("Подключаемый_АктивироватьКнопкуПроверитьАдрес", 0.1, Истина);
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АктивироватьКнопкуПроверитьАдрес()

	ТекущийЭлемент = Элементы.ПроверитьАдрес;

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьКодПодтвержденияТелефонДляПаролей()

	ОтключитьОбработчикОжидания("Подключаемый_ОбновитьТелефонДляПаролей");
	ОчиститьСообщения();
	КодПодтверждения = Неопределено;

	Результат = ПроверитьНомерНаСервере(ТелефонДляПаролей, ПроверкаТелефонДляПаролей.ИдентификаторПроверки);
	Если Результат.Выполнено Тогда
		Таймер = Результат.ЗадержкаПередПовторнойОтправкой;
		ПроверкаТелефонДляПаролей.ИдентификаторПроверки = Результат.Идентификатор;
		ЗапуститьОбратныйОтсчет();
		ПроверкаТелефонДляПаролей.ВыполняетсяПроверка = Истина;
		ПроверкаТелефонДляПаролей.КодОтправлен = Истина;

		ПодключитьОбработчикОжидания("Подключаемый_АктивироватьПолеКодПодтвержденияТелефон", 0.1, Истина);
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ОписаниеОшибки, , "ТелефонДляПаролей");
	КонецЕсли;
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьКодПодтвержденияЭлектроннаяПочтаДляПаролей()

	ОтключитьОбработчикОжидания("Подключаемый_ОбновитьЭлектроннаяПочтаДляПаролей");
	ОчиститьСообщения();
	КодПодтверждения = Неопределено;

	Результат = ПроверитьАдресНаСервере(ЭлектроннаяПочтаДляПаролей, ПроверкаЭлектроннаяПочтаДляПаролей.ИдентификаторПроверки);
	Если Результат.Выполнено Тогда
		Таймер = Результат.ЗадержкаПередПовторнойОтправкой;
		ПроверкаЭлектроннаяПочтаДляПаролей.ИдентификаторПроверки = Результат.Идентификатор;
		ЗапуститьОбратныйОтсчет();
		ПроверкаЭлектроннаяПочтаДляПаролей.ВыполняетсяПроверка = Истина;
		ПроверкаЭлектроннаяПочтаДляПаролей.КодОтправлен = Истина;
		ПодключитьОбработчикОжидания("Подключаемый_АктивироватьПолеКодПодтвержденияЭлектроннаяПочта", 0.1, Истина);
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ОписаниеОшибки, , "ЭлектроннаяПочтаДляПаролей");
	КонецЕсли;
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АктивироватьПолеКодПодтвержденияТелефон()

	ТекущийЭлемент = Элементы.КодПодтвержденияТелефон;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АктивироватьПолеКодПодтвержденияЭлектроннаяПочта()

	ТекущийЭлемент = Элементы.КодПодтвержденияЭлектроннаяПочта;

КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьОбратныйОтсчет()

	ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета", 1, Истина);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьНомерНаСервере(Телефон, Идентификатор)

	Возврат МенеджерСервисаКриптографии.ПолучитьКодПроверкиТелефона(Телефон, Идентификатор);

КонецФункции

&НаСервереБезКонтекста
Функция ПроверитьАдресНаСервере(ЭлектроннаяПочта, Идентификатор)

	Возврат МенеджерСервисаКриптографии.ПолучитьКодПроверкиЭлектроннойПочты(ЭлектроннаяПочта, Идентификатор);

КонецФункции

&НаКлиенте
Процедура Подключаемый_АктивироватьПолеКодПодтвержденияТелефонСтарый()

	ТекущийЭлемент = Элементы.КодПодтвержденияТелефонСтарый;

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьКодПодтвержденияТелефонСтарый()

	ОчиститьСообщения();
	КодПодтверждения = Неопределено;

	Если ЗначениеЗаполнено(ПроверкаЭлектроннаяПочтаДляПаролей.ИдентификаторПроверки) Тогда
		ЭлектроннаяПочта = ПроверкаЭлектроннаяПочтаДляПаролей.ИдентификаторПроверки;
	ИначеЕсли Не ЗначениеЗаполнено(ЭлектроннаяПочтаДляПаролей)
			И ЭлектроннаяПочтаДляПаролей <> ПроверкаЭлектроннаяПочтаДляПаролей.ИсходноеЗначение Тогда
		ЭлектроннаяПочта = "";
	КонецЕсли;

	Если РежимПроверки = "Подтверждение" Тогда
		ПараметрыЗакрытия = Новый Структура();
		ПараметрыЗакрытия.Вставить("НомерТелефона", ПроверкаТелефонДляПаролей.ИдентификаторПроверки);
		ПараметрыЗакрытия.Вставить("ЭлектроннаяПочта", ЭлектроннаяПочта);
		ЗакрытьФорму(ПараметрыЗакрытия);
	Иначе
		Результат = ОтправитьКодПодтвержденияНаСтарыйНомер(
			СервисКриптографииСлужебныйКлиент.Идентификатор(Сертификат), 
			?(ЗначениеЗаполнено(ПроверкаТелефонДляПаролей.ИдентификаторПроверки), ПроверкаТелефонДляПаролей.ИдентификаторПроверки, Неопределено), 
			ЭлектроннаяПочта, 
			ПроверкаТелефонСтарый.ИдентификаторПроверки);
		Если Результат.Выполнено Тогда
			Таймер = Результат.ЗадержкаПередПовторнойОтправкой;
			ПроверкаТелефонСтарый.ИдентификаторПроверки = Результат.Идентификатор;
			ЗапуститьОбратныйОтсчет();
			ПроверкаТелефонСтарый.ВыполняетсяПроверка = Истина;
			ПроверкаТелефонСтарый.КодОтправлен = Истина;

			ПодключитьОбработчикОжидания("Подключаемый_АктивироватьПолеКодПодтвержденияТелефонСтарый", 0.1, Истина);
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ОписаниеОшибки);
		КонецЕсли;
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьТелефонСтарыйПоКодуНаСервере(Идентификатор, КодПодтверждения)

	Возврат МенеджерСервисаКриптографии.ЗавершитьИзменениеНастроекПолученияВременныхПаролей(Идентификатор, КодПодтверждения);

КонецФункции

&НаКлиенте
Процедура ЗакрытьФормуПослеПодтвержденияСтарогоНомера(ВходящийКонтекст) Экспорт

	ЗакрытьФорму();

КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(ПараметрыЗакрытия = Неопределено)

	ПрограммноеЗакрытие = Истина;

	Если ПараметрыЗакрытия = Неопределено Тогда
		ПараметрыЗакрытия = Новый Структура;
		ПараметрыЗакрытия.Вставить("ТелефонИзменен", ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено);
		ПараметрыЗакрытия.Вставить("ЭлектроннаяПочтаИзменена", ПроверкаЭлектроннаяПочтаДляПаролей.ПодтверждениеВыполнено);
	КонецЕсли;

	Закрыть(ПараметрыЗакрытия);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ОтправитьКодПодтвержденияНаСтарыйНомер(ИдентификаторСертификата, Телефон, ЭлектроннаяПочта, Идентификатор)

	Возврат МенеджерСервисаКриптографии.НачатьИзменениеНастроекПолученияВременныхПаролей(ИдентификаторСертификата, Телефон, ЭлектроннаяПочта, Идентификатор);

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПроверкаТелефонДляПаролей(ЗначениеВведено, ВыполняетсяПроверка,
		ИдентификаторПроверки, ПодтверждениеВыполнено, КодОтправлен, ИсходноеЗначение)

	ПроверкаТелефонДляПаролей = Новый Структура;

	ПроверкаТелефонДляПаролей.Вставить("ЗначениеВведено", ЗначениеВведено);
	ПроверкаТелефонДляПаролей.Вставить("ВыполняетсяПроверка", ВыполняетсяПроверка);
	ПроверкаТелефонДляПаролей.Вставить("ИдентификаторПроверки", ИдентификаторПроверки);
	ПроверкаТелефонДляПаролей.Вставить("ПодтверждениеВыполнено", ПодтверждениеВыполнено);
	ПроверкаТелефонДляПаролей.Вставить("КодОтправлен", КодОтправлен);
	ПроверкаТелефонДляПаролей.Вставить("ИсходноеЗначение", ИсходноеЗначение);

	Возврат ПроверкаТелефонДляПаролей;

КонецФункции

#КонецОбласти
