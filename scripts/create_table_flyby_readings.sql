drop table if exists flyby_readings;
create table flyby_readings(
    reading_id int not null unique references inms.readings(id),
    flyby_id int not null references flybys(id),
    primary key(reading_id, flyby_id)
);
insert into flyby_readings(flyby_id, reading_id)
select flybys.id,
    inms.readings.id
from flybys
    inner join inms.readings on date_part('year', time_stamp) = flybys.year
    and date_part('week', time_stamp) = flybys.week;