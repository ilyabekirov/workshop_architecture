# Микросервисное шасси

Репозиторий содержит шаблон для генерации каркаса Rails приложения
Для того чтобы создать новое приложения используя шаблон нужно выполнить команду:

    rails new awesome-template -m library-template/template.rb

Для конфигурирования приложения предусмотрены следующие флаги:

- `--skip-rabbitmq` - без взаимодействия с RabbitMQ
- `--skip-active-admin` -  без панели администрирования
- `--skip-db` - без базы данных

    rails new liked --database=postgresql --skip-gits --skip-action-mailbox --skip-action-text --skip-action-cable --skip-hotwire --skip-jbuilder --skip-test --skip-system-test --skip-bootsnap --skip-ci --skip-kamal --skip-solid --skip-javascript --skip-git -m library-template/template.rb

# Компоненты шаблона

- `Gemfile`
- `.gitignore`

## Точки входа

Приложение имеет две точки входа. Пользователи могут обращаться к системе администрирования через HTTP, для этого запускается веб-сервер puma

```sh
bundle exec rails s
```

Кроме того, приложение слушает RabbitMQ-сообщения, для этого поднимается sneakers-обработчик 

```sh
bundle exec rails sneakers:run
```

## RabbitMQ

Панель управления RabbitMQ можно найти по ссылке http://localhost:15672/
