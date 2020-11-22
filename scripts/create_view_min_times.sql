drop materialized view if exists min_times cascade;
create materialized view min_times as
select public.mins.*,
    min(time_stamp) as low_time,
    min(time_stamp) + interval '20 seconds' as window_end,
    min(time_stamp) - interval '20 seconds' as window_start
from public.mins
    inner join time_altitudes ta on public.mins.year = ta.year
    and public.mins.week = ta.week
    and public.mins.nadir = ta.altitude
group by public.mins.week,
    public.mins.year,
    public.mins.nadir