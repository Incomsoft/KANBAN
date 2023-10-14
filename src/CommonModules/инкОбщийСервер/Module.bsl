	  
// Процедура - Отправка сообщений об изменении в задачах:
//
Процедура ОтправкаСообщений() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкЗадачаПользователяДиалогиКЗадачеТаблица.Ссылка КАК Ссылка
		|ИЗ
		|	Задача.инкЗадачаПользователя.ДиалогиКЗадачеТаблица КАК инкЗадачаПользователяДиалогиКЗадачеТаблица
		|ГДЕ
		|	НЕ инкЗадачаПользователяДиалогиКЗадачеТаблица.РассылкаВыполнена
		|
		|СГРУППИРОВАТЬ ПО
		|	инкЗадачаПользователяДиалогиКЗадачеТаблица.Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ЗадачаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		ЗадачаОбъект.ОтправитьОповещениеОбИзмененииЗадачи();
		
	КонецЦикла;

КонецПроцедуры
	  
// Процедура - Установить стандартные настройки интерфейса программы на сервере
//
Процедура УстановитьСтандартныеНастройкиИнтерфейсаПрограммыНаСервере() Экспорт
	
	Если Константы.инкСтандартныеНастройкиИнтерфейса.Получить() Тогда
		
		НастройкиИнтерфейса = Новый НастройкиИнтерфейсаКлиентскогоПриложения;
		НастройкиСостава = НастройкиИнтерфейса.ПолучитьСостав();
		
		// Очистить настройки состава.
		НастройкиСостава.Верх.Очистить();
		НастройкиСостава.Лево.Очистить();
		НастройкиСостава.Низ.Очистить();
		НастройкиСостава.Право.Очистить();

		ПанельРазделов = Новый ЭлементНастройкиСоставаИнтерфейсаКлиентскогоПриложения("ПанельРазделов");
		ПанельОткрытых = Новый ЭлементНастройкиСоставаИнтерфейсаКлиентскогоПриложения("ПанельОткрытых");

		НастройкиСостава.Верх.Добавить(ПанельОткрытых);
		НастройкиСостава.Лево.Добавить(ПанельРазделов);

		НастройкиИнтерфейса.УстановитьСостав(НастройкиСостава);
		ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиИнтерфейсаКлиентскогоПриложения", , НастройкиИнтерфейса);	
		
	КонецЕсли;
	
КонецПроцедуры

// Функция - Получить данные справочника
//
// Параметры:
//  стрТаблица	 - Строка	 - Имя таблицы в БД;
// 
// Возвращаемое значение:
//   - Таблица значений;
//
Функция ПолучитьДанныеСправочника(стрТаблица) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	фуТаблицаБД.Ссылка КАК Ссылка,
		|	фуТаблицаБД.ПометкаУдаления КАК ПометкаУдаления,
		|	фуТаблицаБД.Код КАК Код,
		|	фуТаблицаБД.Наименование КАК Наименование
		|ИЗ
		|	Справочник.фуТаблицаБД КАК фуТаблицаБД";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"Справочник.фуТаблицаБД","Справочник."+стрТаблица);
	
	тзРезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаТаблица Из тзРезультатЗапроса Цикл
		СтрокаТаблица.Наименование = ВРег(СтрокаТаблица.Наименование);
	КонецЦикла;

	тзРезультатЗапроса.Индексы.Добавить("Наименование");

	Возврат тзРезультатЗапроса; 

КонецФункции

// Процедура - Установить параметр в запросе
//
// Параметры:
//  Запрос			 - Запрос - Запрос в котором устанавливается параметр;
//  ИмяПараметра	 - Строка - Имя параметра;
//  ИсходныеДанные	 - Структура - Значения параметров; 
//
Процедура УстановитьПараметрВЗапросе(ИмяПараметра,СтрокаЗаменыПараметра,ИсходныеДанные,Запрос,СтрокаЗаменыЗначение = "Истина",ИмяПараметраВЗапросе = "") Экспорт
	
	Если ИмяПараметраВЗапросе = "" Тогда
		ИмяПараметраВЗапросе = ИмяПараметра;	
	КонецЕсли;
	
	УстановитьПараметр = Ложь;
	Если инкОбщийКлиентСервер.ЕстьСвойство(ИсходныеДанные,ИмяПараметра) Тогда
		Если ЗначениеЗаполнено(ИсходныеДанные[ИмяПараметра]) Тогда
			УстановитьПараметр = Истина;
		КонецЕсли;	
	КонецЕсли;
	
	Если УстановитьПараметр Тогда
		Запрос.УстановитьПараметр(ИмяПараметраВЗапросе, ИсходныеДанные[ИмяПараметра]);	
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,СтрокаЗаменыПараметра,СтрокаЗаменыЗначение);
	КонецЕсли;

КонецПроцедуры  
  
// Процедура - Записать текст в журнал операций на сервере
//
// Параметры:
//  ТекстСообщения		- Строка - Текст сообщения;                        
//	ИмяСобытия			- Строка - Имя события например имя обработки или сервиса;
//  ПредставлениеСтрока	- Строка - "Информация", "Ошибка", "Предупреждение", "Примечание";
//  
Процедура ЗаписатьТекстВЖурналОперацийНаСервере(ТекстСообщения, ИмяСобытия = "Служебная запись в журнал", ПредставлениеСтрока = "Информация") Экспорт

	СтруктураСобытий = Новый Структура("ИмяСобытия, ПредставлениеУровня, Комментарий,ДатаСобытия");
  	СтруктураСобытий.ИмяСобытия 		 = ИмяСобытия;
	СтруктураСобытий.ПредставлениеУровня = ПредставлениеСтрока;	
	СтруктураСобытий.Комментарий 		 = ТекстСообщения;
	СтруктураСобытий.ДатаСобытия 		 = ТекущаяДата();

	СобытияДляЖурналаРегистрации = Новый СписокЗначений();
	СобытияДляЖурналаРегистрации.Добавить(СтруктураСобытий);

	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СобытияДляЖурналаРегистрации);

КонецПроцедуры

// Процедура - Задать значение по умолчанию
//
// Параметры:
//  РеквизитИмя		 - строка	 - Имя реквезита
//  РеквизитЗначение - переопределяемый	 - Значение реквизита
//  Объект			 - переопределяемый	 - Объект в котором проверяется значение
//
Процедура ЗадатьЗначениеПоУмолчанию(РеквизитИмя,РеквизитЗначение,Объект) Экспорт

	Если Не ЗначениеЗаполнено(Объект[РеквизитИмя]) Тогда
		Объект[РеквизитИмя] = РеквизитЗначение;	
	КонецЕсли;  
	
КонецПроцедуры        
 
// Функция - Получить файл из макета в хранилище 
//
// Параметры:
//  ИмяМакета		 - Строка - Имя общего макета
//  ИмяРасширения	 - Строка - Имя расширения файла 
// 
// Возвращаемое значение:
//   - Строка
//
Функция ПолучитьФайлИзМакетаВХранилищеНаСервере(ИмяМакета,ИмяРасширения) Экспорт
	
    АдресФайла = Неопределено;
    
    Попытка

		ВремФайлМакета = ПолучитьИмяВременногоФайла(ИмяРасширения);
		
		МакетСФайлом = ПолучитьОбщийМакет(ИмяМакета);
        МакетСФайлом.Записать(ВремФайлМакета);
    
        
        АдресФайла = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ВремФайлМакета));

    Исключение
        Сообщить("Ошибка при формировании файла выгрузки. Описание: "+ОписаниеОшибки());
    КонецПопытки; 
    
    Возврат АдресФайла; 	
	
КонецФункции

// Функция - Адрес параметров в хранилище
//
// Параметры:
//  ДанныеСтруктура	 - структура - 
// 
// Возвращаемое значение:
//   - Адрес хранилища
//
Функция АдресПараметровВХранилище(ДанныеСтруктура, УникальныйИдентификатор) Экспорт
	
	Возврат ПоместитьВоВременноеХранилище(ДанныеСтруктура, УникальныйИдентификатор);
	
КонецФункции                                              

// Функция - Возвращает код расчетного периода
//
// Параметры:
//  КвараталЧисло	 - Число	 - Номер квартала
// 
// Возвращаемое значение:
//   - Строка 
//
Функция РасчетныйПериодКод(КвараталЧисло) Экспорт
	
	КодРасчетногоПериода = "";
	
	Если КвараталЧисло = 1 Тогда
		КодРасчетногоПериода = "21";	
	ИначеЕсли КвараталЧисло = 2 Тогда  	
		КодРасчетногоПериода = "31";
	ИначеЕсли КвараталЧисло = 3 Тогда  	
		КодРасчетногоПериода = "33";
	ИначеЕсли КвараталЧисло = 4 Тогда  	
		КодРасчетногоПериода = "34";
	КонецЕсли; 
	
	Возврат КодРасчетногоПериода;
	
КонецФункции
 
// Функция - Квартал по периоду регламентного отчета
//
// Параметры:
//  ПериодРегламентногоОтчета     - перечисление - номер периода
// 
// Возвращаемое значение:
//   - число - номер квартала 
//
Функция КварталПоПериодуРегламентногоОтчета(ПериодРегламентногоОтчета) Экспорт
    
    КварталЧисло = 0;    
    Если ПериодРегламентногоОтчета = Перечисления.инкПериодыРегламентныхОтчетов.ПервыйКвартал Тогда
        КварталЧисло = 1;    
    ИначеЕсли ПериодРегламентногоОтчета = Перечисления.инкПериодыРегламентныхОтчетов.ВторойКвартал Тогда 
    	КварталЧисло = 2;
    ИначеЕсли ПериодРегламентногоОтчета = Перечисления.инкПериодыРегламентныхОтчетов.ТретийКвартал Тогда 
        КварталЧисло = 3;
    ИначеЕсли ПериодРегламентногоОтчета = Перечисления.инкПериодыРегламентныхОтчетов.ЧетвертыйКвартал Тогда 
        КварталЧисло = 4;
    КонецЕсли; 
    
    Возврат КварталЧисло; 
    
КонецФункции  

// Функция - Стандартный период по году и периоду регламентного отчета
//
// Параметры:
//  Год                             -  число    - год
//  ПериодРегламентногоОтчета       -  перечисление -  период года
// 
// Возвращаемое значение:
//   - стандартный период - начало и конец квартала 
//
Функция СтандартныйПериодПоГодуИПериодуРегламентногоОтчета(Год, ПериодРегламентногоОтчета) Экспорт
    
    ПериодКвартала = Новый СтандартныйПериод;
    ГодСтрока = Строка(Формат(Год,"ЧГ=0"));
    
    Если (Год<>0) Тогда
        Если ПериодРегламентногоОтчета = Перечисления.инкПериодыРегламентныхОтчетов.ПервыйКвартал Тогда
            ПериодКвартала.ДатаНачала = Дата(ГодСтрока+"0101000000");	
        ИначеЕсли ПериодРегламентногоОтчета = Перечисления.инкПериодыРегламентныхОтчетов.ВторойКвартал Тогда     
            ПериодКвартала.ДатаНачала = Дата(ГодСтрока+"0104000000");
        ИначеЕсли ПериодРегламентногоОтчета = Перечисления.инкПериодыРегламентныхОтчетов.ТретийКвартал Тогда     
            ПериодКвартала.ДатаНачала = Дата(ГодСтрока+"0107000000");
        ИначеЕсли ПериодРегламентногоОтчета = Перечисления.инкПериодыРегламентныхОтчетов.ЧетвертыйКвартал Тогда     
            ПериодКвартала.ДатаНачала = Дата(ГодСтрока+"0110000000");
        КонецЕсли; 
    КонецЕсли; 
    
    ПериодКвартала.ДатаОкончания = ДобавитьМесяц(ПериодКвартала.ДатаНачала,3)-1;
    
    Возврат ПериодКвартала; 
    
КонецФункции

// Функция - Получить период регламентного отчета по дате
//
// Параметры:
//  Дата - дата     - дата по которой определяется квартал
// 
// Возвращаемое значение:
//   - перечисление
//
Функция ПолучитьПериодРегламентногоОтчетаПоДате(Дата) Экспорт
    
    ПериодРегламентногоОтчета = Перечисления.инкПериодыРегламентныхОтчетов.ПустаяСсылка();
    КварталПоДате = инкОбщийКлиентСервер.КварталПоДате(Дата);
    
    Если КварталПоДате = 1 Тогда
    	ПериодРегламентногоОтчета = Перечисления.инкПериодыРегламентныхОтчетов.ПервыйКвартал;
    ИначеЕсли КварталПоДате = 2 Тогда
        ПериодРегламентногоОтчета = Перечисления.инкПериодыРегламентныхОтчетов.ВторойКвартал;
    ИначеЕсли КварталПоДате = 3 Тогда
        ПериодРегламентногоОтчета = Перечисления.инкПериодыРегламентныхОтчетов.ТретийКвартал;
    ИначеЕсли КварталПоДате = 4 Тогда
        ПериодРегламентногоОтчета = Перечисления.инкПериодыРегламентныхОтчетов.ЧетвертыйКвартал;
    КонецЕсли; 
    
    Возврат ПериодРегламентногоОтчета; 
		
КонецФункции

// Удаляет дубли из массива источника:
// Параметры:
//  МассивПриемник – Массив – массив, который заполняется уникальными значениями
//  МассивИсточник – Массив – массив, из которого подбираются элементы в массив-приемник.
// 
Функция УдалитьДублиИзМассива(МассивИсточник) Экспорт
	
	МассивПриемник = Новый Массив; 
	
    Для Каждого Элемент Из МассивИсточник Цикл
		
		Если МассивПриемник.Найти(Элемент) = Неопределено Тогда
            МассивПриемник.Добавить(Элемент);
        КонецЕсли;
        
    КонецЦикла;
	
	Возврат МассивПриемник; 
	
КонецФункции

// Добавляет признак нового в дополнительные свойства объекта.
Процедура ДобавитьПризнакЭтоНовый(Источник) Экспорт
	
	Источник.ДополнительныеСвойства.Вставить("фмЭтоНовый",Источник.ЭтоНовый());
	
КонецПроцедуры

//Высчитывает разницу в днях между двумя датами
Функция РазницаВДнях(Дата1, Дата2) Экспорт
	Если Дата1 > Дата2 Тогда
        Возврат Окр((Дата1 - Дата2)/86400);
    Иначе
        Возврат Окр((Дата2 - Дата1)/86400);
    КонецЕсли;
КонецФункции

// Функция "расщепляет" строку на подстроки, используя заданный  
//        разделитель. Разделитель может иметь любую длину.  //        Если в качестве разделителя задан пробел, рядом стоящие пробелы  
//        считаются одним разделителем, а ведущие и хвостовые пробелы параметра Стр //        игнорируются. 
//        Например,  //        РазложитьСтрокуВМассивПодстрок(",ку,,,му", ",") возвратит массив значений из пяти элементов,  
//        три из которых - пустые строки, а  //        РазложитьСтрокуВМассивПодстрок(" ку   му", " ") возвратит массив значений из двух элементов 
// //    Параметры:  
//        Стр -             строка, которую необходимо разложить на подстроки.  //                        Параметр передается по значению. 
//        Разделитель -     строка-разделитель, по умолчанию - запятая. // 
// //    Возвращаемое значение: 
//        массив значений, элементы которого - подстроки // 
Функция РазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель = ",") Экспорт
    
    МассивСтрок = Новый Массив();
    Если Разделитель = " " Тогда
        Стр = СокрЛП(Стр);
        Пока 1=1 Цикл
            Поз = Найти(Стр,Разделитель);
            Если Поз=0 Тогда
                МассивСтрок.Добавить(Стр);
                Возврат МассивСтрок;
            КонецЕсли;
            МассивСтрок.Добавить(Лев(Стр,Поз-1));
            Стр = СокрЛ(Сред(Стр,Поз));
        КонецЦикла;
    Иначе
        ДлинаРазделителя = СтрДлина(Разделитель);
        Пока 1=1 Цикл
            Поз = Найти(Стр,Разделитель);
            Если Поз=0 Тогда
                МассивСтрок.Добавить(Стр);
                Возврат МассивСтрок;
            КонецЕсли;
            МассивСтрок.Добавить(Лев(Стр,Поз-1));
            Стр = Сред(Стр,Поз+ДлинаРазделителя);
        КонецЦикла;
    КонецЕсли;
    
КонецФункции// глРазложить

// Выделяет слово из строки:
Функция ВыделитьСлово(ИсходнаяСтрока) Экспорт

    Буфер = СокрЛ(ИсходнаяСтрока);
    ПозицияПослПробела = Найти(Буфер, " ");

    Если ПозицияПослПробела = 0 Тогда
        ИсходнаяСтрока = "";
        Возврат Буфер;
    КонецЕсли;
    
    ВыделенноеСлово = СокрЛП(Лев(Буфер, ПозицияПослПробела));
    ИсходнаяСтрока = Сред(ИсходнаяСтрока, ПозицияПослПробела + 1);
    
    Возврат ВыделенноеСлово;
    
КонецФункции

// Возвращает менеджер объекта по полному имени объекта метаданных.
// Ограничение: не обрабатываются точки маршрутов бизнес-процессов.
//
// Параметры:
//  ПолноеИмя - Строка - полное имя объекта метаданных. Пример: "Справочник.Организации".
//
// Возвращаемое значение:
//  СправочникМенеджер, ДокументМенеджер.
// 
Функция МенеджерОбъектаПоПолномуИмени(ПолноеИмя) Экспорт
	Перем КлассОМ, ИмяОМ, Менеджер;
	
	ЧастиИмени = СтрРазделить(ПолноеИмя, ".");
	
	Если ЧастиИмени.Количество() >= 2 Тогда
		КлассОМ = ЧастиИмени[0];
		ИмяОМ  = ЧастиИмени[1];
	КонецЕсли;
	
	Если      ВРег(КлассОМ) = "ПЛАНОБМЕНА" Тогда
		Менеджер = ПланыОбмена;
		
	ИначеЕсли ВРег(КлассОМ) = "СПРАВОЧНИК" Тогда
		Менеджер = Справочники;
		
	ИначеЕсли ВРег(КлассОМ) = "ДОКУМЕНТ" Тогда
		Менеджер = Документы;
		
	ИначеЕсли ВРег(КлассОМ) = "ЖУРНАЛДОКУМЕНТОВ" Тогда
		Менеджер = ЖурналыДокументов;
		
	ИначеЕсли ВРег(КлассОМ) = "ПЕРЕЧИСЛЕНИЕ" Тогда
		Менеджер = Перечисления;
		
	ИначеЕсли ВРег(КлассОМ) = "ОТЧЕТ" Тогда
		Менеджер = Отчеты;
		
	ИначеЕсли ВРег(КлассОМ) = "ОБРАБОТКА" Тогда
		Менеджер = Обработки;
		
	ИначеЕсли ВРег(КлассОМ) = "ПЛАНВИДОВХАРАКТЕРИСТИК" Тогда
		Менеджер = ПланыВидовХарактеристик;
		
	ИначеЕсли ВРег(КлассОМ) = "ПЛАНСЧЕТОВ" Тогда
		Менеджер = ПланыСчетов;
		
	ИначеЕсли ВРег(КлассОМ) = "ПЛАНВИДОВРАСЧЕТА" Тогда
		Менеджер = ПланыВидовРасчета;
		
	ИначеЕсли ВРег(КлассОМ) = "РЕГИСТРСВЕДЕНИЙ" Тогда
		Менеджер = РегистрыСведений;
		
	ИначеЕсли ВРег(КлассОМ) = "РЕГИСТРНАКОПЛЕНИЯ" Тогда
		Менеджер = РегистрыНакопления;
		
	ИначеЕсли ВРег(КлассОМ) = "РЕГИСТРБУХГАЛТЕРИИ" Тогда
		Менеджер = РегистрыБухгалтерии;
		
	ИначеЕсли ВРег(КлассОМ) = "РЕГИСТРРАСЧЕТА" Тогда
		Если ЧастиИмени.Количество() = 2 Тогда
			// Регистр расчета
			Менеджер = РегистрыРасчета;
		Иначе
			КлассПодчиненногоОМ = ЧастиИмени[2];
			ИмяПодчиненногоОМ = ЧастиИмени[3];
			Если ВРег(КлассПодчиненногоОМ) = "ПЕРЕРАСЧЕТ" Тогда
				// Перерасчет
				Попытка
					Менеджер = РегистрыРасчета[ИмяОМ].Перерасчеты;
					ИмяОм = ИмяПодчиненногоОМ;
				Исключение
					Менеджер = Неопределено;
				КонецПопытки;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ВРег(КлассОМ) = "БИЗНЕСПРОЦЕСС" Тогда
		Менеджер = БизнесПроцессы;
		
	ИначеЕсли ВРег(КлассОМ) = "ЗАДАЧА" Тогда
		Менеджер = Задачи;
		
	ИначеЕсли ВРег(КлассОМ) = "КОНСТАНТА" Тогда
		Менеджер = Константы;
		
	ИначеЕсли ВРег(КлассОМ) = "ПОСЛЕДОВАТЕЛЬНОСТЬ" Тогда
		Менеджер = Последовательности;
	КонецЕсли;
	
	Если Менеджер <> Неопределено Тогда
		Попытка
			Возврат Менеджер[ИмяОМ];
		Исключение
			Менеджер = Неопределено;
		КонецПопытки;
	КонецЕсли;
	
	//ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неизвестный тип объекта метаданных ""%1""'"), ПолноеИмя);
	
КонецФункции

// Проверяет есть ли элемент в массиве
//
//	Параметры:
//		Элемент - Исходный элемент
//		Массив - массив в котором производится поиск
Функция ЭлементВМассиве(Элемент, Массив) Экспорт
	
	булНайден = Ложь;
	Для каждого элМассива из Массив Цикл
		Если Элемент = элМассива Тогда
			булНайден = Истина;
			Прервать;;
		КонецЕсли;		
	КонецЦикла;
	
	Возврат булНайден;
	
КонецФункции

Функция ПреобразоватьТаблицуЗначенийВМассив(тзДанные) Экспорт 
    
    мсДанные = Новый Массив;
        
    // Запишем в массив
    Для Каждого СтрокаТЗ Из тзДанные Цикл
		
		Если СтрокаТЗ.ВыборСтроки Тогда
		
	        стСтрокаТаблицы = Новый Структура;
	        Для Каждого ИмяКолонки Из тзДанные.Колонки Цикл
	            стСтрокаТаблицы.Вставить(ИмяКолонки.Имя, СтрокаТЗ[ИмяКолонки.Имя]);
	        КонецЦикла;
	        
	        мсДанные.Добавить(стСтрокаТаблицы);
			
		КонецЕсли;
			
    КонецЦикла;
    
    Возврат мсДанные;
    
КонецФункции // ПреобразоватьТаблицуЗначенийВМассив()

Функция УстановитьСсылкуНового(обОбъект) Экспорт

	ссОбъект = обОбъект.Ссылка; 
	
	Если Не ЗначениеЗаполнено(ссОбъект) Тогда
		
		// Получаем возможно уже установленную ранее ссылку нового
		ссОбъект = обОбъект.ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(ссОбъект) Тогда
			
			// Если ссылка нового пустая, то запрашиваем ее у менеджера и устанавливаем
			Если ТипЗнч(обОбъект.Ссылка) = Тип("ДокументСсылка.инкНачислениеЗаработнойПлаты") Тогда
				ссОбъект = Документы.инкНачислениеЗаработнойПлаты.ПолучитьСсылку();
			КонецЕсли;
			
			обОбъект.УстановитьСсылкуНового(ссОбъект);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ссОбъект;
	
КонецФункции

//	Определяет внешняя обработка, отчет или нет:
Функция ЭтоВнешняяОбработкаОтчет(Объект) Экспорт
	
	ПолноеИмяМетаданных = Объект.Метаданные().ПолноеИмя();
    Возврат Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных) = Неопределено
	
КонецФункции






	