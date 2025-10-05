BEGIN;
SELECT plan(2);

TRUNCATE TABLE item;
SELECT new_item('Conjured Aged Brie', -1, 47);

SELECT update_quality();

-- Expected: quality increases by 4 (47 → 51, Conjured doubles +2 to +4, capped at 50), sell_in decreases by 1 (-1 → -2)
SELECT is(
    (SELECT quality::int FROM item WHERE name = 'Conjured Aged Brie'),
    50,
    'Expired Conjured Aged Brie quality increases by 4 (capped at 50)'
);
SELECT is(
    (SELECT sell_in::int FROM item WHERE name = 'Conjured Aged Brie'),
    -2,
    'Expired Conjured Aged Brie sell_in decreases by 1'
);

SELECT * FROM finish();
ROLLBACK;
