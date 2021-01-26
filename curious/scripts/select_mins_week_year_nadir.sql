select public.mins.*,
    min(time_stamp) as low_time
from public.mins
    inner join time_altitudes ta on public.mins.year = ta.year
    and public.mins.week = ta.week
    and public.mins.nadir = ta.altitude
group by public.mins.week,
    public.mins.year,
    public.mins.nadir