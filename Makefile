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

normalize:
	psql -U postgres -d $(DB) -f $(SCRIPTS)/normalize.sql

clean:
	@rm -rf $(BUILD)