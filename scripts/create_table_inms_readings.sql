drop table if exists inms.readings;
select sclk::timestamp as time_stamp,
    source::text,
    mass_table,
    alt_t::numeric(9, 2) as altitude,
    mass_per_charge::numeric(6, 3),
    p_energy::numeric(7, 3),
    pythag(
        sc_vel_t_scx::numeric,
        sc_vel_t_scy::numeric,
        sc_vel_t_scz::numeric
    ) as relative_speed,
    c1counts::integer as high_counts,
    c2counts::integer as low_counts into inms.readings
from import.inms
order by time_stamp;
alter table inms.readings
add id serial primary key;