select min(altitude) as nadir,
    year,
    week
from time_altitudes
group by year,
    week
order by year,
    week