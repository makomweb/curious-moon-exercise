with lows_by_week as (
    select year, week, min(altitude) as altitude
    from flyby_altitudes
    group by year, week
),
nadirs as (
    select (min(time_stamp) + (max(time_stamp) - min(time_stamp)) / 2) as nadir, lows_by_week.altitude
    from flyby_altitudes, lows_by_week
    where flyby_altitudes.altitude = lows_by_week.altitude
        and flyby_altitudes.year = lows_by_week.year
        and flyby_altitudes.week = lows_by_week.week
    group by lows_by_week.altitude
    order by nadir
)
select nadir, altitude
from nadirs;