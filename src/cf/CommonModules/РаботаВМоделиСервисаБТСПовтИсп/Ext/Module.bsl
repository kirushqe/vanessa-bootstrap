﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность в модели сервиса".
// Серверные процедуры и функции общего назначения:
// - Поддержка работы в модели сервиса.
//
////////////////////////////////////////////////////////////////////////////////
// @strict-types

#Область ПрограммныйИнтерфейс

// Возвращает конечную точку для отправки сообщений в менеджер сервиса.
//
// Возвращаемое значение:
//  ПланОбменаСсылка.ОбменСообщениями - узел соответствующий менеджеру сервиса.
//
Функция КонечнаяТочкаМенеджераСервиса() Экспорт
	
	Возврат РаботаВМоделиСервисаБТС.КонечнаяТочкаМенеджераСервиса();
	
КонецФункции

// Параметры:
// 	ДанныеСервера - см. РаботаВМоделиСервисаБТС.СоединениеСМенеджеромСервиса.ДанныеСервера
// 	Таймаут - см. РаботаВМоделиСервисаБТС.СоединениеСМенеджеромСервиса.Таймаут
// 	
// Возвращаемое значение:
//	См. РаботаВМоделиСервисаБТС.СоединениеСМенеджеромСервиса
//
Функция СоединениеСМенеджеромСервиса(ДанныеСервера, Таймаут = 60) Экспорт
	
	Возврат РаботаВМоделиСервисаБТС.СоединениеСМенеджеромСервиса(ДанныеСервера, Таймаут);
	
КонецФункции
 
#КонецОбласти
