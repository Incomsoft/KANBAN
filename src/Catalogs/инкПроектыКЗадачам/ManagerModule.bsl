Функция ПолучитьПервыйПроект() Экспорт
	
	ПроектСсылка = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкПроектыКЗадачам.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.инкПроектыКЗадачам КАК инкПроектыКЗадачам
		|ГДЕ
		|	НЕ инкПроектыКЗадачам.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ПроектСсылка = ВыборкаДетальныеЗаписи.Ссылка;
		Прервать;
	КонецЦикла;
	
	Возврат ПроектСсылка;
	
КонецФункции
