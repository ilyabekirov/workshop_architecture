# Индексация и поиск по базе данных

Это приложение попытка создать собственное решение для работы с библиотекой книг.

# Что такое inpx-индекс?

Файл с расширением inpx представляет собой архив inp-файлов, в которых располагаются списки книг.

## Где взять inpx-индекс или дамп?

Загрузить пример inpx-индека можно по [ссылке](https://drive.google.com/file/d/1_HaRCXqNngRX5CUmkxPkjrNBaFbE7iKQ/view?usp=sharing). Ниже описываются rake-задача по развертыванию библиотеки книг из inpx-файла в базу данных приложения. Однако, на маках на ARM-архитектуре гем parallel работает не важно, поэтому можно ориентироваться на готовый [SQL-дамп](https://drive.google.com/file/d/117DV_2fMGY4mEUqq41MuQTy7gNNGz6EF/view).

## Развертывание индекса

Прежде чем запускать полноценную rake-задачу по разбору inpx-файла и переноса его содержимого в базу данных можно запустить легковесную rake-задачу inpx:ls, которая извлекает содержимое inpx-файла и выводит его в стандартный поток вывода:

```bash
bundle exec rails inpx:ls['db/data/archive.inpx']
```

Допускает запуск rake-задачи без аргумента в квадратных скобках, в этом случае путь к inpx-файлу будет взят из файла db/data/archive.inpx (его туда необходимо предварительно положить).

```bash
bundle exec rails inpx:ls
```

В случае успешного выполнения предыдущей команды можно приступать к развертыванию базы данных из inpx-файл при помощи следующей rake-задачи

```bash
bundle exec rails inpx:rebuild['db/data/archive.inpx']
```

Аргумент так же можно опустить, если по пути db/data/archive.inpx будет размещен актуальный inpx-файл

```bash
bundle exec rails inpx:rebuild
```

# Переменные окружения

Переменные окружения лучше всего устанавливать в файле `.env`, который игнорируется правилами `.gitignore`. Файл можно создать из заготовки `.sample.env`.

* INPX_PATH - путь к inpx-файлу с индексом библиотеки, необходим для перестройки индекса в базе данных. По умолчанию db/data/archive.inpx
* ARCHIVES_FOLDER - путь к папке с архивами библиотеки. По умолчанию db/data/
* SQL_DUMP_PATH - путь к SQL-дампу, который разворачивается командой `bundle exec rails db:seed`
* SECRET_KEY_BASE - соль для шифрования данных, лучше всего генерировать командой `openssl rand -hex 64`
* DOCKER_COMPOSE_ARCHIVE_FOLDER - абсолютный путь к папке с архивами библиотеки. Необходим для запуска docker-compose, например, на NAS-сервере
* SEED_EMAIL - электронный адрес для создания первого администратора. Электронный адрес за одно выступает и паролем, который можно поменять в системе админстрирования.
* INDEX_CONCURRENT_PROCESSES - количество параллельных процессов при разборе inpx-файла. По умолчанию, равно удвоенному количеству ядер центрального процессора

# Запуск в docker-контейнере

Запуск приложения с базой данных в docker

```bash
docker compose up
```

Запуск с пересборкой образов

```bash
docker compose up --build
```

Развертывание базы данных из дампа

```bash
docker compose run web bundle exec rails db:seed
```

# Диаграммы

В папке docs находятся PlantUML-диаграмма для rake-задачи `inpx:rebuild`. Посмотреть диаграмму можно в [online-редакторе](https://www.planttext.com/).

* [docs/inpx-rebuild.puml](docs/inpx-rebuild.puml) - схема распараллеливания задач в rake-задаче `inpx:rebuild`

# Запуск проекта в docker

Запускаем проект командой

```bash
docker compose up -d
```

Создаем базу данных и прогоняем миграции

```bash
docker compose exec -it web bundle exec rails db:create db:migrate
```

(1) Далее, если есть дамп, можно воспользовать им:

```bash
docker compose exec -it web bundle exec rails db:seed
```

Если вы воспользовались существующим дампом, в нем уже имеется пользователь с логином и паролем igor@softtime.ru.

(2) Или можно запустить разворачивание inpx-индекса

```bash
docker compose exec -it web bundle exec rails inpx:rebuild
```

В последнем случае в системе не будет ни одного пользвателя, поэтому придется самостоятельно создать его через rails-консоль. Запускаем консоль

```bash
docker compose exec -it web bundle exec rails c
```

И создаем пользователя с нужными вам логином и паролем:

```bash
AdminUser.create!(email: 'igor@softtime.ru', password: '...')
```

# Переиндексация:
```bash
docker-compose exec web bundle exec rake elasticsearch:reindex_books
```
