BEGIN;
SELECT plan(1);

TRUNCATE TABLE item;
SELECT new_item('Aged Brie', -1, 49);

SELECT update_quality();

SELECT is(
    (SELECT quality::int FROM item LIMIT 1),
    50,
    'Aged Brie at 49 expired increases to 50 (only +1 due to cap)'
);

SELECT * FROM finish();
ROLLBACK;
