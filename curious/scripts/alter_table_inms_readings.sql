alter table inms.readings
add flyby_id int references flybys(id);
update inms.readings
set flyby_id = flybys.id
from flybys
where flybys.date = inms.readings.time_stamp::date;