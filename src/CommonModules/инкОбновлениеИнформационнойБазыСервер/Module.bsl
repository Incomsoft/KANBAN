			  
#Область о // Обновления базы:

Процедура Обновление_1_0_0_1() Экспорт
	
 	ИмяГруппыИПрофиля = "Задачи (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
    ДобавитьВПрофильРоль("инкСтандартныеНастройкиИнтерфейса",ПрофильГруппДоступа);
	
	Константы.инкСтандартныеНастройкиИнтерфейса.Установить(Истина);	

КонецПроцедуры

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
	Константы.инкВключитьРассылкуОНовыхЗадачах.Установить(Истина);
	Константы.инкПолучатьФайлыКЗадачеПриСозданииКаталога.Установить(Ложь);
	Константы.ЗаголовокСистемы.Установить("Инкомсофт: KANBAN (Доска задач) 1.0");
	
КонецПроцедуры

#КонецОбласти		  
		  
#Область о // Дополнительные процедуры и функции:

Процедура ПерезаписатьВсеЗадачи()

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
		ЗадачаОбъект.ЗаполнитьЗначениямиПоУмолчанию();
		ЗадачаОбъект.Записать();
		
	КонецЦикла;

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