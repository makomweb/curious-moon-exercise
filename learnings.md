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
select 
date_part('year',time_stamp) as year,
date_part('week',time_stamp) as week, 
min(altitude) as altitude
from flyby_altitudes
group by 
year,
week
), nadirs as (
select (min(time_stamp) + (max(time_stamp) - min(time_stamp)) / 2) as nadir,
lows_by_week.altitude
from flyby_altitudes,lows_by_week
where flyby_altitudes.altitude = lows_by_week.altitude
and year = lows_by_week.year
and week = lows_by_week.week
group by lows_by_week.altitude
order by nadir
)
select nadir at time zone 'UTC', altitude 
from nadirs;
~~~