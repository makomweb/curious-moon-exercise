with lows_by_week as (
    select year,
        week,
        min(altitude) as altitude
    from flyby_altitudes
    group by year,
        week
),
nadirs as (
    select low_time(altitude, year, week) as time_stamp,
        altitude
    from lows_by_week
)
select *
from nadirs;