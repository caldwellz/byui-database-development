-- Open log file.
SPOOL oracle_lab8_diagnostics.txt

-- Set the page size.
SET ECHO ON
SET PAGESIZE 999

-- Customers
COL customer_name  FORMAT A24  HEADING "Customer Name"
COL city           FORMAT A12  HEADING "City"
COL state          FORMAT A6   HEADING "State"
COL telephone      FORMAT A10  HEADING "Telephone"
SELECT   m.account_number
,        c.last_name||', '||c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name
         END AS customer_name
,        a.city AS city
,        a.state_province AS state
,        t.telephone_number AS telephone
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN telephone t
ON       c.contact_id = t.contact_id;

-- Rental Items
COL account_number  FORMAT A10  HEADING "Account|Number"
COL customer_name   FORMAT A22  HEADING "Customer Name"
COL rental_id       FORMAT 9999 HEADING "Rental|ID #"
COL rental_item_id  FORMAT 9999 HEADING "Rental|Item|ID #"
SELECT   m.account_number
,        c.last_name||', '||c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name
         END AS customer_name
,        r.rental_id
,        ri.rental_item_id
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN rental r
ON       c.contact_id = r.customer_id INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id
ORDER BY 3, 4;

-- Price Type / Rental Item TYPE
COL common_lookup_table  FORMAT A12 HEADING "Common|Lookup Table"
COL common_lookup_column FORMAT A18 HEADING "Common|Lookup Column"
COL common_lookup_code   FORMAT 999 HEADING "Common|Lookup|Code"
COL total_pk_count       FORMAT 999 HEADING "Foreign|Key|Count"
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        TO_NUMBER(cl.common_lookup_code) AS common_lookup_code
,        COUNT(*) AS total_pk_count
FROM     price p INNER JOIN common_lookup cl
ON       p.price_type = cl.common_lookup_id
AND      cl.common_lookup_table = 'PRICE'
AND      cl.common_lookup_column = 'PRICE_TYPE'
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_code
UNION ALL
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        TO_NUMBER(cl.common_lookup_code) AS common_lookup_code
,        COUNT(*) AS total_pk_count
FROM     rental_item ri INNER JOIN common_lookup cl
ON       ri.rental_item_type = cl.common_lookup_id
AND      cl.common_lookup_table = 'RENTAL_ITEM'
AND      cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_code
ORDER BY 1, 2, 3;

-- Price table dates
COL customer_name          FORMAT A20  HEADING "Contact|--------|Customer Name"
COL r_rental_id            FORMAT 9999 HEADING "Rental|------|Rental|ID #"
COL amount                 FORMAT 9999 HEADING "Price|------||Amount"
COL price_type_code        FORMAT 9999 HEADING "Price|------|Type|Code"
COL rental_item_type_code  FORMAT 9999 HEADING "Rental|Item|------|Type|Code"
COL needle                 FORMAT A11  HEADING "Rental|--------|Check Out|Date"
COL low_haystack           FORMAT A11  HEADING "Price|--------|Start|Date"
COL high_haystack          FORMAT A11  HEADING "Price|--------|End|Date"
SELECT   c.last_name||', '||c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name
         END AS customer_name
,        ri.rental_id AS ri_rental_id
,        p.amount
,        TO_NUMBER(cl2.common_lookup_code) AS price_type_code
,        TO_NUMBER(cl2.common_lookup_code) AS rental_item_type_code
,        p.start_date AS low_haystack
,        r.check_out_date AS needle
,        NVL(p.end_date,TRUNC(SYSDATE) + 1) AS high_haystack
FROM     price p INNER JOIN common_lookup cl1
ON       p.price_type = cl1.common_lookup_id
AND      cl1.common_lookup_table = 'PRICE'
AND      cl1.common_lookup_column = 'PRICE_TYPE' FULL JOIN rental_item ri
ON       p.item_id = ri.item_id INNER JOIN common_lookup cl2
ON       ri.rental_item_type = cl2.common_lookup_id
AND      cl2.common_lookup_table = 'RENTAL_ITEM'
AND      cl2.common_lookup_column = 'RENTAL_ITEM_TYPE' RIGHT JOIN rental r
ON       ri.rental_id = r.rental_id FULL JOIN contact c
ON       r.customer_id = c.contact_id
WHERE    cl1.common_lookup_code = cl2.common_lookup_code
AND      p.active_flag = 'Y'
AND NOT  r.check_out_date
           BETWEEN  p.start_date AND NVL(p.end_date,TRUNC(SYSDATE) + 1)
ORDER BY 2, 3;

SPOOL OFF
