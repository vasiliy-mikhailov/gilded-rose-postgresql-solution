BEGIN;
SELECT plan(1);

TRUNCATE TABLE item;
SELECT new_item('Aged Brie', -1, 10);

SELECT update_quality();

SELECT is(
    (SELECT quality::int FROM item LIMIT 1),
    12,
    'Aged Brie expired quality increases by 2'
);

SELECT * FROM finish();
ROLLBACK;
