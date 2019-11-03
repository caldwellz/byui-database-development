-- ------------------------------------------------------------------
--  Program Name:   create_insert_common_lookup.sql
--  Lab Assignment: 7
--  Program Author: Zach Caldwell
--  Creation Date:  02-Nov-2019
-- ------------------------------------------------------------------
-- ------------------------------------------------------------------
--  Convenience function to save some verboseness on common_lookup inserts
-- ------------------------------------------------------------------

-- ------------------------------------------------------------------
--  Open log file.
-- ------------------------------------------------------------------
SPOOL create_insert_common_lookup.txt

-- Transaction Management Example.
CREATE OR REPLACE PROCEDURE insert_common_lookup
( pv_cl_table            VARCHAR2
, pv_cl_column           VARCHAR2
, pv_cl_code             VARCHAR2
, pv_cl_type             VARCHAR2
, pv_cl_meaning          VARCHAR2
, pv_cl_id               NUMBER   := NULL
, pv_created_by          NUMBER   := NULL
, pv_creation_date       DATE     := SYSDATE
, pv_last_updated_by     NUMBER   := NULL
, pv_last_update_date    DATE     := SYSDATE) IS

id_common_lookup         NUMBER   := pv_cl_id;
id_created_by            NUMBER   := pv_created_by;
id_last_updated_by       NUMBER   := pv_last_updated_by;

BEGIN
 
  /* Create a SAVEPOINT as a starting point. */
  SAVEPOINT starting_point;

  -- Use sequence nextval if no lookup ID was given
  IF pv_cl_id IS NULL THEN
    id_common_lookup := common_lookup_s1.nextval;
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

  /* Insert into the common_lookup table. */
  INSERT INTO common_lookup
  ( common_lookup_id
  , common_lookup_table
  , common_lookup_column
  , common_lookup_code
  , common_lookup_type
  , common_lookup_meaning
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( id_common_lookup
  , pv_cl_table
  , pv_cl_column
  , pv_cl_code
  , pv_cl_type
  , pv_cl_meaning
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
END insert_common_lookup;
/

-- ------------------------------------------------------------------
--  Close log file.
-- ------------------------------------------------------------------
SPOOL OFF
