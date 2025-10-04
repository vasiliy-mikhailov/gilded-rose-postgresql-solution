BEGIN;
SELECT plan(1);

TRUNCATE TABLE item;
SELECT new_item('Elixir of the Mongoose', 0, 0);

SELECT update_quality();

SELECT is(
    (SELECT quality::int FROM item LIMIT 1),
    0,
    'Expired normal item with quality 0 stays at 0'
);

SELECT * FROM finish();
ROLLBACK;
