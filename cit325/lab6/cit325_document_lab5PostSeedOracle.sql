INSERT INTO item VALUES
( item_s1.nextval
,'9689-80547-3'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'ITEM'
  AND      common_lookup_column = 'ITEM_TYPE'
  AND      common_lookup_type = 'VHS_SINGLE_TAPE')
,'Beau Geste'
,''
, empty_clob()
,''
,'PG'
,'MPAA'
,'01-MAR-92'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'53939-64103'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'ITEM'
  AND      common_lookup_column = 'ITEM_TYPE'
  AND      common_lookup_type = 'VHS_SINGLE_TAPE')
,'I Remember Mama'
,''
, empty_clob()
,''
,'NR'
,'MPAA'
,'05-JAN-98'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'24543-01292'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'ITEM'
  AND      common_lookup_column = 'ITEM_TYPE'
  AND      common_lookup_type = 'VHS_SINGLE_TAPE')
,'Tora! Tora! Tora!'
,'The Attack on Pearl Harbor'
, empty_clob()
,''
,'G'
,'MPAA'
,'02-NOV-99'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'43396-60047'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'ITEM'
  AND      common_lookup_column = 'ITEM_TYPE'
  AND      common_lookup_type = 'VHS_SINGLE_TAPE')
,'A Man for All Seasons'
,''
, empty_clob()
,''
,'G'
,'MPAA'
,'28-JUN-94'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'43396-70603'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'ITEM'
  AND      common_lookup_column = 'ITEM_TYPE'
  AND      common_lookup_type = 'VHS_SINGLE_TAPE')
,'Hook'
,''
, empty_clob()
,''
,'PG'
,'MPAA'
,'11-DEC-91'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'85391-13213'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'ITEM'
  AND      common_lookup_column = 'ITEM_TYPE'
  AND      common_lookup_type = 'VHS_DOUBLE_TAPE')
,'Around the World in 80 Days'
,''
, empty_clob()
,''
,'G'
,'MPAA'
,'04-DEC-92'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'85391-10843'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'ITEM'
  AND      common_lookup_column = 'ITEM_TYPE'
  AND      common_lookup_type = 'VHS_DOUBLE_TAPE')
,'Camelot'
,''
, empty_clob()
,''
,'G'
,'MPAA'
,'15-MAY-98'
, 3, SYSDATE, 3, SYSDATE);