LOAD DATA
INFILE 'pan_data.csv'
INTO TABLE scott.pan_log
FIELDS TERMINATED BY ','
(
  log_id,
  pan_no,
  activity,
  log_time DATE "DD-MON-YYYY"
)
