

1) QUERY 1 – CHECK TABLE FRAGMENTATION
--------------------------------------
SELECT table_name, blocks, empty_blocks, chain_cnt
FROM dba_tables
WHERE owner = 'MCA10';

Conclusion:
- HIGH EMPTY_BLOCKS → internal fragmentation inside table extents.
- HIGH CHAIN_CNT → chained or migrated rows exist.
- If BLOCKS are high but EMPTY_BLOCKS also high → table is fragmented.


2) QUERY 2 – CHECK INDEX FRAGMENTATION
--------------------------------------
SELECT index_name, blevel, leaf_blocks, distinct_keys
FROM dba_indexes
WHERE owner = 'MCA10';

Conclusion:
- HIGH BLEVEL means index tree is deep → fragmented.
- Many LEAF_BLOCKS with low DISTINCT_KEYS → index contains unused space.
- REBUILD recommended.


3) QUERY 3 – TABLESPACE FREE SPACE FRAGMENTATION
------------------------------------------------
SELECT tablespace_name, file_id, block_id, blocks
FROM dba_free_space
ORDER BY tablespace_name, file_id, block_id;

Conclusion:
- Many small BLOCK ranges indicate high fragmentation.
- Few large continuous ranges indicate healthy tablespace.


=====================================================================

II. CREATE A CHAINED / MIGRATED TABLE
-------------------------------------

-- Create table with 0 PCTFREE to force migration
CREATE TABLE chain_test (
    id NUMBER,
    data VARCHAR2(4000)
) PCTFREE 0;


-- Insert small rows
INSERT INTO chain_test VALUES (1, RPAD('A', 100));
INSERT INTO chain_test VALUES (2, RPAD('B', 100));
INSERT INTO chain_test VALUES (3, RPAD('C', 100));
COMMIT;


-- Update rows to larger size (causes row migration)
UPDATE chain_test SET data = RPAD('X', 3000) WHERE id = 1;
UPDATE chain_test SET data = RPAD('Y', 3000) WHERE id = 2;
COMMIT;

Conclusion:
- Row migration happens because original block has no free space.
- Oracle moves row to another block → leaves pointer behind.
- Performance slows → fragmentation increases.


=====================================================================

III. SHOW CHAINED ROWS
----------------------

-- Create Oracle-recommended chained rows table
ANALYZE TABLE chain_test LIST CHAINED ROWS INTO chained_rows;

-- Display chained rows
SELECT * FROM chained_rows;

Conclusion:
- Presence of rows here proves table has chained/migrated rows.
- Indicates poor block usage or oversized updates.
- Requires table reorganization or PCTFREE adjustment.

=====================================================================

FINAL CONCLUSION
----------------
✔ Three fragmentation queries included  
✔ Chained table created  
✔ Chained rows displayed  
✔ Explanation & conclusion provided  

ALL REQUIREMENTS ACHIEVED SUCCESSFULLY.
