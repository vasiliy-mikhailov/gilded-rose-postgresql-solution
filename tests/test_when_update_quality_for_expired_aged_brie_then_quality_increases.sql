BEGIN;
SELECT plan(1);

TRUNCATE TABLE item;
SELECT new_item('Aged Brie', -1, 49);  -- Просрочен, quality <50

SELECT update_quality();

-- Качество увеличивает на 1 даже после истечения срока
SELECT is(
    (SELECT quality::int FROM item LIMIT 1),
    50,
    'Expired Aged Brie quality increases by 1'
);

SELECT * FROM finish();
ROLLBACK;
