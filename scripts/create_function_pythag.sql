drop function if exists pythag(numeric, numeric, numeric);
create function pythag(
    x numeric,
    y numeric,
    z numeric,
    out numeric
) as $$
select sqrt((x * x) + (y * y) + (z * z))::numeric(10, 2);
$$ language sql;