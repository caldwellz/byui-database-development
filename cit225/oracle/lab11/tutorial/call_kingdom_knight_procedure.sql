-- ------------------------------------------------------------------
--  Program Name:   call_kingdom_knight_procedure.sql
--  Lab Assignment: N/A
--  Program Author: Michael McLaughlin
--  Creation Date:  17-Jan-2012
-- ------------------------------------------------------------------
--  Change Log:
-- ------------------------------------------------------------------
--  Change Date    Change Reason
-- -------------  ---------------------------------------------------
--  13-Aug-2019    Enabled for preprocessing to support editing
--                 of raw file in the student account.
-- ------------------------------------------------------------------
--   This calls the procedure to MERGE data from the external table
--   to the two internally managed tables.
-- ------------------------------------------------------------------

-- ------------------------------------------------------------------
--   Create tutorial tables for MERGE statement.
-- ------------------------------------------------------------------


SET PAGESIZE 999

COL kingdom_name           FORMAT A8        HEADING "Kingdom|Name"
COL population             FORMAT 99999999  HEADING "Population"
COL knight_name            FORMAT A30       HEADING "Knight Name"
COL allegiance_start_date  FORMAT A11       HEADING "Allegiance|Start Date"
COL allegiance_end_date    FORMAT A11       HEADING "Allegiance|End Date"
SELECT   kingdom_name
,        population
,        knight_name
,        TO_CHAR(allegiance_start_date,'DD-MON-YYYY') AS allegiance_start_date
,        TO_CHAR(allegiance_end_date,'DD-MON-YYYY') AS allegiance_end_date
FROM     kingdom_knight_import;

-- Format Oracle output.
COLUMN knight_id             FORMAT 999 HEADING "Knight|ID #"
COLUMN knight_name           FORMAT A23 HEADING "Knight Name"
COLUMN kingdom_allegiance_id FORMAT 999 HEADING "Kingdom|Allegiance|ID #"
COLUMN start_date            FORMAT A11 HEADING "Allegiance|Start Date"
COLUMN end_date              FORMAT A11 HEADING "Allegiance|End Date"
SELECT   kn.knight_id
,        kki.knight_name
,        k.kingdom_id
,        kki.allegiance_start_date AS start_date
,        kki.allegiance_end_date AS end_date
FROM     kingdom_knight_import kki INNER JOIN kingdom k
ON       kki.kingdom_name = k.kingdom_name
AND      kki.population = k.population LEFT JOIN knight kn 
ON       k.kingdom_id = kn.kingdom_allegiance_id
AND      kki.knight_name = kn.knight_name
AND      kki.allegiance_start_date = kn.allegiance_start_date
AND      kki.allegiance_end_date = kn.allegiance_end_date;

EXEC upload_kingdom;

-- Check the kingdom table.
SELECT * FROM kingdom;
 
-- Format Oracle output.
COLUMN knight_id             FORMAT 999 HEADING "Knight|ID #"
COLUMN knight_name           FORMAT A23 HEADING "Knight Name"
COLUMN kingdom_allegiance_id FORMAT 999 HEADING "Kingdom|Allegiance|ID #"
COLUMN allegiance_start_date FORMAT A11 HEADING "Allegiance|Start Date"
COLUMN allegiance_end_date   FORMAT A11 HEADING "Allegiance|End Date"
 
-- Check the knight table.
SELECT   knight_id
,        knight_name
,        kingdom_allegiance_id
,        TO_CHAR(allegiance_start_date,'DD-MON-YYYY') AS allegiance_start_date
,        TO_CHAR(allegiance_end_date,'DD-MON-YYYY') AS allegiance_end_date
FROM     knight;
