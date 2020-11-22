select f.id,
    f.name,
    f.date,
    f.altitude,
    f.speed,
    mt.nadir,
    mt.year,
    mt.week,
    mt.low_time,
    mt.window_start,
    mt.window_end
from flybys f
    inner join public.min_times mt on date_part('year', f.date) = mt.year
    and date_part('week', f.date) = mt.week;