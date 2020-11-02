drop view if exists enceladus_events;
create view enceladus_events as
select events.id,
    events.title,
    events.description,
    events.time_stamp,
    events.time_stamp::date as date,
    event_types.description as event,
    to_tsvector(events.description) as search
from events
    inner join event_types on event_types.id = events.event_type_id
where target_id = 40
order by time_stamp;