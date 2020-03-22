/*
||  Name:          apply_plsql_lab11.sql
||  Author:        Zach Caldwell
||  Purpose:       Complete 325 Chapter 12 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

-- Run initial lab scripts
@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql


-- Open log file.
SPOOL apply_plsql_lab11.txt


-- Add text_file_name column to the item table and allow null in desc
ALTER TABLE item
  ADD text_file_name VARCHAR2(40);
ALTER TABLE item
  MODIFY (item_desc NULL);


-- Conditionally drop logger sequence and table
BEGIN
  FOR i IN (SELECT uo.object_name
            ,      uo.object_type
            FROM   user_objects uo
            WHERE  uo.object_name IN ('LOGGER','LOGGER_S')) LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/


-- Create logger sequence and table
CREATE SEQUENCE logger_s;
CREATE TABLE logger
( logger_id                           NUMBER      NOT NULL
, OLD_ITEM_ID                          NUMBER
, OLD_ITEM_BARCODE                    VARCHAR2(20)
, OLD_ITEM_TYPE                        NUMBER
, OLD_ITEM_TITLE                       VARCHAR2(60)
, OLD_ITEM_SUBTITLE                    VARCHAR2(60)
, OLD_ITEM_RATING                      VARCHAR2(8)
, OLD_ITEM_RATING_AGENCY              VARCHAR2(4)
, OLD_ITEM_RELEASE_DATE                DATE
, OLD_CREATED_BY                       NUMBER
, OLD_CREATION_DATE                    DATE
, OLD_LAST_UPDATED_BY                  NUMBER
, OLD_LAST_UPDATE_DATE                DATE
, OLD_TEXT_FILE_NAME                  VARCHAR2(40)
, NEW_ITEM_ID                          NUMBER
, NEW_ITEM_BARCODE                    VARCHAR2(20)
, NEW_ITEM_TYPE                        NUMBER
, NEW_ITEM_TITLE                       VARCHAR2(60)
, NEW_ITEM_SUBTITLE                    VARCHAR2(60)
, NEW_ITEM_RATING                      VARCHAR2(8)
, NEW_ITEM_RATING_AGENCY                VARCHAR2(4)
, NEW_ITEM_RELEASE_DATE                DATE
, NEW_CREATED_BY                       NUMBER
, NEW_CREATION_DATE                    DATE
, NEW_LAST_UPDATED_BY                  NUMBER
, NEW_LAST_UPDATE_DATE                DATE
, NEW_TEXT_FILE_NAME                  VARCHAR2(40)
, CONSTRAINT logger_pk PRIMARY KEY (logger_id));


-- Do a test insert into the logger table
DECLARE
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'Brave Heart';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP

    INSERT INTO logger
    ( logger_id
    , old_item_id
    , old_item_barcode
    , old_item_type
    , old_item_title 
    , old_item_subtitle
    , old_item_rating
    , old_item_rating_agency 
    , old_item_release_date
    , old_created_by 
    , old_creation_date
    , old_last_updated_by
    , old_last_update_date
    , old_text_file_name
    , new_item_id
    , new_item_barcode
    , new_item_type
    , new_item_title 
    , new_item_subtitle
    , new_item_rating
    , new_item_rating_agency 
    , new_item_release_date
    , new_created_by 
    , new_creation_date
    , new_last_updated_by
    , new_last_update_date
    , new_text_file_name )
    VALUES
    ( logger_s.NEXTVAL
    , i.item_id
    , i.item_barcode
    , i.item_type
    , i.item_title 
    , i.item_subtitle
    , i.item_rating
    , i.item_rating_agency 
    , i.item_release_date
    , i.created_by 
    , i.creation_date
    , i.last_updated_by
    , i.last_update_date
    , i.text_file_name
    , i.item_id
    , i.item_barcode
    , i.item_type
    , i.item_title 
    , i.item_subtitle
    , i.item_rating
    , i.item_rating_agency 
    , i.item_release_date
    , i.created_by 
    , i.creation_date
    , i.last_updated_by
    , i.last_update_date
    , i.text_file_name );

  END LOOP;
END;
/


-- Query the logger table
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;


-- Define manage_item package
CREATE OR REPLACE PACKAGE manage_item IS
  -- Full UPDATING version
  PROCEDURE item_insert
  ( pv_old_item_id         NUMBER
  , pv_old_item_barcode      VARCHAR2
  , pv_old_item_type        NUMBER
  , pv_old_item_title        VARCHAR2
  , pv_old_item_subtitle      VARCHAR2
  , pv_old_item_rating        VARCHAR2
  , pv_old_item_rating_agency    VARCHAR2
  , pv_old_item_release_date    DATE
  , pv_old_created_by        NUMBER
  , pv_old_creation_date      DATE
  , pv_old_last_updated_by     NUMBER
  , pv_old_last_update_date    DATE
  , pv_old_text_file_name      VARCHAR2
  , pv_new_item_id         NUMBER
  , pv_new_item_barcode      VARCHAR2
  , pv_new_item_type        NUMBER
  , pv_new_item_title        VARCHAR2
  , pv_new_item_subtitle      VARCHAR2
  , pv_new_item_rating        VARCHAR2
  , pv_new_item_rating_agency    VARCHAR2
  , pv_new_item_release_date    DATE
  , pv_new_created_by        NUMBER
  , pv_new_creation_date      DATE
  , pv_new_last_updated_by     NUMBER
  , pv_new_last_update_date    DATE
  , pv_new_text_file_name      VARCHAR2 );

  -- INSERTING version
    PROCEDURE item_insert
  ( pv_new_item_id         NUMBER
  , pv_new_item_barcode      VARCHAR2
  , pv_new_item_type        NUMBER
  , pv_new_item_title        VARCHAR2
  , pv_new_item_subtitle      VARCHAR2
  , pv_new_item_rating        VARCHAR2
  , pv_new_item_rating_agency    VARCHAR2
  , pv_new_item_release_date    DATE
  , pv_new_created_by        NUMBER
  , pv_new_creation_date      DATE
  , pv_new_last_updated_by     NUMBER
  , pv_new_last_update_date    DATE
  , pv_new_text_file_name      VARCHAR2 );

  -- DELETING version
  PROCEDURE item_insert
  ( pv_old_item_id         NUMBER
  , pv_old_item_barcode      VARCHAR2
  , pv_old_item_type        NUMBER
  , pv_old_item_title        VARCHAR2
  , pv_old_item_subtitle      VARCHAR2
  , pv_old_item_rating        VARCHAR2
  , pv_old_item_rating_agency    VARCHAR2
  , pv_old_item_release_date    DATE
  , pv_old_created_by        NUMBER
  , pv_old_creation_date      DATE
  , pv_old_last_updated_by     NUMBER
  , pv_old_last_update_date    DATE
  , pv_old_text_file_name      VARCHAR2 );
END manage_item;
/


-- Implement manage_item package body
CREATE OR REPLACE PACKAGE BODY manage_item IS
  -- Full UPDATING version
  PROCEDURE item_insert
  ( pv_old_item_id         NUMBER
  , pv_old_item_barcode      VARCHAR2
  , pv_old_item_type        NUMBER
  , pv_old_item_title        VARCHAR2
  , pv_old_item_subtitle      VARCHAR2
  , pv_old_item_rating        VARCHAR2
  , pv_old_item_rating_agency    VARCHAR2
  , pv_old_item_release_date    DATE
  , pv_old_created_by        NUMBER
  , pv_old_creation_date      DATE
  , pv_old_last_updated_by     NUMBER
  , pv_old_last_update_date    DATE
  , pv_old_text_file_name      VARCHAR2
  , pv_new_item_id         NUMBER
  , pv_new_item_barcode      VARCHAR2
  , pv_new_item_type        NUMBER
  , pv_new_item_title        VARCHAR2
  , pv_new_item_subtitle      VARCHAR2
  , pv_new_item_rating        VARCHAR2
  , pv_new_item_rating_agency    VARCHAR2
  , pv_new_item_release_date    DATE
  , pv_new_created_by        NUMBER
  , pv_new_creation_date      DATE
  , pv_new_last_updated_by     NUMBER
  , pv_new_last_update_date    DATE
  , pv_new_text_file_name      VARCHAR2 ) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    SAVEPOINT startpoint;

    INSERT INTO logger
    ( logger_id
    , old_item_id
    , old_item_barcode
    , old_item_type
    , old_item_title 
    , old_item_subtitle
    , old_item_rating
    , old_item_rating_agency 
    , old_item_release_date
    , old_created_by 
    , old_creation_date
    , old_last_updated_by
    , old_last_update_date
    , old_text_file_name
    , new_item_id
    , new_item_barcode
    , new_item_type
    , new_item_title 
    , new_item_subtitle
    , new_item_rating
    , new_item_rating_agency 
    , new_item_release_date
    , new_created_by 
    , new_creation_date
    , new_last_updated_by
    , new_last_update_date
    , new_text_file_name )
    VALUES
    ( logger_s.NEXTVAL
    , pv_old_item_id
    , pv_old_item_barcode
    , pv_old_item_type
    , pv_old_item_title 
    , pv_old_item_subtitle
    , pv_old_item_rating
    , pv_old_item_rating_agency 
    , pv_old_item_release_date
    , pv_old_created_by 
    , pv_old_creation_date
    , pv_old_last_updated_by
    , pv_old_last_update_date
    , pv_old_text_file_name
    , pv_new_item_id
    , pv_new_item_barcode
    , pv_new_item_type
    , pv_new_item_title 
    , pv_new_item_subtitle
    , pv_new_item_rating
    , pv_new_item_rating_agency 
    , pv_new_item_release_date
    , pv_new_created_by 
    , pv_new_creation_date
    , pv_new_last_updated_by
    , pv_new_last_update_date
    , pv_new_text_file_name );
    COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK TO startpoint;
        RAISE;
  END item_insert;

  -- INSERTING version
  PROCEDURE item_insert
  ( pv_new_item_id         NUMBER
  , pv_new_item_barcode      VARCHAR2
  , pv_new_item_type        NUMBER
  , pv_new_item_title        VARCHAR2
  , pv_new_item_subtitle      VARCHAR2
  , pv_new_item_rating        VARCHAR2
  , pv_new_item_rating_agency    VARCHAR2
  , pv_new_item_release_date    DATE
  , pv_new_created_by        NUMBER
  , pv_new_creation_date      DATE
  , pv_new_last_updated_by     NUMBER
  , pv_new_last_update_date    DATE
  , pv_new_text_file_name      VARCHAR2 ) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    item_insert
    ( NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , pv_new_item_id 
    , pv_new_item_barcode
    , pv_new_item_type
    , pv_new_item_title
    , pv_new_item_subtitle
    , pv_new_item_rating
    , pv_new_item_rating_agency
    , pv_new_item_release_date
    , pv_new_created_by
    , pv_new_creation_date
    , pv_new_last_updated_by 
    , pv_new_last_update_date
    , pv_new_text_file_name );
  END item_insert;

  -- DELETING version
  PROCEDURE item_insert
  ( pv_old_item_id         NUMBER
  , pv_old_item_barcode      VARCHAR2
  , pv_old_item_type        NUMBER
  , pv_old_item_title        VARCHAR2
  , pv_old_item_subtitle      VARCHAR2
  , pv_old_item_rating        VARCHAR2
  , pv_old_item_rating_agency    VARCHAR2
  , pv_old_item_release_date    DATE
  , pv_old_created_by        NUMBER
  , pv_old_creation_date      DATE
  , pv_old_last_updated_by     NUMBER
  , pv_old_last_update_date    DATE
  , pv_old_text_file_name      VARCHAR2 ) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    item_insert
    ( pv_old_item_id 
    , pv_old_item_barcode
    , pv_old_item_type
    , pv_old_item_title
    , pv_old_item_subtitle
    , pv_old_item_rating
    , pv_old_item_rating_agency
    , pv_old_item_release_date
    , pv_old_created_by
    , pv_old_creation_date
    , pv_old_last_updated_by 
    , pv_old_last_update_date
    , pv_old_text_file_name
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL
    , NULL );
  END item_insert;
END manage_item;
/


-- Test manage_item package
DECLARE
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'King Arthur';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP
    -- Test INSERT 
    manage_item.item_insert
    ( pv_new_item_id => i.item_id
    , pv_new_item_barcode => i.item_barcode
    , pv_new_item_type => i.item_type
    , pv_new_item_title  => i.item_title || '-Inserted'
    , pv_new_item_subtitle => i.item_subtitle
    , pv_new_item_rating => i.item_rating
    , pv_new_item_rating_agency  => i.item_rating_agency 
    , pv_new_item_release_date => i.item_release_date
    , pv_new_created_by  => i.created_by 
    , pv_new_creation_date => i.creation_date
    , pv_new_last_updated_by => i.last_updated_by
    , pv_new_last_update_date => i.last_update_date
    , pv_new_text_file_name => i.text_file_name );

    -- Test UPDATE
    manage_item.item_insert
    ( pv_old_item_id => i.item_id
    , pv_old_item_barcode => i.item_barcode
    , pv_old_item_type => i.item_type
    , pv_old_item_title  => i.item_title 
    , pv_old_item_subtitle => i.item_subtitle
    , pv_old_item_rating => i.item_rating
    , pv_old_item_rating_agency  => i.item_rating_agency 
    , pv_old_item_release_date => i.item_release_date
    , pv_old_created_by  => i.created_by 
    , pv_old_creation_date => i.creation_date
    , pv_old_last_updated_by => i.last_updated_by
    , pv_old_last_update_date => i.last_update_date
    , pv_old_text_file_name => i.text_file_name
    , pv_new_item_id => i.item_id
    , pv_new_item_barcode => i.item_barcode
    , pv_new_item_type => i.item_type
    , pv_new_item_title  => i.item_title || '-Changed'
    , pv_new_item_subtitle => i.item_subtitle
    , pv_new_item_rating => i.item_rating
    , pv_new_item_rating_agency  => i.item_rating_agency 
    , pv_new_item_release_date => i.item_release_date
    , pv_new_created_by  => i.created_by 
    , pv_new_creation_date => i.creation_date
    , pv_new_last_updated_by => i.last_updated_by
    , pv_new_last_update_date => i.last_update_date
    , pv_new_text_file_name => i.text_file_name );

    -- Test DELETE
    manage_item.item_insert
    ( pv_old_item_id => i.item_id
    , pv_old_item_barcode => i.item_barcode
    , pv_old_item_type => i.item_type
    , pv_old_item_title  => i.item_title || '-Deleted'
    , pv_old_item_subtitle => i.item_subtitle
    , pv_old_item_rating => i.item_rating
    , pv_old_item_rating_agency  => i.item_rating_agency 
    , pv_old_item_release_date => i.item_release_date
    , pv_old_created_by  => i.created_by 
    , pv_old_creation_date => i.creation_date
    , pv_old_last_updated_by => i.last_updated_by
    , pv_old_last_update_date => i.last_update_date
    , pv_old_text_file_name => i.text_file_name );
  END LOOP;
END;
/


-- Query the logger table
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;


-- Create INSERT/UPDATE trigger
CREATE OR REPLACE TRIGGER item_trig
  BEFORE INSERT OR UPDATE ON item
  REFERENCING NEW AS new OLD AS old
  FOR EACH ROW
  DECLARE
    lv_title_colon_pos NUMBER;
  BEGIN
    lv_title_colon_pos := INSTR(:new.item_title, ': ');

    /* Check for an event and log accordingly. */
    IF INSERTING THEN
      -- Check for a title colon and split into a subtitle if needed
      IF lv_title_colon_pos > 0 THEN
        IF (lv_title_colon_pos + 1) < LENGTH(:new.item_title) THEN
          :new.item_subtitle := SUBSTR(:new.item_title, lv_title_colon_pos + 2);
        END IF;
        :new.item_title := SUBSTR(:new.item_title, 0, lv_title_colon_pos - 1);
      END IF;

      /* Log the insert change to the item table in the logger table. */
      manage_item.item_insert
      ( pv_new_item_id => :new.item_id
      , pv_new_item_barcode => :new.item_barcode
      , pv_new_item_type => :new.item_type
      , pv_new_item_title  => :new.item_title
      , pv_new_item_subtitle => :new.item_subtitle
      , pv_new_item_rating => :new.item_rating
      , pv_new_item_rating_agency  => :new.item_rating_agency 
      , pv_new_item_release_date => :new.item_release_date
      , pv_new_created_by  => :new.created_by 
      , pv_new_creation_date => :new.creation_date
      , pv_new_last_updated_by => :new.last_updated_by
      , pv_new_last_update_date => :new.last_update_date
      , pv_new_text_file_name => :new.text_file_name );
    ELSIF UPDATING THEN
      /* Log the update change to the item table in the logging table. */
      manage_item.item_insert
      ( pv_old_item_id => :old.item_id
      , pv_old_item_barcode => :old.item_barcode
      , pv_old_item_type => :old.item_type
      , pv_old_item_title  => :old.item_title
      , pv_old_item_subtitle => :old.item_subtitle
      , pv_old_item_rating => :old.item_rating
      , pv_old_item_rating_agency  => :old.item_rating_agency 
      , pv_old_item_release_date => :old.item_release_date
      , pv_old_created_by  => :old.created_by 
      , pv_old_creation_date => :old.creation_date
      , pv_old_last_updated_by => :old.last_updated_by
      , pv_old_last_update_date => :old.last_update_date
      , pv_old_text_file_name => :old.text_file_name
      , pv_new_item_id => :new.item_id
      , pv_new_item_barcode => :new.item_barcode
      , pv_new_item_type => :new.item_type
      , pv_new_item_title  => :new.item_title
      , pv_new_item_subtitle => :new.item_subtitle
      , pv_new_item_rating => :new.item_rating
      , pv_new_item_rating_agency  => :new.item_rating_agency 
      , pv_new_item_release_date => :new.item_release_date
      , pv_new_created_by  => :new.created_by 
      , pv_new_creation_date => :new.creation_date
      , pv_new_last_updated_by => :new.last_updated_by
      , pv_new_last_update_date => :new.last_update_date
      , pv_new_text_file_name => :new.text_file_name );

      -- Check for a title colon and throw error if needed
      IF lv_title_colon_pos > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No colons allowed in item titles.');
      END IF;
    END IF;
  END item_trig;
/


-- Create DELETE trigger
CREATE OR REPLACE TRIGGER item_delete_trig
  BEFORE DELETE ON item
  FOR EACH ROW
  DECLARE
  BEGIN
    IF DELETING THEN
      /* Log the delete change to the item table in the logging table. */
      manage_item.item_insert
      ( pv_old_item_id => :old.item_id
      , pv_old_item_barcode => :old.item_barcode
      , pv_old_item_type => :old.item_type
      , pv_old_item_title  => :old.item_title
      , pv_old_item_subtitle => :old.item_subtitle
      , pv_old_item_rating => :old.item_rating
      , pv_old_item_rating_agency  => :old.item_rating_agency 
      , pv_old_item_release_date => :old.item_release_date
      , pv_old_created_by  => :old.created_by 
      , pv_old_creation_date => :old.creation_date
      , pv_old_last_updated_by => :old.last_updated_by
      , pv_old_last_update_date => :old.last_update_date
      , pv_old_text_file_name => :old.text_file_name );
    END IF;
  END item_delete_trig;
/


-- Temprarily remove foreign key constraints for testing
ALTER TABLE rental_item
  DROP CONSTRAINT fk_rental_item_2;
ALTER TABLE price
  DROP CONSTRAINT fk_price_1;


-- Test item triggers
DELETE FROM item
  WHERE item_id = 1087;

INSERT INTO item
( item_id
, item_barcode
, item_type
, item_title
, item_rating
, item_rating_agency
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( 1087
, 'ASIN: B000930DPU'
, 1015
, 'Harry Potter: Goblet of Fire'
, 'E10+'
, 'ESRB'
, '15-JUN-06'
, 1
, TRUNC(SYSDATE)
, 1
, TRUNC(SYSDATE) );

UPDATE item
  SET item_title = 'Harry Potter: Goblet of Fire'
  WHERE item_id = 1087;


-- View updated item and logger table
COL item_title FORMAT A15
COL item_subtitle FORMAT A15
SELECT item_title, item_subtitle FROM item WHERE item_id = 1087;

COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;


-- Close log file.
SPOOL OFF
