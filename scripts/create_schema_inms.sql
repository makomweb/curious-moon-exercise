drop schema if exists inms cascade;
create schema inms;
alter table chem_data
set schema inms;