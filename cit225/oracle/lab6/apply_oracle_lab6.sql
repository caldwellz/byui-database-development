-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab6.sql
--  Lab Assignment: Lab #6
--  Program Author: Michael McLaughlin
--  Creation Date:  02-Mar-2018
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
--   sql> @apply_oracle_lab6.sql
--
-- ------------------------------------------------------------------

-- Call library files.
@/home/student/Data/cit225/oracle/lab5/apply_oracle_lab5.sql
@/home/student/Data/cit225/oracle/lab6/group_contact_insert.sql
@/home/student/Data/cit225/oracle/lab6/create_insert_rental.sql

-- Open log file.
SPOOL apply_oracle_lab6.txt

-- Set the page size.
SET ECHO ON
SET PAGESIZE 999

-- ----------------------------------------------------------------------
--  Step #1 : Add two columns to the RENTAL_ITEM table.
-- ----------------------------------------------------------------------
SELECT  'Step #1' AS "Step Number" FROM dual;

-- ----------------------------------------------------------------------
--  Objective #1: Add the RENTAL_ITEM_PRICE and RENTAL_ITEM_TYPE columns
--                to the RENTAL_ITEM table. Both columns should use a
--                NUMBER data type in Oracle, and an int unsigned data
--                type.
-- ----------------------------------------------------------------------

-- --------------------------------------------------
--  Step 1: Write the ALTER statement.
-- --------------------------------------------------
ALTER TABLE rental_item
  ADD (rental_item_price NUMBER)
  ADD (rental_item_type  NUMBER);


-- ----------------------------------------------------------------------
--  Verification #1: Verify the table structure.
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'RENTAL_ITEM'
ORDER BY 2;

-- ----------------------------------------------------------------------
--  Step #2 : Create the PRICE table.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Objective #1: Conditionally drop a PRICE table before creating a
--                PRICE table and PRICE_S1 sequence.
-- ----------------------------------------------------------------------

-- Conditionally drop PRICE table and sequence.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'PRICE') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE PRICE CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'PRICE_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE PRICE_S1';
  END LOOP;
END;
/

-- --------------------------------------------------
--  Step 1: Write the CREATE TABLE statement.
-- --------------------------------------------------
CREATE TABLE price
( price_id          NUMBER
, item_id           NUMBER       NOT NULL  
, price_type        NUMBER
, active_flag       VARCHAR2(1)  NOT NULL  CONSTRAINT yn_price CHECK(active_flag IN ('Y','N'))
, start_date        DATE         NOT NULL
, end_date          DATE
, amount            NUMBER       NOT NULL
, created_by        NUMBER       NOT NULL
, creation_date     DATE         NOT NULL
, last_updated_by   NUMBER       NOT NULL
, last_update_date  NUMBER       NOT NULL
, CONSTRAINT pk_price_1          PRIMARY KEY(price_id)
, CONSTRAINT fk_price_1          FOREIGN KEY(item_id)         REFERENCES item(item_id)
, CONSTRAINT fk_price_2          FOREIGN KEY(price_type)      REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_price_3          FOREIGN KEY(price_type)      REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_price_4          FOREIGN KEY(created_by)      REFERENCES system_user(system_user_id)
, CONSTRAINT fk_price_5          FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id));


-- --------------------------------------------------
--  Step 2: Write the CREATE SEQUENCE statement.
-- --------------------------------------------------
CREATE SEQUENCE price_s1 START WITH 1001;


-- ----------------------------------------------------------------------
--  Objective #2: Verify the table structure.
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'PRICE'
ORDER BY 2;
-- ----------------------------------------------------------------------
--  Objective #3: Verify the table constraints.
-- ----------------------------------------------------------------------
COLUMN constraint_name   FORMAT A16
COLUMN search_condition  FORMAT A30
SELECT   uc.constraint_name
,        uc.search_condition
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('price')
AND      ucc.column_name = UPPER('active_flag')
AND      uc.constraint_name = UPPER('yn_price')
AND      uc.constraint_type = 'C';

-- ----------------------------------------------------------------------
--  Step #3 : Insert new data into the model.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Objective #3: Rename ITEM_RELEASE_DATE column to RELEASE_DATE column,
--                insert three new DVD releases into the ITEM table,
--                insert three new rows in the MEMBER, CONTACT, ADDRESS,
--                STREET_ADDRESS, and TELEPHONE tables, and insert
--                three new RENTAL and RENTAL_ITEM table rows.
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
--  Step #3a: Rename ITEM_RELEASE_DATE Column.
-- ----------------------------------------------------------------------
ALTER TABLE item
  RENAME COLUMN item_release_date TO release_date;


-- ----------------------------------------------------------------------
--  Verification #3a: Verify the column name change.
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        data_type
||      '('||data_length||')' AS data_type
FROM     user_tab_columns
WHERE    TABLE_NAME = 'ITEM'
ORDER BY 2;


-- ----------------------------------------------------------------------
--  Step #3b: Insert three rows in the ITEM table.
-- ----------------------------------------------------------------------
INSERT INTO item
( item_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_s1.nextval
,'69011-12203'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'ITEM'
  AND      common_lookup_type = 'DVD_FULL_SCREEN')
,'Knights of the Old Republic II'
,''
,'PG'
,(TRUNC(SYSDATE) - 1)
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item
( item_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_s1.nextval
,'48213-09002'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'ITEM'
  AND      common_lookup_type = 'DVD_FULL_SCREEN')
,'Quidditch Through the Ages'
,'A Documentary'
,'PG'
,(TRUNC(SYSDATE) - 1)
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item
( item_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_s1.nextval
,'10903-34811'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'ITEM'
  AND      common_lookup_type = 'DVD_WIDE_SCREEN')
,'Inception 2'
,''
,'PG'
,(TRUNC(SYSDATE) - 1)
, 1001
, SYSDATE
, 1001
, SYSDATE);


-- ----------------------------------------------------------------------
--  Verification #3b: Verify the column name change.
-- ----------------------------------------------------------------------
COLUMN item_title FORMAT A14
COLUMN today FORMAT A10
COLUMN release_date FORMAT A10 HEADING "RELEASE|DATE"
SELECT   i.item_title
,        SYSDATE AS today
,        i.release_date
FROM     item i
WHERE   (SYSDATE - i.release_date) < 31;

-- ----------------------------------------------------------------------
--  Step #3c: Insert three new rows in the MEMBER, CONTACT, ADDRESS,
--            STREET_ADDRESS, and TELEPHONE tables.
-- ----------------------------------------------------------------------
BEGIN
  -- Call the contact_insert procedure, creating everything at once
  contact_insert(
      pv_member_type        => 'GROUP'
    , pv_account_number     => 'US00011'
    , pv_credit_card_number => '6011-0000-0000-0078'
    , pv_credit_card_type   => 'DISCOVER_CARD'
    , pv_first_name         => 'Harry'
    , pv_last_name          => 'Potter'
    , pv_contact_type       => 'CUSTOMER'
    , pv_address_type       => 'HOME'
    , pv_city               => 'Provo'
    , pv_state_province     => 'Utah'
    , pv_postal_code        => '84606'
    , pv_street_address     => '900 E 300 N'
    , pv_telephone_type     => 'HOME'
    , pv_country_code       => '001'
    , pv_area_code          => '801'
    , pv_telephone_number   => '333-3333' );
END;
/

-- Use a custom procedure to add other contacts to the current member
-- group, reducing verbose and error-prone individual inserts.
BEGIN
  -- Insert Ginny's contact info
  group_contact_insert(
      pv_first_name         => 'Ginny'
    , pv_last_name          => 'Potter'
    , pv_contact_type       => 'CUSTOMER'
    , pv_address_type       => 'HOME'
    , pv_city               => 'Provo'
    , pv_state_province     => 'Utah'
    , pv_postal_code        => '84606'
    , pv_street_address     => '900 E 300 N'
    , pv_telephone_type     => 'HOME'
    , pv_country_code       => '001'
    , pv_area_code          => '801'
    , pv_telephone_number   => '333-3333' );
END;
/

BEGIN
  -- Insert Lily's contact info
  group_contact_insert(
      pv_first_name         => 'Lily'
    , pv_middle_name        => 'Luna'
    , pv_last_name          => 'Potter'
    , pv_contact_type       => 'CUSTOMER'
    , pv_address_type       => 'HOME'
    , pv_city               => 'Provo'
    , pv_state_province     => 'Utah'
    , pv_postal_code        => '84606'
    , pv_street_address     => '900 E 300 N'
    , pv_telephone_type     => 'HOME'
    , pv_country_code       => '001'
    , pv_area_code          => '801'
    , pv_telephone_number   => '333-3333' );
END;
/


-- ----------------------------------------------------------------------
--  Verification #3c: Verify the three new CONTACTS and their related
--                    information set.
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN full_name FORMAT A20
COLUMN city      FORMAT A10
COLUMN state     FORMAT A10
SELECT   c.last_name || ', ' || c.first_name AS full_name
,        a.city
,        a.state_province AS state
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN street_address sa
ON       a.address_id = sa.address_id INNER JOIN telephone t
ON       c.contact_id = t.contact_id
WHERE    c.last_name = 'Potter';

-- ----------------------------------------------------------------------
--  Step #3d: Insert three new RENTAL and RENTAL_ITEM table rows.
-- ----------------------------------------------------------------------
-- Insert Harry's rental and first rental_item
DECLARE
  p_customer_id NUMBER;
  p_item_id     NUMBER;
BEGIN
  SELECT   contact_id
  INTO     p_customer_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Harry';

  SELECT   i.item_id
  INTO     p_item_id
  FROM     item i, common_lookup cl
  WHERE    i.item_title = 'Star Wars I'
  AND      i.item_subtitle = 'Phantom Menace'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN';
  
  insert_rental(
    pv_customer_id => p_customer_id
  , pv_item_id     => p_item_id
  , pv_return_date => (TRUNC(SYSDATE) + 1));
END;
/

-- Insert Harry's second rental_item
INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
, rental_s1.currval
,(SELECT   item_id
  FROM     item
  WHERE    item_barcode = '69011-12203')
,(SELECT   system_user_id
    FROM     system_user
    WHERE    system_user_name = 'SYSADMIN')
, SYSDATE
,(SELECT   system_user_id
    FROM     system_user
    WHERE    system_user_name = 'SYSADMIN')
, SYSDATE);

-- Insert Ginny's rental and rental_item
DECLARE
  p_customer_id NUMBER;
  p_item_id     NUMBER;
BEGIN
  SELECT   contact_id
  INTO     p_customer_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Ginny';

  SELECT   item_id
  INTO     p_item_id
  FROM     item
  WHERE    item_barcode = '48213-09002';

  insert_rental(
    pv_customer_id => p_customer_id
  , pv_item_id     => p_item_id
  , pv_return_date => (TRUNC(SYSDATE) + 3));
END;
/

-- Insert Lily's rental and rental_item
DECLARE
  p_customer_id NUMBER;
  p_item_id     NUMBER;
BEGIN
  SELECT   contact_id
  INTO     p_customer_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Lily'
  AND      middle_name = 'Luna';

  SELECT   item_id
  INTO     p_item_id
  FROM     item
  WHERE    item_barcode = '10903-34811';

  insert_rental(
      pv_customer_id => p_customer_id
    , pv_item_id     => p_item_id
    , pv_return_date => (TRUNC(SYSDATE) + 5));
END;
/


-- ----------------------------------------------------------------------
--  Verification #3d: Verify the three new CONTACTS and their related
--                    information set.
-- ----------------------------------------------------------------------
COLUMN full_name   FORMAT A18
COLUMN rental_id   FORMAT 9999
COLUMN rental_days FORMAT A14
COLUMN rentals     FORMAT 9999
COLUMN items       FORMAT 9999
SELECT   c.last_name||', '||c.first_name||' '||c.middle_name AS full_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL' AS rental_days
,        COUNT(DISTINCT r.rental_id) AS rentals
,        COUNT(ri.rental_item_id) AS items
FROM     rental r INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id INNER JOIN contact c
ON       r.customer_id = c.contact_id
WHERE   (SYSDATE - r.check_out_date) < 15
AND      c.last_name = 'Potter'
GROUP BY c.last_name||', '||c.first_name||' '||c.middle_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL'
ORDER BY 2;

-- ----------------------------------------------------------------------
--  Objective #4: Modify the design of the COMMON_LOOKUP table, insert
--                new data into the model, and update old non-compliant
--                design data in the model.
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
--  Step #4a: Drop Indexes.
-- ----------------------------------------------------------------------
DROP INDEX common_lookup_n1;
DROP INDEX common_lookup_u2;


-- ----------------------------------------------------------------------
--  Verification #4a: Verify the unique indexes are dropped.
-- ----------------------------------------------------------------------
COLUMN table_name FORMAT A14
COLUMN index_name FORMAT A20
SELECT   table_name
,        index_name
FROM     user_indexes
WHERE    table_name = 'COMMON_LOOKUP';

-- ----------------------------------------------------------------------
--  Step #4b: Add three new columns.
-- ----------------------------------------------------------------------
ALTER TABLE common_lookup
  ADD (common_lookup_table VARCHAR2(30))
  ADD (common_lookup_column VARCHAR2(30))
  ADD (common_lookup_code VARCHAR2(1));


-- ----------------------------------------------------------------------
--  Verification #4b: Verify the unique indexes are dropped.
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- ----------------------------------------------------------------------
--  Step #4c: Migrate data subject to re-engineered COMMON_LOOKUP table.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #4c(1): Query the pre-change state of the table.
-- ----------------------------------------------------------------------
COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;

-- ----------------------------------------------------------------------
--  Step #4c(2): Query the post COMMON_LOOKUP_TABLE changes where the
--               COMMON_LOOKUP_CONTEXT is equal to the table names.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #4c(2): Update the records.
-- ----------------------------------------------------------------------
UPDATE   common_lookup
SET      common_lookup_table = common_lookup_context
WHERE    common_lookup_context != 'MULTIPLE';


-- ----------------------------------------------------------------------
--  Step #4c(2): Verify update of the records.
-- ----------------------------------------------------------------------
COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;

-- ----------------------------------------------------------------------
--  Step #4c(3): Query the post COMMON_LOOKUP_TABLE changes where the
--               COMMON_LOOKUP_CONTEXT is not equal to the table names.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #4c(3): Update the records.
-- ----------------------------------------------------------------------
UPDATE   common_lookup
SET      common_lookup_table = 'ADDRESS'
WHERE    common_lookup_context = 'MULTIPLE';


-- ----------------------------------------------------------------------
--  Step #4c(3): Verify update of the records.
-- ----------------------------------------------------------------------
COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;

-- ----------------------------------------------------------------------
--  Step #4c(4): Query the post COMMON_LOOKUP_COLUMN change.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #4c(4): Update the type records.
-- ----------------------------------------------------------------------
UPDATE   common_lookup
SET      common_lookup_column = common_lookup_context || '_TYPE'
WHERE    common_lookup_context != 'MULTIPLE';


-- ----------------------------------------------------------------------
--  Step #4c(4): Verify update of the type records.
-- ----------------------------------------------------------------------
COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN
          (SELECT table_name
           FROM   user_tables)
ORDER BY 1, 2, 3;

-- ----------------------------------------------------------------------
--  Step #4c(4): Query the post COMMON_LOOKUP_COLUMN change.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #4c(4): Update the ADDRESS table type records.
-- ----------------------------------------------------------------------
UPDATE   common_lookup
SET      common_lookup_column = 'ADDRESS_TYPE'
WHERE    common_lookup_context = 'MULTIPLE';


-- ----------------------------------------------------------------------
--  Step #4c(4): Verify update of the ADDRESS table type records.
-- ----------------------------------------------------------------------
COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN
          (SELECT table_name
           FROM   user_tables)
ORDER BY 1, 2, 3;

-- ----------------------------------------------------------------------
--  Step #4c(5): Query the post COMMON_LOOKUP_COLUMN change.
-- ----------------------------------------------------------------------
-- ----------------------------------------------------------------------
--  Step #4c(4): Alter the table and remove the unused column.
-- ----------------------------------------------------------------------
ALTER TABLE common_lookup
  DROP (common_lookup_context);


-- ----------------------------------------------------------------------
--  Step #4c(4): Verify modification of table structure.
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- ----------------------------------------------------------------------
--  Step #4c(6): Insert new rows for the TELEPHONE table.
-- ----------------------------------------------------------------------
INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( common_lookup_s1.nextval
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, 'HOME'
, 'Home'
,(SELECT   system_user_id
    FROM     system_user
    WHERE    system_user_name = 'SYSADMIN')
, SYSDATE
,(SELECT   system_user_id
    FROM     system_user
    WHERE    system_user_name = 'SYSADMIN')
, SYSDATE);

INSERT INTO common_lookup
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( common_lookup_s1.nextval
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, 'WORK'
, 'Work'
,(SELECT   system_user_id
    FROM     system_user
    WHERE    system_user_name = 'SYSADMIN')
, SYSDATE
,(SELECT   system_user_id
    FROM     system_user
    WHERE    system_user_name = 'SYSADMIN')
, SYSDATE);


-- ----------------------------------------------------------------------
--  Step #4c(6): Verify insert of new rows to the TELEPHONE table.
-- ----------------------------------------------------------------------
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN
          (SELECT table_name
           FROM   user_tables)
ORDER BY 1, 2, 3;

-- ----------------------------------------------------------------------
--  Step #4d: Alter the table structure.
-- ----------------------------------------------------------------------
ALTER TABLE common_lookup
  MODIFY (common_lookup_table  VARCHAR2(30) CONSTRAINT nn_clookup_8 NOT NULL )
  MODIFY (common_lookup_column VARCHAR2(30) CONSTRAINT nn_clookup_9 NOT NULL );


-- ----------------------------------------------------------------------
--  Step #4d: Verify changes to the table structure.
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- Display non-unique constraints.
COLUMN constraint_name   FORMAT A22  HEADING "Constraint Name"
COLUMN search_condition  FORMAT A36  HEADING "Search Condition"
COLUMN constraint_type   FORMAT A10  HEADING "Constraint|Type"
SELECT   uc.constraint_name
,        uc.search_condition
,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('common_lookup')
AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
,        uc.constraint_name;

-- ----------------------------------------------------------------------
--  Step #4d: Add unique index.
-- ----------------------------------------------------------------------
CREATE UNIQUE INDEX common_lookup_nuidx
ON common_lookup ( common_lookup_table
                 , common_lookup_column
                 , common_lookup_type);


-- ----------------------------------------------------------------------
--  Step #4d: Verify new unique index.
-- ----------------------------------------------------------------------
COLUMN sequence_name   FORMAT A22 HEADING "Sequence Name"
COLUMN column_position FORMAT 999 HEADING "Column|Position"
COLUMN column_name     FORMAT A22 HEADING "Column|Name"
SELECT   ui.index_name
,        uic.column_position
,        uic.column_name
FROM     user_indexes ui INNER JOIN user_ind_columns uic
ON       ui.index_name = uic.index_name
AND      ui.table_name = uic.table_name
WHERE    ui.table_name = UPPER('common_lookup')
ORDER BY ui.index_name
,        uic.column_position;

-- ----------------------------------------------------------------------
--  Step #4d: Update the foreign keys of the TELEPHONE table.
-- ----------------------------------------------------------------------
UPDATE telephone
SET   telephone_type = (SELECT common_lookup_id
                        FROM   common_lookup
                        WHERE  common_lookup_table = 'TELEPHONE'
                        AND    common_lookup_type = 'HOME')
WHERE telephone_type = (SELECT common_lookup_id
                        FROM   common_lookup
                        WHERE  common_lookup_table = 'ADDRESS'
                        AND    common_lookup_type = 'HOME');

UPDATE telephone
SET   telephone_type = (SELECT common_lookup_id
                        FROM   common_lookup
                        WHERE  common_lookup_table = 'TELEPHONE'
                        AND    common_lookup_type = 'WORK')
WHERE telephone_type = (SELECT common_lookup_id
                        FROM   common_lookup
                        WHERE  common_lookup_table = 'ADDRESS'
                        AND    common_lookup_type = 'WORK');


-- ----------------------------------------------------------------------
--  Step #4d: Verify the foreign keys of the TELEPHONE table.
-- ----------------------------------------------------------------------
COLUMN common_lookup_table  FORMAT A14 HEADING "Common|Lookup Table"
COLUMN common_lookup_column FORMAT A14 HEADING "Common|Lookup Column"
COLUMN common_lookup_type   FORMAT A8  HEADING "Common|Lookup|Type"
COLUMN count_dependent      FORMAT 999 HEADING "Count of|Foreign|Keys"
COLUMN count_lookup         FORMAT 999 HEADING "Count of|Primary|Keys"
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(a.address_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     address a RIGHT JOIN common_lookup cl
ON       a.address_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'ADDRESS'
AND      cl.common_lookup_column = 'ADDRESS_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
UNION
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(t.telephone_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     telephone t RIGHT JOIN common_lookup cl
ON       t.telephone_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TELEPHONE'
AND      cl.common_lookup_column = 'TELEPHONE_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type;

SPOOL OFF
