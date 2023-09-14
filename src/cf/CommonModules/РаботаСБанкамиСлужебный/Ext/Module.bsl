﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Определяет нужно ли обновление данных классификатора.
//
Функция КлассификаторАктуален() Экспорт
	
	ИмяОбработки = "ЗагрузкаКлассификатораБанков";
	Если Метаданные.Обработки.Найти(ИмяОбработки) <> Неопределено Тогда
		Возврат Обработки[ИмяОбработки].КлассификаторАктуален();
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция КлассификаторПустой()
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КлассификаторБанков.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КлассификаторБанков КАК КлассификаторБанков";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ПредлагатьЗагрузкуКлассификатора() Экспорт
	
	Возврат Не ОбщегоНазначения.РазделениеВключено() И КлассификаторПустой();
	
КонецФункции

#КонецОбласти
