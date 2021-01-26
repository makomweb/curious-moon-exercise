drop materialized view if exists mins cascade;
create materialized view mins as
select min(altitude) as nadir,
    year,
    week
from time_altitudes
group by year,
    week
order by year,
    week;