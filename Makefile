DB=enceladus
BUILD=${CURDIR}/build.sql
CSV='${CURDIR}/master_plan.csv'

all: prepare
	psql -U postgres -d $(DB) -f $(BUILD)

prepare:
	@echo "starting build ..."

clean:
	@echo "clean ... done."