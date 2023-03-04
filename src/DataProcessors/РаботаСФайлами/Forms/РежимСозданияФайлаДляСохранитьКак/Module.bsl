///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КопияФайла = Параметры.Файл;
	Сообщение = Параметры.Сообщение;
	
	РежимСозданияФайла = 1;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьФайл(Команда)
	
	Закрыть(РежимСозданияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталог(Команда)
	
	РаботаСФайламиСлужебныйКлиент.ОткрытьПроводникСФайлом(КопияФайла);
	
КонецПроцедуры

#КонецОбласти
