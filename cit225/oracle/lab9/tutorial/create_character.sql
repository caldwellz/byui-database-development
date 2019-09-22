-- ------------------------------------------------------------------
--  Program Name:   create_character.sql
--  Lab Assignment: N/A
--  Program Author: Michael McLaughlin
--  Creation Date:  17-Jan-2018
-- ------------------------------------------------------------------
--  Change Log:
-- ------------------------------------------------------------------
--  Change Date    Change Reason
-- -------------  ---------------------------------------------------
--  13-Aug-2019    Incorporate directory change.
-- ------------------------------------------------------------------
--   This creates an external table to support the tutorial.
-- ------------------------------------------------------------------

-- ------------------------------------------------------------------
--   Creates a CHARACTER external table.
-- ------------------------------------------------------------------

CREATE TABLE CHARACTER
( character_id NUMBER
, first_name VARCHAR2(20)
, last_name VARCHAR2(20))
  ORGANIZATION EXTERNAL
  ( TYPE oracle_loader
    DEFAULT DIRECTORY upload
    ACCESS PARAMETERS
    ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      BADFILE     'UPLOAD':'character.bad'
      DISCARDFILE 'UPLOAD':'character.dis'
      LOGFILE     'UPLOAD':'character.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL )
    LOCATION ('character.csv'))
REJECT LIMIT UNLIMITED;
