/*
||  Name:          apply_plsql_lab4.sql
||  Author:        Zach Caldwell
||  Purpose:       Complete 325 Chapter 5 lab.
*/

-- Call seeding libraries.
-- @$LIB/cleanup_oracle.sql
-- @$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

--- Open log file.
SPOOL apply_plsql_lab4.txt

SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

DECLARE
  TYPE str8_list IS TABLE OF VARCHAR2(8);
  TYPE lyric IS RECORD (
    day_name  VARCHAR2(8)  := NULL    
  , gift_name VARCHAR2(24) := NULL
  );
  TYPE lyrics_list IS TABLE OF lyric;
  lv_days   STR8_LIST;
  lv_lyrics LYRICS_LIST;
BEGIN
  lv_days   := str8_list('first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth');
  lv_lyrics := lyrics_list(
    lyric('and a', 'Partridge in a pear tree')
  , lyric('Two', 'Turtle doves')
  , lyric('Three', 'French hens')
  , lyric('Four', 'Calling birds')
  , lyric('Five', 'Golden rings')
  , lyric('Six', 'Geese a laying')
  , lyric('Seven', 'Swans a swimming')
  , lyric('Eight', 'Maids a milking')
  , lyric('Nine', 'Ladies dancing')
  , lyric('Ten', 'Lords a leaping')
  , lyric('Eleven', 'Pipers piping')
  , lyric('Twelve', 'Drummers drumming'));

  FOR last_day IN 1..lv_days.COUNT LOOP
    dbms_output.put_line('On the '||lv_days(last_day)||' day of Christmas');
    dbms_output.put_line('my true love sent to me:');
    FOR current_day IN REVERSE 1..last_day LOOP
      IF (last_day = 1) AND (current_day = 1) THEN
        dbms_output.put_line('-A '||lv_lyrics(1).gift_name);
      ELSE
        dbms_output.put_line('-'||lv_lyrics(current_day).day_name||' '||lv_lyrics(current_day).gift_name);
      END IF;
    END LOOP;
    dbms_output.put_line(CHR(13));
  END LOOP;
END;
/

--- Close log file.
SPOOL OFF
