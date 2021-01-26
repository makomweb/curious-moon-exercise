drop table if exists time_altitudes;
SELECT (sclk::timestamp) as time_stamp,
    alt_t::numeric(9, 2) as altitude,
    date_part('year',(sclk::timestamp)) as year,
    date_part('week',(sclk::timestamp)) week into time_altitudes
from import.inms
where target = 'ENCELADUS'
    and alt_t IS NOT NULL;