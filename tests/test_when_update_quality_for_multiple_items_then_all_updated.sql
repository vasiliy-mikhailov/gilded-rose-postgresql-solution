BEGIN;
SELECT plan(3);  -- 3 проверки для демонстрации множественности

TRUNCATE TABLE item;
SELECT new_item('foo', 10, 5);  -- Нормальный: -1 quality
SELECT new_item('Aged Brie', 5, 10);  -- +1 quality
SELECT new_item('Sulfuras, Hand of Ragnaros', 0, 80);  -- Без изменений

SELECT update_quality();

-- Проверяем первый (нормальный)
SELECT is((SELECT quality::int FROM item WHERE name = 'foo'), 4, 'normal item quality decreased by 1');
-- Проверяем второй (Aged Brie)
SELECT is((SELECT quality::int FROM item WHERE name = 'Aged Brie'), 11, 'Aged Brie quality increased by 1');
-- Проверяем третий (Sulfuras)
SELECT is((SELECT quality::int FROM item WHERE name = 'Sulfuras, Hand of Ragnaros'), 80, 'Sulfuras quality unchanged');

SELECT * FROM finish();
ROLLBACK;
