////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы Инкомсофт: Зарплата и кадры 11.0.
//
/////////////////////////////////////////////////////////////////////////////

#Область о //Последовательность действий при добавлении нового обновления ИБ:

//* Добавить в менеджере объекта экспортную процедуру с именем ИмяПроцедуры_11_0_0_0;
//* В этом модуле в процедуре ПриДобавленииОбработчиковОбновления указать обработчик
//* В этом модуле в процедуре ПриДобавленииПодсистемы установить новый номер конфигурации
//*  В этом модуле в процедуре ПриПодготовкеМакетаОписанияОбновлений указать новый номер
//версии конфигурации;	
//* Поднять номер версии в свойствах конфигураци; 
//см. п. 1;
//* В общем макете ОписаниеИзмененийСистемы, добавить описание изменения с нужно версией;

#КонецОбласти

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Получение сведений о библиотеке (или конфигурации).

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
//
// Параметры:
//  Описание - Структура - сведения о библиотеке:
//
//   Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                  Обработчики обновления таких библотек должны быть вызваны ранее
//                                  обработчиков обновления данной библиотеки.
//                                  При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                  порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                  в процедуре ПриДобавленииПодсистем общего модуля ПодсистемыКонфигурацииПереопределяемый.
//   РежимВыполненияОтложенныхОбработчиков - Строка - "Последовательно" - отложенные обработчики обновления выполняются
//                                    последовательно в интервале от номера версии информационной базы до номера
//                                    версии конфигурации включительно или "Параллельно" - отложенный обработчик после
//                                    обработки первой порции данных передает управление следующему обработчику, а после
//                                    выполнения последнего обработчика цикл повторяется заново.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя = "ИнкомсофтKANBAN";
	Описание.Версия = "1.0.0.1";  
	Описание.ИдентификаторИнтернетПоддержки = "incomsoft_kanban";
	Описание.РежимВыполненияОтложенныхОбработчиков = "Последовательно";

	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления информационной базы.

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - описание полей
//                                  см. в процедуре ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
// Шаблон: 
//	Обработчик = Обработчики.Добавить();
//	Обработчик.Версия = "<номер версии>";
//	Обработчик.Процедура = "<полное имя экспортной процедуры>";
//	Обработчик.НачальноеЗаполнение = {Истина|Ложь};
//	Обработчик.РежимВыполнения = {"Монопольно"|"Оперативно"|"Отложенно"};
//РежимВыполнения (Строка) – принимает одно из значений: "Монопольно", "Оперативно" и "Отложенно". 
//Если свойство не задано, то по умолчанию обработчик – монопольный.
//
//Монопольно – если обработчик обновления необходимо выполнять монопольно, в условиях отсутствия активных
//сеансов работы пользователей, 
//регламентных заданий, внешних соединений и подключений по веб-сервисам. В противном случае,
//обновление версии программы прерывается. 
//Подробнее см. Ограничения на использование монопольного режима обработчиков обновления
//
//Монопольные обработчики предназначены для обновления тех данных, обработка которых должна быть 
//обязательно завершена к моменту входа пользователей в программу. 
//Для сокращения времени простоя (ожидания обработки данных), рекомендуется большие объемы данных 
//обновлять отложенно (см. ниже).
//Примеры монопольных обработчиков: обработка небольшого объема данных текущего периода, активных позиций 
//номенклатуры и т.п.
//
//Если хотя бы один обработчик обновления конфигурации – монопольный, то все оперативные обработчики (см. далее) выполняются в монопольном режиме.
//
//В случае если обработчик обновления – обязательный (свойство Версия = «*»), то значение Монопольно 
//следует устанавливать только в тех случаях, 
//когда обработчик обновления должен программно определить, требуется ли монопольный режим для его выполнения:
//Такой обработчик вызывается дважды, в него передается параметр Параметры типа Структура, в котором 
//имеется свойство МонопольныйРежим (Булево)
//При первом вызове в режиме проверки, свойство МонопольныйРежим содержит значение Ложь.
//Код обработчика не должен модифицировать данные ИБ
//Если в ходе выполнения обработчика возникает необходимость внесения изменений в ИБ, обработчик должен
//установить значение свойства в Истина 
//и прекратить свое выполнение
//При втором вызове в режиме выполнения свойство МонопольныйРежим содержит значение Истина
//Код обработчик может модифицировать данные ИБ
//Изменение значения свойства в этом случае игнорируется
//
//Оперативно – если обработчик обновления необходимо выполнять не монопольно: при активных сеансах работы 
//пользователей, регламентных заданий, 
//внешних соединений и подключений через веб-сервисы.
//
//Оперативные обработчики следует применять в редких случаях, когда важно сократить время ожидания 
//пользователей при переходе 
//на исправительные релизы, которые не содержат изменений в структуре данных, и обновление на которые 
//должно выполняться динамически.
//
//Подробнее см. Оперативное обновление данных.
//Отложенно – если обработчик обновления необходимо выполнять в фоне после того, как завершено выполнение 
//монопольных (оперативных) обработчиков,и пользователям уже разрешен вход в программу.
//
//Отложенные обработчики предназначены для обработки той части данных ИБ, которые не препятствуют 
//пользователям начинать свою работу с новой версией программы, не дожидаясь завершения обработки этих данных.
//
//Примеры отложенных обработчиков: обработка больших архивов данных за закрытые/прошлые периоды, 
//неактивных позиций номенклатуры, различных данных, отключенных в данный момент функциональными опциями и т.п.
//
//Подробнее см. Отложенное обновление данных.
//
//Если в конфигурации (библиотеке) используется параллельный режим отложенного обновления 
//(в процедуре ПриДобавленииПодсистемы свойство РежимВыполненияОтложенныхОбработчиков = "Параллельно"), 
//то для написания отложенных обработчиков следует руководствоваться стандартом Параллельный режим отложенного обновления.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики./Добавить();
//  Обработчик.Версия              = "1.0.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_0_0_0";
//  Обработчик.РежимВыполнения     = "Монопольно";
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	//	1.0.0.1:
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия              = "1.0.0.1";
	Обработчик.Процедура           = "инкОбновлениеИнформационнойБазыСервер.Обновление_1_0_0_1";
	Обработчик.РежимВыполнения     = "Монопольно";
	Обработчик.НачальноеЗаполнение = Истина;       

	//	1.0.0.0:
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия              = "1.0.0.0";
	Обработчик.Процедура           = "инкОбновлениеИнформационнойБазыСервер.Обновление_1_0_0_0";
	Обработчик.РежимВыполнения     = "Монопольно";
	Обработчик.НачальноеЗаполнение = Истина;       

КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений в программе.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновления всех библиотек и конфигурации.
//           Макет можно дополнить или заменить.
//           См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Макет) Экспорт
	
	НомераВерсийДляОтображенияМассив = Новый Массив;
	НомераВерсийДляОтображенияМассив.Добавить("1.0.0.1");
	НомераВерсийДляОтображенияМассив.Добавить("1.0.0.0");
	
	Макет = ДокументОписаниеОбновлений(НомераВерсийДляОтображенияМассив);
	
КонецПроцедуры

// Формирует табличный документ с описанием изменений в версиях,
// которые соответствуют переданному списку версий Разделы.
//
Функция ДокументОписаниеОбновлений(Знач Разделы) 
	
	ДокументОписаниеОбновлений = Новый ТабличныйДокумент();
	Если Разделы.Количество() = 0 Тогда
		Возврат ДокументОписаниеОбновлений;
	КонецЕсли;
	
	МакетОписаниеОбновлений = Метаданные.ОбщиеМакеты.Найти("инкОписаниеИзмененийСистемы");
	Если МакетОписаниеОбновлений <> Неопределено Тогда
		МакетОписаниеОбновлений = ПолучитьОбщийМакет(МакетОписаниеОбновлений);
	Иначе
		Возврат Новый ТабличныйДокумент();
	КонецЕсли;
	
	Для Каждого Версия Из Разделы Цикл
		
		ВывестиОписаниеИзменений(Версия, ДокументОписаниеОбновлений, МакетОписаниеОбновлений);
		
	КонецЦикла;
	
	Возврат ДокументОписаниеОбновлений;
	
КонецФункции

// Вызывается перед процедурами-обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
 
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
//
// Параметры:
//   ПредыдущаяВерсия       - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсия          - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//                                             сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - (возвращаемое значение) если установить Истина,
//                                то будет вывена форма с описанием обновлений. По умолчанию, Истина.
//   МонопольныйРежим           - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
	
	Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
 
КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных,
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется,
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
 
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//                                           или "*", если нужно выполнять при переходе с любой конфигурации.
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации.
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
 
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура -
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь,
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода.
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации,
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина.
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации,
	
	Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
 
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Заполнение пустой ИБ

////////////////////////////////////////////////////////////////////////////////
// Обновление ИБ

// Вывести описания изменений в указанной версии.
//
// Параметры:
//  НомерВерсии  - Строка - номер версии, для которого выводится описание из макета
//                          табличного документа МакетОписаниеОбновлений в табличный документ.
//                          ДокументОписаниеОбновлений.
//
Процедура ВывестиОписаниеИзменений(Знач НомерВерсии, ДокументОписаниеОбновлений, МакетОписаниеОбновлений)
	
	Номер = СтрЗаменить(НомерВерсии, ".", "_");
	
	Если МакетОписаниеОбновлений.Области.Найти("Шапка" + Номер) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДокументОписаниеОбновлений.Вывести(МакетОписаниеОбновлений.ПолучитьОбласть("Шапка" + Номер));
	ДокументОписаниеОбновлений.НачатьГруппуСтрок("Версия" + Номер);
	ДокументОписаниеОбновлений.Вывести(МакетОписаниеОбновлений.ПолучитьОбласть("Версия" + Номер));
	ДокументОписаниеОбновлений.ЗакончитьГруппуСтрок();
	ДокументОписаниеОбновлений.Вывести(МакетОписаниеОбновлений.ПолучитьОбласть("Отступ"));
	
КонецПроцедуры

#КонецОбласти

