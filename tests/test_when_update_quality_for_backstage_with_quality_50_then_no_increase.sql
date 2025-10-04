BEGIN;
SELECT plan(1);

TRUNCATE TABLE item;
SELECT new_item('Backstage passes to a TAFKAL80ETC concert', 10, 50);

SELECT update_quality();

SELECT is(
    (SELECT quality::int FROM item LIMIT 1),
    50,
    'Backstage passes with quality 50 does not increase'
);

SELECT * FROM finish();
ROLLBACK;
