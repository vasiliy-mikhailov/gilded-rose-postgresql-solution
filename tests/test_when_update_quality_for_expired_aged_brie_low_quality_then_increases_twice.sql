BEGIN;
SELECT plan(1);

TRUNCATE TABLE item;
SELECT new_item('Aged Brie', -1, 48);  -- Просрочен, quality=48 (<49, чтобы после main +1 было <50)

SELECT update_quality();

-- Основной +1 (до 49), expired +1 (до 50)
SELECT is(
    (SELECT quality::int FROM item LIMIT 1),
    50,
    'Expired Aged Brie with low quality increases twice (main + expired)'
);

SELECT * FROM finish();
ROLLBACK;
