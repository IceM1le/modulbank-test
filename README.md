# Тестовое задание — стажёр Data Engineer / SQL-разработчик

Решение подготовлено для PostgreSQL и Python 3.11+.

## Состав проекта

- `docs/Отчет.docx` — Отчёт с ответами на теоретические вопросы.
- `sql/solutions.sql` — решения всех 7 SQL-задач.
- `tests/test_db_connection.py` — pytest-тест подключения и выполнения `SELECT NOW()`.
- `docker-compose.yml` — локальный PostgreSQL для воспроизводимого запуска.
- `requirements.txt` — Python-зависимости.
- `.env.example` — пример настроек подключения.
- `.gitignore` — исключает виртуальное окружение, кэш и локальный `.env`.

## Требования

- Python 3.11 или новее.
- Docker Desktop либо установленный PostgreSQL.

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

Команда с `-v` удаляет том с данными PostgreSQL.
