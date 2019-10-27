-- ------------------------------------------------------------------
--  Program Name:   create_insert_rental.sql
--  Lab Assignment: 6
--  Program Author: Zach Caldwell
--  Creation Date:  26-Oct-2019
-- ------------------------------------------------------------------
-- ------------------------------------------------------------------
--  Convenience function to create both a RENTAL and a RENTAL_ITEM
-- ------------------------------------------------------------------

-- ------------------------------------------------------------------
--  Open log file.
-- ------------------------------------------------------------------
SPOOL create_insert_rental.txt

-- Transaction Management Example.
CREATE OR REPLACE PROCEDURE insert_rental
( pv_customer_id         NUMBER
, pv_item_id             NUMBER
, pv_return_date         DATE
, pv_check_out_date      DATE     := TRUNC(SYSDATE)
, pv_created_by          NUMBER   := NULL
, pv_creation_date       DATE     := SYSDATE
, pv_last_updated_by     NUMBER   := NULL
, pv_last_update_date    DATE     := SYSDATE) IS
id_created_by            NUMBER   := pv_created_by;
id_last_updated_by       NUMBER   := pv_last_updated_by;
BEGIN
 
  /* Create a SAVEPOINT as a starting point. */
  SAVEPOINT starting_point;

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

  /* Insert into the rental table. */
  INSERT INTO rental
  VALUES
  ( rental_s1.nextval
  , pv_customer_id
  , pv_check_out_date
  , pv_return_date
  , id_created_by
  , pv_creation_date
  , id_last_updated_by
  , pv_last_update_date );

  /* Insert into the rental_item table. */
  INSERT INTO rental_item
  VALUES
  ( rental_item_s1.nextval
  , rental_s1.currval
  , pv_item_id
  , id_created_by
  , pv_creation_date
  , id_last_updated_by
  , pv_last_update_date );

  /* Commit the series of inserts. */
  COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END insert_rental;
/

-- ------------------------------------------------------------------
--  Close log file.
-- ------------------------------------------------------------------
SPOOL OFF
