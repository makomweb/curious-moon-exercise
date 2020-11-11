DB=enceladus

BUILD=${CURDIR}/build.sql
SCRIPTS=${CURDIR}/scripts

CSV='${CURDIR}/data/master_plan.csv'
INMS_CSV='${CURDIR}/data/inms.csv'
CDA_CSV='${CURDIR}/data/cda.csv'
JPL_FLYBYS_CSV='${CURDIR}/data/jpl_flybys.csv'

CREATE_MASTER_PLAN_TABLE=$(SCRIPTS)/create_table_master_plan.sql
CREATE_IMNS_TABLE=$(SCRIPTS)/create_table_inms.sql
CREATE_CDA_TABLE=$(SCRIPTS)/create_table_cda.sql
CREATE_TABLE_JPL_FLYBYS=$(SCRIPTS)/create_table_jpl_flybys.sql

create_table_jpl_flybys:
	@echo "Creating table for JPL flybys ..."
	@cat $(CREATE_TABLE_JPL_FLYBYS) >> $(BUILD)
	@echo "COPY flybys FROM $(JPL_FLYBYS_CSV) DELIMITER ',' HEADER CSV;" >> $(BUILD)
	psql -U postgres -d $(DB) -f $(BUILD)

create_function_pythag:
	@echo "Creating function for Phythagoras ..."
	psql -U postgres -d $(DB) -f $(SCRIPTS)/create_function_pythag.sql

normalize_cda: create_table_cda
	@echo "Normalizing cda data ..."
	psql -U postgres -d $(DB) -f $(SCRIPTS)/normalize_cda.sql

create_table_cda: 
	@echo "Creating table for CDA ..."
	@cat $(CREATE_CDA_TABLE) >> $(BUILD)
	@echo "COPY import.cda FROM $(CDA_CSV) DELIMITER ',' HEADER CSV;" >> $(BUILD)
	psql -U postgres -d $(DB) -f $(BUILD)

create_table_flybys: create_function_lowtime
	@echo "Creating table for flybys ..."
	psql -U postgres -d $(DB) -f $(SCRIPTS)/create_table_flybys.sql

create_function_lowtime:
	@echo "Creating function for lowtime ..."
	psql -U postgres -d $(DB) -f $(SCRIPTS)/create_function_lowtime.sql

create_view_flyby_altitudes: import_inms
	@echo "Creating view for Enceladus flyby altitudes ..."
	psql -U postgres -d $(DB) -f $(SCRIPTS)/create_view_flyby_altitudes.sql

import_inms:
	@echo "Creating table for imns ..."
	@cat $(CREATE_IMNS_TABLE) >> $(BUILD)
	@echo "COPY import.inms FROM $(INMS_CSV) DELIMITER ',' HEADER CSV;" >> $(BUILD)
	@echo "DELETE FROM import.inms WHERE sclk IS NULL or sclk = 'sclk';" >> $(BUILD)
	psql -U postgres -d $(DB) -f $(BUILD)

create_view_enceladus_events: normalize_master_plan
	@echo "Creating view for Enceladus events ..."
	psql -U postgres -d $(DB) -f $(SCRIPTS)/create_view_enceladus_events.sql

normalize_master_plan: import_master_plan
	@echo "Normalize master plan data ..."
	psql -U postgres -d $(DB) -f $(SCRIPTS)/normalize_master_plan.sql

import_master_plan:
	@echo "Importing master plan data ..."
	@cat $(CREATE_MASTER_PLAN_TABLE) >> $(BUILD)
	@echo "COPY import.master_plan FROM $(CSV) WITH DELIMITER ',' HEADER CSV;" >> $(BUILD)
	psql -U postgres -d $(DB) -f $(BUILD)

clean:
	@rm -rf $(BUILD)