select speed,
    avg(relative_speed)::numeric(9, 1)
from flybys
    inner join inms.readings on time_stamp >= flybys.window_start
    and time_stamp <= flybys.window_end
group by speed;