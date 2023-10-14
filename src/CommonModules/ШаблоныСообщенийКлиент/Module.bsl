///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс


// Открывает окно выбора шаблона для формирования электронного письма или сообщения SMS по шаблону
// для переданного в параметре ПредметСообщения предмета.
//
// Параметры:
//  ПредметСообщения            - ОпределяемыйТип.ПредметШаблонаСообщения
//                              - Строка - объект-источник данных, выводимых в сообщение.
//                                Для общих шаблонов необходимо  передавать значение "Общий".
//                                Для передачи предмета сообщения строкой необходимо указывать полное имя метаданных.
//                                Например, "Справочник.Контрагенты".
//  ВидСообщения                - Строка - "Письмо" для электронного письма и "СообщениеSMS" для сообщений SMS.
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - оповещение, которое вызывается после формирования сообщения. Содержит:
//     * Результат - Булево - если Истина, то сообщение было создано.
//     * ПараметрыСообщения - Структура
//                          - Неопределено - значение, которое было передано в параметре ПараметрыСообщения. 
//  ВладелецШаблона             - ОпределяемыйТип.ВладелецШаблона - владелец шаблонов. Если не указан, то в окне выбора
//                                              шаблона выводятся все доступные шаблоны для указанного предмета ПредметСообщения.
//  ПараметрыСообщения          - Структура -  дополнительная информация для формирования сообщения, 
//                                             которая передается в свойство ПараметрыСообщения параметра ПараметрыШаблона
//                                             процедуры ШаблоныСообщенийПереопределяемый.ПриФормированииСообщения. 
//
Процедура СформироватьСообщение(ПредметСообщения, ВидСообщения, ОписаниеОповещенияОЗакрытии = Неопределено, 
	ВладелецШаблона = Неопределено, ПараметрыСообщения = Неопределено) Экспорт
	
	ПараметрыФормы = ПараметрыФормыСообщения(ПредметСообщения, ВидСообщения, ВладелецШаблона, ПараметрыСообщения);
	ПоказатьФормуСформироватьСообщение(ОписаниеОповещенияОЗакрытии, ПараметрыФормы);
	
КонецПроцедуры

// Открывает форму для выбора шаблона.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - оповещение, которое будет вызвано после выбора шаблона:
//      * Результат - СправочникСсылка.ШаблоныСообщений - выбранный шаблон.
//      * ДополнительныеПараметры - Структура - значение, которое было указано при создании объекта ОписаниеОповещения.
//  ВидСообщения                - Строка - "Письмо" для электронного письма и "СообщениеSMS" для сообщений SMS.
//  ПредметШаблона   - ЛюбаяСсылка
//                   - Строка - ссылка на объект, являющийся предметом, или его полное имя.
//  ВладелецШаблона  - ОпределяемыйТип.ВладелецШаблона - владелец шаблонов. Если не указан, то в окне выбора шаблона
//                                              выводятся все доступные шаблоны для указанного предмета ПредметСообщения.
//
Процедура ВыбратьШаблон(Оповещение, ВидСообщения = "Письмо", ПредметШаблона = Неопределено, ВладелецШаблона = Неопределено) Экспорт
	
	Если ПредметШаблона = Неопределено Тогда
		ПредметШаблона = "Общий";
	КонецЕсли;
	
	ПараметрыФормы = ПараметрыФормыСообщения(ПредметШаблона, ВидСообщения, ВладелецШаблона, Неопределено);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	
	ПоказатьФормуСформироватьСообщение(Оповещение, ПараметрыФормы);
	
КонецПроцедуры

// Показывает форму шаблона сообщения.
//
// Параметры:
//  Значение - СправочникСсылка.ШаблоныСообщений
//           - Структура
//           - ЛюбаяСсылка - если передана ссылка на шаблон сообщения,
 //                    то будет открыт этот шаблон сообщения.
 //                    Если передана структура, то будет открыто окно нового шаблона сообщения заполненного из полей
//                     структуры. Описание полей. см. ШаблоныСообщенийКлиентСервер.ОписаниеПараметровШаблона.
//                     Если ссылка из состава типов ОпределяемыйТип.ВладелецШаблонаСообщения, то будет открыт шаблон
//                     сообщения по владельцу.
//  ПараметрыОткрытия - Структура - параметры открытия формы:
//    * Владелец - Произвольный - форма или элемент управления другой формы.
//    * Уникальность - Произвольный - ключ, значение которого будет использоваться для поиска уже открытых форм.
//    * НавигационнаяСсылка - Строка - задает навигационную ссылку, возвращаемую формой.
//    * ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана после
//                                                         закрытия формы.
//    * РежимОткрытияОкна - РежимОткрытияОкнаФормы - указывает режим открытия окна управляемой формы.
//
Процедура ПоказатьФормуШаблона(Значение, ПараметрыОткрытия = Неопределено) Экспорт
	
	ПараметрыОткрытияФормы = ПараметрыФормы(ПараметрыОткрытия);
	
	ПараметрыФормы = Новый Структура;
	Если ТипЗнч(Значение) = Тип("Структура") Тогда
		ПараметрыФормы.Вставить("Основание", Значение);
		ПараметрыФормы.Вставить("ВладелецШаблона", Значение.ВладелецШаблона);
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.ШаблоныСообщений") Тогда
		ПараметрыФормы.Вставить("Ключ", Значение);
	Иначе
		ПараметрыФормы.Вставить("ВладелецШаблона", Значение);
		ПараметрыФормы.Вставить("Ключ", Значение);
	КонецЕсли;

	ОткрытьФорму("Справочник.ШаблоныСообщений.ФормаОбъекта", ПараметрыФормы, ПараметрыОткрытияФормы.Владелец,
		ПараметрыОткрытияФормы.Уникальность,, ПараметрыОткрытияФормы.НавигационнаяСсылка,
		ПараметрыОткрытияФормы.ОписаниеОповещенияОЗакрытии, ПараметрыОткрытияФормы.РежимОткрытияОкна);
КонецПроцедуры

// Возвращает параметры открытия формы шаблона сообщения.
//
// Параметры:
//  ДанныеЗаполнения - Произвольный - значение, на основании которого выполняется заполнение.
//                                    Значение данного параметра не может быть следующих типов:
//                                    Неопределено, Null, Число, Строка, Дата, Булево, Дата.
// 
// Возвращаемое значение:
//  Структура - список параметров открытия формы:
//   * Владелец - Произвольный - форма или элемент управления другой формы.
//   * Уникальность - Произвольный - ключ, значение которого будет использоваться для поиска уже открытых форм.
//   * НавигационнаяСсылка - Строка - задает навигационную ссылку, возвращаемую формой.
//   * ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана после
//                                                       закрытия формы.
//   * РежимОткрытияОкна - РежимОткрытияОкнаФормы - указывает режим открытия окна управляемой формы.
//
Функция ПараметрыФормы(ДанныеЗаполнения) Экспорт
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("Владелец", Неопределено);
	ПараметрыОткрытия.Вставить("Уникальность", Неопределено);
	ПараметрыОткрытия.Вставить("НавигационнаяСсылка", Неопределено);
	ПараметрыОткрытия.Вставить("ОписаниеОповещенияОЗакрытии", Неопределено);
	ПараметрыОткрытия.Вставить("РежимОткрытияОкна", Неопределено);
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, ДанныеЗаполнения);
	КонецЕсли;
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Открывает окно выбора шаблона для формирования электронного письма или сообщения SMS по указанному предмету
// ПредметСообщения и возвращает сформированный шаблон.
//
// Параметры:
//  ПредметСообщения            - ЛюбаяСсылка
//                              - Строка - объект-источник данных, выводимых в сообщение.
//                                Для общих шаблонов необходимо  передавать значение "Общий".
//  ВидСообщения                - Строка - "Письмо" для электронного письма и "СообщениеSMS" для сообщений SMS.
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - оповещение, которое вызывается после формирования сообщения:
//     * Результат - Структура - если Истина, то сообщение было создано.
//     * ПараметрыСообщения - Структура
//                          - Неопределено - значение, которое было передано в параметре ПараметрыСообщения. 
//  ВладелецШаблона             - ОпределяемыйТип.ВладелецШаблона - владелец шаблонов. Если не указан, то в окне выбора
//                                              шаблона выводятся все доступные шаблоны для указанного предмета ПредметСообщения.
//  ПараметрыСообщения          - Структура -  дополнительная информация для формирования сообщения, 
//                                             которая передается в свойство ПараметрыСообщения параметра ПараметрыШаблона
//                                             процедуры ШаблоныСообщенийПереопределяемый.ПриФормированииСообщения. 
//
Процедура ПодготовитьСообщениеПоШаблону(ПредметСообщения, ВидСообщения, ОписаниеОповещенияОЗакрытии = Неопределено, 
	ВладелецШаблона = Неопределено, ПараметрыСообщения = Неопределено) Экспорт
	
	ПараметрыФормы = ПараметрыФормыСообщения(ПредметСообщения, ВидСообщения, ВладелецШаблона, ПараметрыСообщения);
	ПараметрыФормы.Вставить("ПодготовитьШаблон", Истина);
	
	ПоказатьФормуСформироватьСообщение(ОписаниеОповещенияОЗакрытии, ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыФормыСообщения(ПредметШаблона, ВидСообщения, ВладелецШаблона, ПараметрыСообщения)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Предмет",            ПредметШаблона);
	ПараметрыФормы.Вставить("ВидСообщения",       ВидСообщения);
	ПараметрыФормы.Вставить("ВладелецШаблона",    ВладелецШаблона);
	ПараметрыФормы.Вставить("ПараметрыСообщения", ПараметрыСообщения);
	
	Возврат ПараметрыФормы;
	
КонецФункции

Процедура ПоказатьФормуСформироватьСообщение(ОписаниеОповещенияОЗакрытии, ПараметрыФормы)
	
	ДополнительныеПараметры = Новый Структура("Оповещение", ОписаниеОповещенияОЗакрытии);
	Оповещение = Новый ОписаниеОповещения("ВыполнитьОповещениеОЗакрытие", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Справочник.ШаблоныСообщений.Форма.СформироватьСообщение", ПараметрыФормы, ЭтотОбъект,,,, Оповещение);
	
КонецПроцедуры

Процедура ВыполнитьОповещениеОЗакрытие(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.Оповещение, Результат);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


