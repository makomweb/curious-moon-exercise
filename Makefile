DB=enceladus
BUILD=${CURDIR}/build.sql
SCRIPTS=${CURDIR}/scripts
CSV='${CURDIR}/data/master_plan.csv'
CREATE_TABLE=$(SCRIPTS)/create_table.sql

all: prepare
	psql -U postgres -d $(DB) -f $(BUILD)

prepare:
	@cat $(CREATE_TABLE) >> $(BUILD)
	@echo "COPY import.master_plan FROM $(CSV) WITH DELIMITER ',' HEADER CSV;" >> $(BUILD)

events:
	psql -U postgres -d $(DB) -f $(SCRIPTS)/create_events_table.sql

teams:
	psql -U postgres -d $(DB) -f $(SCRIPTS)/create_teams_table.sql
	
clean:
	@rm -rf $(BUILD)