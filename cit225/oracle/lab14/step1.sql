DECLARE
  lv_port  NUMBER;
BEGIN
  SELECT dbms_xdb.gethttpport()
  INTO   lv_port
  FROM dual;
 
  /* Check for default port and reset. */
  IF NOT lv_port = 8080 THEN
    dbms_xdb.sethttpport(8080);
  END IF;
END;
/

SELECT dbms_xdb.gethttpport() FROM dual;
