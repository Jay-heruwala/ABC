expdp mca10/mca10@orcl19 \
schemas=MCA10 \
include=TABLE \
directory=DATA_PUMP_DIR \
dumpfile=mca10_export.dmp \
logfile=mca10_export.log




impdp scott/tiger@orcl19 \
directory=DATA_PUMP_DIR \
dumpfile=mca10_export.dmp \
logfile=scott_import.log \
remap_schema=MCA10:SCOTT \
remap_tablespace=USERS:USERS




-- load data

sqlldr scott/tiger control=pan.ctl log=pan_load.log



--  export scott schema

expdp scott/tiger@orcl19 \
schemas=SCOTT \
directory=DATA_PUMP_DIR \
dumpfile=scott_dump.dmp \
logfile=scott_dump.log
