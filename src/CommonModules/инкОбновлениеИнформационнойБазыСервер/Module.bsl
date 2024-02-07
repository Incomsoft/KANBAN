
#Область ОписаниеПеременных

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

// Процедура - Обновление 1 0 0 11
//
Процедура Обновление_1_0_0_11() Экспорт
	
	ИмяГруппыИПрофиля = "Задачи (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
    ДобавитьВПрофильРоль("инкПолучатьФайлыКЗадачеПриСозданииКаталога",ПрофильГруппДоступа); 
	
КонецПроцедуры

// Процедура - Обновление 1 0 0 9
//
Процедура Обновление_1_0_0_9() Экспорт
	
	ИмяГруппыИПрофиля = "Задачи (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
    ДобавитьВПрофильРоль("инкДиалогиКЗадачамДобавлениеИзменение",ПрофильГруппДоступа); 
	
	ПеренестиДиалогиЗадачВРегистр();
	
КонецПроцедуры

// Процедура - Обновление 1 0 0 8
//
Процедура Обновление_1_0_0_8() Экспорт
	
	ИмяГруппыИПрофиля = "Задачи (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
    ДобавитьВПрофильРоль("инкЦенаЧасаПоПроектуЧтение",ПрофильГруппДоступа); 
	
КонецПроцедуры

// Процедура - Обновление 1 0 0 6
//
Процедура Обновление_1_0_0_6() Экспорт

	// Обновить задание:
	ОтборПоМетаданным = Новый Структура("Метаданные",Метаданные.РегламентныеЗадания.инкОтправкаСообщений);
	ЗаданияМассив = РегламентныеЗадания.ПолучитьРегламентныеЗадания(ОтборПоМетаданным);
	
	Для каждого ЗаданиеЭлемент Из ЗаданияМассив Цикл
		
		РасписаниеВыполненияЗадачи = Новый РасписаниеРегламентногоЗадания;
		РасписаниеВыполненияЗадачи.ПериодПовтораВТечениеДня = 1800;
		РасписаниеВыполненияЗадачи.ПериодПовтораДней = 1;
		
		ЗаданиеЭлемент.Расписание = РасписаниеВыполненияЗадачи;
		
		ЗаданиеЭлемент.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура - Обновление 1 0 0 5
//
Процедура Обновление_1_0_0_5() Экспорт
	
	// Пометить все сообщения как прочитанные:
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкЗадачаПользователя.Ссылка КАК Ссылка
		|ИЗ
		|	Задача.инкЗадачаПользователя КАК инкЗадачаПользователя";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ЗадачаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();  
		ЗадачаОбъект.ПометитьВсеСообщенияКакПрочитанные();
		ЗадачаОбъект.Записать();
		
	КонецЦикла;                               
	
	// Содать регламентное задание:
	ОтборПоМетаданным = Новый Структура("Метаданные",Метаданные.РегламентныеЗадания.инкОтправкаСообщений);
	ЗаданияМассив = РегламентныеЗадания.ПолучитьРегламентныеЗадания(ОтборПоМетаданным);
	
	Если ЗаданияМассив.Количество() = 0 Тогда
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.инкОтправкаСообщений);
		ПараметрыЗадания.Вставить("Использование", Истина);
		ПараметрыЗадания.Вставить("Наименование", "Отправка сообщений (Инкомсофт)");
		ПараметрыЗадания.Вставить("Ключ", Новый УникальныйИдентификатор);
		
		РасписаниеВыполненияЗадачи = Новый РасписаниеРегламентногоЗадания;
		РасписаниеВыполненияЗадачи.ПериодПовтораВТечениеДня = 1800;
		РасписаниеВыполненияЗадачи.ПериодПовтораДней = 1;
		
		ПараметрыЗадания.Вставить("Расписание", РасписаниеВыполненияЗадачи);
		Задание = РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
		
	КонецЕсли; 
	
	ИмяГруппыИПрофиля = "Задачи (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
    ДобавитьВПрофильРоль("инкНаблюдателиПоПроектамДобавлениеИзменение",ПрофильГруппДоступа); 
	
КонецПроцедуры

// Процедура - Обновление 1 0 0 3
//
Процедура Обновление_1_0_0_3() Экспорт
	
	Задачи.инкЗадачаПользователя.ПерезаписатьВсеЗадачи();	
	
КонецПроцедуры

// Процедура - Обновление 1 0 0 2
//
Процедура Обновление_1_0_0_2() Экспорт
	
 	ИмяГруппыИПрофиля = "Задачи (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
    ДобавитьВПрофильРоль("инкОплатаПоЗадачам",ПрофильГруппДоступа); 
	
КонецПроцедуры

// Процедура - Обновление 1 0 0 1
//
Процедура Обновление_1_0_0_1() Экспорт
	
 	ИмяГруппыИПрофиля = "Задачи (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
    ДобавитьВПрофильРоль("инкСтандартныеНастройкиИнтерфейса",ПрофильГруппДоступа);
	
	Константы.инкСтандартныеНастройкиИнтерфейса.Установить(Истина);	

КонецПроцедуры

// Процедура - Обновление 1 0 0 0
//
Процедура Обновление_1_0_0_0() Экспорт
	
	ИмяГруппыИПрофиля = "Задачи (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкЗадачи",ПрофильГруппДоступа); 
	ДобавитьВПрофильРоль("инкЗадачиДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкЗадачиЧтение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкДоскаЗадачПользователей",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкЗадачи",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкЗадачиДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкЗадачаПользователяДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкЗадачаПользователяПрисоединенныеФайлыДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПроектыКЗадачамДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПутиККаталогамЗадачДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВключитьРассылкуОНовыхЗадачахЧтение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкОтправкаСообщенийПриИзмененииЗадачи",ПрофильГруппДоступа);

	ДобавитьВПрофильБазовыеРоли(ПрофильГруппДоступа);

	Константы.инкОтправкаСообщенийПриИзмененииЗадачи.Установить(Истина);
	Константы.инкПолучатьФайлыКЗадачеПриСозданииКаталога.Установить(Ложь);
	Константы.ЗаголовокСистемы.Установить("Инкомсофт: KANBAN (Доска задач) 1.0");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий
// Код процедур и функций
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПеренестиДиалогиЗадачВРегистр()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкЗадачаПользователяДиалогиКЗадачеТаблица.Ссылка КАК ЗадачаПользователя,
		|	инкЗадачаПользователяДиалогиКЗадачеТаблица.Ссылка.Проект КАК Проект,
		|	инкЗадачаПользователяДиалогиКЗадачеТаблица.Автор КАК Автор,
		|	инкЗадачаПользователяДиалогиКЗадачеТаблица.Дата КАК Дата,
		|	инкЗадачаПользователяДиалогиКЗадачеТаблица.ИДСообщения КАК ИДСообщения,
		|	инкЗадачаПользователяДиалогиКЗадачеТаблица.СообщениеДиалога КАК СообщениеДиалога,
		|	инкЗадачаПользователяДиалогиКЗадачеТаблица.РассылкаВыполнена КАК РассылкаВыполнена
		|ИЗ
		|	Задача.инкЗадачаПользователя.ДиалогиКЗадачеТаблицаУдалить КАК инкЗадачаПользователяДиалогиКЗадачеТаблица";
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	НаборЗаписейДиалогиКЗадаче = РегистрыСведений.инкДиалогиКЗадачам.СоздатьНаборЗаписей();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ЗаписьРегистра = НаборЗаписейДиалогиКЗадаче.Добавить();
		ЗаполнитьЗначенияСвойств(ЗаписьРегистра,ВыборкаДетальныеЗаписи);
		
	КонецЦикла;
		
	НаборЗаписейДиалогиКЗадаче.Записать(Истина);
	
КонецПроцедуры

Процедура ДобавитьВПрофильРоль(ИмяРоли,ПрофильГруппДоступа)
	
	РольСсылка = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту("Имя",ИмяРоли);

	Если НЕ ЗначениеЗаполнено(РольСсылка) Тогда
		Возврат;	
	КонецЕсли;
	
	НайденаРольВГруппе = Ложь;
	Для каждого РольСтрока Из ПрофильГруппДоступа.Роли Цикл
		
		Если РольСтрока.Роль = РольСсылка Тогда
			НайденаРольВГруппе = Истина;
			Прервать;
		КонецЕсли;	
		
	КонецЦикла;     
	
	Если НЕ НайденаРольВГруппе Тогда
		
		ПрофильГруппДоступаОбъект = ПрофильГруппДоступа.ПолучитьОбъект();
		РольПрофиляСтрока = ПрофильГруппДоступаОбъект.Роли.Добавить();
		РольПрофиляСтрока.Роль = РольСсылка;
		ПрофильГруппДоступаОбъект.Записать();
		
	КонецЕсли;	
	
КонецПроцедуры

Функция ПолучитьПрофильГруппДоступа(НаименованиеПрофилиГруппДоступа)

	ПрофильГруппДоступаСсылка = Справочники.ПрофилиГруппДоступа.НайтиПоНаименованию(НаименованиеПрофилиГруппДоступа);
	
	Если НЕ ЗначениеЗаполнено(ПрофильГруппДоступаСсылка) Тогда
		ПрофильГруппДоступаОбъект = Справочники.ПрофилиГруппДоступа.СоздатьЭлемент();
	Иначе
		ПрофильГруппДоступаОбъект = ПрофильГруппДоступаСсылка.ПолучитьОбъект();
	КонецЕсли;

	ПрофильГруппДоступаОбъект.Наименование = НаименованиеПрофилиГруппДоступа;  
	НазначениеСтрока = ПрофильГруппДоступаОбъект.Назначение.Добавить();
	ПрофильГруппДоступаОбъект.Записать();
	ПрофильГруппДоступаСсылка = ПрофильГруппДоступаОбъект.Ссылка;	
	
	Возврат ПрофильГруппДоступаСсылка;
	
КонецФункции 

Процедура ДобавитьВПрофильБазовыеРоли(ПрофильГруппДоступа)
	
	ДобавитьВПрофильРоль("БазовыеПраваБСП",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ВыводНаПринтерФайлБуферОбмена",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеАдресныхСведений",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеБанков",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеВариантовОтчетов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеВидовКонтактнойИнформации",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеДополнительныхОтчетовИОбработок",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеДополнительныхРеквизитовИСведений",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеЗаметок",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеКалендарныхГрафиков",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеКурсовВалют",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеЛичныхВариантовОтчетов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеЛичныхШаблоновСообщений",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеНапоминаний",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеЭлектронныхПодписейИШифрование",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЗапускAutomation",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЗапускВебКлиента",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЗапускВнешнегоСоединения",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЗапускМобильногоКлиента",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЗапускТолстогоКлиента",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЗапускТонкогоКлиента",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ИзменениеДополнительныхСведений",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ИзменениеМакетовПечатныхФорм",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ИнтерактивноеОткрытиеВнешнихОтчетовИОбработок",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ИспользованиеУниверсальногоОтчета",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ПросмотрОписанияИзмененийПрограммы",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ПросмотрОтчетаДвиженияДокумента",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ПросмотрСвязанныеДокументы",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("РедактированиеРеквизитовОбъектов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("РедактированиеПечатныхФорм",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("РежимВсеФункции",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("СохранениеДанныхПользователя",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("УдаленныйДоступБазоваяФункциональность",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеВариантовОтчетов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеВерсийОбъектов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеДополнительныхОтчетовИОбработок",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеДополнительныхСведений",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеИнформацииОВерсияхОбъектов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеКурсовВалют",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеРассылокОтчетов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеРезультатовПроверкиУчета",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеУчетныхЗаписейЭлектроннойПочты",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеШаблоновСообщений",ПрофильГруппДоступа);
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

#КонецОбласти
			  
