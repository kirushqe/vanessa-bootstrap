﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела.
// См. ЭлектроннаяПодписьКлиент.ПредставлениеСертификата.
// См. ЭлектроннаяПодпись.ПредставлениеСертификата.
//
Функция ПредставлениеСертификата(Сертификат, Отчество = Ложь, СрокДействия = Истина) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Если СрокДействия Тогда
		Возврат ЭлектроннаяПодпись.ПредставлениеСертификата(Сертификат);
	Иначе	
		Возврат ЭлектроннаяПодпись.ПредставлениеСубъекта(Сертификат);
	КонецЕсли;	
#Иначе
	Если СрокДействия Тогда
		Возврат ЭлектроннаяПодписьКлиент.ПредставлениеСертификата(Сертификат);
	Иначе
		Возврат ЭлектроннаяПодписьКлиент.ПредставлениеСубъекта(Сертификат);
	КонецЕсли;
#КонецЕсли
	
КонецФункции

// Устарела.
// См. ЭлектроннаяПодписьКлиент.ПредставлениеСубъекта.
// См. ЭлектроннаяПодпись.ПредставлениеСубъекта.
//
Функция ПредставлениеСубъекта(Сертификат, Отчество = Истина) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ЭлектроннаяПодпись.ПредставлениеСубъекта(Сертификат);
#Иначе
	Возврат ЭлектроннаяПодписьКлиент.ПредставлениеСубъекта(Сертификат);
#КонецЕсли
	
КонецФункции

// Устарела.
// См. ЭлектроннаяПодписьКлиент.ПредставлениеИздателя.
// См. ЭлектроннаяПодпись.ПредставлениеИздателя.
//
Функция ПредставлениеИздателя(Сертификат) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ЭлектроннаяПодпись.ПредставлениеИздателя(Сертификат);
#Иначе
	Возврат ЭлектроннаяПодписьКлиент.ПредставлениеИздателя(Сертификат);
#КонецЕсли
	
КонецФункции

// Устарела.
// См. ЭлектроннаяПодписьКлиент.СвойстваСертификата.
// См. ЭлектроннаяПодпись.СвойстваСертификата.
//
Функция ЗаполнитьСтруктуруСертификата(Сертификат) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ЭлектроннаяПодпись.СвойстваСертификата(Сертификат);
#Иначе
	Возврат ЭлектроннаяПодписьКлиент.СвойстваСертификата(Сертификат);
#КонецЕсли
	
КонецФункции

// Устарела.
// См. ЭлектроннаяПодписьКлиент.СвойстваСубъектаСертификата.
// См. ЭлектроннаяПодпись.СвойстваСубъектаСертификата.
//
Функция СвойстваСубъектаСертификата(Сертификат) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ЭлектроннаяПодпись.СвойстваСубъектаСертификата(Сертификат);
#Иначе
	Возврат ЭлектроннаяПодписьКлиент.СвойстваСубъектаСертификата(Сертификат);
#КонецЕсли
	
КонецФункции

// Устарела.
// См. ЭлектроннаяПодписьКлиент.СвойстваИздателяСертификата.
// См. ЭлектроннаяПодпись.СвойстваИздателяСертификата.
//
Функция СвойстваИздателяСертификата(Сертификат) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ЭлектроннаяПодпись.СвойстваИздателяСертификата(Сертификат);
#Иначе
	Возврат ЭлектроннаяПодписьКлиент.СвойстваИздателяСертификата(Сертификат);
#КонецЕсли
	
КонецФункции

// Устарела.
// См. ЭлектроннаяПодписьКлиент.ПараметрыXMLDSig.
// См. ЭлектроннаяПодпись.ПараметрыXMLDSig.
//
Функция ПараметрыXMLDSig() Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ЭлектроннаяПодпись.ПараметрыXMLDSig();
#Иначе
	Возврат ЭлектроннаяПодписьКлиент.ПараметрыXMLDSig();
#КонецЕсли
	
КонецФункции

#КонецОбласти

#КонецОбласти
