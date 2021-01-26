select name,
    mass_per_charge,
    time_stamp,
    inms.readings.altitude - nadir as distance
from inms.readings
    inner join flybys on analysis_window @> inms.readings.time_stamp
where flybys.id = 4;