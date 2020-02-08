/*
||  Name:          apply_plsql_lab4.sql
||  Author:        Zach Caldwell
||  Purpose:       Complete 325 Chapter 5 lab.
*/

-- Call seeding libraries.
@$LIB/cleanup_oracle.sql
@$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

SET SERVEROUTPUT ON SIZE UNLIMITED

-- Open log file.
SPOOL apply_plsql_lab5.txt

-- Create rating_agency sequence and table
CREATE SEQUENCE rating_agency_s START WITH 1001;

CREATE TABLE rating_agency AS
SELECT rating_agency_s.NEXTVAL AS rating_agency_id
,      il.item_rating AS rating
,      il.item_rating_agency AS rating_agency
FROM  (SELECT DISTINCT
        i.item_rating
      , i.item_rating_agency
      FROM item i) il;

-- Create rating_agency structure
CREATE OR REPLACE
  TYPE rating_agency_type IS OBJECT (
    rating_agency_id  NUMBER(38)
  , rating            VARCHAR2(8)
  , rating_agency     VARCHAR2(4));
/

-- Add required column to item table
ALTER TABLE item
  ADD (rating_agency_id NUMBER(22));

-- Begin update subroutine
DECLARE
  CURSOR c_ra IS
    SELECT rating_agency_id, rating, rating_agency
    FROM rating_agency;

  TYPE rating_agency_list IS TABLE OF rating_agency_type;
  lv_ra_list RATING_AGENCY_LIST := rating_agency_list();

  lv_rating_agency_id  rating_agency.rating_agency_id%TYPE;
  lv_rating            rating_agency.rating%TYPE;
  lv_rating_agency     rating_agency.rating_agency%TYPE;
BEGIN
  -- Read the cursor into the collection
  OPEN c_ra;
  LOOP
    FETCH c_ra INTO lv_rating_agency_id, lv_rating, lv_rating_agency;
    EXIT WHEN c_ra%NOTFOUND;

    lv_ra_list.EXTEND;
    lv_ra_list(lv_ra_list.COUNT) := rating_agency_type(lv_rating_agency_id, lv_rating, lv_rating_agency);
  END LOOP;

  -- Loop through the collection and update the item table
  FOR i IN 1..lv_ra_list.COUNT LOOP
    UPDATE item
    SET rating_agency_id = lv_ra_list(i).rating_agency_id
    WHERE item_rating = lv_ra_list(i).rating
      AND item_rating_agency = lv_ra_list(i).rating_agency;
  END LOOP;

  CLOSE c_ra;
  COMMIT;
END;
/

-- Verify results
SELECT   rating_agency_id
,        COUNT(*)
FROM     item
WHERE    rating_agency_id IS NOT NULL
GROUP BY rating_agency_id
ORDER BY 1;

-- Close log file.
SPOOL OFF
