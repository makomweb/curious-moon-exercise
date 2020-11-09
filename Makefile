DB=enceladus

BUILD=${CURDIR}/build.sql
SCRIPTS=${CURDIR}/scripts
CSV='${CURDIR}/data/master_plan.csv'
INMS_CSV='${CURDIR}/data/inms.csv'
CDA_CSV='${CURDIR}/data/cda.csv'

CREATE_TABLE=$(SCRIPTS)/create_table.sql
CREATE_IMNS_TABLE=$(SCRIPTS)/create_inms_table.sql
CREATE_CDA_TABLE=$(SCRIPTS)/create_cda_table.sql

all: prepare
	@echo "Running all ..."
	psql -U postgres -d $(DB) -f $(SCRIPTS)/normalize.sql
	psql -U postgres -d $(DB) -f $(SCRIPTS)/view.sql

cda: 
	@echo "Creating CDA table ..."
	@cat $(CREATE_CDA_TABLE) >> $(BUILD)
	@echo "COPY import.cda FROM $(CDA_CSV) DELIMITER ',' HEADER CSV;" >> $(BUILD)
	psql -U postgres -d $(DB) -f $(BUILD)


flybys: function
	@echo "Creating flybys table ..."
	psql -U postgres -d $(DB) -f $(SCRIPTS)/create_flybys_table.sql

function:
	@echo "Creating low time function ..."
	psql -U postgres -d $(DB) -f $(SCRIPTS)/low_time_function.sql

flyby_view: imns
	@echo "Create flyby view ..."
	psql -U postgres -d $(DB) -f $(SCRIPTS)/create_flyby_altitudes_view.sql

inms:
	@echo "Running imns ..."
	@cat $(CREATE_IMNS_TABLE) >> $(BUILD)
	@echo "COPY import.inms FROM $(INMS_CSV) DELIMITER ',' HEADER CSV;" >> $(BUILD)
	@echo "DELETE FROM import.inms WHERE sclk IS NULL or sclk = 'sclk';" >> $(BUILD)
	psql -U postgres -d $(DB) -f $(BUILD)

prepare:
	@echo "Running prepare ..."
	@cat $(CREATE_TABLE) >> $(BUILD)
	@echo "COPY import.master_plan FROM $(CSV) WITH DELIMITER ',' HEADER CSV;" >> $(BUILD)
	psql -U postgres -d $(DB) -f $(BUILD)

clean:
	@rm -rf $(BUILD)