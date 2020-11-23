# List some or my SQL learnings

## Joining the targets table with the events

```
select targets.description as target,
time_stamp,
title
from events
inner join targets on target_id=targets.id;
```

## Filtering using WHERE

```
select targets.description as target,
time_stamp,
title
from events
inner join targets on target_id=targets.id
where title like '%flyby%' or title like '%fly by%';
```

and the case insensitve filtering using `ilike`

```
select targets.description as target,
time_stamp,
title
from events
inner join targets on target_id=targets.id
where title ilike '%flyby%' or title ilike '%fly by%';
```

## Improved join

```
select targets.description as target,
  event_types.description as event,
  time_stamp,
  time_stamp::date as date,
  title
from events
left join targets on target_id=targets.id
left join event_types on event_type_id=event_types.id
where title ilike '%flyby%'
or title ilike '%fly by%';
```

## Decorate with more data

```
select targets.description as target,
event_types.description as event,
time_stamp,
time_stamp::date as date,
title
from events
left join targets on target_id=targets.id
left join event_types on event_type_id=event_types.id
where title ilike '%flyby%'
or title ilike '%fly by%';
```

## Run a query from the scripts subfolder

Open Powershell.

Execute a shell on the Postgres Docker Container:

`docker exec -it curious-moon-postgres bas`

Use PSQL to run the SQL scripts:

`psql -U postgres -d enceladus -f ./scripts/query.sql`

## Select lowest altitudes per flyby

~~~
select
date_part('year',time_stamp) as year,
min(altitude) as nadir
from flyby_altitudes
group by year order by year;
~~~

(Comment to Rob: the group by clause can be simplified)

~~~
select
  date_part('year',time_stamp) as year,
  date_part('month',time_stamp) as month,
  min(altitude) as nadir
from flyby_altitudes
group by
  date_part('year',time_stamp),
  date_part('month',time_stamp);
~~~

can be simplified

~~~
select
date_part('year',time_stamp) as year,
date_part('month',time_stamp) as month,
min(altitude) as nadir
from flyby_altitudes
group by year, month;
~~~

~~~
select time_stamp::date as date,
min(altitude) as nadir
from flyby_altitudes
group by date order by date;
~~~

~~~
select
date_part('year',time_stamp) as year,
date_part('week',time_stamp) as week,
min(altitude) as altitude
from flyby_altitudes
group by
year, week;
~~~

## Get the timestamps when the flyby was closest

~~~
select time_stamp as nadir, altitude
from flyby_altitudes
where flyby_altitudes.altitude=28.576
and date_part('year', time_stamp) = 2008
and date_part('week', time_stamp) = 41;
~~~

Use a time window and calculate a midway point

~~~
select min(time_stamp) + (max(time_stamp) - min(time_stamp)) / 2 as nadir, altitude
from flyby_altitudes
where flyby_altitudes.altitude = 28.576
and date_part('year', time_stamp) = 2008
and date_part('week', time_stamp) = 41
group by altitude;
~~~

Generalize the query using CTEs - so that it can output timestamps when every flyby was closest
simplified in the group by and where clauses

~~~
with lows_by_week as (
    select year, week, min(altitude) as altitude
    from flyby_altitudes
    group by year, week
),
nadirs as (
    select (min(time_stamp) + (max(time_stamp) - min(time_stamp)) / 2) as nadir, lows_by_week.altitude
    from flyby_altitudes, lows_by_week
    where flyby_altitudes.altitude = lows_by_week.altitude
        and flyby_altitudes.year = lows_by_week.year
        and flyby_altitudes.week = lows_by_week.week
    group by lows_by_week.altitude
    order by nadir
)
select nadir, altitude
from nadirs;
~~~

And with the stored function it can be simplified:

~~~
with lows_by_week as (
    select year,
        week,
        min(altitude) as altitude
    from flyby_altitudes
    group by year,
        week
),
nadirs as (
    select low_time(altitude, year, week) as time_stamp,
        altitude
    from lows_by_week
)
select *
from nadirs;
~~~

## Some queries

~~~
select impact_date,
pythag(x_velocity, y_velocity, z_velocity) as v_kms
from cda.impacts
where x_velocity <> -99.99
~~~

~~~
with kms as (
select impact_date as the_date,
date_part('month', time_stamp) as month,
date_part('year', time_stamp) as year,
pythag(x_velocity, y_velocity, z_velocity) as v_kms
from cda.impacts
where x_velocity <> -99.99
), speeds as (
select kms.*,
(v_kms * 60 * 60)::integer as kmh,
(v_kms * 60 * 60 * .621)::integer as mph
from kms
)
select * from speeds;
~~~

## Failure versus Success 

That’s why we test.

```
Failure is the best teacher, success is the worst.
```

It teaches you to be lazy and arrogant, believing you’re special. That’s not good work, that’s lazy luck.

## More queries: window functions, partitions, counts

```
select targets.description,
count(1) over (
partition by targets.description)
from events
inner join targets
on targets.id = target_id;
```

```
select targets.description,
count(1) over ()
from events
inner join targets on targets.id = target_id;
```

```
select
targets.description as target,
100.0 * ((count(1) over (partition by targets.description))::numeric / (count(1) over ())::numeric) as percent_of_mission
from events
inner join targets
on targets.id = target_id;
```

### Distribution per target

```
select
distinct(targets.description) as target,
100.0 * ((count(1) over (partition by targets.description))::numeric / (count(1) over ())::numeric) as percent_of_mission
from events
inner join targets on targets.id = target_id
order by percent_of_mission desc;
```

### Distribution per team

```
select
distinct(teams.description) as team,
100.0 * ((count(1) over (partition by teams.description))::numeric / (count(1) over ())::numeric) as percent_of_mission
from events
inner join teams on teams.id = team_id
order by percent_of_mission desc;
```

### Distribution min/max speeds

```
with kms as (
select impact_date as the_date,
date_part('month', time_stamp) as month,
date_part('year', time_stamp) as year,
pythag(x_velocity, y_velocity, z_velocity) as v_kms
from cda.impacts
where x_velocity <> -99.99
), speeds as (
select kms.*,
(v_kms * 60 * 60)::integer as kmh,
(v_kms * 60 * 60 * .621)::integer as mph
from kms
), rollup as (
select distinct(year, month), year, month,
max(mph) over (partition by month),
min(mph) over (partition by month)
from speeds
order by year, month
)
select * from rollup;
```

### Caculate C

```
select id, altitude,
(altitude + 252) as total_altitude, --b
((altitude + 252) / sind(73)) - 252 as target_altitude -- c
from flybys;
```

### Update flybys table with target_altitude

```
update flybys
set target_altitude=(
(altitude + 252) / sind(73)
) - 252;
```

### Update flybys table with transit_distance 

```
update flybys
set
transit_distance = (
(target_altitude + 252) * sind(17) * 2
);
```

### Query flyby_altitudes

```
select min(flyby_altitudes.time_stamp)
from flyby_altitudes
inner join flybys on flybys.time_stamp::date = flyby_altitudes.time_stamp::date
and flybys.target_altitude = flyby_altitudes.altitude
```

### Select altitutes for a given day if it is in a certain range

```
select * from flyby_altitudes
where time_stamp::date = '2005-02-17'
and altitude between 1200 and 1500
order by time_stamp;
```

### Fetch a row where the timestamp matches the time-range-window

Precondition: a column `analysis_window` of type time-range exists.
See Postgres `tsrange()` for details.

~~~
select name
from flybys
where analysis_window @> '2005-02-17 03:30:12.119'::timestamp;
~~~~