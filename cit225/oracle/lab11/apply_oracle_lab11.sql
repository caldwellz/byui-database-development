-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab11.sql
--  Lab Assignment: Lab #11
--  Program Author: Michael McLaughlin
--  Creation Date:  02-Mar-2018
-- ------------------------------------------------------------------
-- Instructions:
-- ------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab11.sql
--
-- ------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab9/apply_oracle_lab9.sql

-- Spool log file.
SPOOL apply_oracle_lab11.txt

-- --------------------------------------------------------
--  Step #1 : Merge statement to the rental table.
-- --------------------------------------------------------
/*
-- Count rentals before insert.
SELECT   COUNT(*) AS "Rental before count"
FROM     rental;

-- Merge transaction data into rental table.

-- *** MERGE statement moved to procedure ***

-- Count rentals after insert.
SELECT   COUNT(*) AS "Rental after count"
FROM     rental;

-- --------------------------------------------------------
--  Step #2 : Merge statement to the rental_item table.
-- --------------------------------------------------------

-- Count rental items before insert.
SELECT   COUNT(*)
FROM     rental_item;

-- Merge transaction data into rental_item table.

-- *** MERGE statement moved to procedure ***

-- Count rental items after insert.
SELECT   COUNT(*) AS "After Insert"
FROM     rental_item;

-- --------------------------------------------------------
--  Step #3 : Merge statement to the transaction table.
-- --------------------------------------------------------

-- Count transactions before insert
SELECT   COUNT(*) AS "Before Insert"
FROM     transaction;

-- Merge transaction data into transaction table.

-- *** MERGE statement moved to procedure ***

-- Count transactions after insert
SELECT   COUNT(*)
FROM     transaction;
*/
-- --------------------------------------------------------
--  Step #4(a) : Put merge statements in a procedure.
-- --------------------------------------------------------

-- Create a procedure to wrap the transformation of import to normalized tables.
CREATE OR REPLACE PROCEDURE upload_transactions IS
BEGIN
  -- Set save point for an all or nothing transaction.
  SAVEPOINT starting_point;

  -- Insert or update the table, which makes this rerunnable when the file hasn't been updated.
  MERGE INTO rental target
  USING (SELECT   DISTINCT
                    r.rental_id
           ,        c.contact_id
           ,        tu.check_out_date AS check_out_date
           ,        tu.return_date AS return_date
           ,        1001 AS created_by
           ,        TRUNC(SYSDATE) AS creation_date
           ,        1001 AS last_updated_by
           ,        TRUNC(SYSDATE) AS last_update_date
           FROM   member m INNER JOIN transaction_upload tu
           ON     m.account_number = tu.account_number
           INNER JOIN contact c
           ON     m.member_id = c.member_id LEFT JOIN rental r
           ON     c.contact_id = r.customer_id
           AND TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
           AND TRUNC(tu.return_date) = TRUNC(r.return_date)
           WHERE  c.first_name = tu.first_name
           AND    NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
           AND    c.last_name = tu.last_name) source
  ON (target.rental_id = source.rental_id)
  WHEN MATCHED THEN
  UPDATE SET last_updated_by = source.last_updated_by
  ,          last_update_date = source.last_update_date
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( rental_s1.NEXTVAL
  , source.contact_id
  , source.check_out_date
  , source.return_date
  , source.created_by
  , source.creation_date
  , source.last_updated_by
  , source.last_update_date);


  -- Insert or update the table, which makes this rerunnable when the file hasn't been updated.
  MERGE INTO rental_item target
  USING (SELECT   r.rental_id
         ,        tu.item_id
         ,        ri.rental_item_id
         ,        1001 AS created_by
         ,        TRUNC(SYSDATE) AS creation_date
         ,        1001 AS last_updated_by
         ,        TRUNC(SYSDATE) AS last_update_date
         ,        cl.common_lookup_id AS rental_item_type
         ,        p.amount AS rental_item_price
         FROM member m INNER JOIN transaction_upload tu
         ON     m.account_number = tu.account_number
         INNER JOIN contact c
         ON     m.member_id = c.member_id LEFT JOIN rental r
         ON     c.contact_id = r.customer_id
         AND TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
         AND TRUNC(tu.return_date) = TRUNC(r.return_date)
         LEFT JOIN common_lookup cl
         ON cl.common_lookup_table = 'RENTAL_ITEM'
         AND cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
         AND tu.rental_item_type = cl.common_lookup_type
         LEFT JOIN rental_item ri
         ON r.rental_id = ri.rental_id
         LEFT JOIN common_lookup cl2
         ON cl2.common_lookup_table = 'PRICE'
         AND cl2.common_lookup_column = 'PRICE_TYPE'
         AND cl2.common_lookup_code = cl.common_lookup_code
         LEFT JOIN price p
         ON p.item_id = tu.item_id
         AND p.price_type = cl2.common_lookup_id
         AND p.active_flag = 'Y'
         WHERE  c.first_name = tu.first_name
         AND    NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
         AND    c.last_name = tu.last_name) source
  ON (target.rental_item_id = source.rental_item_id)
  WHEN MATCHED THEN
  UPDATE SET last_updated_by = source.last_updated_by
  ,          last_update_date = source.last_update_date
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( rental_item_s1.nextval
  , source.rental_id
  , source.item_id
  , source.created_by
  , source.creation_date
  , source.last_updated_by
  , source.last_update_date
  , source.rental_item_type
  , source.rental_item_price);


  -- Insert or update the table, which makes this rerunnable when the file hasn't been updated.
  MERGE INTO transaction target
  USING (SELECT   t.transaction_id
  ,        tu.payment_account_number AS transaction_account
  ,        cl4.common_lookup_id AS transaction_type
  ,        TRUNC(tu.transaction_date) AS transaction_date
  ,       (SUM(tu.transaction_amount) / 1.06) AS transaction_amount
  ,        r.rental_id
  ,        cl3.common_lookup_id AS payment_method_type
  ,        m.credit_card_number AS payment_account_number
  ,        1001 AS created_by
  ,        TRUNC(SYSDATE) AS creation_date
  ,        1001 AS last_updated_by
  ,        TRUNC(SYSDATE) AS last_update_date
  FROM     member m
           INNER JOIN transaction_upload tu
             ON     m.account_number = tu.account_number
           INNER JOIN contact c
             ON     m.member_id = c.member_id
           LEFT JOIN rental r
             ON     c.contact_id = r.customer_id
             AND TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
             AND TRUNC(tu.return_date) = TRUNC(r.return_date)
           LEFT JOIN common_lookup cl1
             ON cl1.common_lookup_table = 'RENTAL_ITEM'
             AND cl1.common_lookup_column = 'RENTAL_ITEM_TYPE'
             AND cl1.common_lookup_type = tu.rental_item_type
           LEFT JOIN rental_item ri
             ON r.rental_id = ri.rental_id
           LEFT JOIN common_lookup cl2
             ON cl2.common_lookup_table = 'PRICE'
             AND cl2.common_lookup_column = 'PRICE_TYPE'
             AND cl2.common_lookup_code = cl1.common_lookup_code
           LEFT JOIN price p
             ON p.item_id = tu.item_id
             AND p.price_type = cl2.common_lookup_id
             AND p.active_flag = 'Y'
           LEFT JOIN common_lookup cl3
             ON cl3.common_lookup_table = 'TRANSACTION'
             AND cl3.common_lookup_column = 'PAYMENT_METHOD_TYPE'
             AND cl3.common_lookup_type = tu.payment_method_type
           LEFT JOIN common_lookup cl4
             ON cl4.common_lookup_table = 'TRANSACTION'
             AND cl4.common_lookup_column = 'TRANSACTION_TYPE'
             AND cl4.common_lookup_type = tu.transaction_type
           LEFT JOIN transaction t
             ON t.transaction_account = tu.payment_account_number
             AND t.rental_id = r.rental_id
             AND t.transaction_type = cl4.common_lookup_id
             AND t.transaction_date = tu.transaction_date
             AND t.payment_method_type = cl3.common_lookup_id
             AND t.payment_account_number = m.credit_card_number
           WHERE  c.first_name = tu.first_name
             AND    NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
             AND    c.last_name = tu.last_name
          GROUP BY t.transaction_id
          ,        tu.payment_account_number
          ,        cl4.common_lookup_id
          ,        tu.transaction_date
          ,        r.rental_id
          ,        cl3.common_lookup_id
          ,        m.credit_card_number
          ,        1001
          ,        TRUNC(SYSDATE)
          ,        1001
          ,        TRUNC(SYSDATE)) source
  ON (target.transaction_id = source.transaction_id)
  WHEN MATCHED THEN
  UPDATE SET last_updated_by = source.last_updated_by
  ,          last_update_date = source.last_update_date
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( transaction_s1.nextval
  , source.transaction_account
  , source.transaction_type
  , source.transaction_date
  , source.transaction_amount
  , source.rental_id
  , source.payment_method_type
  , source.payment_account_number
  , source.created_by
  , source.creation_date
  , source.last_updated_by
  , source.last_update_date);


  -- Save the changes.
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END;
/

-- Show errors if any.
SHOW ERRORS

-- --------------------------------------------------------
--  Step #4(b) : Execute the procedure for the first time.
-- --------------------------------------------------------

-- Verify and execute procedure.
COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"

-- Query for initial counts, should return:
-- ----------------------------------------------
--          Rental
--  Rental    Item Transaction
--   Count   Count       Count
-- ------- ------- -----------
--       8      12           0
-- ----------------------------------------------
SELECT   rental_count
,        rental_item_count
,        transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction);

-- Transform import source into normalized tables.
EXECUTE upload_transactions;

-- --------------------------------------------------------
--  Step #4(c) : Verify first merge statements results.
-- --------------------------------------------------------

-- Requery to see completed counts, should return:
-- ----------------------------------------------
--          Rental
--  Rental    Item Transaction
--   Count   Count       Count
-- ------- ------- -----------
--   4,689  11,532       4,681
-- ----------------------------------------------
SELECT   rental_count
,        rental_item_count
,        transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction);

-- --------------------------------------------------------
--  Step #4(d) : Execute the procedure for the second time.
-- --------------------------------------------------------

-- Transform import source into normalized tables.
EXECUTE upload_transactions;

-- --------------------------------------------------------
--  Step #4(e) : Verify second merge statements results.
-- --------------------------------------------------------

-- Requery to see completed counts, should return:
-- ----------------------------------------------
--          Rental
--  Rental    Item Transaction
--   Count   Count       Count
-- ------- ------- -----------
--   4,689  11,532       4,681
-- ----------------------------------------------

SELECT   rental_count
,        rental_item_count
,        transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction);

-- --------------------------------------------------------
--  Step #5 : Demonstrate aggregation with sorting options.
-- --------------------------------------------------------

-- Query, aggregate, and sort data.
-- Query for initial counts, should return:
-- --------------------------------------------------------------------------------------------
-- MONTH      BASE_REVENUE   10_PLUS        20_PLUS        10_PLUS_LESS_B 20_PLUS_LESS_B
-- ---------- -------------- -------------- -------------- -------------- --------------
-- JAN-2009        $2,671.20      $2,938.32      $3,205.44        $267.12        $534.24
-- FEB-2009        $4,270.74      $4,697.81      $5,124.89        $427.07        $854.15
-- MAR-2009        $5,371.02      $5,908.12      $6,445.22        $537.10      $1,074.20
-- APR-2009        $4,932.18      $5,425.40      $5,918.62        $493.22        $986.44
-- MAY-2009        $2,216.46      $2,438.11      $2,659.75        $221.65        $443.29
-- JUN-2009        $1,208.40      $1,329.24      $1,450.08        $120.84        $241.68
-- JUL-2009        $2,404.08      $2,644.49      $2,884.90        $240.41        $480.82
-- AUG-2009        $2,241.90      $2,466.09      $2,690.28        $224.19        $448.38
-- SEP-2009        $2,197.38      $2,417.12      $2,636.86        $219.74        $439.48
-- OCT-2009        $3,275.40      $3,602.94      $3,930.48        $327.54        $655.08
-- NOV-2009        $3,125.94      $3,438.53      $3,751.13        $312.59        $625.19
-- DEC-2009        $2,340.48      $2,574.53      $2,808.58        $234.05        $468.10
-- --------------------------------------------------------------------------------------------

-- Expand line length in environment.
SET LINESIZE 150
SET PAGESIZE 20
COLUMN month         FORMAT A8 HEADING "Month"
COLUMN base          FORMAT A11 HEADING "Base|Revenue"
COLUMN ten_plus_b    FORMAT A11 HEADING "10 Plus|Revenue"
COLUMN twenty_plus_b FORMAT A11 HEADING "20 Plus|Revenue"
COLUMN ten_plus      FORMAT A11 HEADING "10 Plus|Difference"
COLUMN twenty_plus   FORMAT A11 HEADING "20 Plus|Difference"
SELECT
    TO_CHAR(TO_DATE(td.mo,'MM'),'MON')
    || '-' || td.yr AS month,
    TO_CHAR(td.base, '$99,999.00') AS base
,   TO_CHAR(td.base + td.tenper, '$99,999.00') AS ten_plus_b
,   TO_CHAR(td.base + (2 * td.tenper), '$99,999.00') AS twenty_plus_b
,   TO_CHAR(td.tenper, '$99,999.00') AS ten_plus
,   TO_CHAR(2 * td.tenper, '$99,999.00') AS twenty_plus
    FROM (SELECT
        EXTRACT(MONTH FROM transaction_date) AS mo
        , EXTRACT(YEAR FROM transaction_date) AS yr
        , (SUM(transaction_amount) / 1.06) AS base -- Adjust for 6% tax / "interest"
        , ((SUM(transaction_amount) / 1.06) * 0.1) AS tenper
        FROM transaction
        WHERE EXTRACT(YEAR FROM transaction_date) = 2009
        GROUP BY
        EXTRACT(YEAR FROM transaction_date)
,       EXTRACT(MONTH FROM transaction_date)) td
    ORDER BY td.mo;


SPOOL OFF
