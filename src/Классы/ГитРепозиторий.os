#Использовать asserts
#Использовать logos

Перем Лог;

Перем мВыводКоманды;
Перем ИмяФайлаИнформации;
Перем РабочийКаталог;
Перем ПутьКГит;

Перем ЭтоWindows;

/////////////////////////////////////////////////////////////////////////
// Программный интерфейс

/////////////////////////////////////////////////////////////////////////
// Процедуры-обертки над git

Процедура Инициализировать() Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("init");
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

Функция Статус() Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("status");
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
    Возврат ПолучитьВыводКоманды();
    
КонецФункции

Процедура ДобавитьФайлВИндекс(Знач ПутьКДобавляемомуФайлу) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("add");
    ПараметрыЗапуска.Добавить(ПутьКДобавляемомуФайлу);
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

Процедура Закоммитить(Знач ТекстСообщения, Знач ПроиндексироватьОтслеживаемыеФайлы = Ложь) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("commit");
    
    Если ПроиндексироватьОтслеживаемыеФайлы Тогда
        ПараметрыЗапуска.Добавить("-a");
    КонецЕсли;
    
    ПараметрыЗапуска.Добавить("-m");
    ПараметрыЗапуска.Добавить(ОбернутьВКавычки(ТекстСообщения));
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

Процедура ВывестиИсторию(Графически = Ложь) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("log");
    
    Если Графически Тогда
        ПараметрыЗапуска.Добавить("--graph");
    КонецЕсли;
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

Процедура Получить(Знач ИмяРепозитория = "", Знач ИмяВетки = "") Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("pull");
    
    Если ЗначениеЗаполнено(ИмяРепозитория) Тогда
        ПараметрыЗапуска.Добавить(ИмяРепозитория);
    КонецЕсли;
    
    Если ЗначениеЗаполнено(ИмяВетки) Тогда
        ПараметрыЗапуска.Добавить(ИмяВетки);
    КонецЕсли;
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

Процедура Отправить(Знач ИмяРепозитория = "", Знач ИмяВетки = "") Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("push");
    
    Если ЗначениеЗаполнено(ИмяРепозитория) Тогда
        ПараметрыЗапуска.Добавить(ИмяРепозитория);
    КонецЕсли;
    
    Если ЗначениеЗаполнено(ИмяВетки) Тогда
        ПараметрыЗапуска.Добавить(ИмяВетки);
    КонецЕсли;
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

// TODO: Потенциально bad-design. По-хорошему это не относится к объекту ГитРепозиторий, это что-то вроде ГитМенеджер.
//
Процедура КлонироватьРепозиторий(Знач ПутьУдаленномуРепозиторию, Знач КаталогКлонирования = "") Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("clone");
    ПараметрыЗапуска.Добавить(ПутьУдаленномуРепозиторию);
    
    Если ЗначениеЗаполнено(КаталогКлонирования) Тогда
        ПараметрыЗапуска.Добавить(ОбернутьВКавычки(КаталогКлонирования));
    КонецЕсли;
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

//////////////////////////////////////////////
// Работа с ветками

Функция ПолучитьТекущуюВетку() Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("symbolic-ref");
    ПараметрыЗапуска.Добавить("--short");
    ПараметрыЗапуска.Добавить("HEAD");
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
    ВыводКоманды = ПолучитьВыводКоманды();
    
    Возврат ВыводКоманды;
    
КонецФункции

// @unstable
//
Процедура ПерейтиВВетку(Знач ИмяВетки, Знач СоздатьНовую = Ложь) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("checkout");
    
    Если СоздатьНовую Тогда
        ПараметрыЗапуска.Добавить("-b");
    КонецЕсли;
    
    ПараметрыЗапуска.Добавить(ИмяВетки);
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

Процедура СоздатьВетку(Знач ИмяВетки) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("branch");    
    ПараметрыЗапуска.Добавить(ИмяВетки);
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

Функция ПолучитьСписокВеток(Знач ВключаяУдаленные = Ложь) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("branch");    
    
    Если ВключаяУдаленные Тогда
        ПараметрыЗапуска.Добавить("-a");    
    КонецЕсли;
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
    ВыводКоманды = ПолучитьВыводКоманды();
    
    ТаблицаВеток = Новый ТаблицаЗначений();
    ТаблицаВеток.Колонки.Добавить("Текущая");
    ТаблицаВеток.Колонки.Добавить("Имя");
    
    ЧислоСтрок = СтрЧислоСтрок(ВыводКоманды);
    
    Для сч = 1 По ЧислоСтрок Цикл
        
        Ветка = ТаблицаВеток.Добавить();
        
        Строка = СтрПолучитьСтроку(ВыводКоманды, сч);
        
        Ветка.Текущая = Лев(Строка, 1) = "*";
        
        Строка = Прав(Строка, СтрДлина(Строка) - 2);
        Ветка.Имя = Строка;
        
    КонецЦикла;
    
    Возврат ТаблицаВеток;
    
    
КонецФункции

// Работа с ветками
//////////////////////////////////////////////

//////////////////////////////////////////////
// Работа с внешними репозиториями

Процедура ДобавитьВнешнийРепозиторий(Знач ИмяРепозитория, Знач ПутьКРепозиторию) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("remote");
    ПараметрыЗапуска.Добавить("add");
    
    ПараметрыЗапуска.Добавить(ИмяРепозитория);
    ПараметрыЗапуска.Добавить(ПутьКРепозиторию);
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

Процедура УдалитьВнешнийРепозиторий(Знач ИмяРепозитория) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("remote");
    ПараметрыЗапуска.Добавить("remove");
    
    ПараметрыЗапуска.Добавить(ИмяРепозитория);
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

Функция ПолучитьСписокВнешнихРепозиториев() Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("remote");
    ПараметрыЗапуска.Добавить("-v");
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
    ВыводКоманды = ПолучитьВыводКоманды();
    
    ТаблицаВнешнихРепозиториев = Новый ТаблицаЗначений;
    ТаблицаВнешнихРепозиториев.Колонки.Добавить("Имя");
    ТаблицаВнешнихРепозиториев.Колонки.Добавить("Адрес");
    ТаблицаВнешнихРепозиториев.Колонки.Добавить("Режим");
    
    ЧислоСтрок = СтрЧислоСтрок(ВыводКоманды);
    
    Для сч = 1 По ЧислоСтрок Цикл
        
        ВнешнийРепозиторий = ТаблицаВнешнихРепозиториев.Добавить();
        
        Строка = СтрПолучитьСтроку(ВыводКоманды, сч);
        СимволТаб = СтрНайти(Строка, Символы.Таб);
        СимволПробел = СтрНайти(Строка, " ");
        
        ИмяВнешнегоРепозитория = Лев(Строка, СимволТаб - 1);
        АдресВнешнегоРепозитория = Сред(Строка, СимволТаб + 1, СимволПробел - СимволТаб - 1);
        РежимВнешнегоРепозитория = Прав(Строка, СтрДлина(Строка) - СимволПробел);
        РежимВнешнегоРепозитория = Сред(РежимВнешнегоРепозитория, 2, СтрДлина(РежимВнешнегоРепозитория) - 2);
        
        ВнешнийРепозиторий.Имя 		= ИмяВнешнегоРепозитория;
        ВнешнийРепозиторий.Адрес 	= АдресВнешнегоРепозитория;
        ВнешнийРепозиторий.Режим 	= РежимВнешнегоРепозитория;
        
    КонецЦикла;
    
    Возврат ТаблицаВнешнихРепозиториев;
    
КонецФункции

// Работа с внешними репозиториями
//////////////////////////////////////////////

//////////////////////////////////////////////
// Работа с подмодулями

Процедура ДобавитьПодмодуль(Знач АдресВнешнегоРепозитория, 
    Знач Местоположение = "",
    Знач Ветка = "",
    Знач ИмяПодмодуля = "") Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("submodule");
    ПараметрыЗапуска.Добавить("add");
    
    Если ЗначениеЗаполнено(Ветка) Тогда
        ПараметрыЗапуска.Добавить("-b");
        ПараметрыЗапуска.Добавить(Ветка);
    КонецЕсли;
    
    Если ЗначениеЗаполнено(ИмяПодмодуля) Тогда
        ПараметрыЗапуска.Добавить("--name");
        ПараметрыЗапуска.Добавить(ИмяПодмодуля);
    КонецЕсли;
    
    ПараметрыЗапуска.Добавить(АдресВнешнегоРепозитория);
    
    Если ЗначениеЗаполнено(Местоположение) Тогда
        ПараметрыЗапуска.Добавить(Местоположение);
    КонецЕсли;
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

Процедура ОбновитьПодмодули(Знач Инициализировать = Ложь, Знач Рекурсивно = Ложь) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("submodule");
    ПараметрыЗапуска.Добавить("update");
    
    Если Инициализировать Тогда
        ПараметрыЗапуска.Добавить("--init");
    КонецЕсли;
    
    Если Рекурсивно Тогда
        ПараметрыЗапуска.Добавить("--recursive");
    КонецЕсли;
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

Функция ПолучитьСостояниеПодмодулей() Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("submodule");
    ПараметрыЗапуска.Добавить("status");
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
    ВыводКоманды = ПолучитьВыводКоманды();
    
    ТаблицаПодмодулей = Новый ТаблицаЗначений;
    ТаблицаПодмодулей.Колонки.Добавить("ХэшКоммита");
    ТаблицаПодмодулей.Колонки.Добавить("Имя");
    ТаблицаПодмодулей.Колонки.Добавить("Указатель");
    
    ЧислоСтрок = СтрЧислоСтрок(ВыводКоманды);
    
    Для сч = 1 По ЧислоСтрок Цикл
        
        ДанныеПодмодуля = ТаблицаПодмодулей.Добавить();
        
        Строка = СтрПолучитьСтроку(ВыводКоманды, сч);
        Если ПустаяСтрока(Строка) Тогда
            Продолжить;
        КонецЕсли;
        
        ДанныеСтроки = СтрРазделить(Строка, " ");
        ДанныеПодмодуля.ХэшКоммита 	= ДанныеСтроки[0];
        ДанныеПодмодуля.Имя 		= ДанныеСтроки[1];
        ДанныеПодмодуля.Указатель 	= Сред(ДанныеСтроки[2], 2, СтрДлина(ДанныеСтроки[2]) - 2);
        
    КонецЦикла;
    
    Возврат ТаблицаПодмодулей;
    
КонецФункции

// Работа с подмодулями
//////////////////////////////////////////////

//////////////////////////////////////////////
// Работа с настройками git

Функция ПолучитьНастройку(Знач ИмяНастройки) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("config");    
    ПараметрыЗапуска.Добавить(ИмяНастройки);
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
    ВыводКоманды = СокрЛП(ПолучитьВыводКоманды());
    
    Возврат ВыводКоманды;
    
КонецФункции

Процедура УстановитьНастройку(Знач ИмяНастройки, Знач ЗначениеНастройки, Знач РежимУстановкиНастроек = Неопределено) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("config");
    
    Если РежимУстановкиНастроек <> Неопределено Тогда
        ПараметрыЗапуска.Добавить(РежимУстановкиНастроек);
    КонецЕсли;
    
    ПараметрыЗапуска.Добавить(ИмяНастройки);
    ПараметрыЗапуска.Добавить(ЗначениеНастройки);
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

Функция ПолучитьСписокНастроек(Знач РежимУстановкиНастроек = Неопределено) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("config");
    ПараметрыЗапуска.Добавить("--list");

    Если РежимУстановкиНастроек <> Неопределено Тогда
        ПараметрыЗапуска.Добавить(РежимУстановкиНастроек);
    КонецЕсли;
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
    ВыводКоманды = ПолучитьВыводКоманды();
    
    СписокНастроек = Новый Соответствие();
    
    ЧислоСтрок = СтрЧислоСтрок(ВыводКоманды);
    
    Для сч = 1 По ЧислоСтрок Цикл
        
        Строка = СтрПолучитьСтроку(ВыводКоманды, сч);
        СимволРавно = СтрНайти(Строка, "=");
        
        ИмяНастройки = Лев(Строка, СимволРавно - 1);
        ЗначениеНастройки = Прав(Строка, СтрДлина(Строка) - СимволРавно);
        
        СписокНастроек.Вставить(ИмяНастройки, ЗначениеНастройки);
        
    КонецЦикла;
    
    Возврат СписокНастроек;
    
КонецФункции

// Работа с настройками git
//////////////////////////////////////////////

Процедура ВыполнитьКоманду(Знач Параметры) Экспорт
    
    //NOTICE: https://github.com/oscript-library/v8runner 
    //Apache 2.0 
    
    ПроверитьВозможностьВыполненияКоманды();
    
    КодВозврата = ЗапуститьИПодождать(Параметры);
    Если КодВозврата <> 0 Тогда
        Лог.Ошибка("Получен ненулевой код возврата "+КодВозврата+". Выполнение скрипта остановлено!");
        ВызватьИсключение ПолучитьВыводКоманды();
    Иначе
        Лог.Отладка("Код возврата равен 0");
    КонецЕсли;
    
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////
// Работа со свойствами класса

Функция ПолучитьРабочийКаталог() Экспорт
    Возврат РабочийКаталог;
КонецФункции

Процедура УстановитьРабочийКаталог(Знач ПутьРабочийКаталог) Экспорт
    
    Файл_РабочийКаталог = Новый Файл(ПутьРабочийКаталог);
    Ожидаем.Что(Файл_РабочийКаталог.Существует(), СтрШаблон("Рабочий каталог <%1> не существует.", ПутьРабочийКаталог)).ЭтоИстина();
    
    РабочийКаталог = Файл_РабочийКаталог.ПолноеИмя;
    
КонецПроцедуры

Функция ПолучитьПутьКГит() Экспорт
    Возврат ПутьКГит;
КонецФункции

Процедура УстановитьПутьКГит(Знач Путь) Экспорт
    ПутьКГит = Путь;
КонецПроцедуры

Функция ПолучитьВыводКоманды() Экспорт
    Возврат мВыводКоманды;
КонецФункции

Процедура УстановитьВывод(Знач Сообщение)
    мВыводКоманды = Сообщение;
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////
// Служебные процедуры и функции

Процедура ПроверитьВозможностьВыполненияКоманды()
    
    Ожидаем.Что(ПолучитьРабочийКаталог(), "Рабочий каталог не установлен.").Заполнено();
    
    Лог.Отладка("РабочийКаталог: " + ПолучитьРабочийКаталог());
    
КонецПроцедуры

Функция ЗапуститьИПодождать(Знач Параметры)
    
    //NOTICE: https://github.com/oscript-library/v8runner 
    //Apache 2.0
    // ЗапуститьПриложение переделано на СоздатьПроцесс и чтение данных вывода 
    
    СтрокаЗапуска = "";
    СтрокаДляЛога = "";
    Для Каждого Параметр Из Параметры Цикл
        
        СтрокаЗапуска = СтрокаЗапуска + " " + Параметр;
        
        Если Лев(Параметр,2) <> "/P" и Лев(Параметр,25) <> "/ConfigurationRepositoryP" Тогда
            СтрокаДляЛога = СтрокаДляЛога + " " + Параметр;
        КонецЕсли;
        
    КонецЦикла;
    
    Приложение = ОбернутьВКавычки(ПолучитьПутьКГит());
    Лог.Отладка(Приложение + СтрокаДляЛога);
    
    Если ЭтоWindows = Ложь Тогда 
        СтрокаЗапуска = "sh -c '" + Приложение + СтрокаЗапуска + "'";
    Иначе
        СтрокаЗапуска = Приложение + СтрокаЗапуска;
    КонецЕсли;
    
    ЗаписьXML = Новый ЗаписьXML();
    ЗаписьXML.УстановитьСтроку();
    
    Процесс = СоздатьПроцесс(СтрокаЗапуска, РабочийКаталог, Истина, , КодировкаТекста.UTF8);
    Процесс.Запустить();
    
    Пока НЕ Процесс.Завершен ИЛИ Процесс.ПотокВывода.ЕстьДанные Цикл
        СтрокаВывода = "" + Процесс.ПотокВывода.ПрочитатьСтроку() + Символы.ПС;
        ЗаписьXML.ЗаписатьБезОбработки(СтрокаВывода);
    КонецЦикла;
    
    Если Процесс.КодВозврата <> 0 Тогда
        Лог.Ошибка("Код возврата: " + Процесс.КодВозврата);
        ТекстВывода = Процесс.ПотокОшибок.Прочитать();
        УстановитьВывод(ТекстВывода);
        ВызватьИсключение ТекстВывода;
    КонецЕсли;
    
    РезультатРаботыПроцесса = ЗаписьXML.Закрыть();
    УстановитьВывод(РезультатРаботыПроцесса);
    
    Возврат Процесс.КодВозврата;
    
КонецФункции

Функция ОбернутьВКавычки(Знач Строка)
    
    //NOTICE: https://github.com/oscript-library/v8runner 
    //Apache 2.0 
    
    Если Лев(Строка, 1) = """" и Прав(Строка, 1) = """" Тогда
        Возврат Строка;
    Иначе
        Возврат """" + Строка + """";
    КонецЕсли;
    
КонецФункции

Процедура Инициализация()
    
    Лог = Логирование.ПолучитьЛог("oscript.lib.gitrunner");
    
    СистемнаяИнформация = Новый СистемнаяИнформация;
    ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;
    
    УстановитьПутьКГит("git");
    
КонецПроцедуры

Инициализация();
