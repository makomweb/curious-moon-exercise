select (sclk::timestamp) as time_stamp,
    alt_t::numeric(10, 3) as altitude
from import.inms
where target = 'ENCELADUS'
    and alt_t IS NOT NULL;