select count(1) as activity,
    teams.description
from events
    inner join teams on teams.id = team_id
where time_stamp::date = '2005-03-09'
    and target_id = 28;