# language: ru

Функциональность: Выполнение произвольной команды

Как разработчик
Я хочу иметь возможность выполнять произвольные команды git
Чтобы мочь автоматизировать больше рутинных действий на OneScript

Контекст:
    Допустим Я создаю новый объект ГитРепозиторий
    И Я создаю временный каталог и сохраняю его в контекст
    И Я инициализирую репозиторий во временном каталоге

Сценарий: Выполнение произвольной команды
    Когда Я выполняю произвольную команду git "status"
    Тогда Вывод команды содержит "On branch master"
