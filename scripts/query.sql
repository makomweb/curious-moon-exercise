-- find the thermal results
select id, date, title
from enceladus_events
where date between '2005-02-01'::date and '2005-02-28'::date
and search @@ to_tsquery('thermal');