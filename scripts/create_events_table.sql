drop table if exists events;
create table events(
    id serial primary key,
    time_stamp timestamptz not null,
    title varchar(500),
    description text,
    event_type_id int,
    spass_type_id int,
    target_id int,
    team_id int,
    request_id int
);
insert into events(
        time_stamp,
        title,
        description
    )
select import.master_plan.start_time_utc::timestamptz at time zone 'UTC',
    import.master_plan.title,
    import.master_plan.description
from import.master_plan;