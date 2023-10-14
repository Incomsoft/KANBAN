///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ПроверкаПрограммВыполнялась;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	ЭлектроннаяПодписьСлужебный.УстановитьУсловноеОформлениеСпискаСертификатов(Сертификаты, Истина);
	
	НавигационнаяСсылка = "e1cib/app/ОбщаяФорма.НастройкиЭлектроннойПодписиИШифрования";
	
	Если Не ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		Элементы.СтраницаНастройки.Видимость = Ложь;
		БезПраваСохранениеДанныхПользователя = Истина;
	КонецЕсли;
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь();
	
	Если Параметры.Свойство("ПоказатьСтраницуСертификаты") Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСертификаты;
		
	ИначеЕсли Параметры.Свойство("ПоказатьСтраницуНастройки") Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаНастройки;
		
	ИначеЕсли Параметры.Свойство("ПоказатьСтраницуПрограммы") Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПрограммы;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		УстановитьПроверкуПодписейНаСервере(Ложь);
		Элементы.ПроверятьПодписиНаСервере.Видимость = Ложь;
		Элементы.ПодписыватьНаСервере.Видимость = Ложь;
	Иначе
		ПроверятьПодписиНаСервере = Константы.ПроверятьЭлектронныеПодписиНаСервере.Получить();
		ПодписыватьНаСервере      = Константы.СоздаватьЭлектронныеПодписиНаСервере.Получить();
	КонецЕсли;
	
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		СертификатыПоказать = "ВсеСертификаты";
	Иначе
		СертификатыПоказать = "МоиСертификаты";
		
		// Страница Программы
		Элементы.Программы.ИзменятьСоставСтрок = Ложь;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ПрограммыДобавить", "Видимость", Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ПрограммыИзменить", "Видимость", Ложь);
		
		Элементы.ПрограммыУстановитьПометкуУдаления.Видимость = Ложь;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ПрограммыКонтекстноеМенюДобавить", "Видимость", Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ПрограммыКонтекстноеМенюИзменить", "Видимость", Ложь);
		
		Элементы.ПрограммыКонтекстноеМенюПрограммыУстановитьПометкуУдаления.Видимость = Ложь;
		Элементы.ПроверятьПодписиНаСервере.Видимость = Ложь;
		Элементы.ПодписыватьНаСервере.Видимость = Ложь;
		Элементы.Программы.Заголовок =
			НСтр("ru = 'Список программ, предусмотренных администратором, которые можно использовать на компьютере'");
	КонецЕсли;
	
	Если Не ЭлектроннаяПодпись.ОбщиеНастройки().ЗаявлениеНаВыпускСертификатаДоступно Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"СертификатыСоздать", "Видимость", Истина);
		
		Элементы.СертификатыДобавить.Видимость           = Ложь;
		Элементы.СертификатыПоказатьЗаявления.Видимость  = Ложь;
		Элементы.Инструкция.Видимость                    = Ложь;
	КонецЕсли;
	
	СертификатыОбновитьОтбор(ЭтотОбъект, Пользователи.ТекущийПользователь());
	
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		// Состав и настройки предусмотренных программ нельзя изменять.
		// Можно изменять только пути к программам на серверах Linux.
		Элементы.Программы.ИзменятьСоставСтрок = Ложь;
		Элементы.ПрограммыУстановитьПометкуУдаления.Доступность = Ложь;
		Элементы.ПрограммыКонтекстноеМенюПрограммыУстановитьПометкуУдаления.Доступность = Ложь;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ПрограммыИзменить", "ТолькоВоВсехДействиях", Ложь);
	Иначе
		Элементы.НадписьНастройкаВЦентральномУзле.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ЭлектроннаяПодписьСлужебный.ТребуетсяПутьКПрограмме(Истина) Тогда
		Элементы.ГруппаПрограммыLinuxПутьКПрограмме.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаВебКлиентРасширениеНеУстановлено.Видимость = ОбщегоНазначения.ЭтоВебКлиент()
		И Параметры.Свойство("РасширениеНеПодключено");
	
	ЗаполнитьПрограммыИНастройки();
	
	ОбновитьТекущуюВидимостьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОпределитьУстановленныеПрограммы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	
	ОпределитьУстановленныеПрограммы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования")
	   И Параметр.Свойство("ЭтоНовый") Тогда
		
		Элементы.Сертификаты.Обновить();
		Элементы.Сертификаты.ТекущаяСтрока = Источник;
		Возврат;
	КонецЕсли;
	
	// При изменении состава или настроек программ.
	Если ВРег(ИмяСобытия) = ВРег("Запись_ПрограммыЭлектроннойПодписиИШифрования")
	 Или ВРег(ИмяСобытия) = ВРег("Запись_ПутиКПрограммамЭлектроннойПодписиИШифрованияНаСерверахLinux")
	 Или ВРег(ИмяСобытия) = ВРег("Запись_ЛичныеНастройкиЭлектроннойПодписиИШифрования") Тогда
		
		ПодключитьОбработчикОжидания("ПриИзмененииСоставаИлиНастроекПрограмм", 0.1, Истина);
		Возврат;
	КонецЕсли;
	
	Если ВРег(ИмяСобытия) = ВРег("Установка_РасширениеРаботыСКриптографией") Тогда
		ОпределитьУстановленныеПрограммы();
		Возврат;
	КонецЕсли;
	
	// При изменении настроек использования.
	Если ВРег(ИмяСобытия) <> ВРег("Запись_НаборКонстант") Тогда
		Возврат;
	КонецЕсли;
	
	Если ВРег(Источник) = ВРег("ИспользоватьЭлектронныеПодписи")
	 Или ВРег(Источник) = ВРег("ИспользоватьШифрование") Тогда
		
		ПодключитьОбработчикОжидания("ПриИзмененияИспользованияПодписанияИлиШифрования", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ПроверкаПрограммВыполнялась <> Истина Тогда
		ОпределитьУстановленныеПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПоказатьПриИзменении(Элемент)
	
	СертификатыОбновитьОтбор(ЭтотОбъект, ПользователиКлиент.ТекущийПользователь());
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПоказатьЗаявленияПриИзменении(Элемент)
	
	СертификатыОбновитьОтбор(ЭтотОбъект, ПользователиКлиент.ТекущийПользователь());
	
КонецПроцедуры

&НаКлиенте
Процедура РасширениеДляЗашифрованныхФайловПриИзменении(Элемент)
	
	Если ПустаяСтрока(РасширениеДляЗашифрованныхФайлов) Тогда
		РасширениеДляЗашифрованныхФайлов = "p7m";
	КонецЕсли;
	
	СохранитьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура РасширениеДляФайловПодписиПриИзменении(Элемент)
	
	Если ПустаяСтрока(РасширениеДляФайловПодписи) Тогда
		РасширениеДляФайловПодписи = "p7s";
	КонецЕсли;
	
	СохранитьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияПриСохраненииДанныхСЭлектроннойПодписьюПриИзменении(Элемент)
	
	СохранитьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверятьПодписиНаСервереПриИзменении(Элемент)
	
	УстановитьПроверкуПодписейНаСервере(ПроверятьПодписиНаСервере);
	
	Оповестить("Запись_НаборКонстант", Новый Структура, "ПроверятьЭлектронныеПодписиНаСервере");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписыватьНаСервереПриИзменении(Элемент)
	
	УстановитьПодписаниеНаСервере(ПодписыватьНаСервере);
	
	Оповестить("Запись_НаборКонстант", Новый Структура, "СоздаватьЭлектронныеПодписиНаСервере");
	
КонецПроцедуры

&НаКлиенте
Процедура СохранятьСертификатВместеСПодписьюПриИзменении(Элемент)
	СохранитьНастройки();
КонецПроцедуры

&НаКлиенте
Процедура ПрограммыLinuxПутьКПрограммеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Программы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьПутьКПрограмме();
	
КонецПроцедуры

&НаКлиенте
Процедура ПрограммыLinuxПутьКПрограммеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Программы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ДанныеВыбора = Неопределено;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура("Программа", ТекущиеДанные.Ссылка);
	Строки = ПутиКПрограммамПоУмолчанию.НайтиСтроки(Отбор);
	Если Строки.Количество() = 0 Тогда
		ДанныеВыбора = Неопределено;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрограммыLinuxПутьКПрограммеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Программы.ТекущиеДанные;
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение)
		Или ТекущиеДанные = Неопределено Тогда
		
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура("Программа", ТекущиеДанные.Ссылка);
	Строки = ПутиКПрограммамПоУмолчанию.НайтиСтроки(Отбор);
	ТекущиеДанные.LinuxПутьКПрограмме = ?(Строки.Количество() = 0, "", Строки[0].Путь);
	
	СохранитьПутьКПрограмме();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСертификаты

&НаКлиенте
Процедура СертификатыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ПараметрыСоздания = Новый Структура;
	
	Если Копирование Тогда
		Если Элементы.Сертификаты.ТекущаяСтрока = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ТекущиеДанные = СертификатыТекущиеДанные(Элементы.Сертификаты);
		ПараметрыСоздания.Вставить("СоздатьЗаявление", Истина);
		ПараметрыСоздания.Вставить("СертификатОснование", ТекущиеДанные.Ссылка);
	Иначе
		ПараметрыСоздания = Новый Структура;
		ПараметрыСоздания.Вставить("СкрытьЗаявление", Ложь);
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебныйКлиент.ДобавитьСертификат(ПараметрыСоздания);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрограммы

&НаКлиенте
Процедура ПрограммыПриАктивизацииСтроки(Элемент)
	
	Элементы.ПрограммыУстановитьПометкуУдаления.Доступность =
		Элементы.Программы.ТекущиеДанные <> Неопределено;
	
	Если Элементы.Программы.ТекущиеДанные <> Неопределено Тогда
		LinuxПутьКТекущейПрограмме = Элементы.Программы.ТекущиеДанные.LinuxПутьКПрограмме;
	КонецЕсли;
	
	ОбновитьLinuxПутьКПрограмме();
	
КонецПроцедуры

&НаКлиенте
Процедура ПрограммыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Если Элементы.Программы.ИзменятьСоставСтрок Тогда
		ОткрытьФорму("Справочник.ПрограммыЭлектроннойПодписиИШифрования.ФормаОбъекта");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрограммыПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	Если Элементы.Найти("ПрограммыИзменить") <> Неопределено
	   И Элементы.ПрограммыИзменить.Видимость Тогда
		
		ПоказатьЗначение(, Элементы.Программы.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрограммыПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	Если Элементы.Найти("ПрограммыИзменить") <> Неопределено
	   И Элементы.ПрограммыИзменить.Видимость Тогда
		
		ПрограммыУстановитьПометкуУдаления(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОткрытьИнструкциюПоРаботеСПрограммами();
	
КонецПроцедуры

&НаКлиенте
Процедура ПрограммыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Программы.ТекущиеДанные;
	Если Поле = Элементы.ПрограммыПодробнее
		И Не ПустаяСтрока(ТекущиеДанные.Подробнее)Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗаголовокПредупреждения", НСтр("ru = 'Результат проверки программы'"));
		ПараметрыФормы.Вставить("ТекстОшибкиКлиент", ТекущиеДанные.РезультатПроверки);
		ПараметрыФормы.Вставить("ПоказатьТребуетсяПомощь", Истина);
		ПараметрыФормы.Вставить("ПоказатьИнструкцию", Истина);
		
		ОткрытьФорму("ОбщаяФорма.РасширенноеПредставлениеОшибки", ПараметрыФормы, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьПрограммыИНастройки(Истина);
	
	ОпределитьУстановленныеПрограммы();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЗаявлениеНаВыпускСертификата(Команда)
	
	ПараметрыСоздания = Новый Структура;
	ПараметрыСоздания.Вставить("СоздатьЗаявление", Истина);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ДобавитьСертификат(ПараметрыСоздания);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзУстановленныхНаКомпьютере(Команда)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ДобавитьСертификат();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширение(Команда)
	
	ЭлектроннаяПодписьКлиент.УстановитьРасширение(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрограммыУстановитьПометкуУдаления(Команда)
	
	ТекущиеДанные = Элементы.Программы.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ПометкаУдаления Тогда
		ТекстВопроса = НСтр("ru = 'Снять с ""%1"" пометку на удаление?'");
	Иначе
		ТекстВопроса = НСтр("ru = 'Пометить ""%1"" на удаление?'");
	КонецЕсли;
	
	СодержимоеВопроса = Новый Массив;
	СодержимоеВопроса.Добавить(БиблиотекаКартинок.Вопрос32);
	СодержимоеВопроса.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, ТекущиеДанные.Наименование));
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ПрограммыУстановитьПометкуУдаленияПродолжить", ЭтотОбъект, ТекущиеДанные.Ссылка),
		Новый ФорматированнаяСтрока(СодержимоеВопроса),
		РежимДиалогаВопрос.ДаНет);
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.ТекстЗапрещеннойЯчейкиЦвет.Значение;
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Программы.Установлена");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("ПрограммыРезультатПроверки");
	ЭлементОформляемогоПоля.Использование = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("ПрограммыНаименование");
	ЭлементОформляемогоПоля.Использование = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СертификатыОбновитьОтбор(Форма, ТекущийПользователь)
	
	Элементы = Форма.Элементы;
	
	// Отбор сертификатов Все/Мои.
	ПоказатьСвои = Форма.СертификатыПоказать <> "ВсеСертификаты";
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Сертификаты, "Пользователь", ТекущийПользователь,,, ПоказатьСвои);
	
	Элементы.СертификатыПользователь.Видимость = Не ПоказатьСвои;
	
	Если Элементы.СертификатыПоказатьЗаявления.Видимость Тогда
		// Отбор сертификатов по состоянию заявления.
		ОтборПоСостояниюЗаявления = ЗначениеЗаполнено(Форма.СертификатыПоказатьЗаявления);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Форма.Сертификаты,
			"СостояниеЗаявления", Форма.СертификатыПоказатьЗаявления, , , ОтборПоСостояниюЗаявления);
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  ТаблицаФормы - ДанныеФормыКоллекция
// 
// Возвращаемое значение:
//  Структура:
//    * Ссылка - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
//
&НаКлиенте
Функция СертификатыТекущиеДанные(ТаблицаФормы)
	
	Возврат ТаблицаФормы.ТекущиеДанные;
	
КонецФункции

&НаКлиенте
Процедура ПрограммыУстановитьПометкуУдаленияПродолжить(Ответ, ТекущаяПрограмма) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ИзменитьПометкуУдаленияПрограммы(ТекущаяПрограмма);
		ОповеститьОбИзменении(ТекущаяПрограмма);
		Оповестить("Запись_ПрограммыЭлектроннойПодписиИШифрования", Новый Структура, ТекущаяПрограмма);
		ОпределитьУстановленныеПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьПометкуУдаленияПрограммы(Программа)
	
	ЗаблокироватьДанныеДляРедактирования(Программа, , УникальныйИдентификатор);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ПрограммыЭлектроннойПодписиИШифрования");
	ЭлементБлокировки.УстановитьЗначение("Ссылка", Программа);
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка.Заблокировать();
		
		Объект = Программа.ПолучитьОбъект();
		Объект.ПометкаУдаления = Не Объект.ПометкаУдаления;
		Объект.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		РазблокироватьДанныеДляРедактирования(Программа, УникальныйИдентификатор);
		ВызватьИсключение;
	КонецПопытки;
	
	РазблокироватьДанныеДляРедактирования(Программа, УникальныйИдентификатор);
	
	ЗаполнитьПрограммыИНастройки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененияИспользованияПодписанияИлиШифрования()
	
	ОбновитьТекущуюВидимостьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТекущуюВидимостьЭлементов()
	
	Если Константы.ИспользоватьШифрование.Получить()
	 Или ЭлектроннаяПодпись.ОбщиеНастройки().ЗаявлениеНаВыпускСертификатаДоступно Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"СертификатыСоздать", "Заголовок", НСтр("ru = 'Добавить...'"));
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"СертификатыКонтекстноеМенюСоздать", "Заголовок", НСтр("ru = 'Добавить...'"));
		
		Элементы.РасширениеДляЗашифрованныхФайлов.Видимость = Истина;
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"СертификатыСоздать", "Заголовок", НСтр("ru = 'Добавить'"));
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"СертификатыКонтекстноеМенюСоздать", "Заголовок", НСтр("ru = 'Добавить'"));
		
		Элементы.РасширениеДляЗашифрованныхФайлов.Видимость = Ложь;
	КонецЕсли;
	
	Если Константы.ИспользоватьШифрование.Получить() Тогда
		Если ЭлектроннаяПодписьСлужебный.ИспользоватьЭлектроннуюПодписьВМоделиСервиса() Тогда
			Элементы.ДобавитьИзУстановленныхНаКомпьютере.Заголовок =
				НСтр("ru = 'Из установленных в облачном сервисе и на компьютере...'");
		Иначе
			Элементы.ДобавитьИзУстановленныхНаКомпьютере.Заголовок =
				НСтр("ru = 'Из установленных на компьютере...'");
		КонецЕсли;
	Иначе
		Если ЭлектроннаяПодписьСлужебный.ИспользоватьЭлектроннуюПодписьВМоделиСервиса() Тогда
			Элементы.ДобавитьИзУстановленныхНаКомпьютере.Заголовок =
				НСтр("ru = 'Из установленных в облачном сервисе и на компьютере'");
		Иначе
			Элементы.ДобавитьИзУстановленныхНаКомпьютере.Заголовок =
				НСтр("ru = 'Из установленных на компьютере'");
		КонецЕсли;
	КонецЕсли;
	
	Если Константы.ИспользоватьЭлектронныеПодписи.Получить() Тогда
		ЗаголовокФлажка = НСтр("ru = 'Проверять подписи и сертификаты на сервере'");
		ПодсказкаФлажка =
			НСтр("ru = 'Позволяет не устанавливать программу на компьютер пользователя
			           |для проверки электронных подписей и сертификатов.
			           |
			           |Важно: на каждый компьютер, где работает сервер 1С:Предприятия
			           |или веб-сервер, подключенный к файловой информационной базе,
			           |должна быть установлена хотя бы одна из программ в списке.'");
		Элементы.РасширениеДляФайловПодписи.Видимость = Истина;
		Элементы.ДействияПриСохраненииДанныхСЭлектроннойПодписью.Видимость = Истина;
	Иначе
		ЗаголовокФлажка = НСтр("ru = 'Проверять сертификаты на сервере'");
		ПодсказкаФлажка =
			НСтр("ru = 'Позволяет не устанавливать программу на компьютер пользователя
			           |для проверки сертификатов.
			           |
			           |Важно: на каждый компьютер, где работает сервер 1С:Предприятия
			           |или веб-сервер, подключенный к файловой информационной базе,
			           |должна быть установлена хотя бы одна из программ в списке.'");
		Элементы.РасширениеДляФайловПодписи.Видимость = Ложь;
		Элементы.ДействияПриСохраненииДанныхСЭлектроннойПодписью.Видимость = Ложь;
	КонецЕсли;
	Элементы.ПроверятьПодписиНаСервере.Заголовок = ЗаголовокФлажка;
	Элементы.ПроверятьПодписиНаСервере.РасширеннаяПодсказка.Заголовок = ПодсказкаФлажка;
	
	Если Не Константы.ИспользоватьЭлектронныеПодписи.Получить() Тогда
		ЗаголовокФлажка = НСтр("ru = 'Шифровать и расшифровывать на сервере'");
		ПодсказкаФлажка =
			НСтр("ru = 'Позволяет не устанавливать программу и сертификат
			           |на компьютер пользователя для шифрования и расшифровки.
			           |
			           |Важно: на каждый компьютер, где работает сервер 1С:Предприятия
			           |или веб-сервер, подключенный к файловой информационной базе,
			           |должна быть установлена программа и сертификат с закрытым ключом.'");
	ИначеЕсли Не Константы.ИспользоватьШифрование.Получить() Тогда
		ЗаголовокФлажка = НСтр("ru = 'Подписывать на сервере'");
		ПодсказкаФлажка =
			НСтр("ru = 'Позволяет не устанавливать программу и сертификат
			           |на компьютер пользователя для подписания.
			           |
			           |Важно: на каждый компьютер, где работает сервер 1С:Предприятия
			           |или веб-сервер, подключенный к файловой информационной базе,
			           |должна быть установлена программа и сертификат с закрытым ключом.'");
	Иначе
		ЗаголовокФлажка = НСтр("ru = 'Подписывать и шифровать на сервере'");
		ПодсказкаФлажка =
			НСтр("ru = 'Позволяет не устанавливать программу и сертификат
			           |на компьютер пользователя для подписания, шифрования и расшифровки.
			           |
			           |Важно: на каждый компьютер, где работает сервер 1С:Предприятия
			           |или веб-сервер, подключенный к файловой информационной базе,
			           |должна быть установлена программа и сертификат с закрытым ключом.'");
	КонецЕсли;
	Элементы.ПодписыватьНаСервере.Заголовок = ЗаголовокФлажка;
	Элементы.ПодписыватьНаСервере.РасширеннаяПодсказка.Заголовок = ПодсказкаФлажка;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьУстановленныеПрограммы()
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПрограммы Тогда
		ПроверкаПрограммВыполнялась = Истина;
		НачатьПодключениеРасширенияРаботыСКриптографией(Новый ОписаниеОповещения(
			"ОпределитьУстановленныеПрограммыПослеПодключенияРасширения", ЭтотОбъект));
	Иначе
		ПроверкаПрограммВыполнялась = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ОпределитьУстановленныеПрограммы.
&НаКлиенте
Процедура ОпределитьУстановленныеПрограммыПослеПодключенияРасширения(Подключено, Контекст) Экспорт
	
	Если Подключено Тогда
		Элементы.СтраницыПрограммыИОбновление.ТекущаяСтраница = Элементы.СтраницаПрограммыОбновление;
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбработчикОжиданияОпределитьУстановленныеПрограммы", 0.3, Истина);
	#Иначе
		ПодключитьОбработчикОжидания("ОбработчикОжиданияОпределитьУстановленныеПрограммы", 0.1, Истина);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияДляПродолжения()
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияОпределитьУстановленныеПрограммы()
	
	НачатьПодключениеРасширенияРаботыСКриптографией(Новый ОписаниеОповещения(
		"ОбработчикОжиданияОпределитьУстановленныеПрограммыПослеПодключенияРасширения", ЭтотОбъект));
	
	#Если ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДляПродолжения", 0.3, Истина);
	#Иначе
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДляПродолжения", 0.1, Истина);
	#КонецЕсли
	
КонецПроцедуры

// Продолжение процедуры ОбработчикОжиданияОпределитьУстановленныеПрограммы.
&НаКлиенте
Процедура ОбработчикОжиданияОпределитьУстановленныеПрограммыПослеПодключенияРасширения(Подключено, Контекст) Экспорт
	
	Если Не Подключено Тогда
		Если Не Элементы.ГруппаВебКлиентРасширениеНеУстановлено.Видимость Тогда
			УстановитьВидимостьГруппаВебКлиентРасширениеНеУстановлено(Истина);
		КонецЕсли;
		ПодключитьОбработчикОжидания("ОбработчикОжиданияОпределитьУстановленныеПрограммы", 3, Истина);
		Возврат;
	КонецЕсли;
	
	Если Элементы.ГруппаВебКлиентРасширениеНеУстановлено.Видимость Тогда
		УстановитьВидимостьГруппаВебКлиентРасширениеНеУстановлено(Ложь);
	КонецЕсли;
	
	ПутиКПрограммамПоУмолчанию.Очистить();
	
	Контекст = Новый Структура;
	Контекст.Вставить("Индекс", -1);
	
	ОбработчикОжиданияОпределитьУстановленныеПрограммыЦиклНачало(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ОбработчикОжиданияОпределитьУстановленныеПрограммы.
&НаКлиенте
Процедура ОбработчикОжиданияОпределитьУстановленныеПрограммыЦиклНачало(Контекст)
	
	Если Программы.Количество() <= Контекст.Индекс + 1 Тогда
		// После цикла.
		Элементы.СтраницыПрограммыИОбновление.ТекущаяСтраница = Элементы.СтраницаПрограммыСписок;
		ТекущийЭлемент = Элементы.Программы;
		ОбновитьLinuxПутьКПрограмме();
		Возврат;
	КонецЕсли;
	Контекст.Индекс = Контекст.Индекс + 1;
	ОписаниеПрограммы = Программы.Получить(Контекст.Индекс);
	
	Контекст.Вставить("ОписаниеПрограммы", ОписаниеПрограммы);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьПутьКПрограммеПоУмолчанию(Новый ОписаниеОповещения(
		"ОбработчикОжиданияОпределитьУстановленныеПрограммыЦиклПослеПолученияПутиКПрограмме", ЭтотОбъект, Контекст),
		ОписаниеПрограммы.Ссылка);
	
КонецПроцедуры

// Продолжение процедуры ОбработчикОжиданияОпределитьУстановленныеПрограммы.
&НаКлиенте
Процедура ОбработчикОжиданияОпределитьУстановленныеПрограммыЦиклПослеПолученияПутиКПрограмме(ОписаниеПути, Контекст) Экспорт
	
	ОписаниеПрограммы = Контекст.ОписаниеПрограммы;
	
	Если ЗначениеЗаполнено(ОписаниеПути.ПутьКПрограмме) Тогда
		НоваяСтрока = ПутиКПрограммамПоУмолчанию.Добавить();
		НоваяСтрока.Программа = ОписаниеПрограммы.Ссылка;
		НоваяСтрока.Путь = ОписаниеПути.ПутьКПрограмме;
	КонецЕсли;
	
	Если ОписаниеПрограммы.ПометкаУдаления Тогда
		ОбновитьЗначение(ОписаниеПрограммы.РезультатПроверки, "");
		ОбновитьЗначение(ОписаниеПрограммы.Подробнее, "");
		ОбновитьЗначение(ОписаниеПрограммы.Установлена, "");
		ОбработчикОжиданияОпределитьУстановленныеПрограммыЦиклНачало(Контекст);
		Возврат;
	ИначеЕсли ОписаниеПрограммы.ЭтоПрограммаОблачногоСервиса Тогда
		ОбновитьЗначение(ОписаниеПрограммы.РезультатПроверки, НСтр("ru = 'Доступен.'"));
		ОбновитьЗначение(ОписаниеПрограммы.Установлена, Истина);
		ОбработчикОжиданияОпределитьУстановленныеПрограммыЦиклНачало(Контекст);
		Возврат;
	КонецЕсли;
	
	ОписанияПрограмм = Новый Массив;
	ОписанияПрограмм.Добавить(Контекст.ОписаниеПрограммы);
	
	ОписаниеОшибок = ЭлектроннаяПодписьСлужебныйКлиентСервер.НовоеОписаниеОшибок();
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("ОписанияПрограмм",  ОписанияПрограмм);
	ПараметрыВыполнения.Вставить("Индекс",            -1);
	ПараметрыВыполнения.Вставить("ПоказатьОшибку",    Неопределено);
	ПараметрыВыполнения.Вставить("ОписаниеОшибок",    ОписаниеОшибок);
	ПараметрыВыполнения.Вставить("АлгоритмПодписи",   "");
	ПараметрыВыполнения.Вставить("ИнтерактивныйРежим", Ложь);
	ПараметрыВыполнения.Вставить("ЭтоLinux",   ЭлектроннаяПодписьСлужебныйКлиент.ТребуетсяПутьКПрограмме());
	ПараметрыВыполнения.Вставить("Менеджер",   Неопределено);
	ПараметрыВыполнения.Вставить("Оповещение", Новый ОписаниеОповещения(
		"ОбработчикОжиданияОпределитьУстановленныеПрограммыЦиклПродолжение", ЭтотОбъект, Контекст));
	
	Контекст.Вставить("ПараметрыВыполнения", Новый Структура("ОписаниеОшибок", ОписаниеОшибок));
	
	ЭлектроннаяПодписьСлужебныйКлиент.СоздатьМенеджерКриптографииЦиклНачало(ПараметрыВыполнения);
	
КонецПроцедуры

// Продолжение процедуры ОбработчикОжиданияОпределитьУстановленныеПрограммы.
&НаКлиенте
Процедура ОбработчикОжиданияОпределитьУстановленныеПрограммыЦиклПродолжение(Менеджер, Контекст) Экспорт
	
	ОписаниеПрограммы = Контекст.ОписаниеПрограммы;
	Ошибки = Контекст.ПараметрыВыполнения.ОписаниеОшибок.Ошибки; // Массив Из см. ЭлектроннаяПодписьСлужебныйКлиентСервер.НовыеСвойстваОшибки
	
	Если Менеджер <> Неопределено Тогда
		ОбновитьЗначение(ОписаниеПрограммы.РезультатПроверки, НСтр("ru = 'Установлена на компьютере.'"));
		ОбновитьЗначение(ОписаниеПрограммы.Подробнее, "");
		ОбновитьЗначение(ОписаниеПрограммы.Установлена, Истина);
		ОбработчикОжиданияОпределитьУстановленныеПрограммыЦиклНачало(Контекст);
		Возврат;
	КонецЕсли;
	
	Для каждого Ошибка Из Ошибки Цикл
		Прервать;
	КонецЦикла;
	
	Если Ошибка.НеУказанПуть Тогда
		ОбновитьЗначение(ОписаниеПрограммы.РезультатПроверки, Ошибка.Описание);
		ОбновитьЗначение(ОписаниеПрограммы.Подробнее, НСтр("ru = 'Подробнее'") + "...");
		ОбновитьЗначение(ОписаниеПрограммы.Установлена, "");
	Иначе
		ТекстОшибки = НСтр("ru = 'Не установлена на компьютере.'") + " " + Ошибка.Описание;
		Если Ошибка.КАдминистратору И Не ЭтоПолноправныйПользователь Тогда
			ТекстОшибки = ТекстОшибки + " " + НСтр("ru = 'Обратитесь к администратору.'");
		КонецЕсли;
		ОбновитьЗначение(ОписаниеПрограммы.РезультатПроверки, ТекстОшибки);
		ОбновитьЗначение(ОписаниеПрограммы.Подробнее, НСтр("ru = 'Подробнее'") + "...");
		ОбновитьЗначение(ОписаниеПрограммы.Установлена, Ложь);
	КонецЕсли;
	
	ОбработчикОжиданияОпределитьУстановленныеПрограммыЦиклНачало(Контекст);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьLinuxПутьКПрограмме()
	
	ТекущиеДанные = Элементы.Программы.ТекущиеДанные;
	
	ПутьПоУмолчанию = "";
	Если ТекущиеДанные <> Неопределено Тогда
		Отбор = Новый Структура("Программа", ТекущиеДанные.Ссылка);
		Строки = ПутиКПрограммамПоУмолчанию.НайтиСтроки(Отбор);
		Если Строки.Количество() > 0 Тогда
			ПутьПоУмолчанию = Строки[0].Путь;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ПрограммыLinuxПутьКПрограмме.КнопкаВыпадающегоСписка = ЗначениеЗаполнено(ПутьПоУмолчанию);
	Элементы.ПрограммыLinuxПутьКПрограмме.ПодсказкаВвода = ПутьПоУмолчанию;
	
	СписокВыбораПутей = Элементы.ПрограммыLinuxПутьКПрограмме.СписокВыбора;
	СписокВыбораПутей.Очистить();
	Если ЗначениеЗаполнено(ПутьПоУмолчанию) Тогда
		Если ОбщегоНазначенияКлиент.ЭтоLinuxКлиент() Тогда
			СписокВыбораПутей.Добавить("ПутьLinux", НСтр("ru = 'Стандартный путь для Linux'"));
		Иначе
			СписокВыбораПутей.Добавить("ПутьMac", НСтр("ru = 'Стандартный путь для Mac OS'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьГруппаВебКлиентРасширениеНеУстановлено(Знач ВидимостьЭлемента)
	
	Элементы.ГруппаВебКлиентРасширениеНеУстановлено.Видимость = ВидимостьЭлемента;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСоставаИлиНастроекПрограмм()
	
	ЗаполнитьПрограммыИНастройки();
	
	ОпределитьУстановленныеПрограммы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПрограммыИНастройки(ОбновитьПовтИсп = Ложь)
	
	Элементы.Сертификаты.Обновить();
	
	Если ОбновитьПовтИсп Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	ПерсональныеНастройки = ЭлектроннаяПодпись.ПерсональныеНастройки();
	
	ДействияПриСохраненииСЭП                   = ПерсональныеНастройки.ДействияПриСохраненииСЭП;
	РасширениеДляЗашифрованныхФайлов           = ПерсональныеНастройки.РасширениеДляЗашифрованныхФайлов;
	РасширениеДляФайловПодписи                 = ПерсональныеНастройки.РасширениеДляФайловПодписи;
	ПутиКПрограммам                            = ПерсональныеНастройки.ПутиКПрограммамЭлектроннойПодписиИШифрования;
	СохранятьСертификатВместеСПодписью         = ПерсональныеНастройки.СохранятьСертификатВместеСПодписью;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Программы.Ссылка,
	|	Программы.Наименование КАК Наименование,
	|	Программы.ИмяПрограммы,
	|	Программы.ТипПрограммы,
	|	Программы.АлгоритмПодписи,
	|	Программы.АлгоритмХеширования,
	|	Программы.АлгоритмШифрования,
	|	Программы.ПометкаУдаления КАК ПометкаУдаления,
	|	Программы.ЭтоПрограммаОблачногоСервиса
	|ИЗ
	|	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК Программы
	|ГДЕ
	|	НЕ Программы.ЭтоПрограммаОблачногоСервиса
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Программы.Ссылка,
	|	Программы.Наименование,
	|	Программы.ИмяПрограммы,
	|	Программы.ТипПрограммы,
	|	Программы.АлгоритмПодписи,
	|	Программы.АлгоритмХеширования,
	|	Программы.АлгоритмШифрования,
	|	Программы.ПометкаУдаления,
	|	Программы.ЭтоПрограммаОблачногоСервиса
	|ИЗ
	|	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК Программы
	|ГДЕ
	|	Программы.ЭтоПрограммаОблачногоСервиса
	|	И &ИспользоватьЭлектроннуюПодписьВМоделиСервиса
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
	Запрос.УстановитьПараметр("ИспользоватьЭлектроннуюПодписьВМоделиСервиса", 
		ЭлектроннаяПодписьСлужебный.ИспользоватьЭлектроннуюПодписьВМоделиСервиса());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ОбработанныеСтроки = Новый Соответствие;
	Индекс = 0;
	
	Пока Выборка.Следующий() Цикл
		Если Не Пользователи.ЭтоПолноправныйПользователь() И Выборка.ПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		Строки = Программы.НайтиСтроки(Новый Структура("Ссылка", Выборка.Ссылка));
		Если Строки.Количество() = 0 Тогда
			Если Программы.Количество()-1 < Индекс Тогда
				Строка = Программы.Добавить();
			Иначе
				Строка = Программы.Вставить(Индекс);
			КонецЕсли;
		Иначе
			Строка = Строки[0];
			ИндексСтроки = Программы.Индекс(Строка);
			Если ИндексСтроки <> Индекс Тогда
				Программы.Сдвинуть(ИндексСтроки, Индекс - ИндексСтроки);
			КонецЕсли;
		КонецЕсли;
		// Обновление только измененных значений, чтобы таблица формы не обновлялась лишний раз.
		ОбновитьЗначение(Строка.Ссылка,              Выборка.Ссылка);
		ОбновитьЗначение(Строка.ПометкаУдаления,     Выборка.ПометкаУдаления);
		ОбновитьЗначение(Строка.Наименование,        Выборка.Наименование);
		ОбновитьЗначение(Строка.ИмяПрограммы,        Выборка.ИмяПрограммы);
		ОбновитьЗначение(Строка.ТипПрограммы,        Выборка.ТипПрограммы);
		ОбновитьЗначение(Строка.АлгоритмПодписи,     Выборка.АлгоритмПодписи);
		ОбновитьЗначение(Строка.АлгоритмХеширования, Выборка.АлгоритмХеширования);
		ОбновитьЗначение(Строка.АлгоритмШифрования,  Выборка.АлгоритмШифрования);
		ОбновитьЗначение(Строка.LinuxПутьКПрограмме, ПутиКПрограммам.Получить(Выборка.Ссылка));
		ОбновитьЗначение(Строка.НомерКартинки,       ?(Выборка.ПометкаУдаления, 4, 3));
		ОбновитьЗначение(Строка.ЭтоПрограммаОблачногоСервиса, Выборка.ЭтоПрограммаОблачногоСервиса);
		Если Строка.ЭтоПрограммаОблачногоСервиса И Не Строка.ПометкаУдаления Тогда
			ОбновитьЗначение(Строка.РезультатПроверки, НСтр("ru = 'Доступен.'"));
			ОбновитьЗначение(Строка.Установлена, Истина);
		КонецЕсли;
		
		ОбработанныеСтроки.Вставить(Строка, Истина);
		Индекс = Индекс + 1;
	КонецЦикла;
	
	Индекс = Программы.Количество()-1;
	Пока Индекс >=0 Цикл
		Строка = Программы.Получить(Индекс);
		Если ОбработанныеСтроки.Получить(Строка) = Неопределено Тогда
			Программы.Удалить(Индекс);
		КонецЕсли;
		Индекс = Индекс-1;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗначение(СтароеЗначение, НовоеЗначение)
	
	Если СтароеЗначение <> НовоеЗначение Тогда
		СтароеЗначение = НовоеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки()
	
	СохраняемыеНастройки = Новый Структура;
	СохраняемыеНастройки.Вставить("ДействияПриСохраненииСЭП",                   ДействияПриСохраненииСЭП);
	СохраняемыеНастройки.Вставить("РасширениеДляЗашифрованныхФайлов",           РасширениеДляЗашифрованныхФайлов);
	СохраняемыеНастройки.Вставить("РасширениеДляФайловПодписи",                 РасширениеДляФайловПодписи);
	СохраняемыеНастройки.Вставить("СохранятьСертификатВместеСПодписью",         СохранятьСертификатВместеСПодписью);
	СохранитьНастройкиНаСервере(СохраняемыеНастройки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиНаСервере(СохраняемыеНастройки)
	
	ПерсональныеНастройки = ЭлектроннаяПодпись.ПерсональныеНастройки();
	ЗаполнитьЗначенияСвойств(ПерсональныеНастройки, СохраняемыеНастройки);
	ЭлектроннаяПодписьСлужебный.СохранитьПерсональныеНастройки(ПерсональныеНастройки);
	
	// Требуется для обновления персональных настроек на клиенте.
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьПутьLinuxНаСервере(Программа, ПутьLinux)
	
	ПерсональныеНастройки = ЭлектроннаяПодпись.ПерсональныеНастройки();
	ПерсональныеНастройки.ПутиКПрограммамЭлектроннойПодписиИШифрования.Вставить(Программа, ПутьLinux);
	ЭлектроннаяПодписьСлужебный.СохранитьПерсональныеНастройки(ПерсональныеНастройки);
	
	// Требуется для обновления персональных настроек на клиенте.
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьПроверкуПодписейНаСервере(ПроверятьПодписиНаСервере)
	
	Если Не ПравоДоступа("Изменение", Метаданные.Константы.ПроверятьЭлектронныеПодписиНаСервере)
	 Или Константы.ПроверятьЭлектронныеПодписиНаСервере.Получить() = ПроверятьПодписиНаСервере Тогда
		
		Возврат;
	КонецЕсли;
	
	Константы.ПроверятьЭлектронныеПодписиНаСервере.Установить(ПроверятьПодписиНаСервере);
	
	// Требуется для обновления общих настроек на сервере и на клиенте.
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьПодписаниеНаСервере(ПодписыватьНаСервере)
	
	Если Не ПравоДоступа("Изменение", Метаданные.Константы.СоздаватьЭлектронныеПодписиНаСервере)
	 Или Константы.СоздаватьЭлектронныеПодписиНаСервере.Получить() = ПодписыватьНаСервере Тогда
		
		Возврат;
	КонецЕсли;
	
	Константы.СоздаватьЭлектронныеПодписиНаСервере.Установить(ПодписыватьНаСервере);
	
	// Требуется для обновления общих настроек на сервере и на клиенте.
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПутьКПрограмме()
	
	ТекущиеДанные = Элементы.Программы.ТекущиеДанные;
	Если БезПраваСохранениеДанныхПользователя Тогда
		ТекущиеДанные.LinuxПутьКПрограмме = LinuxПутьКТекущейПрограмме;
		ПоказатьПредупреждение(,
			НСтр("ru = 'Невозможно сохранить путь к программе. Отсутствует право сохранения данных.
			           |Обратитесь к администратору.'"));
	Иначе
		СохранитьПутьLinuxНаСервере(ТекущиеДанные.Ссылка, ТекущиеДанные.LinuxПутьКПрограмме);
		ОпределитьУстановленныеПрограммы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
