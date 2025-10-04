BEGIN;
SELECT plan(1);

TRUNCATE TABLE item;
-- Нет вставки — таблица пуста

SELECT update_quality();  -- Цикл не войдёт в тело (0 итераций)

-- Проверяем, что ничего не сломано (кол-во строк = 0)
SELECT is(
    (SELECT count(*)::int FROM item),
    0,
    'update_quality handles empty inventory without changes'
);

SELECT * FROM finish();
ROLLBACK;
