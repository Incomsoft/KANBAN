///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Процедура заканчивает замер времени выполнения ключевой операции.
// Вызывается из обработчика ожидания.
//
Процедура ЗакончитьЗамерВремениАвто() Экспорт
	
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремениНаКлиентеАвто();
		
КонецПроцедуры

// Процедура вызывает функцию записи результатов замеров на сервере.
// Вызывается из обработчика ожидания.
//
Процедура ЗаписатьРезультатыАвто() Экспорт
	
	ОценкаПроизводительностиКлиент.ЗаписатьРезультатыАвтоНеГлобальный();
	
КонецПроцедуры

#КонецОбласти
