///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(УчетнаяЗаписьЭлектроннойПочты)
	|	ИЛИ ЗначениеРазрешено(УчетнаяЗаписьЭлектроннойПочты.ВладелецУчетнойЗаписи, ПустаяСсылка КАК Ложь)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Обновляет дату использования учетной записи в регистре.
//
// Параметры:
//  УчетнаяЗапись     - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись, для которой выполняется обновление.
//  ДатаИспользования - Дата - дата использования учетной записи. Если не передана, то устанавливается текущая дата.
//
Процедура ОбновитьДатуИспользованияУчетнойЗаписи(УчетнаяЗапись, ДатаИспользования = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкиУчетныхЗаписейЭлектроннойПочты");
	ЭлементБлокировки.УстановитьЗначение("УчетнаяЗаписьЭлектроннойПочты", УчетнаяЗапись);
	
	НаборЗаписей = РегистрыСведений.НастройкиУчетныхЗаписейЭлектроннойПочты.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.УчетнаяЗаписьЭлектроннойПочты.Установить(УчетнаяЗапись);
	
	Если ДатаИспользования = Неопределено Тогда
		ДатаИспользования = НачалоДня(ТекущаяДатаСеанса());
	КонецЕсли;
	
	ТребуетсяЗапись = Ложь;
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка.Заблокировать();
		
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() > 0 Тогда
			
			Если НаборЗаписей[0].ДатаПоследнегоИспользования <> ДатаИспользования Тогда
				
				НаборЗаписей[0].ДатаПоследнегоИспользования = ДатаИспользования;
				ТребуетсяЗапись = Истина;
				
			КонецЕсли;
			
		Иначе
			
			ЗаписьНабора = НаборЗаписей.Добавить();
			ЗаписьНабора.ДатаПоследнегоИспользования   = ДатаИспользования;
			ЗаписьНабора.УчетнаяЗаписьЭлектроннойПочты = УчетнаяЗапись;
			
			ТребуетсяЗапись = Истина;
		
		КонецЕсли;
		
		Если ТребуетсяЗапись Тогда
			НаборЗаписей.Записать();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
