drop table if exists teams;
select distinct(team) as description into teams
from import.master_plan;
alter table teams
add id serial primary key;