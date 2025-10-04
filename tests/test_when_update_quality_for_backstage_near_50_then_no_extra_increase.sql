BEGIN;
SELECT plan(1);

TRUNCATE TABLE item;
SELECT new_item('Backstage passes to a TAFKAL80ETC concert', 4, 49);  -- <6 дней, quality близко к 50

SELECT update_quality();

-- Базовое +1, но вторая +1 не применяется (quality >=50 после первой)
SELECT is(
    (SELECT quality::int FROM item LIMIT 1),
    50,
    'Backstage near 50 increases only once (no extra due to cap)'
);

SELECT * FROM finish();
ROLLBACK;
