/*
||  Name:          apply_plsql_lab12.sql
||  Author:        Zach Caldwell
||  Purpose:       Complete 325 Chapter 13 lab.
*/

-- Call seeding libraries.
@$LIB/cleanup_oracle.sql
@$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql


-- Open log file.
SPOOL apply_plsql_lab12.txt
SET SERVEROUTPUT ON;
SET PAGESIZE 80;


-- Create item object and collection
CREATE OR REPLACE
  TYPE item_obj IS OBJECT
  ( title        VARCHAR2(60)    
  , subtitle     VARCHAR2(60)
  , rating       VARCHAR2(8)
  , release_date DATE);
/
CREATE OR REPLACE TYPE item_tab IS TABLE OF item_obj;
/


-- Create item_list function
CREATE OR REPLACE FUNCTION item_list
( pv_start_date IN DATE
, pv_end_date   IN DATE DEFAULT TRUNC(SYSDATE) + 1 )
RETURN ITEM_TAB IS
  -- Declare a matching record type
  TYPE item_rec IS RECORD
  ( title        VARCHAR2(60)    
  , subtitle     VARCHAR2(60)
  , rating       VARCHAR2(8)
  , release_date DATE);

  -- Declare a row for output from an NDS cursor.
  item_row ITEM_REC;
  item_set ITEM_TAB := item_tab();

  -- Define a weakly typed system reference cursor.
  item_cur SYS_REFCURSOR;

  -- Create NDS statement, with a bind or placeholder variable.
  stmt VARCHAR2(2000);
BEGIN
  stmt := 'SELECT item_title AS title '
       || ', item_subtitle AS subtitle '
       || ', item_rating AS rating '
       || ', item_release_date AS release_date '
       || 'FROM item '
       || 'WHERE item_rating_agency = ''MPAA'' '
       || 'AND item_release_date >= :start_date '
       || 'AND item_release_date <= :end_date';

  -- Open the cursor and dynamically assign the function actual parameter.
  OPEN item_cur FOR stmt USING pv_start_date, pv_end_date;

  LOOP
    -- Fetch the cursor into row.
    FETCH item_cur INTO item_row;
    EXIT WHEN item_cur%NOTFOUND;

    -- Extend space and assign a value collection.
    item_set.EXTEND;
    item_set(item_set.COUNT) :=
      item_obj( title        => item_row.title
              , subtitle     => item_row.subtitle
              , rating       => item_row.rating
              , release_date => item_row.release_date );
  END LOOP;

  CLOSE item_cur;
  RETURN item_set;
END;
/


-- Test the item_list function
COLUMN il.title  FORMAT A60
COLUMN il.rating FORMAT A8
SELECT il.title, il.rating
FROM TABLE(item_list(TO_DATE('01/01/2000', 'MM/DD/YYYY'))) il
ORDER BY 1, 2;


-- Close log file.
SPOOL OFF
