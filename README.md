# Тестовое задание — стажёр Data Engineer / SQL-разработчик

Решение подготовлено для PostgreSQL и Python 3.11+.

## Состав проекта

- `docs/theory.md` — ответы на теоретические вопросы.
- `sql/solutions.sql` — решения всех 7 SQL-задач.
- `tests/test_db_connection.py` — pytest-тест подключения и выполнения `SELECT NOW()`.
- `docker-compose.yml` — локальный PostgreSQL для воспроизводимого запуска.
- `requirements.txt` — Python-зависимости.
- `.env.example` — пример настроек подключения.
- `.gitignore` — исключает виртуальное окружение, кэш и локальный `.env`.

## Требования

- Python 3.11 или новее.
- Docker Desktop (рекомендуемый вариант) либо установленный PostgreSQL.
- Git — необязательно для локального запуска, но рекомендуется для публикации решения.

## Быстрый запуск на Windows (PowerShell)

1. Установите и запустите Docker Desktop.
2. В корне проекта запустите базу:

   ```powershell
   docker compose up -d
   docker compose ps
   ```

3. Создайте виртуальное окружение и установите зависимости:

   ```powershell
   py -m venv .venv
   .\.venv\Scripts\Activate.ps1
   python -m pip install -r requirements.txt
   ```

   Если PowerShell блокирует активацию, можно запускать Python напрямую:
   `.venv\Scripts\python.exe -m pip install -r requirements.txt`
   и затем `.venv\Scripts\python.exe -m pytest -v`.

4. Скопируйте `.env.example` в `.env`. Для запуска с настройками по умолчанию это необязательно.
5. Запустите тест:

   ```powershell
   python -m pytest -v
   ```

Ожидаемый результат — `1 passed`. Точный вывод зависит от версии pytest.

## Проверка неверного пароля

В PowerShell:

```powershell
$env:DB_PASSWORD = "wrong_password"
python -m pytest -v
```

Тест должен упасть с ошибкой аутентификации. Это ожидаемая проверка негативного сценария, а не ошибка решения.

Затем верните корректный пароль:

```powershell
$env:DB_PASSWORD = "test_password"
python -m pytest -v
```

Переменные окружения текущего терминала имеют приоритет над `.env` и настройками по умолчанию.

## Остановка базы

```powershell
docker compose down
```

Чтобы удалить также данные тестовой БД:

```powershell
docker compose down -v
```

Команда с `-v` удаляет том с данными PostgreSQL. Используйте её только для этой тестовой базы.

## Публикация в GitHub

GitHub не обязателен, если работодатель принимает архив, но публичный репозиторий удобен для проверки решения.

1. Создайте новый пустой репозиторий на GitHub, например `modulbank-sql-intern-test`.
2. Не добавляйте на GitHub пароли, реальные персональные данные или `.env`.
3. В терминале из корня проекта:

   ```powershell
   git init
   git add README.md .gitignore .env.example docker-compose.yml requirements.txt docs sql tests
   git commit -m "Complete SQL internship test assignment"
   git branch -M main
   git remote add origin https://github.com/<YOUR_USERNAME>/modulbank-sql-intern-test.git
   git push -u origin main
   ```

   Замените `<YOUR_USERNAME>` на свой GitHub username. Если Git попросит авторизацию, войдите в GitHub через предложенный способ.

4. Откройте репозиторий в браузере и проверьте, что файлы видны, а `.env` отсутствует.
5. Отправьте в Telegram `@alinaigosheva` ссылку на резюме и ссылку на репозиторий. Если просят именно выполненное ТЗ файлом, дополнительно прикрепите архив.

## Важные замечания

- SQL-запросы рассчитаны на схему из задания. Их можно выполнить в PostgreSQL после создания соответствующих таблиц.
- Запрос о дублях ищет совпадающие группы по `account_id`, `tx_date`, `amount`, но одинаковые значения сами по себе не доказывают ошибочность транзакций.
- В задаче с топ-3 используется `ROW_NUMBER()`, поэтому на каждый месяц возвращается не более трёх клиентов.
- Тест БД проверяет доступность подключения и успешное выполнение простого запроса, а не корректность всей бизнес-логики.
