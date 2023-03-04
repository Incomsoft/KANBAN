///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Разрешает редактирование заблокированных элементов формы, связанных с заданными реквизитами.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//        - РасширениеУправляемойФормыДляОбъектов - форма, в которой требуется разрешить
//          редактирование элементов формы, заданных реквизитов, где:
//    * Объект - ДанныеФормыСтруктура
//             - СправочникОбъект
//             - ДокументОбъект
//  ОбработкаПродолжения - Неопределено - никаких действий после выполнения процедуры.
//                       - ОписаниеОповещения - оповещение, которое вызывается после выполнения процедуры.
//                         В обработку оповещения передается параметр типа Булево:
//                           Истина - ссылок не обнаружено или пользователь решил разрешить редактирование,
//                           Ложь   - видимых заблокированных реквизитов нет или
//                                    ссылки обнаружены и пользователь отказался от продолжения.
//
Процедура РазрешитьРедактированиеРеквизитовОбъекта(Знач Форма, ОбработкаПродолжения = Неопределено) Экспорт
	
	ЗаблокированныеРеквизиты = Реквизиты(Форма);
	
	Если ЗаблокированныеРеквизиты.Количество() = 0 Тогда
		ПоказатьПредупреждениеВсеВидимыеРеквизитыРазблокированы(
			Новый ОписаниеОповещения("РазрешитьРедактированиеРеквизитовОбъектаПослеПредупреждения",
				ЗапретРедактированияРеквизитовОбъектовСлужебныйКлиент, ОбработкаПродолжения));
		Возврат;
	КонецЕсли;
	
	СинонимыРеквизитов = Новый Массив;
	
	Для Каждого ОписаниеРеквизита Из Форма.ПараметрыЗапретаРедактированияРеквизитов Цикл
		Если ЗаблокированныеРеквизиты.Найти(ОписаниеРеквизита.ИмяРеквизита) <> Неопределено Тогда
			СинонимыРеквизитов.Добавить(ОписаниеРеквизита.Представление);
		КонецЕсли;
	КонецЦикла;
	
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Форма.Объект.Ссылка);
	
	Параметры = Новый Структура;
	Параметры.Вставить("Форма", Форма);
	Параметры.Вставить("ЗаблокированныеРеквизиты", ЗаблокированныеРеквизиты);
	Параметры.Вставить("ОбработкаПродолжения", ОбработкаПродолжения);
	
	ПроверитьСсылкиНаОбъект(
		Новый ОписаниеОповещения("РазрешитьРедактированиеРеквизитовОбъектаПослеПроверкиСсылок",
			ЗапретРедактированияРеквизитовОбъектовСлужебныйКлиент, Параметры),
		МассивСсылок,
		СинонимыРеквизитов);
	
КонецПроцедуры

// Устанавливает доступность элементов формы, связанных с заданными реквизитами,
// для которых установлено разрешение изменения. Если передать массив реквизитов,
// тогда сначала будет дополнен состав реквизитов, разрешенных для изменения.
//   Если разблокировка элементов формы, связанных с заданными реквизитами,
// снята для всех реквизитов, тогда кнопка разрешения редактирования блокируется.
//
// Параметры:
//  Форма        - ФормаКлиентскогоПриложения - форма, в которой требуется разрешить
//                 редактирование элементов формы, заданных реквизитов.
//  
//  Реквизиты    - Массив - значения:
//                  * Строка - имена реквизитов, для которых нужно установить разрешенность изменения.
//                    Используется, когда функция РазрешитьРедактированиеРеквизитовОбъекта не используется.
//               - Неопределено - состав реквизитов, доступных для редактирования, не изменяется,
//                 а для элементов формы, связанных с реквизитами, изменение которых разрешено,
//                 устанавливается доступность.
//
Процедура УстановитьДоступностьЭлементовФормы(Знач Форма, Знач Реквизиты = Неопределено) Экспорт
	
	УстановитьРазрешенностьРедактированияРеквизитов(Форма, Реквизиты);
	
	Для Каждого ОписаниеБлокируемогоРеквизита Из Форма.ПараметрыЗапретаРедактированияРеквизитов Цикл
		Если ОписаниеБлокируемогоРеквизита.РедактированиеРазрешено Тогда
			Для Каждого БлокируемыйЭлементФормы Из ОписаниеБлокируемогоРеквизита.БлокируемыеЭлементы Цикл
				ЭлементФормы = Форма.Элементы.Найти(БлокируемыйЭлементФормы.Значение);
				Если ЭлементФормы <> Неопределено Тогда
					Если ТипЗнч(ЭлементФормы) = Тип("ПолеФормы")
					   И ЭлементФормы.Вид <> ВидПоляФормы.ПолеНадписи
					 Или ТипЗнч(ЭлементФормы) = Тип("ТаблицаФормы") Тогда
						ЭлементФормы.ТолькоПросмотр = Ложь;
					Иначе
						ЭлементФормы.Доступность = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Спрашивает у пользователя подтверждение на включение редактирования реквизитов
// и проверяет, есть ли ссылки на объект в информационной базе.
//
// Параметры:
//  ОбработкаПродолжения - ОписаниеОповещения - оповещение, которое вызывается после проверки.
//                         В обработку оповещения передается параметр типа Булево:
//                           Истина - ссылок не обнаружено или пользователь решил разрешить редактирование,
//                           Ложь   - видимых заблокированных реквизитов нет или
//                                    ссылки обнаружены и пользователь отказался от продолжения.
//  МассивСсылок         - Массив - значения:
//                           * Ссылка - искомые ссылки в различных объектах.
//  СинонимыРеквизитов   - Массив - значения:
//                           * Строка - синонимы реквизитов, которые показываются пользователю.
//
Процедура ПроверитьСсылкиНаОбъект(Знач ОбработкаПродолжения, Знач МассивСсылок, Знач СинонимыРеквизитов) Экспорт
	
	ЗаголовокДиалога = НСтр("ru = 'Разрешение редактирования реквизитов'");
	
	РеквизитыПредставление = "";
	Для Каждого СинонимРеквизита Из СинонимыРеквизитов Цикл
		РеквизитыПредставление = РеквизитыПредставление + СинонимРеквизита + "," + Символы.ПС;
	КонецЦикла;
	РеквизитыПредставление = Лев(РеквизитыПредставление, СтрДлина(РеквизитыПредставление) - 2);
	
	Если СинонимыРеквизитов.Количество() > 1 Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для того чтобы не допустить рассогласования данных в программе,
			           |следующие реквизиты не доступны для редактирования:
			           |%1.
			           |
			           |Перед тем, как разрешить их редактирование, рекомендуется оценить последствия,
			           |проверив все места использования этого элемента в программе.
			           |Поиск мест использования может занять длительное время.'"),
			РеквизитыПредставление);
	Иначе
		Если МассивСсылок.Количество() = 1 Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для того чтобы не допустить рассогласования данных в программе,
				           |реквизит %1 не доступен для редактирования.
				           |
				           |Перед тем, как разрешить его редактирование, рекомендуется оценить последствия,
				           |проверив все места использования ""%2"" в программе.
				           |Поиск мест использования может занять длительное время.'"),
				РеквизитыПредставление, МассивСсылок[0]);
		Иначе
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для того чтобы не допустить рассогласования данных в программе,
				           |реквизит %1 не доступен для редактирования.
				           |
				           |Перед тем, как разрешить его редактирование, рекомендуется оценить последствия,
				           |проверив все места использования выбранных элементов (%2) в программе.
				           |Поиск мест использования может занять длительное время.'"),
				РеквизитыПредставление, МассивСсылок.Количество());
		КонецЕсли;
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("МассивСсылок", МассивСсылок);
	Параметры.Вставить("СинонимыРеквизитов", СинонимыРеквизитов);
	Параметры.Вставить("ЗаголовокДиалога", ЗаголовокДиалога);
	Параметры.Вставить("ОбработкаПродолжения", ОбработкаПродолжения);
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Проверить и разрешить'"));
	Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Отмена'"));
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ПроверитьСсылкиНаОбъектПослеПодтвержденияПроверки",
			ЗапретРедактированияРеквизитовОбъектовСлужебныйКлиент, Параметры),
		ТекстВопроса, Кнопки, , КодВозвратаДиалога.Да, ЗаголовокДиалога);
	
КонецПроцедуры

// Устанавливает разрешенность редактирования для тех реквизитов, описание которых подготовлено в форме.
//  Используется, когда доступность элементов формы изменяется самостоятельно, без
// использования функции УстановитьДоступностьЭлементовФормы.
//
// Параметры:
//  Форма        - ФормаКлиентскогоПриложения - форма, в которой требуется разрешить редактирование реквизитов объекта, где:
//    * Элементы - ВсеЭлементыФормы:
//        ** РазрешитьРедактированиеРеквизитовОбъекта - КнопкаФормы
//  Реквизиты    - Массив из Строка - имена реквизитов, которые нужно пометить как разрешенные для изменения.
//  РедактированиеРазрешено - Булево - значение разрешенности редактирования реквизитов, которое нужно установить.
//                            Значение не будет установлено в Истина, если нет права редактирования реквизита.
//                          - Неопределено - не изменять разрешенность редактирования реквизитов.
//  ПравоРедактирования - Булево - позволяет переопределить или доопределить возможность разблокировки
//                        реквизитов, которая вычисляется автоматически с помощью метода ПравоДоступа.
//                      - Неопределено - не изменять свойство ПравоРедактирования.
// 
Процедура УстановитьРазрешенностьРедактированияРеквизитов(Знач Форма, Знач Реквизиты,
			Знач РедактированиеРазрешено = Истина, Знач ПравоРедактирования = Неопределено) Экспорт
	
	Если ТипЗнч(Реквизиты) = Тип("Массив") Тогда
		
		Для Каждого Реквизит Из Реквизиты Цикл
			ОписаниеРеквизита = Форма.ПараметрыЗапретаРедактированияРеквизитов.НайтиСтроки(Новый Структура("ИмяРеквизита", Реквизит))[0];
			Если ТипЗнч(ПравоРедактирования) = Тип("Булево") Тогда
				ОписаниеРеквизита.ПравоРедактирования = ПравоРедактирования;
			КонецЕсли;
			Если ТипЗнч(РедактированиеРазрешено) = Тип("Булево") Тогда
				ОписаниеРеквизита.РедактированиеРазрешено = ОписаниеРеквизита.ПравоРедактирования И РедактированиеРазрешено;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Обновление доступности команды РазрешитьРедактированиеРеквизитовОбъекта.
	ВсеРеквизитыРазблокированы = Истина;
	
	Для каждого ОписаниеБлокируемогоРеквизита Из Форма.ПараметрыЗапретаРедактированияРеквизитов Цикл
		Если ОписаниеБлокируемогоРеквизита.ПравоРедактирования
		И НЕ ОписаниеБлокируемогоРеквизита.РедактированиеРазрешено Тогда
			ВсеРеквизитыРазблокированы = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ВсеРеквизитыРазблокированы Тогда
		Форма.Элементы.РазрешитьРедактированиеРеквизитовОбъекта.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает массив имен реквизитов, заданных в свойстве формы ПараметрыЗапретаРедактированияРеквизитов
// на основе имен реквизитов, указанных в модуле менеджера объекта, исключая реквизиты,
// у которых ПравоРедактирования = Ложь.
//
// Параметры:
//  Форма         - ФормаКлиентскогоПриложения - форма объекта с обязательным стандартным реквизитом "Объект".
//  ТолькоЗаблокированные - Булево - для вспомогательных целей можно задать Ложь, чтобы
//                  получить список всех видимых реквизитов, которые могут разблокироваться.
//  ТолькоВидимые - Булево - чтобы получить и разблокировать все реквизиты объекта, нужно указать Ложь.
//
// Возвращаемое значение:
//  Массив из Строка - имена реквизитов.
//
Функция Реквизиты(Знач Форма, Знач ТолькоЗаблокированные = Истина, ТолькоВидимые = Истина) Экспорт
	
	Реквизиты = Новый Массив;
	
	Для Каждого ОписаниеБлокируемогоРеквизита Из Форма.ПараметрыЗапретаРедактированияРеквизитов Цикл
		
		Если ОписаниеБлокируемогоРеквизита.ПравоРедактирования
		   И (    ОписаниеБлокируемогоРеквизита.РедактированиеРазрешено = Ложь
		      ИЛИ ТолькоЗаблокированные = Ложь) Тогда
			
			ДобавитьРеквизит = Ложь;
			Для Каждого БлокируемыйЭлементФормы Из ОписаниеБлокируемогоРеквизита.БлокируемыеЭлементы Цикл
				ЭлементФормы = Форма.Элементы.Найти(БлокируемыйЭлементФормы.Значение);
				Если ЭлементФормы <> Неопределено И (ЭлементФормы.Видимость Или НЕ ТолькоВидимые) Тогда
					ДобавитьРеквизит = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ДобавитьРеквизит Тогда
				Реквизиты.Добавить(ОписаниеБлокируемогоРеквизита.ИмяРеквизита);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Реквизиты;
	
КонецФункции

// Выводит предупреждение о том, что все видимые реквизиты разблокированы.
// Необходимость в предупреждении возникает, когда команда разблокировки
// остается включенной из-за наличия невидимых неразблокированных реквизитов.
//
// Параметры:
//  ОбработкаПродолжения - Неопределено - никаких действий после выполнения процедуры.
//                       - ОписаниеОповещения - оповещение, которое вызывается после выполнения процедуры.
//
Процедура ПоказатьПредупреждениеВсеВидимыеРеквизитыРазблокированы(ОбработкаПродолжения = Неопределено) Экспорт
	
	ПоказатьПредупреждение(ОбработкаПродолжения,
		НСтр("ru = 'Редактирование всех видимых реквизитов объекта уже разрешено.'"));
	
КонецПроцедуры

#КонецОбласти
