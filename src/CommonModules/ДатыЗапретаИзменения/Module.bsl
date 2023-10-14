///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверяет, запрещено ли изменение данных при интерактивном редактировании пользователем 
// или при программной загрузке данных из узла плана обмена УзелПроверкиЗапретаЗагрузки.
//
// Параметры:
//  ДанныеИлиПолноеИмя  - СправочникОбъект
//                      - ДокументОбъект
//                      - ПланВидовХарактеристикОбъект
//                      - ПланСчетовОбъект
//                      - ПланВидовРасчетаОбъект
//                      - БизнесПроцессОбъект
//                      - ЗадачаОбъект
//                      - ПланОбменаОбъект
//                      - РегистрСведенийНаборЗаписей
//                      - РегистрНакопленияНаборЗаписей
//                      - РегистрБухгалтерииНаборЗаписей
//                      - РегистрРасчетаНаборЗаписей - проверяемый элемент данных или набор записей.
//                      - Строка - полное имя объекта метаданных, данные которого следует проверить в базе данных.
//                                 Например: "Документ.ПриходнаяНакладная".
//                                 В этом случае следует указать в параметре ИдентификаторДанных,
//                                 какие именно данные требуется прочитать из базы и проверить.
//
//  ИдентификаторДанных - СправочникСсылка
//                      - ДокументСсылка
//                      - ПланВидовХарактеристикСсылка
//                      - ПланСчетовСсылка
//                      - ПланВидовРасчетаСсылка
//                      - БизнесПроцессСсылка
//                      - ЗадачаСсылка
//                      - ПланОбменаСсылка
//                      - Отбор - ссылка на элемент данных или отбор набора записей, который нужно проверить.
//                                При этом значение для проверки будет получено из базы данных.
//                      - Неопределено - если не требуется получать значение для проверки из базы данных,  
//                                       а нужно проверить только данные самого объекта в ДанныеИлиПолноеИмя.
//
//  ОписаниеОшибки    - Null      - (значение по умолчанию) - сведения о запретах не требуются.
//                    - Строка    - (возвращаемое значение) - вернуть текстовое описание найденных запретов.
//                    - Структура - (возвращаемое значение) - вернуть структурное описание найденных запретов,
//                                  подробнее см. функцию ДатыЗапретаИзменения.НайденЗапретИзмененияДанных.
//
//  УзелПроверкиЗапретаЗагрузки - Неопределено
//                              - ПланыОбменаСсылка - если Неопределено, то проверить запрет 
//                                изменения данных; иначе - загрузку данных из указанного узла плана обмена.
//
// Возвращаемое значение:
//  Булево - Истина, если изменение данных запрещено.
//
// Варианты вызова:
//   ИзменениеЗапрещено(СправочникОбъект...)         - проверить данные в переданном объекте (наборе записей).
//   ИзменениеЗапрещено(Строка, СправочникСсылка...) - проверить данные, полученные из базы данных 
//      по полному имени объекта метаданных и ссылке (отбору набора записей).
//   ИзменениеЗапрещено(СправочникОбъект..., СправочникСсылка...) - проверить одновременно 
//      данные в переданном объекте и данные в базе (т.е. "до" и "после" записи в базу, если проверка выполняется
//      перед записью объекта).
//
Функция ИзменениеЗапрещено(ДанныеИлиПолноеИмя, ИдентификаторДанных = Неопределено,
	ОписаниеОшибки = Null, УзелПроверкиЗапретаЗагрузки = Неопределено) Экспорт
	
	ПроверкаЗапретаИзменения = УзелПроверкиЗапретаЗагрузки = Неопределено;
	
	Если ТипЗнч(ДанныеИлиПолноеИмя) = Тип("Строка") Тогда
		Если ТипЗнч(ИдентификаторДанных) = Тип("Отбор") Тогда
			МенеджерДанных = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ДанныеИлиПолноеИмя);
			Источник = МенеджерДанных.СоздатьНаборЗаписей();
			Для Каждого ЭлементОтбора Из ИдентификаторДанных Цикл
				Источник.Отбор[ЭлементОтбора.Имя].Установить(ЭлементОтбора.Значение, ЭлементОтбора.Использование);
			КонецЦикла;
			Источник.Прочитать();
		ИначеЕсли Не ЗначениеЗаполнено(ИдентификаторДанных) Тогда
			Возврат Ложь;
		Иначе
			Источник = ИдентификаторДанных.ПолучитьОбъект();
		КонецЕсли;
		
		Если ДатыЗапретаИзмененияСлужебный.ПропуститьПроверкуДатЗапрета(Источник,
				ПроверкаЗапретаИзменения, УзелПроверкиЗапретаЗагрузки, "") Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Возврат ДатыЗапретаИзмененияСлужебный.ИзменениеЗапрещено(ДанныеИлиПолноеИмя,
			ИдентификаторДанных, ОписаниеОшибки, УзелПроверкиЗапретаЗагрузки);
	КонецЕсли;
	
	ВерсияОбъекта = "";
	Если ДатыЗапретаИзмененияСлужебный.ПропуститьПроверкуДатЗапрета(ДанныеИлиПолноеИмя,
			 ПроверкаЗапретаИзменения, УзелПроверкиЗапретаЗагрузки, ВерсияОбъекта) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Источник      = ДанныеИлиПолноеИмя;
	Идентификатор = ИдентификаторДанных;
	
	Если ВерсияОбъекта = "СтараяВерсия" Тогда
		Источник = Метаданные.НайтиПоТипу(ДанныеИлиПолноеИмя).ПолноеИмя();
		
	ИначеЕсли ВерсияОбъекта = "НоваяВерсия" Тогда
		Идентификатор = Неопределено;
	КонецЕсли;
	
	Возврат ДатыЗапретаИзмененияСлужебный.ИзменениеЗапрещено(Источник,
		Идентификатор, ОписаниеОшибки, УзелПроверкиЗапретаЗагрузки);
	
КонецФункции

// Проверяет наличие запрета загрузки объекта или набора записей Данные.
// При этом выполняется проверка старой и новой версии данных. 
//
// Параметры:
//  Данные              - СправочникОбъект
//                      - ДокументОбъект
//                      - ПланВидовХарактеристикОбъект
//                      - ПланСчетовОбъект
//                      - ПланВидовРасчетаОбъект
//                      - БизнесПроцессОбъект
//                      - ЗадачаОбъект
//                      - ПланОбменаОбъект
//                      - УдалениеОбъекта
//                      - РегистрСведенийНаборЗаписей
//                      - РегистрНакопленияНаборЗаписей
//                      - РегистрБухгалтерииНаборЗаписей
//                      - РегистрРасчетаНаборЗаписей - элемент данных или набор записей.
//
//  УзелПроверкиЗапретаЗагрузки  - ПланОбменаСсылка - узел, для которого требуется проверка.
//
//  Отказ               - Булево - возвращаемый параметр: Истина, если загрузка запрещена.
//
//  ОписаниеОшибки      - Null      - (значение по умолчанию) - сведения о запретах не требуются.
//                      - Строка    - (возвращаемое значение) - вернуть текстовое описание найденных запретов.
//                      - Структура - (возвращаемое значение) - вернуть структурное описание найденных запретов,
//                                    подробнее см. функцию ДатыЗапретаИзменения.НайденЗапретИзмененияДанных.
//
Процедура ПроверитьДатыЗапретаЗагрузкиДанных(Данные, УзелПроверкиЗапретаЗагрузки, Отказ, ОписаниеОшибки = Null) Экспорт
	
	Если ТипЗнч(Данные) = Тип("УдалениеОбъекта") Тогда
		ОбъектМетаданных = Данные.Ссылка.Метаданные();
	Иначе
		ОбъектМетаданных = Данные.Метаданные();
	КонецЕсли;
	
	ИсточникиДанных = ДатыЗапретаИзмененияСлужебный.ИсточникиДанныхДляПроверкиЗапретаИзменения();
	Если ИсточникиДанных.Получить(ОбъектМетаданных.ПолноеИмя()) = Неопределено Тогда
		Возврат; // Для текущего типа объекта не определены запреты по датам.
	КонецЕсли;
	
	ДополнительныеПараметры = ДатыЗапретаИзмененияСлужебный.ПараметрыПроверкиДатЗапрета();
	ДополнительныеПараметры.УзелПроверкиЗапретаЗагрузки = УзелПроверкиЗапретаЗагрузки;
	ДополнительныеПараметры.ОписаниеОшибки = ОписаниеОшибки;
	ЭтоРегистр = ОбщегоНазначения.ЭтоРегистр(ОбъектМетаданных);
	
	Результат = ДатыЗапретаИзмененияСлужебный.ПроверитьДатыЗапретаИзмененияЗагрузкиДанных(Данные,
		ЭтоРегистр, ЭтоРегистр, ТипЗнч(Данные) = Тип("УдалениеОбъекта"), ДополнительныеПараметры);
	
	ОписаниеОшибки = Результат.ОписаниеОшибки;
	Если Результат.ИзменениеЗапрещено Тогда
		Отказ = Истина;
	КонецЕсли;
		
КонецПроцедуры

// Обработчик события формы ПриЧтенииНаСервере, который встраивается в формы элементов справочников,
// документов, записей регистров и др., чтобы заблокировать форму, если изменение запрещено.
//
// Параметры:
//  Форма               - ФормаКлиентскогоПриложения - форма элемента объекта или записи регистра.
//
//  ТекущийОбъект       - СправочникОбъект
//                      - ДокументОбъект
//                      - ПланВидовХарактеристикОбъект
//                      - ПланСчетовОбъект
//                      - ПланВидовРасчетаОбъект
//                      - БизнесПроцессОбъект
//                      - ЗадачаОбъект
//                      - ПланОбменаОбъект
//                      - РегистрСведенийМенеджерЗаписи
//                      - РегистрНакопленияМенеджерЗаписи
//                      - РегистрБухгалтерииМенеджерЗаписи
//                      - РегистрРасчетаМенеджерЗаписи - менеджер записи.
//
// Возвращаемое значение:
//  Булево - Истина, если проверка запрета изменения была пропущена программно.
//
Функция ОбъектПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(ТекущийОбъект));
	ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
	
	ДействующиеДаты = ДатыЗапретаИзмененияСлужебный.ДействующиеДатыЗапрета();
	ИсточникиДанных = ДействующиеДаты.ИсточникиДанных.Получить(ПолноеИмя);
	Если ИсточникиДанных = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоРегистр(ОбъектМетаданных) Тогда
		// Приведение менеджера записи к набору записей с одной записью.
		МенеджерДанных = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмя);
		Источник = МенеджерДанных.СоздатьНаборЗаписей();
		Для каждого ЭлементОтбора Из Источник.Отбор Цикл
			ЭлементОтбора.Установить(ТекущийОбъект[ЭлементОтбора.Имя], Истина);
		КонецЦикла;
		ЗаполнитьЗначенияСвойств(Источник.Добавить(), ТекущийОбъект);
	Иначе
		Источник = ТекущийОбъект;
	КонецЕсли;
	
	Если ДатыЗапретаИзмененияСлужебный.ПропуститьПроверкуДатЗапрета(Источник,
			Истина, Неопределено, "") Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ИзменениеЗапрещено(Источник) Тогда
		Форма.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Добавляет строку описания источника данных для проверки запрета изменения.
// Используется в процедуре ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения
// общего модуля ДатыЗапретаИзмененияПереопределяемый.
// 
// Параметры:
//  Данные      - ТаблицаЗначений - передается в процедуру ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения.
//  Таблица     - Строка - полное имя объекта метаданных, например "Документ.ПриходнаяНакладная".
//  ПолеДаты    - Строка - имя реквизита объекта или табличной части, например: "Дата", "Товары.ДатаОтгрузки".
//  Раздел      - Строка - имя предопределенного элемента ПланВидовХарактеристикСсылка.РазделыДатЗапретаИзменения.
//  ПолеОбъекта - Строка - имя реквизита объекта или реквизита табличной части, например: "Организация", "Товары.Склад".
//
Процедура ДобавитьСтроку(Данные, Таблица, ПолеДаты, Раздел = "", ПолеОбъекта = "") Экспорт
	
	НоваяСтрока = Данные.Добавить();
	НоваяСтрока.Таблица     = Таблица;
	НоваяСтрока.ПолеДаты    = ПолеДаты;
	НоваяСтрока.Раздел      = Раздел;
	НоваяСтрока.ПолеОбъекта = ПолеОбъекта;
	
КонецПроцедуры

// Найти даты запрета по проверяемым данным для указанного пользователя или узла плана обмена.
//
// Параметры:
//  ДанныеДляПроверки - см. ДатыЗапретаИзменения.ШаблонДанныхДляПроверки
//
//  ПараметрыСообщенияОЗапрете - см. ДатыЗапретаИзменения.ПараметрыСообщенияОЗапрете
//                             - Неопределено - формировать текст сообщения о запрете не требуется.
//
//  ОписаниеОшибки    - Null      - (значение по умолчанию) - сведения о запретах не требуются.
//                    - Строка    - (возвращаемое значение) - вернуть текстовое описание найденных запретов.
//                    - Структура - (возвращаемое значение) - вернуть структурное описание найденных запретов:
//                        * ПредставлениеДанных - Строка - представление данных, используемое в заголовке ошибки.
//                        * ЗаголовокОшибки     - Строка - строка, подобная следующей:
//                                                "Заказ 10 от 01.01.2017 невозможно изменить в запрещенном периоде.".
//                        * Запреты - ТаблицаЗначений - найденные запреты в виде таблицы с колонками:
//                          ** Дата            - Дата         - проверяемая дата.
//                          ** Раздел          - Строка       - имя раздела, по которому выполнялся поиск запретов, если
//                                                 пустая строка, значит, выполнялся поиск даты, действующей для всех разделов.
//                          ** Объект          - ЛюбаяСсылка  - ссылка на объект, по которому выполнялся поиск даты запрета.
//                                             - Неопределено - выполнялся поиск даты, действующей для всех объектов.
//                          ** ДатаЗапрета     - Дата         - найденная дата запрета.
//                          ** ОбщаяДата       - Булево       - если Истина, значит, найденная дата запрета действует для
//                                                 всех разделов, а не только для раздела, по которому выполнялся поиск.
//                          ** ДляВсехОбъектов - Булево       - если Истина, значит, найденная дата запрета действует для
//                                                 всех объектов, а не только для объекта, по которому выполнялся поиск.
//                          ** Адресат         - ОпределяемыйТип.АдресатЗапретаИзменения - пользователь или узел
//                                                 плана обмена, для которого задана найденная дата запрета.
//                          ** Описание        - Строка - строка, подобная следующей:
//                            "Дате 01.01.2017 по объекту ""Склад программ"" раздела ""Складской учет"" соответствует
//                            запрет изменения данных для всех пользователей (установлена общая дата запрета)".
//
//  УзелПроверкиЗапретаЗагрузки - Неопределено - выполнить проверку изменения данных.
//                              - ПланыОбменаСсылка.<Имя плана обмена> - выполнить проверку
//                                загрузки данных для указанного узла.
//
// Возвращаемое значение:
//  Булево - если Истина, то найден хотя бы один запрет изменения.
//
Функция НайденЗапретИзмененияДанных(Знач ДанныеДляПроверки,
                                    ПараметрыСообщенияОЗапрете = Неопределено,
                                    ОписаниеОшибки = Null,
                                    УзелПроверкиЗапретаЗагрузки = Неопределено) Экспорт
	
	Если ДатыЗапретаИзмененияСлужебный.ПроверкаДатЗапретаОтключена(
			УзелПроверкиЗапретаЗагрузки = Неопределено, УзелПроверкиЗапретаЗагрузки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ДатыЗапретаИзмененияСлужебный.НайденЗапретИзмененияДанных(ДанныеДляПроверки,
		ПараметрыСообщенияОЗапрете, ОписаниеОшибки, УзелПроверкиЗапретаЗагрузки);
	
КонецФункции

// Возвращает параметры для формирования сообщение о запрете записи или загрузки данных. 
// Для использования в функции ДатыЗапретаИзменения.НайденЗапретИзмененияДанных.
//
// Возвращаемое значение:
//   Структура:
//    * НоваяВерсия - Булево - если Истина, то сообщение о запрете необходимо
//                    сформировать для новой версии, иначе для старой версии.
//    * Данные - ЛюбаяСсылка
//             - СправочникОбъект
//             - ДокументОбъект
//             - НаборЗаписей - ссылка, объект данных,
//                    или набор записей регистра, представление которого будет выведено в сообщении о запрете.
//             - Структура:
//                 ** Регистр - Строка - полное имя регистра.
//                            - НаборЗаписей - набор записей регистра.
//                 ** Отбор   - Отбор - отбор набора записей.
//             - Строка - подготовленное представление данных,
//                 которое будет выведено в сообщении о запрете.
//				 
Функция ПараметрыСообщенияОЗапрете() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Данные", "");
	Результат.Вставить("НоваяВерсия", Ложь);
	Возврат Результат;
	
КонецФункции	

// Возвращает новую таблицу значений с колонками Дата, Раздел и Объект
// для заполнения и последующей передачи в функцию ДатыЗапретаИзменения.НайденЗапретИзмененияДанных.
//
// Возвращаемое значение:
//  ТаблицаЗначений:
//   * Дата   - Дата   - дата без времени, которую нужно проверить на принадлежность установленным запретам.
//   * Раздел - Строка - одно из имен разделов, указанных в процедуре
//                       ДатыЗапретаИзмененияПереопределяемый.ПриЗаполненииРазделовДатЗапретаИзменения
//   * Объект - Ссылка - один из типов объектов, указанных для раздела в процедуре 
//                       ДатыЗапретаИзмененияПереопределяемый.ПриЗаполненииРазделовДатЗапретаИзменения.
//
Функция ШаблонДанныхДляПроверки() Экспорт
	
	ДанныеДляПроверки = Новый ТаблицаЗначений;
	
	ДанныеДляПроверки.Колонки.Добавить(
		"Дата", Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	
	ДанныеДляПроверки.Колонки.Добавить(
		"Раздел", Новый ОписаниеТипов("Строка,ПланВидовХарактеристикСсылка.РазделыДатЗапретаИзменения"));
	
	ДанныеДляПроверки.Колонки.Добавить(
		"Объект", Метаданные.ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.Тип);
	
	Возврат ДанныеДляПроверки;
	
КонецФункции

// Обновляет план видов характеристик РазделыДатЗапретаИзменения по описанию в метаданных.
// Предназначен для вызова из обработчика обновления общих данных (модель сервиса)
// при изменении состава разделов дат запрета изменения или свойств разделов в процедуре
// ПриЗаполненииРазделовДатЗапретаИзменения общего модуля ДатыЗапретаИзмененияПереопределяемый.
//
Процедура ОбновитьРазделыДатЗапретаИзменения() Экспорт
	
	ДатыЗапретаИзмененияСлужебный.ОбновитьРазделыДатЗапретаИзменения();
	
КонецПроцедуры

// В текущем сеансе отключает и включает проверку дат запрета изменения и загрузки данных.
// Требуется для реализации специальной логики работы и ускорения пакетной обработки данных
// при записи объекта или набора записей, когда признак ОбменДанными.Загрузка не установлен.
// 
// Для использования требуются полные права или привилегированный режим.
//
// Рекомендуется:
// - массовой загрузке данных из файла (если данные не попадают в запрещенный период);
// - массовой загрузке данных при обмене данными (если данные не попадают в запрещенный период);
// - в случае, когда требуется отключить проверку дат запрета не для одного объекта,
//   путем вставки свойства ПропуститьПроверкуЗапретаИзменения в ДополнительныеСвойства объекта,
//   а для всех объектов, которые будут записываться в рамках записи этого объекта.
//
// Параметры:
//  Отключить - Булево - Истина - отключает проверку дат запрета изменения и загрузки данных.
//                       Ложь   - включает  проверку дат запрета изменения и загрузки данных.
//
// Пример:
//
//  Вариант 1. Запись набора объектов вне транзакции (ТранзакцияАктивна() = Ложь).
//
//	ПроверкаДатЗапретаОтключена = ДатыЗапретаИзменения.ПроверкаДатЗапретаОтключена();
//	ДатыЗапретаИзменения.ОтключитьПроверкуДатЗапрета(Истина);
//	Попытка
//		// Запись набора объектов.
//		// ...
//	Исключение
//		ДатыЗапретаИзменения.ОтключитьПроверкуДатЗапрета(ПроверкаДатЗапретаОтключена);
//		//...
//		ВызватьИсключение;
//	КонецПопытки;
//	ДатыЗапретаИзменения.ОтключитьПроверкуДатЗапрета(ПроверкаДатЗапретаОтключена);
//
//  Вариант 2. Запись набора объектов в транзакции (ТранзакцияАктивна() = Истина).
//
//	ПроверкаДатЗапретаОтключена = ДатыЗапретаИзменения.ПроверкаДатЗапретаОтключена();
//	ДатыЗапретаИзменения.ОтключитьПроверкуДатЗапрета(Истина);
//	НачатьТранзакцию();
//	Попытка
//		БлокировкаДанных.Заблокировать();
//		// ...
//		// Запись набора объектов.
//		// ...
//		ЗафиксироватьТранзакцию();
//	Исключение
//		ОтменитьТранзакцию();
//		ДатыЗапретаИзменения.ОтключитьПроверкуДатЗапрета(ПроверкаДатЗапретаОтключена);
//		//...
//		ВызватьИсключение;
//	КонецПопытки;
//	ДатыЗапретаИзменения.ОтключитьПроверкуДатЗапрета(ПроверкаДатЗапретаОтключена);
//
Процедура ОтключитьПроверкуДатЗапрета(Отключить) Экспорт
	
	ПараметрыСеанса.ПропуститьПроверкуЗапретаИзменения = Отключить;
	
КонецПроцедуры

// Возвращает состояние отключения дат запрета, выполняемое
// процедурой ОтключитьПроверкуДатЗапрета.
//
// Возвращаемое значение:
//  Булево
//
Функция ПроверкаДатЗапретаОтключена() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ПроверкаДатЗапретаОтключена = ПараметрыСеанса.ПропуститьПроверкуЗапретаИзменения;
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ПроверкаДатЗапретаОтключена;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики подписок на события.

// Обработчик подписки на событие ПередЗаписью для проверки запрета изменения.
//
// Параметры:
//  Источник   - СправочникОбъект
//             - ПланВидовХарактеристикОбъект
//             - ПланСчетовОбъект
//             - ПланВидовРасчетаОбъект
//             - БизнесПроцессОбъект
//             - ЗадачаОбъект
//             - ПланОбменаОбъект - объект данных, передаваемый в подписку на событие ПередЗаписью.
//
//  Отказ      - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//
Процедура ПроверитьДатуЗапретаИзмененияПередЗаписью(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьДатыЗапретаИзмененияДанных(Источник, Отказ);
	
КонецПроцедуры

// Обработчик подписки на событие ПередЗаписью для проверки запрета изменения.
//
// Параметры:
//  Источник        - ДокументОбъект - объект данных, передаваемый в подписку на событие ПередЗаписью.
//  Отказ           - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//  РежимЗаписи     - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//  РежимПроведения - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//
Процедура ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Источник.ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ПроверитьДатыЗапретаИзмененияДанных(Источник, Отказ);
	
КонецПроцедуры

// Обработчик подписки на событие ПередЗаписью для проверки запрета изменения.
//
// Параметры:
//  Источник   - РегистрСведенийНаборЗаписей
//             - РегистрНакопленияНаборЗаписей - набор записей,
//               передаваемый в подписку на событие ПередЗаписью.
//  Отказ      - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//  Замещение  - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//
Процедура ПроверитьДатуЗапретаИзмененияПередЗаписьюНабораЗаписей(Источник, Отказ, Замещение) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьДатыЗапретаИзмененияДанных(Источник, Отказ, Истина, Замещение);
	
КонецПроцедуры

// Обработчик подписки на событие ПередЗаписью для проверки запрета изменения.
//
// Параметры:
//  Источник    - РегистрБухгалтерииНаборЗаписей - набор записей, передаваемый
//                в подписку на событие ПередЗаписью.
//  Отказ       - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//  РежимЗаписи - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//
Процедура ПроверитьДатуЗапретаИзмененияПередЗаписьюНабораЗаписейРегистраБухгалтерии(
		Источник, Отказ, РежимЗаписи) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьДатыЗапретаИзмененияДанных(Источник, Отказ, Истина);
	
КонецПроцедуры

// Обработчик подписки на событие ПередЗаписью для проверки запрета изменения.
//
// Параметры:
//  Источник     - РегистрРасчетаНаборЗаписей - набор записей, передаваемый
//                 в подписку на событие ПередЗаписью.
//  Отказ        - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//  Замещение    - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//  ТолькоЗапись - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//  ЗаписьФактическогоПериодаДействия - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//  ЗаписьПерерасчетов - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//
Процедура ПроверитьДатуЗапретаИзмененияПередЗаписьюНабораЗаписейРегистраРасчета(
		Источник,
		Отказ,
		Замещение,
		ТолькоЗапись,
		ЗаписьФактическогоПериодаДействия,
		ЗаписьПерерасчетов) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьДатыЗапретаИзмененияДанных(Источник, Отказ, Истина, Замещение);
	
КонецПроцедуры

// Обработчик подписки на событие ПередУдалением для проверки запрета изменения.
//
// Параметры:
//  Источник   - СправочникОбъект
//             - ДокументОбъект
//             - ПланВидовХарактеристикОбъект
//             - ПланСчетовОбъект
//             - ПланВидовРасчетаОбъект
//             - БизнесПроцессОбъект
//             - ЗадачаОбъект
//             - ПланОбменаОбъект - объект данных, передаваемый в подписку на событие ПередЗаписью.
//
//  Отказ      - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//
Процедура ПроверитьДатуЗапретаИзмененияПередУдалением(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьДатыЗапретаИзмененияДанных(Источник, Отказ, , , Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Для процедур ПроверитьДатуЗапретаИзменения*.
Процедура ПроверитьДатыЗапретаИзмененияДанных(
		Источник, Отказ, ИсточникРегистр = Ложь, Замещение = Истина, Удаление = Ложь)
	
	Результат = ДатыЗапретаИзмененияСлужебный.ПроверитьДатыЗапретаИзмененияЗагрузкиДанных(
		Источник, ИсточникРегистр, Замещение, Удаление);
	Если Результат.ИзменениеЗапрещено Тогда
		ВызватьИсключение Результат.ОписаниеОшибки;
	КонецЕсли;		
	
КонецПроцедуры

#КонецОбласти
