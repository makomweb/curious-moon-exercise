select inms.chem_data.name,
    sum(high_counts) as high_counts,
    sum(low_counts) as low_counts
from flybys
    inner join inms.readings on time_stamp >= flybys.window_start
    and time_stamp <= flybys.window_end
    inner join inms.chem_data on peak = mass_per_charge
where flybys.id = 4
group by inms.chem_data.name,
    flybys.speed
order by high_counts desc;