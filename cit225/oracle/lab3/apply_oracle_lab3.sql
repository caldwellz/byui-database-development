-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab3.sql
--  Lab Assignment: N/A
--  Program Author: Michael McLaughlin
--  Creation Date:  17-Jan-2018
-- ------------------------------------------------------------------
--  Change Log:
-- ------------------------------------------------------------------
--  Change Date    Change Reason
-- -------------  ---------------------------------------------------
--  
-- ------------------------------------------------------------------
-- This creates tables, sequences, indexes, and constraints necessary
-- to begin lesson #3. Demonstrates proper process and syntax.
-- ------------------------------------------------------------------
-- Instructions:
-- ------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab3.sql
--
-- ------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab2/apply_oracle_lab2.sql
@/home/student/Data/cit225/oracle/lib1/preseed/preseed_oracle_store.sql
 
-- ... insert calls to other code script files here ...
 
SPOOL apply_oracle_lab3.txt
 
-- --------------------------------------------------------
--  Step #1
--  -------
--  Disable foreign key constraints dependencies.
-- --------------------------------------------------------

-- Insert ALTER statement #1.

-- Insert ALTER statement #2.


COL table_name       FORMAT A14  HEADING "Table Name"
COL constraint_name  FORMAT A24  HEADING "Constraint Name"
COL constraint_type  FORMAT A12  HEADING "Constraint Type"
COL status           FORMAT A8   HEADING "Status"
SELECT   table_name
,        constraint_name
,        CASE
           WHEN constraint_type = 'R'        THEN 'FOREIGN KEY'
           WHEN constraint_type = 'P'        THEN 'PRIMARY KEY'
           WHEN constraint_type = 'U'        THEN 'UNIQUE'
           WHEN constraint_type = 'C' AND  REGEXP_LIKE(constraint_name,'^.*nn.*$','i')
           THEN 'NOT NULL'
           ELSE 'CHECK'
         END constraint_type
,        status
FROM     user_constraints
WHERE    table_name = 'SYSTEM_USER_LAB'
ORDER BY CASE
           WHEN constraint_type = 'PRIMARY KEY' THEN 1
           WHEN constraint_type = 'NOT NULL'    THEN 2
           WHEN constraint_type = 'CHECK'       THEN 3
           WHEN constraint_type = 'UNIQUE'      THEN 4
           WHEN constraint_type = 'FOREIGN KEY' THEN 5
         END
,        constraint_name;

-- --------------------------------------------------------
--  Step #2
--  -------
--  Alter the table to remove not null constraints.
-- --------------------------------------------------------

-- Insert ALTER statement #1.

-- Insert ALTER statement #2.


COL table_name       FORMAT A14  HEADING "Table Name"
COL constraint_name  FORMAT A24  HEADING "Constraint Name"
COL constraint_type  FORMAT A12  HEADING "Constraint Type"
COL status           FORMAT A8   HEADING "Status"
SELECT   table_name
,        constraint_name
,        CASE
           WHEN constraint_type = 'R'        THEN 'FOREIGN KEY'
           WHEN constraint_type = 'P'        THEN 'PRIMARY KEY'
           WHEN constraint_type = 'U'        THEN 'UNIQUE'
           WHEN constraint_type = 'C' AND  REGEXP_LIKE(constraint_name,'^.*nn.*$','i')
           THEN 'NOT NULL'
           ELSE 'CHECK'
         END constraint_type
,        status
FROM     user_constraints
WHERE    table_name = 'SYSTEM_USER_LAB'
ORDER BY CASE
           WHEN constraint_type = 'PRIMARY KEY' THEN 1
           WHEN constraint_type = 'NOT NULL'    THEN 2
           WHEN constraint_type = 'CHECK'       THEN 3
           WHEN constraint_type = 'UNIQUE'      THEN 4
           WHEN constraint_type = 'FOREIGN KEY' THEN 5
         END
,        constraint_name;

-- --------------------------------------------------------
--  Step #3
--  -------
--  Insert partial data set for preseeded system_user.
-- --------------------------------------------------------

-- Insert ALTER statement #1.

-- Insert ALTER statement #2.


-- --------------------------------------------------------
--  Step #4
--  -------
--  Disable foreign key constraints dependencies.
-- --------------------------------------------------------

-- Insert ALTER statement #1.

-- Insert ALTER statement #2.


COL table_name       FORMAT A14  HEADING "Table Name"
COL constraint_name  FORMAT A24  HEADING "Constraint Name"
COL constraint_type  FORMAT A12  HEADING "Constraint Type"
COL status           FORMAT A8   HEADING "Status"
SELECT   table_name
,        constraint_name
,        CASE
           WHEN constraint_type = 'R'        THEN 'FOREIGN KEY'
           WHEN constraint_type = 'P'        THEN 'PRIMARY KEY'
           WHEN constraint_type = 'U'        THEN 'UNIQUE'
           WHEN constraint_type = 'C' AND  REGEXP_LIKE(constraint_name,'^.*nn.*$','i')
           THEN 'NOT NULL'
           ELSE 'CHECK'
         END constraint_type
,        status
FROM     user_constraints
WHERE    table_name = 'COMMON_LOOKUP_LAB'
ORDER BY CASE
           WHEN constraint_type = 'PRIMARY KEY' THEN 1
           WHEN constraint_type = 'NOT NULL'    THEN 2
           WHEN constraint_type = 'CHECK'       THEN 3
           WHEN constraint_type = 'UNIQUE'      THEN 4
           WHEN constraint_type = 'FOREIGN KEY' THEN 5
         END
,        constraint_name;

-- --------------------------------------------------------
--  Step #5
--  -------
--  Insert data set for preseeded common_lookup table.
-- --------------------------------------------------------


-- --------------------------------------------------------
--  Step #6
--  -------
--  Display the preseeded values in the common_lookup table.
-- --------------------------------------------------------


-- --------------------------------------------------------
--  Step #7
--  -------
--  Write two queries using the COMMON_LOOKUP table:
--  --------------------------------------------------
--   One finds the primary key values for the
--   SYSTEM_USER_GROUP_ID in the COMMON_LOOKUP table.
--   Another finds the primary key values for the 
--   SYSTEM_USER_TYPE in the COMMON_LOOKUP table.
--  --------------------------------------------------
--  Both queries use the COMMON_LOOKUP_CONTEXT and
--  COMMON_LOOKUP_TYPE columns.
-- --------------------------------------------------------


-- --------------------------------------------------------
--  Step #8
--  -------
--  Update the SYSTEM_USER_GROUP_ID and SYSTEM_USER_TYPE
--  columns in the SYSTEM_USER table.
-- --------------------------------------------------------

-- Insert the UPDATE statement for the SYSTEM_USER_GROUP_ID here.


-- Display results.
SET NULL '<Null>'
COL system_user_lab_id    FORMAT 999999  HEADING "System|User|ID #"
COL system_user_name      FORMAT A10     HEADING "System|User|Name"
COL system_user_group_id  FORMAT 999999  HEADING "System|User|Group|ID #"
COL system_user_type      FORMAT 999999  HEADING "System|User|Type"
SELECT   system_user_lab_id
,        system_user_name
,        system_user_group_id
,        system_user_type
FROM     system_user_lab
WHERE    system_user_lab_id = 1;

-- Insert the UPDATE statement for the SYSTEM_USER_TYPE here.


-- Display results.
SET NULL '<Null>'
COL system_user_lab_id    FORMAT 999999  HEADING "System|User|ID #"
COL system_user_name      FORMAT A10     HEADING "System|User|Name"
COL system_user_group_id  FORMAT 999999  HEADING "System|User|Group|ID #"
COL system_user_type      FORMAT 999999  HEADING "System|User|Type"
SELECT   system_user_lab_id
,        system_user_name
,        system_user_group_id
,        system_user_type
FROM     system_user_lab
WHERE    system_user_lab_id = 1;

-- --------------------------------------------------------
--  Step #9
--  --------
--  Enable foreign key constraints dependencies.
-- --------------------------------------------------------

-- Insert ALTER statement #1.

-- Insert ALTER statement #2.


-- Display system_user table constraints.
COL table_name       FORMAT A14  HEADING "Table Name"
COL constraint_name  FORMAT A24  HEADING "Constraint Name"
COL constraint_type  FORMAT A12  HEADING "Constraint Type"
COL status           FORMAT A8   HEADING "Status"
SELECT   table_name
,        constraint_name
,        CASE
           WHEN constraint_type = 'R'        THEN 'FOREIGN KEY'
           WHEN constraint_type = 'P'        THEN 'PRIMARY KEY'
           WHEN constraint_type = 'U'        THEN 'UNIQUE'
           WHEN constraint_type = 'C' AND  REGEXP_LIKE(constraint_name,'^.*nn.*$','i')
           THEN 'NOT NULL'
           ELSE 'CHECK'
         END constraint_type
,        status
FROM     user_constraints
WHERE    table_name = 'SYSTEM_USER_LAB'
ORDER BY CASE
           WHEN constraint_type = 'PRIMARY KEY' THEN 1
           WHEN constraint_type = 'NOT NULL'    THEN 2
           WHEN constraint_type = 'CHECK'       THEN 3
           WHEN constraint_type = 'UNIQUE'      THEN 4
           WHEN constraint_type = 'FOREIGN KEY' THEN 5
         END
,        constraint_name;

-- Insert ALTER statement #3.

-- Insert ALTER statement #4.


-- Display system_user table constraints.
COL table_name       FORMAT A14  HEADING "Table Name"
COL constraint_name  FORMAT A24  HEADING "Constraint Name"
COL constraint_type  FORMAT A12  HEADING "Constraint Type"
COL status           FORMAT A8   HEADING "Status"
SELECT   table_name
,        constraint_name
,        CASE
           WHEN constraint_type = 'R'        THEN 'FOREIGN KEY'
           WHEN constraint_type = 'P'        THEN 'PRIMARY KEY'
           WHEN constraint_type = 'U'        THEN 'UNIQUE'
           WHEN constraint_type = 'C' AND  REGEXP_LIKE(constraint_name,'^.*nn.*$','i')
           THEN 'NOT NULL'
           ELSE 'CHECK'
         END constraint_type
,        status
FROM     user_constraints
WHERE    table_name = 'COMMON_LOOKUP_LAB'
ORDER BY CASE
           WHEN constraint_type = 'PRIMARY KEY' THEN 1
           WHEN constraint_type = 'NOT NULL'    THEN 2
           WHEN constraint_type = 'CHECK'       THEN 3
           WHEN constraint_type = 'UNIQUE'      THEN 4
           WHEN constraint_type = 'FOREIGN KEY' THEN 5
         END
,        constraint_name;

-- --------------------------------------------------------
--  Step #10
--  --------
--  Alter the table to add not null constraints.
-- --------------------------------------------------------

-- Insert ALTER statement #1.

-- Insert ALTER statement #2.


-- Display system_user table constraints.
COL table_name       FORMAT A14  HEADING "Table Name"
COL constraint_name  FORMAT A24  HEADING "Constraint Name"
COL constraint_type  FORMAT A12  HEADING "Constraint Type"
COL status           FORMAT A8   HEADING "Status"
SELECT   table_name
,        constraint_name
,        CASE
           WHEN constraint_type = 'R'        THEN 'FOREIGN KEY'
           WHEN constraint_type = 'P'        THEN 'PRIMARY KEY'
           WHEN constraint_type = 'U'        THEN 'UNIQUE'
           WHEN constraint_type = 'C' AND  REGEXP_LIKE(constraint_name,'^.*nn.*$','i')
           THEN 'NOT NULL'
           ELSE 'CHECK'
         END constraint_type
,        status
FROM     user_constraints
WHERE    table_name = 'SYSTEM_USER_LAB'
ORDER BY CASE
           WHEN constraint_type = 'PRIMARY KEY' THEN 1
           WHEN constraint_type = 'NOT NULL'    THEN 2
           WHEN constraint_type = 'CHECK'       THEN 3
           WHEN constraint_type = 'UNIQUE'      THEN 4
           WHEN constraint_type = 'FOREIGN KEY' THEN 5
         END
,        constraint_name;

-- --------------------------------------------------------
--  Step #11
--  --------
--  Insert rows in the system_user table with subqueries.
-- --------------------------------------------------------


-- --------------------------------------------------------
--  Step #12
--  --------
--  Display inserted rows from the system_user table.
-- --------------------------------------------------------
SET NULL '<Null>'
COL system_user_lab_id    FORMAT  9999
COL system_user_group_id  FORMAT  9999
COL system_user_type      FORMAT  9999
COL system_user_name      FORMAT  A10
COL full_user_name        FORMAT  A30
SELECT   system_user_lab_id
,        system_user_group_id
,        system_user_type
,        system_user_name
,        CASE
           WHEN last_name IS NOT NULL THEN
             last_name || ', ' || first_name || ' ' || middle_name
         END AS full_user_name
FROM     system_user_lab;

-- Commit changes.
COMMIT;

SPOOL OFF
