BEGIN;
SELECT plan(2);

TRUNCATE TABLE item;
SELECT new_item('Elixir of the Mongoose', 5, 7);

SELECT update_quality();

-- Expected: quality decreases by 1 (7 → 6), sell_in by 1 (5 → 4)
SELECT is(
    (SELECT quality::int FROM item WHERE name = 'Elixir of the Mongoose'),
    6,
    'Normal item (Elixir of the Mongoose) quality decreases by 1'
);
SELECT is(
    (SELECT sell_in::int FROM item WHERE name = 'Elixir of the Mongoose'),
    4,
    'Normal item (Elixir of the Mongoose) sell_in decreases by 1'
);

SELECT * FROM finish();
ROLLBACK;
