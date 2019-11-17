-- ------------------------------------------------------------------
--  Program Name:   create_insert_airport.sql
--  Lab Assignment: 9
--  Program Author: Zach Caldwell
--  Creation Date:  16-Nov-2019
-- ------------------------------------------------------------------
-- ------------------------------------------------------------------
--  Convenience function to save some verboseness on airport inserts
-- ------------------------------------------------------------------

-- ------------------------------------------------------------------
--  Open log file.
-- ------------------------------------------------------------------
SPOOL create_insert_airport.txt

-- Transaction Management Example.
CREATE OR REPLACE PROCEDURE insert_airport
( pv_airport_code     VARCHAR2
, pv_airport_city     VARCHAR2
, pv_city             VARCHAR2
, pv_state_province   VARCHAR2
, pv_airport_id       NUMBER   := NULL
, pv_created_by       NUMBER   := NULL
, pv_creation_date    DATE     := SYSDATE
, pv_last_updated_by  NUMBER   := NULL
, pv_last_update_date DATE     := SYSDATE) IS

id_airport            NUMBER   := pv_airport_id;
id_created_by         NUMBER   := pv_created_by;
id_last_updated_by    NUMBER   := pv_last_updated_by;

BEGIN
 
  /* Create a SAVEPOINT as a starting point. */
  SAVEPOINT starting_point;

  -- Use sequence nextval if no lookup ID was given
  IF pv_airport_id IS NULL THEN
    id_airport := airport_s1.nextval;
  END IF;

  -- Default to sysadmin if no user ids given
  IF pv_created_by IS NULL THEN
    SELECT   system_user_id
    INTO     id_created_by
    FROM     system_user
    WHERE    system_user_name = 'SYSADMIN';
  END IF;

  IF pv_last_updated_by IS NULL THEN
    SELECT   system_user_id
    INTO     id_last_updated_by
    FROM     system_user
    WHERE    system_user_name = 'SYSADMIN';
  END IF;

  /* Insert into the airport table. */
  INSERT INTO airport
  ( airport_id
  , airport_code
  , airport_city
  , city
  , state_province
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( id_airport
  , pv_airport_code
  , pv_airport_city
  , pv_city
  , pv_state_province
  , id_created_by
  , pv_creation_date
  , id_last_updated_by
  , pv_last_update_date );

  /* Commit the insert. */
  COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END insert_airport;
/

-- ------------------------------------------------------------------
--  Close log file.
-- ------------------------------------------------------------------
SPOOL OFF
