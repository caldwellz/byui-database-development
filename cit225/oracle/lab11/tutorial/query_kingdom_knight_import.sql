-- ------------------------------------------------------------------
--  Program Name:   query_kingdom_knight_import.sql
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
--   This queries the external tables.
-- ------------------------------------------------------------------

-- ------------------------------------------------------------------
--   Queries and formats external tutorial table for MERGE statement.
-- ------------------------------------------------------------------

SET PAGESIZE 99

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
