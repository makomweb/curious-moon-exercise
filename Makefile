DB=enceladus
CREATE_TABLE=${CURDIR}/create_table.sql
BUILD=${CURDIR}/build.sql
CSV='${CURDIR}/master_plan.csv'

all: prepare
	psql -U postgres -d $(DB) -f $(BUILD)

prepare:
	@cat $(CREATE_TABLE) >> $(BUILD)
	@echo "COPY import.master_plan(date, team, target, title, description) FROM $(CSV) WITH DELIMITER ',' HEADER CSV;" >> $(BUILD)

clean:
	@rm -rf $(BUILD)