﻿#Область ПрограммныйИнтерфейс

// Возвращает номер текущей версии программного интерфейса.
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//   Строка   - Номер версии интерфейса
//
Функция Версия() Экспорт
КонецФункции

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//   Строка   - Пространство имен интерфейса
//
Функция Пакет() Экспорт
КонецФункции

// Возвращает название программного интерфейса сообщений.
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//   Строка   - Имя интерфейса
//
Функция ПрограммныйИнтерфейс() Экспорт
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//	МассивОбработчиков - Массив - Обработчики каналов. 
//
Процедура ОбработчикиКаналовСообщений(МассивОбработчиков) Экспорт
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//	МассивОбработчиков - Массив - Обработчики каналов.
//
Процедура ОбработчикиТрансляцииСообщений(МассивОбработчиков) Экспорт
КонецПроцедуры

#КонецОбласти