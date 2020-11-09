drop function if exists low_time(
    numeric,
    double precision,
    double precision
);
create function low_time(
    alt numeric,
    yr double precision,
    wk double precision,
    out timestamp without time zone
) as $$
select min(time_stamp) + ((max(time_stamp) - min(time_stamp)) / 2) as nadir
from flyby_altitudes
where flyby_altitudes.altitude = alt
    and flyby_altitudes.year = yr
    and flyby_altitudes.week = wk $$ language sql;