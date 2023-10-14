
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если инкОбщийКлиентСервер.ЕстьСвойство(Параметры,"ДиалогиСтрока") Тогда
		
		мДиалогиКЗадаче = Параметры.ДиалогиСтрока;
		мОригинальныйТестХТМЛ = Параметры.ДиалогиСтрока;
		
	КонецЕсли;    
	
	Элементы.мПроцентОтображенияИзображения.Видимость = Ложь;
	Если инкОбщийКлиентСервер.ЕстьСвойство(Параметры,"КартинкаДиалога") Тогда
		
		мПроцентОтображенияИзображения = 100;
		Элементы.мПроцентОтображенияИзображения.Видимость = Истина;		
				
		УстановитьВидимостьКартинкиВПроцентах();
		
	КонецЕсли;    
	
КонецПроцедуры

&НаКлиенте
Процедура мДиалогиКЗадачеПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	htmlElement = НайтиСсылкуОбъекта(ДанныеСобытия.Element);
    // Анализируем если произошло нажание не ссылку
    Если htmlElement <> Неопределено Тогда
		
        Если СокрЛП(htmlElement.id) <> "" Тогда
			
			Если СтрНайти(htmlElement.id,"image") > 0 Тогда
				
				ОткрытьКартинкуНаКлиенте(htmlElement.id);
				
			КонецЕсли;
			
		КонецЕсли;	  
		
	КонецЕсли;	  			

КонецПроцедуры 

&НаКлиенте
Функция НайтиСсылкуОбъекта(Элемент)  
	
	Попытка
		
		Врем = Элемент;
	    Пока Врем <> Неопределено Цикл
	        Если НРег(Врем.tagName) = "a" Тогда
	            Возврат Врем;
	        КонецЕсли;
	        Врем = Врем.parentElement;
	    КонецЦикла;
		
	Исключение
		Возврат Неопределено;
		//ОписаниеОшибки()
	КонецПопытки;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьКартинкуНаКлиенте(СсылкаСтрока)
	
	ХТМЛКодКартинки = ПолучитьХТМЛКодКартинкиНаСервере(СсылкаСтрока);
	
	Если ХТМЛКодКартинки= "" Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДиалогиСтрока",ХТМЛКодКартинки);   
	ПараметрыФормы.Вставить("КартинкаДиалога",Истина);   
	
	ОткрытьФорму("Задача.инкЗадачаПользователя.Форма.ФормаДиалогиКЗадаче",ПараметрыФормы,ЭтотОбъект,Новый УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры                                                       

&НаСервере
Функция ПолучитьХТМЛКодКартинкиНаСервере(СсылкаСтрока)
	
	ЗадачаОбъект = РеквизитФормыВЗначение("Объект");
	
	Возврат ЗадачаОбъект.ПолучитьХТМЛКодКартинки(СсылкаСтрока);
	
КонецФункции

&НаКлиенте
Процедура мПроцентОтображенияИзображенияПриИзменении(Элемент)
	УстановитьВидимостьКартинкиВПроцентах();
КонецПроцедуры                              

Процедура УстановитьВидимостьКартинкиВПроцентах()
	
	мДиалогиКЗадаче = СтрЗаменить(мОригинальныйТестХТМЛ,"XXX%",Строка(мПроцентОтображенияИзображения)+"%");	
	
КонецПроцедуры

