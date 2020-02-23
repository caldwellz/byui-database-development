/*
||  Name:          apply_plsql_lab7.sql
||  Author:        Zach Caldwell
||  Purpose:       Complete 325 Chapter 8 lab.
*/

-- Call seeding libraries.
@$LIB/cleanup_oracle.sql
@$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab7.txt
SET SERVEROUTPUT ON SIZE UNLIMITED

-- Step 0: Update DBA users
UPDATE system_user
SET    system_user_name = 'DBA'
WHERE  system_user_name LIKE 'DBA%';

DECLARE
  /* Create a local counter variable. */
  lv_counter  NUMBER := 2;

  /* Create a collection of two-character strings. */
  TYPE numbers IS TABLE OF NUMBER;

  /* Create a variable of the roman_numbers collection. */
  lv_numbers  NUMBERS := numbers(1,2,3,4);

BEGIN
  /* Update the system_user names to make them unique. */
  FOR i IN 1..lv_numbers.COUNT LOOP
    /* Update the system_user table. */
    UPDATE system_user
    SET    system_user_name = system_user_name || ' ' || lv_numbers(i)
    WHERE  system_user_id = lv_counter
    AND    system_user_name = 'DBA';

    /* Increment the counter. */
    lv_counter := lv_counter + 1;
  END LOOP;
END;
/


-- Step 0: Drop any stored versions of insert_contact
BEGIN
  FOR i IN (SELECT uo.object_type
            ,      uo.object_name
            FROM   user_objects uo
            WHERE  uo.object_name = 'INSERT_CONTACT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/


-- Step 1: Create insert_contact procedure
CREATE OR REPLACE PROCEDURE insert_contact
  ( pv_first_name         VARCHAR2
  , pv_middle_name        VARCHAR2
  , pv_last_name          VARCHAR2
  , pv_contact_type       VARCHAR2
  , pv_account_number     VARCHAR2
  , pv_member_type        VARCHAR2
  , pv_credit_card_number VARCHAR2
  , pv_credit_card_type   VARCHAR2
  , pv_city               VARCHAR2
  , pv_state_province     VARCHAR2
  , pv_postal_code        VARCHAR2
  , pv_address_type       VARCHAR2
  , pv_country_code       VARCHAR2
  , pv_area_code          VARCHAR2
  , pv_telephone_number   VARCHAR2
  , pv_telephone_type     VARCHAR2
  , pv_user_name          VARCHAR2) IS

  lv_user_id             NUMBER := 0;
  lv_date                DATE   := TRUNC(SYSDATE);
  lv_contact_type_id     NUMBER;
  lv_member_type_id      NUMBER;
  lv_credit_card_type_id NUMBER;
  lv_address_type_id     NUMBER;
  lv_telephone_type_id   NUMBER;

  FUNCTION get_cl_id
    ( pv_table_name  VARCHAR2
    , pv_column_name VARCHAR2
    , pv_lookup_type VARCHAR2) RETURN NUMBER IS
    lv_retval  NUMBER := 0;
    CURSOR cl_id
      ( cv_table_name  VARCHAR2
      , cv_column_name VARCHAR2
      , cv_lookup_type VARCHAR2) IS
      SELECT common_lookup_id
      FROM   common_lookup
      WHERE  common_lookup_table = cv_table_name
      AND    common_lookup_column = cv_column_name
      AND    common_lookup_type = cv_lookup_type;
  BEGIN
    FOR i IN cl_id(pv_table_name, pv_column_name, pv_lookup_type) LOOP
      lv_retval := i.common_lookup_id;
    END LOOP;
    /* Return 0 when no row found and the ID # when row found. */
    RETURN lv_retval;
  END get_cl_id;

BEGIN

-- Get the system user ID
  SELECT system_user_id
  INTO lv_user_id
  FROM system_user
  WHERE system_user_name = pv_user_name;

-- Get the type IDs
  lv_contact_type_id     := get_cl_id('CONTACT', 'CONTACT_TYPE', UPPER(pv_contact_type));
  lv_member_type_id      := get_cl_id('MEMBER', 'MEMBER_TYPE', UPPER(pv_member_type));
  lv_credit_card_type_id := get_cl_id('MEMBER', 'CREDIT_CARD_TYPE', UPPER(pv_credit_card_type));
  lv_address_type_id     := get_cl_id('ADDRESS', 'ADDRESS_TYPE', UPPER(pv_address_type));
  lv_telephone_type_id   := get_cl_id('TELEPHONE', 'TELEPHONE_TYPE', UPPER(pv_telephone_type));

-- Begin insert transactions
  SAVEPOINT startpoint;

  INSERT INTO member
  ( member_id
  , member_type
  , account_number
  , credit_card_number
  , credit_card_type
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( member_s1.NEXTVAL
  , lv_member_type_id
  , pv_account_number
  , pv_credit_card_number
  , lv_credit_card_type_id
  , lv_user_id
  , lv_date
  , lv_user_id
  , lv_date );

  INSERT INTO contact
  ( contact_id
  , member_id
  , contact_type
  , last_name
  , first_name
  , middle_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  , lv_contact_type_id
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , lv_user_id
  , lv_date
  , lv_user_id
  , lv_date );  

  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  , lv_address_type_id
  , pv_city
  , pv_state_province
  , pv_postal_code
  , lv_user_id
  , lv_date
  , lv_user_id
  , lv_date );  

  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  , lv_telephone_type_id
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , lv_user_id                                     -- CREATED_BY
  , lv_date                                  -- CREATION_DATE
  , lv_user_id                                -- LAST_UPDATED_BY
  , lv_date);                             -- LAST_UPDATE_DATE

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO startpoint;
    RAISE;
END insert_contact;
/


-- Step 1: Test insert_contact procedure
BEGIN
  insert_contact
  ( 'Charles'
  , 'Francis'
  , 'Xavier'
  , 'Customer'
  , 'SLC-000008'
  , 'Individual'
  , '7777-6666-5555-4444'
  , 'Discover_Card'
  , 'Milbridge'
  , 'Maine'
  , '04658'
  , 'Home'
  , '001'
  , '207'
  , '111-1234'
  , 'Home'
  , 'DBA 2');
END;
/


-- Step 2: Change to an autonomous invoker rights procedure
CREATE OR REPLACE PROCEDURE insert_contact
  ( pv_first_name         VARCHAR2
  , pv_middle_name        VARCHAR2
  , pv_last_name          VARCHAR2
  , pv_contact_type       VARCHAR2
  , pv_account_number     VARCHAR2
  , pv_member_type        VARCHAR2
  , pv_credit_card_number VARCHAR2
  , pv_credit_card_type   VARCHAR2
  , pv_city               VARCHAR2
  , pv_state_province     VARCHAR2
  , pv_postal_code        VARCHAR2
  , pv_address_type       VARCHAR2
  , pv_country_code       VARCHAR2
  , pv_area_code          VARCHAR2
  , pv_telephone_number   VARCHAR2
  , pv_telephone_type     VARCHAR2
  , pv_user_name          VARCHAR2)
  AUTHID CURRENT_USER IS

  PRAGMA AUTONOMOUS_TRANSACTION;

  lv_user_id             NUMBER := 0;
  lv_date                DATE   := TRUNC(SYSDATE);
  lv_contact_type_id     NUMBER;
  lv_member_type_id      NUMBER;
  lv_credit_card_type_id NUMBER;
  lv_address_type_id     NUMBER;
  lv_telephone_type_id   NUMBER;

  FUNCTION get_cl_id
    ( pv_table_name  VARCHAR2
    , pv_column_name VARCHAR2
    , pv_lookup_type VARCHAR2) RETURN NUMBER IS
    lv_retval  NUMBER := 0;
    CURSOR cl_id
      ( cv_table_name  VARCHAR2
      , cv_column_name VARCHAR2
      , cv_lookup_type VARCHAR2) IS
      SELECT common_lookup_id
      FROM   common_lookup
      WHERE  common_lookup_table = cv_table_name
      AND    common_lookup_column = cv_column_name
      AND    common_lookup_type = cv_lookup_type;
  BEGIN
    FOR i IN cl_id(pv_table_name, pv_column_name, pv_lookup_type) LOOP
      lv_retval := i.common_lookup_id;
    END LOOP;
    /* Return 0 when no row found and the ID # when row found. */
    RETURN lv_retval;
  END get_cl_id;

BEGIN

-- Get the system user ID
  SELECT system_user_id
  INTO lv_user_id
  FROM system_user
  WHERE system_user_name = pv_user_name;

-- Get the type IDs
  lv_contact_type_id     := get_cl_id('CONTACT', 'CONTACT_TYPE', UPPER(pv_contact_type));
  lv_member_type_id      := get_cl_id('MEMBER', 'MEMBER_TYPE', UPPER(pv_member_type));
  lv_credit_card_type_id := get_cl_id('MEMBER', 'CREDIT_CARD_TYPE', UPPER(pv_credit_card_type));
  lv_address_type_id     := get_cl_id('ADDRESS', 'ADDRESS_TYPE', UPPER(pv_address_type));
  lv_telephone_type_id   := get_cl_id('TELEPHONE', 'TELEPHONE_TYPE', UPPER(pv_telephone_type));

-- Begin insert transactions
  SAVEPOINT startpoint;

  INSERT INTO member
  ( member_id
  , member_type
  , account_number
  , credit_card_number
  , credit_card_type
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( member_s1.NEXTVAL
  , lv_member_type_id
  , pv_account_number
  , pv_credit_card_number
  , lv_credit_card_type_id
  , lv_user_id
  , lv_date
  , lv_user_id
  , lv_date );

  INSERT INTO contact
  ( contact_id
  , member_id
  , contact_type
  , last_name
  , first_name
  , middle_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  , lv_contact_type_id
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , lv_user_id
  , lv_date
  , lv_user_id
  , lv_date );  

  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  , lv_address_type_id
  , pv_city
  , pv_state_province
  , pv_postal_code
  , lv_user_id
  , lv_date
  , lv_user_id
  , lv_date );  

  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  , lv_telephone_type_id
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , lv_user_id                                     -- CREATED_BY
  , lv_date                                  -- CREATION_DATE
  , lv_user_id                                -- LAST_UPDATED_BY
  , lv_date);                             -- LAST_UPDATE_DATE

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO startpoint;
    RAISE;
END insert_contact;
/


-- Step 2: Test modified insert_contact procedure
BEGIN
  insert_contact
  ( 'Maura'
  , 'Jane'
  , 'Haggerty'
  , 'Customer'
  , 'SLC-000009'
  , 'Individual'
  , '8888-7777-6666-5555'
  , 'Master_Card'
  , 'Bangor'
  , 'Maine'
  , '04401'
  , 'Home'
  , '001'
  , '207'
  , '111-1234'
  , 'Home'
  , 'DBA 2');
END;
/


-- Step 3: Convert insert_contact into a function returning an error code
DROP PROCEDURE insert_contact;
CREATE OR REPLACE FUNCTION insert_contact
  ( pv_first_name         VARCHAR2
  , pv_middle_name        VARCHAR2
  , pv_last_name          VARCHAR2
  , pv_contact_type       VARCHAR2
  , pv_account_number     VARCHAR2
  , pv_member_type        VARCHAR2
  , pv_credit_card_number VARCHAR2
  , pv_credit_card_type   VARCHAR2
  , pv_city               VARCHAR2
  , pv_state_province     VARCHAR2
  , pv_postal_code        VARCHAR2
  , pv_address_type       VARCHAR2
  , pv_country_code       VARCHAR2
  , pv_area_code          VARCHAR2
  , pv_telephone_number   VARCHAR2
  , pv_telephone_type     VARCHAR2
  , pv_user_name          VARCHAR2)
  RETURN NUMBER IS

  PRAGMA AUTONOMOUS_TRANSACTION;

  lv_user_id             NUMBER := 0;
  lv_date                DATE   := TRUNC(SYSDATE);
  lv_contact_type_id     NUMBER;
  lv_member_type_id      NUMBER;
  lv_credit_card_type_id NUMBER;
  lv_address_type_id     NUMBER;
  lv_telephone_type_id   NUMBER;

  FUNCTION get_cl_id
    ( pv_table_name  VARCHAR2
    , pv_column_name VARCHAR2
    , pv_lookup_type VARCHAR2) RETURN NUMBER IS
    lv_retval  NUMBER := 0;
    CURSOR cl_id
      ( cv_table_name  VARCHAR2
      , cv_column_name VARCHAR2
      , cv_lookup_type VARCHAR2) IS
      SELECT common_lookup_id
      FROM   common_lookup
      WHERE  common_lookup_table = cv_table_name
      AND    common_lookup_column = cv_column_name
      AND    common_lookup_type = cv_lookup_type;
  BEGIN
    FOR i IN cl_id(pv_table_name, pv_column_name, pv_lookup_type) LOOP
      lv_retval := i.common_lookup_id;
    END LOOP;
    /* Return 0 when no row found and the ID # when row found. */
    RETURN lv_retval;
  END get_cl_id;

BEGIN

-- Get the system user ID
  SELECT system_user_id
  INTO lv_user_id
  FROM system_user
  WHERE system_user_name = pv_user_name;

-- Get the type IDs
  lv_contact_type_id     := get_cl_id('CONTACT', 'CONTACT_TYPE', UPPER(pv_contact_type));
  lv_member_type_id      := get_cl_id('MEMBER', 'MEMBER_TYPE', UPPER(pv_member_type));
  lv_credit_card_type_id := get_cl_id('MEMBER', 'CREDIT_CARD_TYPE', UPPER(pv_credit_card_type));
  lv_address_type_id     := get_cl_id('ADDRESS', 'ADDRESS_TYPE', UPPER(pv_address_type));
  lv_telephone_type_id   := get_cl_id('TELEPHONE', 'TELEPHONE_TYPE', UPPER(pv_telephone_type));

-- Begin insert transactions
  SAVEPOINT startpoint;

  INSERT INTO member
  ( member_id
  , member_type
  , account_number
  , credit_card_number
  , credit_card_type
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( member_s1.NEXTVAL
  , lv_member_type_id
  , pv_account_number
  , pv_credit_card_number
  , lv_credit_card_type_id
  , lv_user_id
  , lv_date
  , lv_user_id
  , lv_date );

  INSERT INTO contact
  ( contact_id
  , member_id
  , contact_type
  , last_name
  , first_name
  , middle_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  , lv_contact_type_id
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , lv_user_id
  , lv_date
  , lv_user_id
  , lv_date );  

  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  , lv_address_type_id
  , pv_city
  , pv_state_province
  , pv_postal_code
  , lv_user_id
  , lv_date
  , lv_user_id
  , lv_date );  

  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  , lv_telephone_type_id
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , lv_user_id                                     -- CREATED_BY
  , lv_date                                  -- CREATION_DATE
  , lv_user_id                                -- LAST_UPDATED_BY
  , lv_date);                             -- LAST_UPDATE_DATE

  COMMIT;
  RETURN 0;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO startpoint;
    RAISE;
    RETURN 1;
END insert_contact;
/


-- Step 3: Test insert_contact function
BEGIN
  IF insert_contact
  ( 'Harriet'
  , 'Mary'
  , 'McDonnell'
  , 'Customer'
  , 'SLC-000010'
  , 'Individual'
  , '9999-8888-7777-6666'
  , 'Visa_Card'
  , 'Orono'
  , 'Maine'
  , '04469'
  , 'Home'
  , '001'
  , '207'
  , '111-1234'
  , 'Home'
  , 'DBA 2') = 0 THEN
    dbms_output.put_line('Success!');
  ELSE
    dbms_output.put_line('Failure!');
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('Failure!');
    RAISE;
END;
/


-- Validate inserts
COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Xavier'
OR     c.last_name = 'Haggerty'
OR     c.last_name = 'McDonnell';


-- Step 4
CREATE OR REPLACE
  TYPE contact_obj IS OBJECT (
    first_name  VARCHAR2(20) 
  , middle_name VARCHAR2(20) 
  , last_name   VARCHAR2(20));
/

CREATE OR REPLACE
  TYPE contact_tab IS TABLE OF contact_obj;
/

CREATE OR REPLACE FUNCTION get_contact
  RETURN contact_tab IS

  lv_contact_tab CONTACT_TAB := contact_tab();

  CURSOR cname IS
    SELECT first_name, middle_name, last_name
    FROM contact;

BEGIN

  FOR c IN cname LOOP
    lv_contact_tab.EXTEND;
    lv_contact_tab(lv_contact_tab.COUNT) := contact_obj(c.first_name, c.middle_name, c.last_name);
  END LOOP;

  RETURN lv_contact_tab;
END get_contact;
/


-- Validate Step 4
SET PAGESIZE 999
COL full_name FORMAT A24
SELECT first_name || CASE
                       WHEN middle_name IS NOT NULL
                       THEN ' ' || middle_name || ' '
                       ELSE ' '
                     END || last_name AS full_name
FROM   TABLE(get_contact);

-- Close log file.
SPOOL OFF
