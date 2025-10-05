BEGIN;
SELECT plan(2);

TRUNCATE TABLE item;
SELECT new_item('+5 Dexterity Vest', 10, 20);

SELECT update_quality();

-- Expected: quality decreases by 1 (20 → 19), sell_in by 1 (10 → 9)
SELECT is(
    (SELECT quality::int FROM item WHERE name = '+5 Dexterity Vest'),
    19,
    'Normal item (+5 Dexterity Vest) quality decreases by 1'
);
SELECT is(
    (SELECT sell_in::int FROM item WHERE name = '+5 Dexterity Vest'),
    9,
    'Normal item (+5 Dexterity Vest) sell_in decreases by 1'
);

SELECT * FROM finish();
ROLLBACK;
