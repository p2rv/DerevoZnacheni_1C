
&НаКлиенте
Процедура ОбойтиДерево(Команда)
	Отмеченные=ВернутьПомеченныеЭлементыРекурсивно(Дерево.ПолучитьЭлементы());
	Для каждого ОтмеченныйЭлемент из Отмеченные Цикл
		сообщение=Новый СообщениеПользователю();
		сообщение.Текст=ОтмеченныйЭлемент.ИБ+" "+ОтмеченныйЭлемент.Путь;
		сообщение.Сообщить();
	КонецЦикла;
КонецПроцедуры

// Параметры:
//  ЭлементДерева - ДанныеФормыЭлементДерева:
//      * Пометка   - Число  - обязательный реквизит дерева.
//      * ЭтоГруппа - Булево - обязательный реквизит дерева.
&НаКлиенте
Функция ВернутьПомеченныеЭлементыРекурсивно(ЭлементДерева)
	Отмеченные=новый Массив();
	Для каждого ВложенныйЭлемент Из ЭлементДерева Цикл
		Если ВложенныйЭлемент.Пометка Тогда
			Если ВложенныйЭлемент.Пометка=ПометкаФлажокУстановлен() Тогда
				Отмеченные.Добавить(ВложенныйЭлемент);
			КонецЕсли;
			ОтмеченныеПодчиненные=ВернутьПомеченныеЭлементыРекурсивно(ВложенныйЭлемент.ПолучитьЭлементы());
			Для каждого Элемент из ОтмеченныеПодчиненные Цикл
				Отмеченные.Добавить(Элемент);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	Возврат Отмеченные;	
КонецФункции

&НаКлиенте
Процедура СнятьФлажки(Команда)
	ПометитьВсеЭлементыДереваРекурсивно(Дерево, ПометкаФлажокНеУстановлен());
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	ПометитьВсеЭлементыДереваРекурсивно(Дерево, ПометкаФлажокУстановлен());
КонецПроцедуры

// Параметры:
//  ЭлементДерева - ДанныеФормыЭлементДерева:
//      * Пометка   - Число  - обязательный реквизит дерева.
//      * ЭтоГруппа - Булево - обязательный реквизит дерева.
//  ЗначениеПометки - Число - устанавливаемое значение.
&НаКлиентеНаСервереБезКонтекста
Процедура ПометитьВсеЭлементыДереваРекурсивно(ЭлементДерева, ЗначениеПометки)
	
	КоллекцияЭлементовДерева = ЭлементДерева.ПолучитьЭлементы();
	
	Для каждого ВложенныйЭлемент Из КоллекцияЭлементовДерева Цикл
		ВложенныйЭлемент.Пометка = ЗначениеПометки;
		ПометитьВсеЭлементыДереваРекурсивно(ВложенныйЭлемент, ЗначениеПометки);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДерево(Команда)
	ЗаполнитьДеревоНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоНаСервере()
	ДеревоРек = РеквизитФормыВЗначение("Дерево");
	ДеревоРек.Строки.Очистить();
	Для орг = 1 По 4 Цикл
		НоваяГруппа1 = ДеревоРек.Строки.Добавить();
		НоваяГруппа1.Пометка = 0;
		НоваяГруппа1.ИБ="Организация "+орг;
		НоваяГруппа1.Путь="";
		НоваяГруппа1.ЭтоГруппа=Истина;
		Для подр = 1 По 5 Цикл
			НовыйЭлемент1 = НоваяГруппа1.Строки.Добавить();
			НовыйЭлемент1.Пометка = 0;
			НовыйЭлемент1.ИБ="Подразделение_" + подр;
			НовыйЭлемент1.Путь=	СтрШаблон ("E:\bd\Орг_%1\Подразделение_%2", орг, подр);
			НовыйЭлемент1.ЭтоГруппа=Ложь;
		КонецЦикла;
	КонецЦикла;
	ЗначениеВРеквизитФормы(ДеревоРек,"Дерево");
КонецПроцедуры


&НаКлиенте
Процедура ДеревоПометкаПриИзменении(Элемент)
	ЭлементДерева = ТекущийЭлемент.ТекущиеДанные;
	ПриПометкеЭлементаДерева(ЭлементДерева);
КонецПроцедуры

// Параметры:
//  ЭлементДерева - ДанныеФормыЭлементДерева:
//      * Пометка   - Число  - обязательный реквизит дерева.
//      * ЭтоГруппа - Булево - обязательный реквизит дерева.
&НаКлиентеНаСервереБезКонтекста
Процедура ПриПометкеЭлементаДерева(ЭлементДерева)
	
	ЭлементДерева.Пометка = СледующееЗначениеПометкиЭлемента(ЭлементДерева);
	
	ПометитьВложенныеЭлементыРекурсивно(ЭлементДерева);
	ПометитьЭлементыРодителейРекурсивно(ЭлементДерева);
	
КонецПроцедуры

//Возращает правильное состояние (одно из трех) флажка.
// Параметры:
//  ЭлементДерева - ДанныеФормыЭлементДерева:
//      * Пометка   - Число  - обязательный реквизит дерева.
//      * ЭтоГруппа - Булево - обязательный реквизит дерева.
// Возвращаемое значение:
//	Число - 0 - Флажок не установлен.
// 			1 - Флажок установлен.
//			2 - Установлен квадрат. Устанавливается у группы, у которой среди вложенных элементов есть как Помеченные так и Не помеченные элементы 
//			Платформа делает постоянный цикл при изменении пометки,
//			т.е. совершает цикл: не помеченный - помеченный - квадрат - не помеченный.
//			Для разделов циклы:
//			1) 1-0-1-0-1...
//			2) 2-0-1-0-1-0-... т.е. с квадрата должен быть переход к неустановленному флажку.
//			Для элементов циклы:
//			1) 1-0-1-0-1-0...
&НаКлиентеНаСервереБезКонтекста
Функция СледующееЗначениеПометкиЭлемента(ЭлементДерева)
	
	// На момент проверки платформа уже изменила значение пометки.
	Если ЭлементДерева.ЭтоГруппа Тогда
		// Предыдущее значение пометки = 2 : Установлен квадрат.
		Если ЭлементДерева.Пометка = 0 Тогда
			Возврат ПометкаФлажокУстановлен();
		КонецЕсли;
	КонецЕсли;
	
	// Предыдущее значение пометки = 1 : Флажок установлен.
	Если ЭлементДерева.Пометка = 2 Тогда 
		Возврат ПометкаФлажокНеУстановлен();
	КонецЕсли;
	
	// Во всех остальных случаях - значение установленное платформой.
	Возврат ЭлементДерева.Пометка;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПометкаФлажокНеУстановлен()
	Возврат 0;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПометкаФлажокУстановлен()
	Возврат 1;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПометкаКвадрат()
	Возврат 2;
КонецФункции

// Параметры:
//  ЭлементДерева - ДанныеФормыЭлементДерева:
//      * Пометка   - Число  - обязательный реквизит дерева.
//      * ЭтоГруппа - Булево - обязательный реквизит дерева.
&НаКлиентеНаСервереБезКонтекста
Процедура ПометитьВложенныеЭлементыРекурсивно(ЭлементДерева)
	
	ВложенныеЭлементы = ЭлементДерева.ПолучитьЭлементы();
	
	Для каждого ВложенныйЭлемент Из ВложенныеЭлементы Цикл
		
		ВложенныйЭлемент.Пометка = ЭлементДерева.Пометка;
		ПометитьВложенныеЭлементыРекурсивно(ВложенныйЭлемент);
		
	КонецЦикла;
	
КонецПроцедуры

// Параметры:
//  ЭлементДерева - ДанныеФормыЭлементДерева:
//      * Пометка   - Число  - обязательный реквизит дерева.
//      * ЭтоГруппа - Булево - обязательный реквизит дерева.
&НаКлиентеНаСервереБезКонтекста
Процедура ПометитьЭлементыРодителейРекурсивно(ЭлементДерева)
	
	Родитель = ЭлементДерева.ПолучитьРодителя();
	
	Если Родитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементыРодителя = Родитель.ПолучитьЭлементы();
	Если ЭлементыРодителя.Количество() = 0 Тогда
		Родитель.Пометка = ПометкаФлажокУстановлен();
	ИначеЕсли ЭлементДерева.Пометка = ПометкаКвадрат() Тогда
		Родитель.Пометка = ПометкаКвадрат();
	Иначе
		Родитель.Пометка = ЗначениеПометкиОтносительноВложенныхЭлементов(Родитель);
	КонецЕсли;
	
	ПометитьЭлементыРодителейРекурсивно(Родитель);
	
КонецПроцедуры


// Параметры:
//  ЭлементДерева - ДанныеФормыЭлементДерева:
//      * Пометка   - Число  - обязательный реквизит дерева.
//      * ЭтоГруппа - Булево - обязательный реквизит дерева.
&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеПометкиОтносительноВложенныхЭлементов(ЭлементДерева)
	
	СостояниеВложенныхЭлементов = СостояниеВложенныхЭлементов(ЭлементДерева);
	
	ЕстьПомеченные   = СостояниеВложенныхЭлементов.ЕстьПомеченные;
	ЕстьНепомеченные = СостояниеВложенныхЭлементов.ЕстьНепомеченные;
	
	Если ЕстьПомеченные Тогда

		Если ЕстьНепомеченные Тогда
			Возврат ПометкаКвадрат();
		Иначе
			Возврат ПометкаФлажокУстановлен();
		КонецЕсли;

	КонецЕсли;

	Возврат ПометкаФлажокНеУстановлен();
	
КонецФункции

// Параметры:
//  ЭлементДерева - ДанныеФормыЭлементДерева:
//      * Пометка   - Число  - обязательный реквизит дерева.
//      * ЭтоГруппа - Булево - обязательный реквизит дерева.
&НаКлиентеНаСервереБезКонтекста
Функция СостояниеВложенныхЭлементов(ЭлементДерева)
	
	ВложенныеЭлементы = ЭлементДерева.ПолучитьЭлементы();
	
	ЕстьПомеченные   = Ложь;
	ЕстьНепомеченные = Ложь;
	
	Для каждого ВложенныйЭлемент Из ВложенныеЭлементы Цикл
		
		Если ВложенныйЭлемент.Пометка = ПометкаФлажокНеУстановлен() Тогда 
			ЕстьНепомеченные = Истина;
			Продолжить;
		КонецЕсли;
		
		Если ВложенныйЭлемент.Пометка = ПометкаФлажокУстановлен() Тогда 
			ЕстьПомеченные = Истина;
			
			Если ВложенныйЭлемент.ЭтоГруппа Тогда 
				
				// Для Группы допустимо иметь непомеченные в своем составе элементы,
				Состояние = СостояниеВложенныхЭлементов(ВложенныйЭлемент);
				ЕстьПомеченные   = ЕстьПомеченные   Или Состояние.ЕстьПомеченные;
				ЕстьНепомеченные = ЕстьНепомеченные Или Состояние.ЕстьНепомеченные;
			КонецЕсли;
			
			Продолжить;
		КонецЕсли;
		
		Если ВложенныйЭлемент.Пометка = ПометкаКвадрат() Тогда 
			ЕстьПомеченные   = Истина;
			ЕстьНепомеченные = Истина;
			Продолжить;
		КонецЕсли;
		
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("ЕстьПомеченные",   ЕстьПомеченные);
	Результат.Вставить("ЕстьНепомеченные", ЕстьНепомеченные);
	
	Возврат Результат;
	
КонецФункции