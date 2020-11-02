select date_part('year', date),
    to_char(time_stamp, 'DDD')
from enceladus_events
where event like '%closest%';