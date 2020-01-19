/*
||  Name:          apply_plsql_lab2-2.sql
||  Author:        Zach Caldwell
||  Date:          18 Jan 2020
||  Purpose:       Complete 325 Chapter 3 lab.
*/

-- Call seeding libraries.
@$LIB/cleanup_oracle.sql
@$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
-- SPOOL apply_plsql_lab2-2.txt

SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

DECLARE
  lv_raw_input CLOB;
  lv_input     VARCHAR2(10);
BEGIN
  lv_raw_input := '&1';
  IF (lv_raw_input IS NULL) THEN
    dbms_output.put_line('Hello World!');
  ELSIF (LENGTH(lv_raw_input) > 10) THEN
    lv_input := SUBSTR(lv_raw_input, 1, 10);
    dbms_output.put_line('Hello '||lv_input||'!');
  ELSE
    dbms_output.put_line('Hello '||'&1'||'!');
  END IF;
END;
/

-- Close log file.
-- SPOOL OFF

EXIT;
