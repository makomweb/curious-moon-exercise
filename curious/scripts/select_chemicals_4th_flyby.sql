select flybys.name,
    time_stamp,
    inms.readings.altitude,
    inms.chem_data.name as chem
from inms.readings
    inner join flybys on time_stamp >= flybys.window_start
    and time_stamp <= flybys.window_end
    inner join inms.chem_data on peak = mass_per_charge
where flybys.id = 4;