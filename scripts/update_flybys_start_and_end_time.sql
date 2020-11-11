update flybys
set start_time = (
        select min(time_stamp)
        from flyby_altitudes
        where flybys.time_stamp::date = flyby_altitudes.time_stamp::date
            and altitude < flybys.target_altitude + 0.75
            and altitude > flybys.target_altitude - 0.75
    );
update flybys
set end_time = (
        select max(time_stamp)
        from flyby_altitudes
        where flybys.time_stamp::date = flyby_altitudes.time_stamp::date
            and altitude < flybys.target_altitude + 0.75
            and altitude > flybys.target_altitude - 0.75
    );