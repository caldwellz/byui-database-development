/*
||  Name:          apply_plsql_lab8.sql
||  Author:        Zach Caldwell
||  Purpose:       Complete 325 Chapter 9 lab.
*/

-- Call seeding libraries.
@$LIB/cleanup_oracle.sql
@$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab8.txt

-- Insert new DBAs
INSERT INTO system_user
  ( system_user_id
  , system_user_name
  , system_user_group_id
  , system_user_type
  , first_name
  , middle_initial
  , last_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( 6
  , 'BONDSB'
  , 1
  , 1
  , 'Barry'
  , 'L'
  , 'Bonds'
  , 1
  , TRUNC(SYSDATE)
  , 1
  , TRUNC(SYSDATE) );

INSERT INTO system_user
  ( system_user_id
  , system_user_name
  , system_user_group_id
  , system_user_type
  , first_name
  , middle_initial
  , last_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( 7
  , 'CURRYW'
  , 1
  , 1
  , 'Wardell'
  , 'S'
  , 'Curry'
  , 1
  , TRUNC(SYSDATE)
  , 1
  , TRUNC(SYSDATE) );

INSERT INTO system_user
  ( system_user_id
  , system_user_name
  , system_user_group_id
  , system_user_type
  , first_name
  , middle_initial
  , last_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( -1
  , 'ANONYMOUS'
  , 1
  , 1
  , ''
  , ''
  , ''
  , 1
  , TRUNC(SYSDATE)
  , 1
  , TRUNC(SYSDATE) );


-- Verify DBA inserts
COL system_user_id  FORMAT 9999  HEADING "System|User ID"
COL system_user_name FORMAT A12  HEADING "System|User Name"
COL first_name       FORMAT A10  HEADING "First|Name"
COL middle_initial   FORMAT A2   HEADING "MI"
COL last_name        FORMAT A10  HeADING "Last|Name"
SELECT system_user_id
,      system_user_name
,      first_name
,      middle_initial
,      last_name
FROM   system_user
WHERE  last_name IN ('Bonds','Curry')
OR     system_user_name = 'ANONYMOUS';


-- Create package with procedure signatures
CREATE OR REPLACE PACKAGE contact_package IS
  -- Numbered user ID version
  PROCEDURE insert_contact
  ( pv_first_name         VARCHAR2
  , pv_middle_name        VARCHAR2 := NULL
  , pv_last_name          VARCHAR2
  , pv_contact_type       VARCHAR2
  , pv_account_number     VARCHAR2
  , pv_member_type        VARCHAR2 := NULL
  , pv_credit_card_number VARCHAR2 := NULL
  , pv_credit_card_type   VARCHAR2 := NULL
  , pv_city               VARCHAR2
  , pv_state_province     VARCHAR2
  , pv_postal_code        VARCHAR2
  , pv_address_type       VARCHAR2
  , pv_country_code       VARCHAR2
  , pv_area_code          VARCHAR2
  , pv_telephone_number   VARCHAR2
  , pv_telephone_type     VARCHAR2
  , pv_user_id            NUMBER   := NULL);

  -- User string version
  PROCEDURE insert_contact
  ( pv_first_name         VARCHAR2
  , pv_middle_name        VARCHAR2 := NULL
  , pv_last_name          VARCHAR2
  , pv_contact_type       VARCHAR2
  , pv_account_number     VARCHAR2
  , pv_member_type        VARCHAR2 := NULL
  , pv_credit_card_number VARCHAR2 := NULL
  , pv_credit_card_type   VARCHAR2 := NULL
  , pv_city               VARCHAR2
  , pv_state_province     VARCHAR2
  , pv_postal_code        VARCHAR2
  , pv_address_type       VARCHAR2
  , pv_country_code       VARCHAR2
  , pv_area_code          VARCHAR2
  , pv_telephone_number   VARCHAR2
  , pv_telephone_type     VARCHAR2
  , pv_user_name          VARCHAR2 );
END contact_package;
/


-- Implement package body
CREATE OR REPLACE PACKAGE BODY contact_package IS
  -- Numbered user ID version
  PROCEDURE insert_contact
    ( pv_first_name         VARCHAR2
    , pv_middle_name        VARCHAR2 := NULL
    , pv_last_name          VARCHAR2
    , pv_contact_type       VARCHAR2
    , pv_account_number     VARCHAR2
    , pv_member_type        VARCHAR2 := NULL
    , pv_credit_card_number VARCHAR2 := NULL
    , pv_credit_card_type   VARCHAR2 := NULL
    , pv_city               VARCHAR2
    , pv_state_province     VARCHAR2
    , pv_postal_code        VARCHAR2
    , pv_address_type       VARCHAR2
    , pv_country_code       VARCHAR2
    , pv_area_code          VARCHAR2
    , pv_telephone_number   VARCHAR2
    , pv_telephone_type     VARCHAR2
    , pv_user_id            NUMBER   := NULL)
  IS
    lv_user_id             NUMBER;
    lv_date                DATE := TRUNC(SYSDATE);
    lv_contact_type_id     NUMBER;
    lv_member_id           NUMBER;
    lv_member_type_id      NUMBER;
    lv_credit_card_type_id NUMBER;
    lv_address_type_id     NUMBER;
    lv_telephone_type_id   NUMBER;

    -- Cursor to check for an existing member account
    CURSOR get_member IS
      SELECT member_id FROM member
      WHERE pv_account_number = account_number;

    -- Get a common-lookup ID given the table, column, and type
    FUNCTION get_cl_id
      ( pv_table_name  VARCHAR2
      , pv_column_name VARCHAR2
      , pv_lookup_type VARCHAR2)
    RETURN NUMBER IS
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
    -- Set the anonymous user ID if needed
    IF pv_user_id IS NULL THEN
      lv_user_id := -1;
    ELSE
      lv_user_id := pv_user_id;
    END IF;

    -- Get the type IDs
    lv_contact_type_id     := get_cl_id('CONTACT', 'CONTACT_TYPE', UPPER(pv_contact_type));
    lv_member_type_id      := get_cl_id('MEMBER', 'MEMBER_TYPE', UPPER(pv_member_type));
    lv_credit_card_type_id := get_cl_id('MEMBER', 'CREDIT_CARD_TYPE', UPPER(pv_credit_card_type));
    lv_address_type_id     := get_cl_id('ADDRESS', 'ADDRESS_TYPE', UPPER(pv_address_type));
    lv_telephone_type_id   := get_cl_id('TELEPHONE', 'TELEPHONE_TYPE', UPPER(pv_telephone_type));

    -- Begin database transactions
    SAVEPOINT startpoint;

    -- Check if we are adding to an existing membership and add one otherwise
    OPEN get_member;
    FETCH get_member INTO lv_member_id;
    IF get_member%NOTFOUND THEN
      lv_member_id := member_s1.NEXTVAL;
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
      ( lv_member_id
      , lv_member_type_id
      , pv_account_number
      , pv_credit_card_number
      , lv_credit_card_type_id
      , lv_user_id
      , lv_date
      , lv_user_id
      , lv_date );
    END IF;
    CLOSE get_member;

    -- Add the contact to the membership
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
    , lv_member_id
    , lv_contact_type_id
    , pv_last_name
    , pv_first_name
    , pv_middle_name
    , lv_user_id
    , lv_date
    , lv_user_id
    , lv_date );  

    -- Add the address
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

    -- Add the phone number
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

  -- User string version
  PROCEDURE insert_contact
    ( pv_first_name         VARCHAR2
    , pv_middle_name        VARCHAR2 := NULL
    , pv_last_name          VARCHAR2
    , pv_contact_type       VARCHAR2
    , pv_account_number     VARCHAR2
    , pv_member_type        VARCHAR2 := NULL
    , pv_credit_card_number VARCHAR2 := NULL
    , pv_credit_card_type   VARCHAR2 := NULL
    , pv_city               VARCHAR2
    , pv_state_province     VARCHAR2
    , pv_postal_code        VARCHAR2
    , pv_address_type       VARCHAR2
    , pv_country_code       VARCHAR2
    , pv_area_code          VARCHAR2
    , pv_telephone_number   VARCHAR2
    , pv_telephone_type     VARCHAR2
    , pv_user_name          VARCHAR2 )
    IS
      lv_user_id            NUMBER := NULL;
    BEGIN
      -- Get the system user ID
      SELECT system_user_id
      INTO lv_user_id
      FROM system_user
      WHERE system_user_name = pv_user_name;

      -- Call the overloaded function
      insert_contact
        ( pv_first_name
        , pv_middle_name
        , pv_last_name
        , pv_contact_type
        , pv_account_number
        , pv_member_type
        , pv_credit_card_number
        , pv_credit_card_type
        , pv_city
        , pv_state_province
        , pv_postal_code
        , pv_address_type
        , pv_country_code
        , pv_area_code
        , pv_telephone_number
        , pv_telephone_type
        , lv_user_id);
    END insert_contact;
END contact_package;
/


-- Test procedure package using three inserts
BEGIN
  contact_package.insert_contact(
    'Charlie'
  , NULL
  , 'Brown'
  , 'CUSTOMER'
  , 'SLC-000011'
  , 'GROUP'
  , '8888-6666-8888-4444'
  , 'VISA_CARD'
  , 'Lehi'
  , 'Utah'
  , '84043'
  , 'HOME'
  , '001'
  , '207'
  , '877-4321'
  , 'HOME'
  , 'DBA 3' );

  contact_package.insert_contact(
      pv_first_name         => 'Peppermint'
    , pv_last_name          => 'Patty'
    , pv_contact_type       => 'CUSTOMER'
    , pv_account_number     => 'SLC-000011'
    , pv_city               => 'Lehi'
    , pv_state_province     => 'Utah'
    , pv_postal_code        => '84043'
    , pv_address_type       => 'HOME'
    , pv_country_code       => '001'
    , pv_area_code          => '207'
    , pv_telephone_number   => '877-4321'
    , pv_telephone_type     => 'HOME' );

  contact_package.insert_contact(
      pv_first_name         => 'Sally'
    , pv_last_name          => 'Brown'
    , pv_contact_type       => 'CUSTOMER'
    , pv_account_number     => 'SLC-000011'
    , pv_city               => 'Lehi'
    , pv_state_province     => 'Utah'
    , pv_postal_code        => '84043'
    , pv_address_type       => 'HOME'
    , pv_country_code       => '001'
    , pv_area_code          => '207'
    , pv_telephone_number   => '877-4321'
    , pv_telephone_type     => 'HOME'
    , pv_user_id            => 6 );
END;
/


-- Verify inserted records
COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14
COL created_by     FORMAT 9999

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
,      c.created_by
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name IN ('Brown','Patty');


-- Re-create package with function signatures
CREATE OR REPLACE PACKAGE contact_package IS
  -- Numbered user ID version
  FUNCTION insert_contact
  ( pv_first_name         VARCHAR2
  , pv_middle_name        VARCHAR2 := NULL
  , pv_last_name          VARCHAR2
  , pv_contact_type       VARCHAR2
  , pv_account_number     VARCHAR2
  , pv_member_type        VARCHAR2 := NULL
  , pv_credit_card_number VARCHAR2 := NULL
  , pv_credit_card_type   VARCHAR2 := NULL
  , pv_city               VARCHAR2
  , pv_state_province     VARCHAR2
  , pv_postal_code        VARCHAR2
  , pv_address_type       VARCHAR2
  , pv_country_code       VARCHAR2
  , pv_area_code          VARCHAR2
  , pv_telephone_number   VARCHAR2
  , pv_telephone_type     VARCHAR2
  , pv_user_id            NUMBER   := NULL )
  RETURN NUMBER;

  -- User string version
  FUNCTION insert_contact
  ( pv_first_name         VARCHAR2
  , pv_middle_name        VARCHAR2 := NULL
  , pv_last_name          VARCHAR2
  , pv_contact_type       VARCHAR2
  , pv_account_number     VARCHAR2
  , pv_member_type        VARCHAR2 := NULL
  , pv_credit_card_number VARCHAR2 := NULL
  , pv_credit_card_type   VARCHAR2 := NULL
  , pv_city               VARCHAR2
  , pv_state_province     VARCHAR2
  , pv_postal_code        VARCHAR2
  , pv_address_type       VARCHAR2
  , pv_country_code       VARCHAR2
  , pv_area_code          VARCHAR2
  , pv_telephone_number   VARCHAR2
  , pv_telephone_type     VARCHAR2
  , pv_user_name          VARCHAR2 )
  RETURN NUMBER;
END contact_package;
/


-- Implement package body
CREATE OR REPLACE PACKAGE BODY contact_package IS
  -- Numbered user ID version
  FUNCTION insert_contact
    ( pv_first_name         VARCHAR2
    , pv_middle_name        VARCHAR2 := NULL
    , pv_last_name          VARCHAR2
    , pv_contact_type       VARCHAR2
    , pv_account_number     VARCHAR2
    , pv_member_type        VARCHAR2 := NULL
    , pv_credit_card_number VARCHAR2 := NULL
    , pv_credit_card_type   VARCHAR2 := NULL
    , pv_city               VARCHAR2
    , pv_state_province     VARCHAR2
    , pv_postal_code        VARCHAR2
    , pv_address_type       VARCHAR2
    , pv_country_code       VARCHAR2
    , pv_area_code          VARCHAR2
    , pv_telephone_number   VARCHAR2
    , pv_telephone_type     VARCHAR2
    , pv_user_id            NUMBER   := NULL)
  RETURN NUMBER IS
    lv_user_id             NUMBER;
    lv_date                DATE := TRUNC(SYSDATE);
    lv_contact_type_id     NUMBER;
    lv_member_id           NUMBER;
    lv_member_type_id      NUMBER;
    lv_credit_card_type_id NUMBER;
    lv_address_type_id     NUMBER;
    lv_telephone_type_id   NUMBER;

    -- Cursor to check for an existing member account
    CURSOR get_member IS
      SELECT member_id FROM member
      WHERE pv_account_number = account_number;

    -- Get a common-lookup ID given the table, column, and type
    FUNCTION get_cl_id
      ( pv_table_name  VARCHAR2
      , pv_column_name VARCHAR2
      , pv_lookup_type VARCHAR2)
    RETURN NUMBER IS
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
    -- Set the anonymous user ID if needed
    IF pv_user_id IS NULL THEN
      lv_user_id := -1;
    ELSE
      lv_user_id := pv_user_id;
    END IF;

    -- Get the type IDs
    lv_contact_type_id     := get_cl_id('CONTACT', 'CONTACT_TYPE', UPPER(pv_contact_type));
    lv_member_type_id      := get_cl_id('MEMBER', 'MEMBER_TYPE', UPPER(pv_member_type));
    lv_credit_card_type_id := get_cl_id('MEMBER', 'CREDIT_CARD_TYPE', UPPER(pv_credit_card_type));
    lv_address_type_id     := get_cl_id('ADDRESS', 'ADDRESS_TYPE', UPPER(pv_address_type));
    lv_telephone_type_id   := get_cl_id('TELEPHONE', 'TELEPHONE_TYPE', UPPER(pv_telephone_type));

    -- Begin database transactions
    SAVEPOINT startpoint;

    -- Check if we are adding to an existing membership and add one otherwise
    OPEN get_member;
    FETCH get_member INTO lv_member_id;
    IF get_member%NOTFOUND THEN
      lv_member_id := member_s1.NEXTVAL;
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
      ( lv_member_id
      , lv_member_type_id
      , pv_account_number
      , pv_credit_card_number
      , lv_credit_card_type_id
      , lv_user_id
      , lv_date
      , lv_user_id
      , lv_date );
    END IF;
    CLOSE get_member;

    -- Add the contact to the membership
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
    , lv_member_id
    , lv_contact_type_id
    , pv_last_name
    , pv_first_name
    , pv_middle_name
    , lv_user_id
    , lv_date
    , lv_user_id
    , lv_date );  

    -- Add the address
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

    -- Add the phone number
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

  -- User string version
  FUNCTION insert_contact
    ( pv_first_name         VARCHAR2
    , pv_middle_name        VARCHAR2 := NULL
    , pv_last_name          VARCHAR2
    , pv_contact_type       VARCHAR2
    , pv_account_number     VARCHAR2
    , pv_member_type        VARCHAR2 := NULL
    , pv_credit_card_number VARCHAR2 := NULL
    , pv_credit_card_type   VARCHAR2 := NULL
    , pv_city               VARCHAR2
    , pv_state_province     VARCHAR2
    , pv_postal_code        VARCHAR2
    , pv_address_type       VARCHAR2
    , pv_country_code       VARCHAR2
    , pv_area_code          VARCHAR2
    , pv_telephone_number   VARCHAR2
    , pv_telephone_type     VARCHAR2
    , pv_user_name          VARCHAR2 )
    RETURN NUMBER IS
      lv_user_id            NUMBER := NULL;
    BEGIN
      -- Get the system user ID
      SELECT system_user_id
      INTO lv_user_id
      FROM system_user
      WHERE system_user_name = pv_user_name;

      -- Call the overloaded function
      RETURN insert_contact
        ( pv_first_name
        , pv_middle_name
        , pv_last_name
        , pv_contact_type
        , pv_account_number
        , pv_member_type
        , pv_credit_card_number
        , pv_credit_card_type
        , pv_city
        , pv_state_province
        , pv_postal_code
        , pv_address_type
        , pv_country_code
        , pv_area_code
        , pv_telephone_number
        , pv_telephone_type
        , lv_user_id);
    END insert_contact;
END contact_package;
/


-- Test package using three inserts
DECLARE
  lv_retval NUMBER;
BEGIN
  lv_retval := contact_package.insert_contact(
    'Shirley'
  , NULL
  , 'Partridge'
  , 'CUSTOMER'
  , 'SLC-000012'
  , 'GROUP'
  , '8888-6666-8888-4444'
  , 'VISA_CARD'
  , 'Lehi'
  , 'Utah'
  , '84043'
  , 'HOME'
  , '001'
  , '207'
  , '877-4321'
  , 'HOME'
  , 'DBA 3' );

  lv_retval := contact_package.insert_contact(
      pv_first_name         => 'Keith'
    , pv_last_name          => 'Partridge'
    , pv_contact_type       => 'CUSTOMER'
    , pv_account_number     => 'SLC-000012'
    , pv_city               => 'Lehi'
    , pv_state_province     => 'Utah'
    , pv_postal_code        => '84043'
    , pv_address_type       => 'HOME'
    , pv_country_code       => '001'
    , pv_area_code          => '207'
    , pv_telephone_number   => '877-4321'
    , pv_telephone_type     => 'HOME'
    , pv_user_id            => 6 );

  lv_retval := contact_package.insert_contact(
      pv_first_name         => 'Laurie'
    , pv_last_name          => 'Partridge'
    , pv_contact_type       => 'CUSTOMER'
    , pv_account_number     => 'SLC-000012'
    , pv_city               => 'Lehi'
    , pv_state_province     => 'Utah'
    , pv_postal_code        => '84043'
    , pv_address_type       => 'HOME'
    , pv_country_code       => '001'
    , pv_area_code          => '207'
    , pv_telephone_number   => '877-4321'
    , pv_telephone_type     => 'HOME' );
END;
/


-- Validate the three inserts
COL full_name      FORMAT A18   HEADING "Full Name"
COL created_by     FORMAT 9999  HEADING "System|User ID"
COL account_number FORMAT A12   HEADING "Account|Number"
COL address        FORMAT A16   HEADING "Address"
COL telephone      FORMAT A16   HEADING "Telephone"
SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      c.created_by
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Partridge';

-- Finish up
SHOW ERRORS
SPOOL OFF
