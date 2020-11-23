create index idx_stamps on inms.readings(time_stamp)
where altitude is not null;