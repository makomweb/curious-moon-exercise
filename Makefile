DB=enceladus
BUILD=${CURDIR}/build.sql
SCRIPTS=${CURDIR}/scripts
CSV='${CURDIR}/data/master_plan.csv'
INMS_CSV='${CURDIR}/data/inms.csv'
CREATE_TABLE=$(SCRIPTS)/create_table.sql
CREATE_IMNS_TABLE=$(SCRIPTS)/create_inms_table.sql

all: prepare
	@echo "Running all ... "
	psql -U postgres -d $(DB) -f $(SCRIPTS)/normalize.sql
	psql -U postgres -d $(DB) -f $(SCRIPTS)/view.sql

inms:
	@echo "Running imns ... "
	@cat $(CREATE_IMNS_TABLE) >> $(BUILD)
	@echo "COPY import.inms FROM $(INMS_CSV) DELIMITER ',' HEADER CSV;" >> $(BUILD)
	@echo "DELETE FROM import.inms WHERE sclk IS NULL or sclk = 'sclk';" >> $(BUILD)
	psql -U postgres -d $(DB) -f $(BUILD)

prepare:
	@echo "Running prepare ... "
	@cat $(CREATE_TABLE) >> $(BUILD)
	@echo "COPY import.master_plan FROM $(CSV) WITH DELIMITER ',' HEADER CSV;" >> $(BUILD)
	psql -U postgres -d $(DB) -f $(BUILD)

clean:
	@rm -rf $(BUILD)