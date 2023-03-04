
#Область о // Стандартные процедуры и функции:

Процедура ПередЗаписью(Отказ)
	
	ЗаполнитьЗначениямиПоУмолчанию();
	
	ОбработкаЗакрытияЗадачи();
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ЗадатьНаименованиеДляДоски();
		ОтправитьУведомлениеНаЭлПочуПоИсполнителю();
	КонецЕсли;  
	
	ОтправитьОповещениеОбИзмененииЗадачи();

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если НЕ ЗначениеЗаполнено(НаименованиеДляДоски) Тогда
		Записать();		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область о // Дополнительные процедуры и функции:

Процедура ОбработкаЗакрытияЗадачи()
	
	Если Статус = Перечисления.инкСтатусыЗадач.Завершено Тогда
		
		Если Ссылка.Статус <> Перечисления.инкСтатусыЗадач.Завершено Тогда
			
			КомментарийКЗадаче = Новый ФорматированныйДокумент; 
			КомментарийКЗадаче.Добавить("Задача закрыта.");
			
			ДиалогКЗадачеСтрока 			= ДиалогиКЗадачеТаблица.Добавить();
			ДиалогКЗадачеСтрока.Дата		= ТекущаяДата();	
			ДиалогКЗадачеСтрока.Автор       = Пользователи.ТекущийПользователь();
			ДиалогКЗадачеСтрока.СообщениеДиалога = Новый ХранилищеЗначения(КомментарийКЗадаче, Новый СжатиеДанных(9));
			ДиалогКЗадачеСтрока.ИДСообщения = Новый УникальныйИдентификатор;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьЗначениямиПоУмолчанию() Экспорт

	Если НЕ ЗначениеЗаполнено(Автор) Тогда
		Автор = Пользователи.ТекущийПользователь(); 
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Приоритет) Тогда
		Приоритет = Перечисления.инкПриоритетЗадачи.Низкий;
	КонецЕсли;
	
	Если Приоритет = Перечисления.инкПриоритетЗадачи.Высокий Тогда
		ПриоритетНомер = 1;
	ИначеЕсли Приоритет = Перечисления.инкПриоритетЗадачи.Средний Тогда
		ПриоритетНомер = 2;
	Иначе
		ПриоритетНомер = 3;
	КонецЕсли;   
	
	ПриоритетИНомерЗадачи = "№ "+Номер;

	ПрикрепленныеФайлы = ПроверитьПрикрепленныеФайлы();
	
	Если ПрикрепленныеФайлы Тогда
		ПриоритетИНомерЗадачи = "*" + ПриоритетИНомерЗадачи;	
	КонецЕсли;
	
КонецПроцедуры  

Функция ПроверитьПрикрепленныеФайлы()
	
	ПрикрепленныеФайлыБулево = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкЗадачаПользователяПрисоединенныеФайлы.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.инкЗадачаПользователяПрисоединенныеФайлы КАК инкЗадачаПользователяПрисоединенныеФайлы
		|ГДЕ
		|	инкЗадачаПользователяПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
		|	И НЕ инкЗадачаПользователяПрисоединенныеФайлы.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ВладелецФайла", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
    ПрикрепленныеФайлыБулево = (РезультатЗапроса.Количество() > 0);
	
	Возврат ПрикрепленныеФайлыБулево;
	
КонецФункции

Процедура ЗадатьНаименованиеДляДоски()
	
	ПриоритетСтрока = "";
	Если ЗначениеЗаполнено(Приоритет) Тогда
		ПриоритетСтрока = " Приоритет: "+Приоритет+".";	
	КонецЕсли;
	
	НаименованиеДляДоски = Наименование 
	                     + ПриоритетСтрока
	                     + " " + Номер;		
	
КонецПроцедуры

&НаСервере
Функция ПолучитьХТМЛКодКартинки(СсылкаСтрока) Экспорт
	
	МассивСтрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СсылкаСтрока, ";");	
	НомерСтроки = "";
	ИДКартинки = "";
	Для каждого ЭлементСтрока Из МассивСтрок Цикл
		
		Если СтрНайти(ЭлементСтрока,"НомерСтроки=") > 0 Тогда
			НомерСтроки = Сред(ЭлементСтрока,13,СтрДлина(ЭлементСтрока));
			Продолжить;
		ИначеЕсли СтрНайти(ЭлементСтрока,"Картинка=") > 0 Тогда	
			ИДКартинки = Сред(ЭлементСтрока,10,СтрДлина(ЭлементСтрока));
			Продолжить;
		КонецЕсли;
		
	КонецЦикла;

	Если НомерСтроки = "" ИЛИ ИДКартинки = "" Тогда
		Возврат "";
	КонецЕсли;  
	
	ФорматированныйТекст = ЭтотОбъект.ДиалогиКЗадачеТаблица[НомерСтроки-1].СообщениеДиалога.Получить();
	
	ТекстHTML = "";  
	Вложения = Новый Структура;
	
	ФорматированныйТекст.ПолучитьHTML(ТекстHTML, Вложения);
	
	ХТМЛКодКартинки = "<!DOCTYPE html>
                       |<html dir=""ltr"">
                       |<head>
                       |<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" />
                       |<meta http-equiv=""X-UA-Compatible"" content=""IE=Edge"" />
                       |<meta name=""format-detection"" content=""telephone=no"" />
                       |<style type=""text/css"">
                       |body{margin:0;padding:8px;}
                       |p{line-height:1.15;margin:0;white-space:pre-wrap;}
                       |ol,ul{margin-top:0;margin-bottom:0;}
                       |img{border:none;}
                       |li>p{display:inline;}
                       |</style>
                       |</head>
                       |<body>
                       |<br>
                       |<p><img src=""imageXXX"" style=""border:none;""/></p>
                       |<br>
                       |</body>
                       |</html>
                       |'";
	
	
	ХТМЛКодКартинки	= СтрЗаменить(ХТМЛКодКартинки, 
	            " src=""imageXXX""", 
				" src=""data:image/png;base64, " 
				+ Base64Строка(Вложения[ИДКартинки].ПолучитьДвоичныеДанные()) + """" 
				);                
				
	Возврат ХТМЛКодКартинки;			
	
КонецФункции

#КонецОбласти

#Область о // Отправка уведомления на эл. почту:

Процедура ОтправитьОповещениеОбИзмененииЗадачи()

	Если НЕ Константы.инкОтправкаСообщенийПриИзмененииЗадачи.Получить() Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Исполнитель) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДиалогиКЗадачеТаблица.Количество() <= Ссылка.ДиалогиКЗадачеТаблица.Количество() Тогда
		Возврат;	
	КонецЕсли;	
	
	ПоследнееСообщениеЗадачи = ДиалогиКЗадачеТаблица[ДиалогиКЗадачеТаблица.Количество()-1];
	АвторСообщения = ПоследнееСообщениеЗадачи.Автор;
	
	ПолучателиПисьма = Новый Массив;
	Если АвторСообщения = Исполнитель Тогда
		
		Если АвторСообщения = Автор Тогда
			Возврат;
		Иначе
			ПолучателиПисьма.Добавить(Автор);	
		КонецЕсли;		
		
	ИначеЕсли АвторСообщения = Автор Тогда
		
		Если АвторСообщения = Исполнитель Тогда
			Возврат;
		Иначе
			ПолучателиПисьма.Добавить(Исполнитель);	
		КонецЕсли;		

	Иначе 
		Если Автор = Исполнитель Тогда
			ПолучателиПисьма.Добавить(Автор);
		Иначе
			ПолучателиПисьма.Добавить(Автор);
			ПолучателиПисьма.Добавить(Исполнитель);
		КонецЕсли;
	КонецЕсли;
	
	СодержаниеСообщения = ПоследнееСообщениеЗадачи.СообщениеДиалога.Получить().ПолучитьТекст();
	
	// Тема письма:
	ТемаПисьмаСтрока = "Проект: "+Проект+". Изменена задача: " + НаименованиеДляДоски + ".";
	// Тело письма:
	ТелоПисьмаСтрока = "Добрый день. Изменена задача: " + НаименованиеДляДоски 
					 + "."
					 + Символы.ПС
					 + Символы.ПС
					 + "Проект: "+Проект
					 + Символы.ПС
					 + "Автор: "+Автор
					 + Символы.ПС
					 + "Исполнитель: "+Исполнитель					 
					 + Символы.ПС
					 + Символы.ПС
					 + "Содержание сообщения: "
					 + СодержаниеСообщения
					 ;

	ОтправитьЭлектронноеПисьмо(ПолучателиПисьма, ТелоПисьмаСтрока, ТемаПисьмаСтрока);					 
	
КонецПроцедуры

Процедура ОтправитьУведомлениеНаЭлПочуПоИсполнителю()
	
	Если НЕ Константы.инкВключитьРассылкуОНовыхЗадачах.Получить() Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтправкаПисьмаОНовойЗадаче Тогда
		Возврат;	
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Исполнитель) Тогда
		Возврат;
	КонецЕсли;	
	
	Если Исполнитель = Автор Тогда
		Возврат;	
	КонецЕсли;
	
	// Тема письма:
	ТемаПисьмаСтрока = "Проект: "+Проект+". Добавлена задача: " + НаименованиеДляДоски;
	// Тело письма:
	ТелоПисьмаСтрока = "Добрый день. Добавлена задача: " + НаименованиеДляДоски 
					 + "."
					 + Символы.ПС
					 + Символы.ПС
					 + "Проект: "+Проект
					 + Символы.ПС
					 + "Автор: "+Автор
					 + Символы.ПС
					 + "Исполнитель: "+Исполнитель					 
					 ;
					 
	ПолучателиПисьма = Новый Массив;				 
	ПолучателиПисьма.Добавить(Исполнитель);    
	
	ОтправитьЭлектронноеПисьмо(ПолучателиПисьма, ТелоПисьмаСтрока, ТемаПисьмаСтрока);					 
					 
КонецПроцедуры

Процедура ОтправитьЭлектронноеПисьмо(ПолучателиПисьма, ТелоПисьмаСтрока, ТемаПисьмаСтрока)
	
	АдресЭлектроннойПочты = "";
	Для каждого ПолучательПисьма Из ПолучателиПисьма Цикл
		АдресЭлектроннойПочты = АдресЭлектроннойПочты
		                      + БизнесПроцессыИЗадачиСервер.АдресЭлектроннойПочты(ПолучательПисьма)
							  + "; ";	
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(АдресЭлектроннойПочты) Тогда
		Возврат;
	КонецЕсли;
	
	ТипОповещенияСтрока = "Отправка оповещения по задаче";
	
	Попытка
		ПриведенныйПочтовыйАдрес = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(АдресЭлектроннойПочты);
	Исключение
		ЗаписьЖурналаРегистрации(ТипОповещенияСтрока, 
                                 УровеньЖурналаРегистрации.Ошибка, 
                                 , 
                                 ТекущаяДата(), 
                                 КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	ПараметрыПисьма = Новый Структура;
	Если ЗначениеЗаполнено(ПриведенныйПочтовыйАдрес) Тогда
		ПараметрыПисьма.Вставить("Кому", ПриведенныйПочтовыйАдрес);
	КонецЕсли;

	ПараметрыПисьма.Вставить("Тема", ТемаПисьмаСтрока);
	ПараметрыПисьма.Вставить("Тело", ТелоПисьмаСтрока);
	
	СистемнаяУчетнаяЗаписьЭлектроннойПочты = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
	
	Попытка
		РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(СистемнаяУчетнаяЗаписьЭлектроннойПочты, ПараметрыПисьма);
		
		ТекстОповещения = "Успешно отправлено письмо: "
						+ " получателям: "
						+ ПриведенныйПочтовыйАдрес
						+ " тело письма: "
						+ ТелоПисьмаСтрока;
		
		ЗаписьЖурналаРегистрации(ТипОповещенияСтрока, 
                                 УровеньЖурналаРегистрации.Информация, 
                                 , 
                                 ТекущаяДата(), 
                                 ТекстОповещения);
								 
		ОтправкаПисьмаОНовойЗадаче = Истина;						 
		
	Исключение                 
		
		ИнформацияОбОшибкеСтрока = ИнформацияОбОшибке();
		
		ЗаписьЖурналаРегистрации(ТипОповещенияСтрока, 
                                 УровеньЖурналаРегистрации.Ошибка, 
                                 , 
                                 ТекущаяДата(), 
                                 ИнформацияОбОшибкеСтрока);
	КонецПопытки; 
	
	
КонецПроцедуры

#КонецОбласти 


