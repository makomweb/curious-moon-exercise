drop materialized view if exists mins_view cascade;
create materialized view mins_view as
select min(altitude) as nadir,
    year,
    week
from time_altitudes
group by year,
    week
order by year,
    week;