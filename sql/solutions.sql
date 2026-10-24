-- Схема (PostgreSQL):
-- clients      (client_id PK, full_name, city, registered_at DATE)
--
-- accounts     (account_id PK, client_id FK, currency,
--               opened_at DATE, closed_at DATE NULL)
--
-- transactions (tx_id PK, account_id FK, tx_date TIMESTAMP,
--               amount NUMERIC, tx_type)  -- tx_type: 'in' / 'out'

-- 1. Простая выборка.
-- Клиенты из Новосибирска, зарегистрированные в 2025 году, по дате регистрации.
SELECT c.client_id, c.full_name, c.city, c.registered_at
FROM clients AS c
WHERE c.city = 'Новосибирск'
  AND c.registered_at >= DATE '2025-01-01'
  AND c.registered_at < DATE '2026-01-01'
ORDER BY c.registered_at;

-- 2. Агрегация.
-- Количество открытых счетов в каждой валюте.
SELECT a.currency, COUNT(*) AS accounts_count
FROM accounts AS a
WHERE a.closed_at IS NULL
GROUP BY a.currency
ORDER BY accounts_count DESC;

-- 3. JOIN и агрегация.
-- Имя клиента и общая сумма входящих транзакций.
SELECT
    c.client_id,
    c.full_name,
    COALESCE(SUM(t.amount), 0) AS total_incoming
FROM clients AS c
LEFT JOIN accounts AS a
    ON a.client_id = c.client_id
LEFT JOIN transactions AS t
    ON t.account_id = a.account_id
   AND t.tx_type = 'in'
GROUP BY c.client_id, c.full_name
ORDER BY total_incoming DESC;

-- 4. Анти-джойн.
-- Клиенты без единого счёта.
SELECT c.client_id, c.full_name
FROM clients AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM accounts AS a
    WHERE a.client_id = c.client_id
);

-- 5. HAVING.
-- Клиенты, у которых больше двух счетов.
SELECT
    c.client_id,
    c.full_name,
    COUNT(a.account_id) AS accounts_count
FROM clients AS c
JOIN accounts AS a
    ON a.client_id = c.client_id
GROUP BY c.client_id, c.full_name
HAVING COUNT(a.account_id) > 2;

-- 6. Дубли.
-- Найти задвоенные транзакции (одинаковые account_id, tx_date, amount).
SELECT
    t.account_id,
    t.tx_date,
    t.amount,
    COUNT(*) AS duplicates_count
FROM transactions AS t
GROUP BY t.account_id, t.tx_date, t.amount
HAVING COUNT(*) > 1;

-- 7. Со звёздочкой: оконные функции.
-- Топ-3 клиентов по сумме исходящих транзакций в каждом месяце.
WITH monthly_totals AS (
    SELECT
        DATE_TRUNC('month', t.tx_date)::date AS month,
        a.client_id,
        SUM(t.amount) AS total_outgoing
    FROM transactions AS t
    JOIN accounts AS a
      ON a.account_id = t.account_id
    WHERE t.tx_type = 'out'
    GROUP BY DATE_TRUNC('month', t.tx_date)::date, a.client_id
),
ranked_clients AS (
    SELECT
        month,
        client_id,
        total_outgoing,
        ROW_NUMBER() OVER (
            PARTITION BY month
            ORDER BY total_outgoing DESC, client_id
        ) AS position
    FROM monthly_totals
)
SELECT
    r.month,
    c.client_id,
    c.full_name,
    r.total_outgoing,
    r.position
FROM ranked_clients AS r
JOIN clients AS c
  ON c.client_id = r.client_id
WHERE r.position <= 3
ORDER BY r.month, r.position;
