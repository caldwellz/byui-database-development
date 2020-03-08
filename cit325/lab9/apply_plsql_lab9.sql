/*
||  Name:          apply_plsql_lab9.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 10 lab.
*/

-- Call seeding libraries from within the following file.
@$CIT325/lab9/apply_prep_lab9.sql

-- Open log file.
SPOOL apply_plsql_lab9.txt


-- Conditionally drop tables from prior runs
BEGIN
  FOR i IN (SELECT table_name
            FROM   user_tables
            WHERE  table_name = 'AVENGER'
            OR     table_name = 'FILE_LIST') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||i.table_name||' CASCADE CONSTRAINTS';
  END LOOP;
END;
/


-- Create CSV-backed AVENGER table
CREATE TABLE avenger
( avenger_id      NUMBER
, first_name      VARCHAR2(20)
, last_name       VARCHAR2(20)
, character_name  VARCHAR2(20))
 ORGANIZATION EXTERNAL
 ( TYPE oracle_loader
   DEFAULT DIRECTORY uploadtext
   ACCESS PARAMETERS
   ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
     BADFILE     'UPLOADTEXT':'avenger.bad'
     DISCARDFILE 'UPLOADTEXT':'avenger.dis'
     LOGFILE     'UPLOADTEXT':'avenger.log'
     FIELDS TERMINATED BY ','
     OPTIONALLY ENCLOSED BY "'"
     MISSING FIELD VALUES ARE NULL )
   LOCATION ('avenger.csv'))
REJECT LIMIT 0;


-- Create the file_list external preprocessor
CREATE TABLE file_list
( file_name VARCHAR2(60))
ORGANIZATION EXTERNAL
  ( TYPE oracle_loader
    DEFAULT DIRECTORY uploadtext
    ACCESS PARAMETERS
    ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      PREPROCESSOR uploadtext:'dir_list.sh'
      BADFILE     'UPLOADTEXT':'dir_list.bad'
      DISCARDFILE 'UPLOADTEXT':'dir_list.dis'
      LOGFILE     'UPLOADTEXT':'dir_list.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL)
    LOCATION ('dir_list.sh'))
  REJECT LIMIT UNLIMITED;


-- Fix ITEM data set
UPDATE item i
SET    i.item_title = 'Harry Potter and the Sorcerer''s Stone'
WHERE  i.item_title = 'Harry Potter and the Sorcer''s Stone';


-- Add new column to ITEM
ALTER TABLE item
  ADD text_file_name VARCHAR2(30);


-- Update new column value for existing items
UPDATE item i
  SET    i.text_file_name = 'HarryPotter1.txt'
  WHERE  i.item_title = 'Harry Potter and the Sorcerer''s Stone';
UPDATE item i
  SET    i.text_file_name = 'HarryPotter2.txt'
  WHERE  i.item_title = 'Harry Potter and the Chamber of Secrets';
UPDATE item i
  SET    i.text_file_name = 'HarryPotter3.txt'
  WHERE  i.item_title = 'Harry Potter and the Prisoner of Azkaban';
UPDATE item i
  SET    i.text_file_name = 'HarryPotter4.txt'
  WHERE  i.item_title = 'Harry Potter and the Goblet of Fire';
UPDATE item i
  SET    i.text_file_name = 'HarryPotter5.txt'
  WHERE  i.item_title = 'Harry Potter and the Order of the Phoenix';


-- Create update_item_description procedure
CREATE OR REPLACE PROCEDURE update_item_description
  (pv_item_title VARCHAR2)
IS
  CURSOR cs (partial_title VARCHAR2) IS
    SELECT item_id, text_file_name
    FROM item i JOIN file_list fl
    ON REGEXP_LIKE(i.item_title,'^.*'||partial_title||'.*$')
    AND i.text_file_name = fl.file_name;
BEGIN
  SAVEPOINT startpoint;

  FOR it IN cs(pv_item_title) LOOP
    load_clob_from_file
      ( it.text_file_name
      , 'item'
      , 'item_desc'
      , 'item_id'
      , it.item_id );
  END LOOP;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO startpoint;
    RAISE;
END update_item_description;
/


-- Test update_item_description
EXECUTE update_item_description('Harry Potter');

COL item_id     FORMAT 9999
COL item_title  FORMAT A44
COL text_size   FORMAT 999,999
SET PAGESIZE 99
SELECT   item_id
,        item_title
,        LENGTH(item_desc) AS text_size
FROM     item
WHERE    REGEXP_LIKE(item_title,'^Harry Potter.*$')
AND      item_type IN
        (SELECT common_lookup_id
        FROM   common_lookup
        WHERE  common_lookup_table = 'ITEM'
        AND    common_lookup_column = 'ITEM_TYPE'
        AND    REGEXP_LIKE(common_lookup_type,'^(dvd|vhs).*$','i'))
ORDER BY item_id;


-- Close log file.
SPOOL OFF

