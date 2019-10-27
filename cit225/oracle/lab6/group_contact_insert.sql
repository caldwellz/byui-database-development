-- ------------------------------------------------------------------
--  Program Name:   group_contact_insert.sql
--  Lab Assignment: 6
--  Program Author: Zach Caldwell
--  Creation Date:  26-Oct-2019
-- ------------------------------------------------------------------
-- ------------------------------------------------------------------
--  Convenience function to reduce overly verbose individual inserts.
--  Adds a contact/address/telephone/etc. to the current member group.
-- ------------------------------------------------------------------

-- ------------------------------------------------------------------
--  Open log file.
-- ------------------------------------------------------------------
SPOOL group_contact_insert.txt

-- Transaction Management Example.
CREATE OR REPLACE PROCEDURE group_contact_insert
( pv_first_name          VARCHAR2
, pv_middle_name         VARCHAR2 := ''
, pv_last_name           VARCHAR2
, pv_contact_type        VARCHAR2
, pv_address_type        VARCHAR2
, pv_city                VARCHAR2
, pv_state_province      VARCHAR2
, pv_postal_code         VARCHAR2
, pv_street_address      VARCHAR2
, pv_telephone_type      VARCHAR2
, pv_country_code        VARCHAR2
, pv_area_code           VARCHAR2
, pv_telephone_number    VARCHAR2
, pv_created_by          NUMBER   := NULL
, pv_creation_date       DATE     := SYSDATE
, pv_last_updated_by     NUMBER   := NULL
, pv_last_update_date    DATE     := SYSDATE) IS
  id_created_by          NUMBER   := pv_created_by
, id_last_updated_by     NUMBER   := pv_last_updated_by;
BEGIN
 
  /* Create a SAVEPOINT as a starting point. */
  SAVEPOINT starting_point;

  -- Default to sysadmin if no user ids given
  IF pv_created_by IS NULL THEN
    SELECT   system_user_id
    INTO     id_created_by
    FROM     system_user
    WHERE    system_user_name = 'SYSADMIN'
  END IF;

  IF pv_last_updated_by IS NULL THEN
    SELECT   system_user_id
    INTO     id_last_updated_by
    FROM     system_user
    WHERE    system_user_name = 'SYSADMIN'
  END IF;

  /* Insert into the contact table. */
  INSERT INTO contact
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'CONTACT'
    AND      common_lookup_type = pv_contact_type)
  , pv_first_name
  , pv_middle_name
  , pv_last_name
  , id_created_by
  , pv_creation_date
  , id_last_updated_by
  , pv_last_update_date );  

  /* Insert into the address table. */
  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = pv_address_type)
  , pv_city
  , pv_state_province
  , pv_postal_code
  , id_created_by
  , pv_creation_date
  , id_last_updated_by
  , pv_last_update_date );  

  /* Insert into the street_address table. */
  INSERT INTO street_address
  VALUES
  ( street_address_s1.NEXTVAL
  , address_s1.CURRVAL
  , pv_street_address
  , id_created_by
  , pv_creation_date
  , id_last_updated_by
  , pv_last_update_date );  

  /* Insert into the telephone table. */
  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  ,(SELECT   common_lookup_id                         -- ADDRESS_TYPE
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = pv_telephone_type)
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , id_created_by                                     -- CREATED_BY
  , pv_creation_date                                  -- CREATION_DATE
  , id_last_updated_by                                -- LAST_UPDATED_BY
  , pv_last_update_date);                             -- LAST_UPDATE_DATE

  /* Commit the series of inserts. */
  COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END group_contact_insert;
/

-- ------------------------------------------------------------------
--  Close log file.
-- ------------------------------------------------------------------
SPOOL OFF

