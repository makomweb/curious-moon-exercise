select public.mins_view.*,
    min(time_stamp) as low_time
from public.mins_view
    inner join time_altitudes ta on public.mins_view.year = ta.year
    and public.mins_view.week = ta.week
    and public.mins_view.nadir = ta.altitude
group by public.mins_view.week,
    public.mins_view.year,
    public.mins_view.nadir