BEGIN;
SELECT plan(1);

TRUNCATE TABLE item;
SELECT new_item('Sulfuras, Hand of Ragnaros', -5, 80);  -- Просрочен сильно

SELECT update_quality();

-- SellIn не меняется, quality=80
SELECT is(
    (SELECT quality::int FROM item LIMIT 1),
    80,
    'Expired Sulfuras quality and sell_in unchanged'
);

SELECT * FROM finish();
ROLLBACK;
