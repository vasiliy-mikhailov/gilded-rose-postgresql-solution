CREATE OR REPLACE FUNCTION decrease_quality(p_quality numeric, p_delta integer)
RETURNS numeric
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN GREATEST(p_quality - p_delta, 0);
END;
$$;

CREATE OR REPLACE FUNCTION increase_quality(p_quality numeric, p_delta integer)
RETURNS numeric
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN LEAST(p_quality + p_delta, 50);
END;
$$;

CREATE OR REPLACE FUNCTION update_normal(p_quality numeric, p_sell_in numeric, p_is_conjured boolean)
RETURNS TABLE(new_quality numeric, new_sell_in numeric)
LANGUAGE plpgsql
AS $$
DECLARE
  l_new_sell_in numeric := p_sell_in - 1;
  l_delta integer := CASE WHEN p_is_conjured THEN 2 ELSE 1 END;
  l_total_delta integer := l_delta + (CASE WHEN l_new_sell_in < 0 THEN l_delta ELSE 0 END);
BEGIN
  RETURN QUERY SELECT decrease_quality(p_quality, l_total_delta), l_new_sell_in;
END;
$$;

CREATE OR REPLACE FUNCTION update_aged_brie(p_quality numeric, p_sell_in numeric, p_is_conjured boolean)
RETURNS TABLE(new_quality numeric, new_sell_in numeric)
LANGUAGE plpgsql
AS $$
DECLARE
  l_new_sell_in numeric := p_sell_in - 1;
  l_delta integer := CASE WHEN p_is_conjured THEN 2 ELSE 1 END;
  l_total_delta integer := l_delta + (CASE WHEN l_new_sell_in < 0 THEN l_delta ELSE 0 END);
BEGIN
  RETURN QUERY SELECT increase_quality(p_quality, l_total_delta), l_new_sell_in;
END;
$$;

CREATE OR REPLACE FUNCTION update_backstage_passes(p_quality numeric, p_sell_in numeric, p_is_conjured boolean)
RETURNS TABLE(new_quality numeric, new_sell_in numeric)
LANGUAGE plpgsql
AS $$
DECLARE
  l_new_quality numeric := p_quality;
  l_new_sell_in numeric := p_sell_in - 1;
  l_delta integer := CASE WHEN p_is_conjured THEN 2 ELSE 1 END;
  l_extra integer := 0;
BEGIN
  l_new_quality := increase_quality(l_new_quality, l_delta);
  IF p_sell_in < 11 THEN l_extra := l_extra + l_delta; END IF;
  IF p_sell_in < 6 THEN l_extra := l_extra + l_delta; END IF;
  l_new_quality := increase_quality(l_new_quality, l_extra);
  IF l_new_sell_in < 0 THEN
    l_new_quality := 0;
  END IF;
  RETURN QUERY SELECT l_new_quality, l_new_sell_in;
END;
$$;

CREATE OR REPLACE FUNCTION update_sulfuras(p_quality numeric, p_sell_in numeric, p_is_conjured boolean)
RETURNS TABLE(new_quality numeric, new_sell_in numeric)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY SELECT p_quality, p_sell_in;
END;
$$;

CREATE OR REPLACE FUNCTION update_quality()
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  l_item RECORD;
  l_name item.name%TYPE;
  l_sell_in item.sell_in%TYPE;
  l_quality item.quality%TYPE;
  l_base_name text;
  l_is_conjured boolean;
  l_new_quality numeric;
  l_new_sell_in numeric;
BEGIN
  FOR l_item IN SELECT name, sell_in, quality, ctid FROM item FOR UPDATE LOOP
    l_name := l_item.name; l_sell_in := l_item.sell_in; l_quality := l_item.quality;
    l_is_conjured := LEFT(l_name, 9) = 'Conjured ';
    l_base_name := CASE WHEN l_is_conjured THEN SUBSTRING(l_name FROM 10) ELSE l_name END;
    CASE
      WHEN l_base_name = 'Sulfuras, Hand of Ragnaros' THEN SELECT * FROM update_sulfuras(l_quality, l_sell_in, l_is_conjured) INTO l_new_quality, l_new_sell_in;
      WHEN l_base_name = 'Aged Brie' THEN SELECT * FROM update_aged_brie(l_quality, l_sell_in, l_is_conjured) INTO l_new_quality, l_new_sell_in;
      WHEN l_base_name = 'Backstage passes to a TAFKAL80ETC concert' THEN SELECT * FROM update_backstage_passes(l_quality, l_sell_in, l_is_conjured) INTO l_new_quality, l_new_sell_in;
      ELSE SELECT * FROM update_normal(l_quality, l_sell_in, l_is_conjured) INTO l_new_quality, l_new_sell_in;
    END CASE;
    UPDATE item SET name = l_name, sell_in = l_new_sell_in, quality = l_new_quality WHERE ctid = l_item.ctid;
  END LOOP;
END;
$$;
