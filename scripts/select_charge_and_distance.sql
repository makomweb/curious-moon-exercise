select name,
    mass_per_charge,
    time_stamp,
    inms.readings.altitude - nadir as distance
from inms.readings
    inner join flybys on time_stamp >= window_start
    and time_stamp <= window_end
where flybys.id = 4;