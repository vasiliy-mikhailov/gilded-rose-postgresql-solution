BEGIN;
SELECT plan(2);

TRUNCATE TABLE item;
SELECT new_item('Conjured Mana Cake', 3, 6);

SELECT update_quality();

-- Expected: quality decreases by 2 (6 → 4, Conjured double degradation), sell_in by 1 (3 → 2)
SELECT is(
    (SELECT quality::int FROM item WHERE name = 'Conjured Mana Cake'),
    4,
    'Conjured Mana Cake quality decreases by 2'
);
SELECT is(
    (SELECT sell_in::int FROM item WHERE name = 'Conjured Mana Cake'),
    2,
    'Conjured Mana Cake sell_in decreases by 1'
);

SELECT * FROM finish();
ROLLBACK;
