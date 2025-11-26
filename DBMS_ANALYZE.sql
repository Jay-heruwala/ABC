CREATE CLUSTER pan_cluster (
    pan_no VARCHAR2(10)
)
SIZE 1024;



CREATE INDEX pan_cluster_idx
ON CLUSTER pan_cluster;



CREATE TABLE person (
    pan_no     VARCHAR2(10) PRIMARY KEY,
    full_name  VARCHAR2(100),
    dob        DATE,
    address    VARCHAR2(200)
)
CLUSTER pan_cluster (pan_no);



CREATE TABLE pan_application (
    application_id NUMBER(10) PRIMARY KEY,
    pan_no         VARCHAR2(10),
    apply_date     DATE,
    status         VARCHAR2(20)
)
CLUSTER pan_cluster (pan_no);



CREATE TABLE aadhaar_link (
    id              NUMBER,
    pan_no          VARCHAR2(10),
    aadhaar_no      VARCHAR2(12),
    link_status     VARCHAR2(20)
)
STORAGE (
    INITIAL     5K
    NEXT        5K
    MINEXTENTS  1
    MAXEXTENTS  5
);



CREATE INDEX aadhaar_idx
ON aadhaar_link (aadhaar_no);



BEGIN
  -- Analyze cluster
  DBMS_DDL.ANALYZE_OBJECT(
    type   => 'CLUSTER',
    schema => 'MCA10',
    name   => 'PAN_CLUSTER',
    method => 'COMPUTE'
  );

  -- Analyze tables inside cluster
  DBMS_DDL.ANALYZE_OBJECT('TABLE', 'MCA10', 'PERSON', 'COMPUTE');
  DBMS_DDL.ANALYZE_OBJECT('TABLE', 'MCA10', 'PAN_APPLICATION', 'COMPUTE');

  -- Analyze cluster index
  DBMS_DDL.ANALYZE_OBJECT('INDEX', 'MCA10', 'PAN_CLUSTER_IDX', 'COMPUTE');

  -- Analyze normal table
  DBMS_DDL.ANALYZE_OBJECT('TABLE', 'MCA10', 'AADHAAR_LINK', 'COMPUTE');

  -- Analyze normal index
  DBMS_DDL.ANALYZE_OBJECT('INDEX', 'MCA10', 'AADHAAR_IDX', 'COMPUTE');
END;
/



SELECT table_name, num_rows, blocks, last_analyzed
FROM user_tables
WHERE table_name IN ('PERSON','PAN_APPLICATION','AADHAAR_LINK');



SELECT index_name, table_name, distinct_keys, leaf_blocks, last_analyzed
FROM user_indexes
WHERE index_name IN ('PAN_CLUSTER_IDX','AADHAAR_IDX');



SELECT table_name, last_analyzed
FROM user_tab_statistics
WHERE table_name IN ('PERSON', 'PAN_APPLICATION');
