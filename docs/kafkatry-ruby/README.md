## Использование Kafka в качестве брокера сообщений

Для межсервисного взаимодействия планируется использовать брокер сообщений Kafka.

## Подготовка

```bash
make build
make db_setup
```

## Запуск

Для успешной работы необходимо подготовить кластер Kafka, запустить RoR-приложение и обработчик Kafka-сообщений

### Запуск кластера kafka

```bash
make up
```

Для того, чтобы понимать, что происходит внутри kafka, можно использовать redpanda-панель, которая будет доступна по пути http://localhost:8080/

Система администрирования приложения находится по ссылке http://localhost:3000/admin/

Отправить сообщение:

```bash
make send_message
```

или из консоли rails

```ruby
docker compose bundle exec -it server bundle exec rails c
> Karafka.producer.produce_sync(topic: 'example', payload: { 'ping' => 'pong' }.to_json)
```

## План работ

* регистрация kafka-сообщений в модели EventsMessage
* сервис-объект на отправку сообщений
* сервис-объект на регистрацию сообщений
* кнопка в active_admin на отправку уведомлений
* нужно подружить karafka с ActiveJob
* гем dotenv
* гем config
* тесты
* probe-роуты для Kubernetes
