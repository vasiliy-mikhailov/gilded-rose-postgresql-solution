BEGIN;
SELECT plan(1);

TRUNCATE TABLE item;
SELECT new_item('Backstage passes to a TAFKAL80ETC concert', 12, 20);

SELECT update_quality();

-- Увеличение на 2
SELECT is(
    (SELECT quality::int FROM item LIMIT 1),
    21,
    'Backstage quality increases by 1 when more than 10 days SellIn'
);

SELECT * FROM finish();
ROLLBACK;

