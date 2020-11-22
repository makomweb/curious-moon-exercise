-- create the table from the CTE
select * into flybys_2
from flybys_fixed
order by date;
-- add a primary key
alter table flybys_2
add primary key (id);
-- drop the flybys table
drop table flybys cascade;
drop table time_altitudes cascade;
-- rename flybys_2
alter table flybys_2
rename to flybys;
-- add a targeted field
alter table flybys
add targeted boolean not null default false;
-- set it
update flybys
set targeted = true
where id in (3, 5, 7, 17, 18, 21);