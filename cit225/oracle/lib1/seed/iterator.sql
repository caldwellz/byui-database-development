DECLARE
  TYPE months IS TABLE OF VARCHAR2(10);
  lv_months MONTHS := months('JAN','FEB','MAR','APR','MAY','JUN'
                            ,'JUL','AUG','SEP','OCT','NOV','DEC');
  counter NUMBER := 1;
  current NUMBER;
BEGIN
  lv_months.DELETE(8);
  FOR i IN 1..lv_months.LAST LOOP
    IF lv_months.EXISTS(i) THEN
      dbms_output.put_line('Month ['||lv_months(i)||']');
    END IF;
  END LOOP;

--    dbms_output.put_line('Debug 1 ['||lv_months(counter)||']');
    dbms_output.put_line('Debug 2 ['||lv_months.LAST||']');
    dbms_output.put_line('Debug 2 ['||lv_months(lv_months.LAST)||']');
  current := lv_months.FIRST;
  WHILE NOT (lv_months(current) = lv_months(lv_months.LAST)) LOOP
    dbms_output.put_line('Debug 3 ['||current||']');
    dbms_output.put_line('Month ['||lv_months(current)||']');
    current := lv_months.NEXT(current);
  END LOOP;
END;
/
