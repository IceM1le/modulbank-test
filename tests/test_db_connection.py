"""Smoke test: проверка подключения к PostgreSQL и выполнения базового запроса."""

import os

import psycopg


def test_db_connection():
    """
    Подключиться к настроенной базе данных и проверить выполнение запроса SELECT NOW(),
    который возвращает текущие дату и время.
    """
    connection = psycopg.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=int(os.getenv("DB_PORT", "5433")),
        dbname=os.getenv("DB_NAME", "test_db"),
        user=os.getenv("DB_USER", "test_user"),
        password=os.getenv("DB_PASSWORD", "test_password"),
        connect_timeout=5,
    )

    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT NOW()")
            row = cursor.fetchone()

        assert row is not None, "SELECT NOW() did not return a row"
        assert row[0] is not None, "SELECT NOW() returned NULL"
    finally:
        connection.close()
