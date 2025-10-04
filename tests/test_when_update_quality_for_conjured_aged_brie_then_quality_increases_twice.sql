BEGIN;
SELECT plan(1);

TRUNCATE TABLE item;
SELECT new_item('Conjured Aged Brie', 5, 10);

SELECT update_quality();

SELECT is(
    (SELECT quality::int FROM item LIMIT 1),
    12,
    'Conjured Aged Brie quality increases by 2 with age'
);

SELECT * FROM finish();
ROLLBACK;
