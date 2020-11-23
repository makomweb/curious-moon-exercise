create index concurrently idx_stamps on inms.readings(time_stamp)
where altitude is not null;