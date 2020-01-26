/*
||  Name:          apply_plsql_lab3.sql
||  Author:        Zach Caldwell
||  Purpose:       Complete 325 Chapter 4 lab.
*/

-- Call seeding libraries.
-- @$LIB/cleanup_oracle.sql
-- @$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

CREATE OR REPLACE
  FUNCTION verify_date
  ( pv_date_in  VARCHAR2) RETURN DATE IS
  /* Local return variable. */
  lv_date    DATE;
BEGIN
  lv_date := NULL;
  /* Check for a DD-MON-RR or DD-MON-YYYY string. */
  IF REGEXP_LIKE(pv_date_in,'^[0-9]{2,2}-[ADFJMNOS][ACEOPU][BCGLNPRTVY]-([0-9]{2,2}|[0-9]{4,4})$') THEN
    /* Case statement checks for 28 or 29, 30, or 31 day month. */
    CASE
      /* Valid 31 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) IN ('JAN','MAR','MAY','JUL','AUG','OCT','DEC') AND
           TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 31 THEN 
        lv_date := TO_DATE(pv_date_in);
      /* Valid 30 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) IN ('APR','JUN','SEP','NOV') AND
           TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 30 THEN 
        lv_date := TO_DATE(pv_date_in);
      /* Valid 28 or 29 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) = 'FEB' THEN
        /* Verify 2-digit or 4-digit year. */
        IF (LENGTH(pv_date_in) = 9 AND MOD(TO_NUMBER(SUBSTR(pv_date_in,8,2)) + 2000,4) = 0 OR
            LENGTH(pv_date_in) = 11 AND MOD(TO_NUMBER(SUBSTR(pv_date_in,8,4)),4) = 0) AND
            TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 29 THEN
          lv_date := TO_DATE(pv_date_in);
        ELSE /* Not a leap year. */
          IF TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 28 THEN
            lv_date := TO_DATE(pv_date_in);
          END IF;
        END IF;
      ELSE
        lv_date := NULL;
    END CASE;
  END IF;
  /* Return date. */
  RETURN lv_date;
END;
/

DECLARE
  TYPE list IS TABLE OF VARCHAR2(100);
  TYPE three_type IS RECORD (
    xnum    NUMBER       := NULL    
  , xdate   DATE         := NULL
  , xstring VARCHAR2(30) := NULL
  );
  lv_strings LIST;
  lv_three   three_type;
  lv_date    DATE;
BEGIN
  lv_strings := list('&1', '&2', '&3');
  FOR i IN 1..lv_strings.COUNT LOOP
    CASE
      WHEN lv_strings(i) IS NULL THEN
        CONTINUE;
      WHEN REGEXP_LIKE(lv_strings(i),'^[[:digit:]]*$') THEN
        lv_three.xnum := TO_NUMBER(lv_strings(i));
      WHEN REGEXP_LIKE(lv_strings(i),'^[0-9]{2,2}-[[:alpha:]]{3,3}-([0-9]{2,2}|[0-9]{4,4})$') THEN
        lv_date := verify_date(lv_strings(i));
        IF lv_date IS NULL THEN
          CONTINUE;
        ELSE
          lv_three.xdate := lv_date;
        END IF;
      ELSE -- string
        lv_three.xstring := lv_strings(i);
    END CASE;
  END LOOP;

  dbms_output.put_line('Record ['||lv_three.xnum||'] ['||lv_three.xstring||'] ['||lv_three.xdate||']');
END;
/

QUIT;
