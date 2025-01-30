  
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)        
	
	ПользовательСсылка 	= Пользователи.ТекущийПользователь(); 
	ПроектСсылка 		= ПолучитьПроектПоУмолчанию(ПользовательСсылка);   
	
	Проекты.Очистить();	
	Проекты.Добавить(ПроектСсылка);
	
	ДобавитьИсполнителейПоПроектам(ПользовательСсылка,Проекты.ВыгрузитьЗначения());
	
	УстановитьВидимостьКолонокКАНБАН(ПользовательСсылка);
	
КонецПроцедуры   

&НаСервере
Процедура ДобавитьИсполнителейПоПроектам(ПользовательСсылка,ПроектыМассив)
	
	Исполнители.Очистить();
	Исполнители.Добавить(ПользовательСсылка);

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	инкИсполнительПоПроекту.Проект КАК Проект,
		|	инкИсполнительПоПроекту.Пользователь КАК Пользователь
		|ИЗ
		|	РегистрСведений.инкИсполнительПоПроекту КАК инкИсполнительПоПроекту
		|ГДЕ
		|	инкИсполнительПоПроекту.Проект В(&ПроектыМассив)
		|	И инкИсполнительПоПроекту.Пользователь <> &ТекущийПользователь";
	
	Запрос.УстановитьПараметр("ПроектыМассив", ПроектыМассив);
	Запрос.УстановитьПараметр("ТекущийПользователь", ПользовательСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 		
		Исполнители.Добавить(ВыборкаДетальныеЗаписи.Пользователь);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКолонокКАНБАН(ПользовательСсылка)

	ВидимостьКолонокКАНБАНСтруктура = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ВидимостьКолонокКАНБАНСтруктура",ПользовательСсылка.Наименование);
	
	Если ЗначениеЗаполнено(ВидимостьКолонокКАНБАНСтруктура) Тогда
		
		мВидимостьВРаботе = ВидимостьКолонокКАНБАНСтруктура.мВидимостьВРаботе;    
		мВидимостьЗавершено = ВидимостьКолонокКАНБАНСтруктура.мВидимостьЗавершено;
		мВидимостьКВыполнениюПауза = ВидимостьКолонокКАНБАНСтруктура.мВидимостьКВыполнениюПауза;
		мВидимостьСписокБыстрыеЗаметки = ВидимостьКолонокКАНБАНСтруктура.мВидимостьСписокБыстрыеЗаметки;
		мВидимостьТестирование = ВидимостьКолонокКАНБАНСтруктура.мВидимостьТестирование;
		
	Иначе

		мВидимостьСписокБыстрыеЗаметки = Ложь;
		мВидимостьВРаботе = Истина;    
		мВидимостьЗавершено = Истина;
		мВидимостьКВыполнениюПауза = Истина;
		мВидимостьТестирование = Истина;
		
	КонецЕсли;   
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	ПользовательСсылка 	= Пользователи.ТекущийПользователь(); 
	
	ВидимостьКолонокКАНБАНСтруктура = Новый Структура;
	ВидимостьКолонокКАНБАНСтруктура.Вставить("мВидимостьВРаботе",мВидимостьВРаботе);    
	ВидимостьКолонокКАНБАНСтруктура.Вставить("мВидимостьЗавершено",мВидимостьЗавершено);
	ВидимостьКолонокКАНБАНСтруктура.Вставить("мВидимостьКВыполнениюПауза",мВидимостьКВыполнениюПауза);
	ВидимостьКолонокКАНБАНСтруктура.Вставить("мВидимостьСписокБыстрыеЗаметки",мВидимостьСписокБыстрыеЗаметки);
	ВидимостьКолонокКАНБАНСтруктура.Вставить("мВидимостьТестирование",мВидимостьТестирование);
		
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ВидимостьКолонокКАНБАНСтруктура",ПользовательСсылка.Наименование,ВидимостьКолонокКАНБАНСтруктура);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		ПриЗакрытииНаСервере();	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПроектПоУмолчанию(ПользовательСсылка)
	
	ПроектСсылка = ПользовательСсылка.инкПроектПоУмолчанию;
	Если НЕ ЗначениеЗаполнено(ПроектСсылка) Тогда
		ПроектСсылка = Справочники.инкПроектыКЗадачам.ПолучитьПервыйПроект();	
	КонецЕсли;
	
	Возврат ПроектСсылка;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	УстановитьОтборВСписках(); 
	УстановитьВидимостьКолонокКАНБАННаФорме();

КонецПроцедуры   

&НаКлиенте
Процедура ПроектПриИзменении(Элемент)
	
	УстановитьОтборВСписках();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокКВыполнениюПаузаПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ОбновитьСтатусЗадачНаКлиенте("Пауза",ПараметрыПеретаскивания.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВРаботеПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ОбновитьСтатусЗадачНаКлиенте("ВРаботе",ПараметрыПеретаскивания.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТестированиеПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ОбновитьСтатусЗадачНаКлиенте("Тестирование",ПараметрыПеретаскивания.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗавершеноПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ОбновитьСтатусЗадачНаКлиенте("Завершено",ПараметрыПеретаскивания.Значение);
	
КонецПроцедуры                  

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	УстановитьОтборВСписках();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокКВыполнениюПаузаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ОткрытьЗадачуПользователя(Элемент.ТекущаяСтрока,СтандартнаяОбработка);
	
КонецПроцедуры   

&НаКлиенте
Процедура СписокВРаботеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ОткрытьЗадачуПользователя(Элемент.ТекущаяСтрока,СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТестированиеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ОткрытьЗадачуПользователя(Элемент.ТекущаяСтрока,СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗавершеноВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ОткрытьЗадачуПользователя(Элемент.ТекущаяСтрока,СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗадачу(Команда)

	ПараметрыФормы = ПолучитьСтруктуруЗаполненияЗадачи();
	ОткрытьФорму("Задача.инкЗадачаПользователя.Форма.ФормаЗадачи",ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры  

&НаКлиенте
Процедура СброситьНастройкиФормы(Команда)
	
	СброситьНастройкиФормыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СброситьНастройкиФормыНаСервере()
	
	//ХранилищеСистемныхНастроек.Удалить("Обработка.инкДоскаЗадачПользователей.Форма.Форма/НастройкиФормы",, ИмяПользователя());
	
КонецПроцедуры 	

&НаКлиенте
Процедура ОбновитьФорму(Команда)
	ОповеститьОбИзменении(Тип("ЗадачаСсылка.инкЗадачаПользователя"));
КонецПроцедуры

&НаКлиенте
Процедура СписокВсехЗадач(Команда)
	
	ОткрытьФорму("Справочник.инкЗадачаПользователяИерархия.Форма.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура БыстраяЗаметка(Команда)
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Найти("ГруппаБыстрыеЗаметки");	
	ПараметрыФормы = ПолучитьСтруктуруЗаполненияЗадачи();
	ОткрытьФорму("Задача.инкЗадачаПользователя.Форма.ФормаБыстраяЗаметка",ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.Независимый);

КонецПроцедуры   

&НаКлиенте
Процедура СписокБыстрыеЗаметкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;                                          
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ",ВыбраннаяСтрока);
	
	ОткрытьФорму("Задача.инкЗадачаПользователя.Форма.ФормаБыстраяЗаметка",ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.Независимый);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОплатаПоЗадачам(Команда)
	
	ОткрытьФорму("Отчет.инкОплатаПоЗадачам.Форма");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьКолонокКАНБАННаФорме()

	Элементы.ГруппаБыстрыеЗаметки.Видимость = мВидимостьСписокБыстрыеЗаметки;
	Элементы.ГруппаКВыполнениюПауза.Видимость = мВидимостьКВыполнениюПауза;
	Элементы.ГруппаВРаботе.Видимость = мВидимостьВРаботе;
	Элементы.ГруппаТестирование.Видимость = мВидимостьТестирование;
	Элементы.ГруппаЗавершено.Видимость = мВидимостьЗавершено;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьСтруктуруЗаполненияЗадачи()

	СтруктураЗаполненияЗадачи = Новый Структура;   
	
	Если Проекты.Количество() = 1 Тогда
		СтруктураЗаполненияЗадачи.Вставить("Проект",Проекты[0].Значение);
	КонецЕсли;
	Если Исполнители.Количество() = 1 Тогда
		СтруктураЗаполненияЗадачи.Вставить("Исполнитель",Исполнители[0].Значение);
	КонецЕсли;                   
	
	Возврат СтруктураЗаполненияЗадачи;

КонецФункции

&НаКлиенте
Процедура УстановитьОтборВСписках()

	УстановитьОтоборПоПроектуВСпике("СписокКВыполнениюПауза",Проекты);
	УстановитьОтоборПоПроектуВСпике("СписокВРаботе",Проекты);
	УстановитьОтоборПоПроектуВСпике("СписокТестирование",Проекты);
	УстановитьОтоборПоПроектуВСпике("СписокЗавершено",Проекты);
	//
	УстановитьОтоборПоИсполнителюВСпике("СписокКВыполнениюПауза",Исполнители);
	УстановитьОтоборПоИсполнителюВСпике("СписокВРаботе",Исполнители);
	УстановитьОтоборПоИсполнителюВСпике("СписокТестирование",Исполнители);
	УстановитьОтоборПоИсполнителюВСпике("СписокЗавершено",Исполнители);
	//          

КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтоборПоПроектуВСпике(ИмяСписка,ПроектСписок)
	
	ПользовательскийОтбор = ЭтотОбъект[ИмяСписка].КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ЭтотОбъект[ИмяСписка].КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки);
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных("Проект");
	
	ЭлементОтбораПользовательский = Неопределено;
	Для каждого ЭлементОтбора Из ПользовательскийОтбор.Элементы Цикл
		
		Если ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки Тогда
			ЭлементОтбораПользовательский = ЭлементОтбора; 		
		КонецЕсли;
		
	КонецЦикла;                              
	
	Если ЭлементОтбораПользовательский = Неопределено Тогда
		ЭлементОтбораПользовательский =  ПользовательскийОтбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораПользовательский.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор();
	
	КонецЕсли;
	
	ЭлементОтбораПользовательский.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбораПользовательский.ЛевоеЗначение = ПолеКомпоновки;
	ЭлементОтбораПользовательский.ПравоеЗначение = ПроектСписок;
	ЭлементОтбораПользовательский.Использование = ЗначениеЗаполнено(ПроектСписок);                            
	ЭлементОтбораПользовательский.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтоборПоИсполнителюВСпике(ИмяСписка,ИсполнительСписок)
	
	ПользовательскийОтбор = ЭтотОбъект[ИмяСписка].КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ЭтотОбъект[ИмяСписка].КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки);
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных("Исполнитель");
	
	ЭлементОтбораПользовательский = Неопределено;
	Для каждого ЭлементОтбора Из ПользовательскийОтбор.Элементы Цикл
		
		Если ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки Тогда
			ЭлементОтбораПользовательский = ЭлементОтбора; 		
		КонецЕсли;
		
	КонецЦикла;                              
	
	Если ЭлементОтбораПользовательский = Неопределено Тогда
		ЭлементОтбораПользовательский =  ПользовательскийОтбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораПользовательский.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор();
	
	КонецЕсли;
	
	ЭлементОтбораПользовательский.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбораПользовательский.ЛевоеЗначение = ПолеКомпоновки;
	ЭлементОтбораПользовательский.ПравоеЗначение = ИсполнительСписок;
	ЭлементОтбораПользовательский.Использование = ЗначениеЗаполнено(ИсполнительСписок);                            
	ЭлементОтбораПользовательский.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусЗадачНаКлиенте(СтатусСтрока,МассивЗадач)

	ОбновитьСтатусЗадачНаСервере(СтатусСтрока,МассивЗадач);
	ОповеститьОбИзменении(Тип("ЗадачаСсылка.инкЗадачаПользователя"));
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьСтатусЗадачНаСервере(СтатусСтрока,МассивЗадач)
	
	Если ТипЗнч(МассивЗадач) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;  
	
	Для каждого ЗадачаСсылка Из МассивЗадач Цикл
		
		УстанановитьСтатус = Перечисления.инкСтатусыЗадач[СтатусСтрока];
		Если ЗадачаСсылка.Статус = УстанановитьСтатус Тогда
			Прервать;
		КонецЕсли;
		
		Попытка
			ЗадачаОбъект = ЗадачаСсылка.ПолучитьОбъект();
			ЗадачаОбъект.Статус = УстанановитьСтатус;
			ЗадачаОбъект.Выполнена = (ЗадачаОбъект.Статус = Перечисления.инкСтатусыЗадач.Завершено);
			ЗадачаОбъект.Записать();
		Исключение
		    инкОбщийКлиентСервер.СообщитьПользователю("Ошибка при записи задачи. Описание: " + ОписаниеОшибки());
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗадачуПользователя(ЗадачаСсылка,СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("Ключ", ЗадачаСсылка);
    ОткрытьФорму("Задача.инкЗадачаПользователя.Форма.ФормаЗадачи", ПараметрыФормы,,Новый УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьПриИзменении(Элемент)
	
	УстановитьВидимостьКолонокКАНБАННаФорме();
	
КонецПроцедуры

#КонецОбласти	  
