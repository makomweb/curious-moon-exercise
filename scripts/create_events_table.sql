drop table if exists events;
create table events(
    id serial primary key,
    time_stamp timestamptz not null,
    title varchar(500),
    description text,
    event_type_id int references event_types(id),
    target_id int references targets(id),
    team_id int references teams(id),
    request_id int references requests(id),
    spass_type_id int references spass_types(id)
);
insert into events(
        time_stamp,
        title,
        description,
        event_type_id,
        target_id,
        team_id,
        request_id,
        spass_type_id
    )
select import.master_plan.start_time_utc::timestamp,
    import.master_plan.title,
    import.master_plan.description,
    event_types.id as event_type_id,
    targets.id as target_id,
    teams.id as team_id,
    requests.id as request_id,
    spass_types.id as spass_type_id
from import.master_plan
    inner join event_types on event_types.description = import.master_plan.library_definition
    inner join targets on targets.description = import.master_plan.target
    inner join teams on teams.description = import.master_plan.team
    inner join requests on requests.description = import.master_plan.request_name
    inner join spass_types on spass_types.description = import.master_plan.spass_type;