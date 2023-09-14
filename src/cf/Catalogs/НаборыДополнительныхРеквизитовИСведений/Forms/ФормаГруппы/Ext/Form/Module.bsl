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
	
	ТолькоПросмотр = Истина;
	
	ВидыСвойствНабора = УправлениеСвойствамиСлужебный.ВидыСвойствНабора(Объект.Ссылка);
	ИспользоватьДопРеквизиты = ВидыСвойствНабора.ДополнительныеРеквизиты;
	ИспользоватьДопСведения  = ВидыСвойствНабора.ДополнительныеСведения;
	
	Если ИспользоватьДопРеквизиты И ИспользоватьДопСведения Тогда
		Заголовок = Объект.Наименование + " " + НСтр("ru = '(Группа наборов дополнительных реквизитов и сведений)'")
		
	ИначеЕсли ИспользоватьДопРеквизиты Тогда
		Заголовок = Объект.Наименование + " " + НСтр("ru = '(Группа наборов дополнительных реквизитов)'")
		
	ИначеЕсли ИспользоватьДопСведения Тогда
		Заголовок = Объект.Наименование + " " + НСтр("ru = '(Группа наборов дополнительных сведений)'")
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти
