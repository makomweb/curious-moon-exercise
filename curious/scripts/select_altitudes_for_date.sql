SELECT time_stamp,
    altitude
FROM flyby_altitudes
WHERE time_stamp::date = '2005-07-14'
ORDER BY time_stamp;