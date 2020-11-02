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

##
