alter table flybys
add analysis_window tsrange;
update flybys
set analysis_window = tsrange(window_start, window_end, '[]');