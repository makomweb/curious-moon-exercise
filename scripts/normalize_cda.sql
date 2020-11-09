drop schema if exists cda cascade;
create schema cda;
select event_id::integer as id,
    impact_event_time::timestamp as time_stamp,
    impact_event_time::date as impact_date,
    case
        counter_number
        when '**' then null
        else counter_number::integer
    end as counter,
    spacecraft_sun_distance::numeric(6, 4) as sun_distance_au,
    spacecraft_saturn_distance::numeric(8, 2) as saturn_distance_rads,
    spacecraft_x_velocity::numeric(6, 2) as x_velocity,
    spacecraft_y_velocity::numeric(6, 2) as y_velocity,
    spacecraft_z_velocity::numeric(6, 2) as z_velocity,
    particle_charge::numeric(4, 1),
    particle_mass::numeric(4, 1)
from import.cda
order by impact_event_time::timestamp;