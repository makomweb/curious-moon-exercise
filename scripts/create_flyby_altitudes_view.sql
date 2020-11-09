drop materialized view if exists flyby_altitudes;
create materialized view flyby_altitudes as
select (sclk::timestamp) as time_stamp,
    alt_t::numeric(10, 3) as altitude
from import.inms
where target = 'ENCELADUS'
    and alt_t IS NOT NULL;