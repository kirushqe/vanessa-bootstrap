﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("СделатьОсновнымЗавершение", ЭтотОбъект, ПараметрКоманды);
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Отметить проект %1 как основной?
		|Основной проект подсвечивается жирным шрифтом и выводится в заголовке программы.'"), Строка(ПараметрКоманды));
	ПоказатьВопрос(ОповещениеОЗакрытии, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СделатьОсновнымЗавершение(Результат, Проект) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьОсновнойПроект(Проект);
	Оповестить("Запись__ДемоПроект", Новый Структура, Проект);
	ОбновитьПовторноИспользуемыеЗначения();
	СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОсновнойПроект(Проект)
	
	Справочники._ДемоПроекты.УстановитьОсновнойПроект(Проект);
		
КонецПроцедуры

#КонецОбласти
