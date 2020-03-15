/*
||  Name:          apply_plsql_lab10.sql
||  Author:        Zach Caldwell
||  Purpose:       Complete 325 Chapter 11 lab.
*/

-- Open log file.
SET SERVEROUTPUT ON SIZE UNLIMITED
SPOOL apply_plsql_lab10.txt


-- Unconditional drops of objects.
DROP TABLE logger;
DROP SEQUENCE logger_s;
DROP TYPE contact_t FORCE;
DROP TYPE item_t FORCE;
DROP TYPE base_t FORCE;


-- Create base_t object type.
CREATE OR REPLACE
  TYPE base_t IS OBJECT
  ( oname VARCHAR2(30)
  , name  VARCHAR2(30)
  , CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT
  , CONSTRUCTOR FUNCTION base_t
    ( oname  VARCHAR2
    , name   VARCHAR2 ) RETURN SELF AS RESULT
  , MEMBER FUNCTION get_name RETURN VARCHAR2
  , MEMBER FUNCTION get_oname RETURN VARCHAR2
  , MEMBER PROCEDURE set_oname (oname VARCHAR2)
  , MEMBER FUNCTION to_string RETURN VARCHAR2)
  INSTANTIABLE NOT FINAL;
/


-- Create logger table and sequence
CREATE TABLE logger
( logger_id NUMBER
, log_text  BASE_T );
CREATE SEQUENCE logger_s;


-- Create base_t object body.
CREATE OR REPLACE
  TYPE BODY base_t IS

    -- Override constructor.
    CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT IS
    BEGIN
      self.oname := 'BASE_T';
      RETURN;
    END;

    -- Formalized default constructor.
    CONSTRUCTOR FUNCTION base_t
    ( oname  VARCHAR2
    , name   VARCHAR2 ) RETURN SELF AS RESULT IS
    BEGIN
      -- Assign oname value, and either NEW, OLD, or NULL to name
      self.oname := oname;
      IF name IS NOT NULL AND UPPER(name) IN ('NEW','OLD') THEN
        self.name := UPPER(name);
      END IF;

      RETURN;
    END;

    -- A getter function to return the name attribute.
    MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
      RETURN self.name;
    END get_name;

    -- A getter function to return the name attribute.
    MEMBER FUNCTION get_oname RETURN VARCHAR2 IS
    BEGIN
      RETURN self.oname;
    END get_oname;

    -- A setter procedure to set the oname attribute.
    MEMBER PROCEDURE set_oname
    ( oname VARCHAR2 ) IS
    BEGIN
      self.oname := oname;
    END set_oname;

    -- A to_string function.
    MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
      RETURN '['||self.oname||']';
    END to_string;
  END;
/


-- Test object type
DECLARE
  -- Create a default instance of the object type.
  lv_instance  BASE_T := base_t();
BEGIN
  -- Print the default value of the oname attribute.
  dbms_output.put_line('Default  : ['||lv_instance.get_oname()||']');

  -- Set the oname value to a new value.
  lv_instance.set_oname('SUBSTITUTE');

  -- Print the default value of the oname attribute.
  dbms_output.put_line('Override : ['||lv_instance.get_oname()||']');
END;
/


-- Test case - Insert rows into the table
INSERT INTO logger
VALUES (logger_s.NEXTVAL, base_t());

DECLARE
  lv_base  BASE_T;
BEGIN
  lv_base := base_t(
      oname => 'BASE_T'
    , name => 'NEW' );

    INSERT INTO logger
    VALUES (logger_s.NEXTVAL, lv_base);

    COMMIT;
END;
/


-- Test the two rows inserted into the logger table.
COLUMN oname     FORMAT A20
COLUMN get_name  FORMAT A20
COLUMN to_string FORMAT A20
SELECT t.logger_id
,      t.log.oname AS oname
,      NVL(t.log.get_name(),'Unset') AS get_name
,      t.log.to_string() AS to_string
FROM  (SELECT l.logger_id
       ,      TREAT(l.log_text AS base_t) AS log
       FROM   logger l) t
WHERE  t.log.oname = 'BASE_T';


-- Create or replace the item_t type.
CREATE OR REPLACE
  TYPE item_t UNDER base_t
  ( ITEM_ID             NUMBER
  , ITEM_BARCODE        VARCHAR2(20)
  , ITEM_TYPE           NUMBER
  , ITEM_TITLE          VARCHAR2(60)
  , ITEM_SUBTITLE       VARCHAR2(60)
  , ITEM_RATING         VARCHAR2(8)
  , ITEM_RATING_AGENCY  VARCHAR2(4)
  , ITEM_RELEASE_DATE   DATE
  , CREATED_BY          NUMBER
  , CREATION_DATE       DATE
  , LAST_UPDATED_BY     NUMBER
  , LAST_UPDATE_DATE    DATE
  , CONSTRUCTOR FUNCTION item_t
    ( oname               VARCHAR2
    , name                VARCHAR2
    , ITEM_ID             NUMBER
    , ITEM_BARCODE        VARCHAR2
    , ITEM_TYPE           NUMBER
    , ITEM_TITLE          VARCHAR2
    , ITEM_SUBTITLE       VARCHAR2
    , ITEM_RATING         VARCHAR2
    , ITEM_RATING_AGENCY  VARCHAR2
    , ITEM_RELEASE_DATE   DATE
    , CREATED_BY          NUMBER
    , CREATION_DATE       DATE
    , LAST_UPDATED_BY     NUMBER
    , LAST_UPDATE_DATE    DATE ) RETURN SELF AS RESULT
  , OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
  , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)
  INSTANTIABLE NOT FINAL;
/


-- Create or replace the item_t object body.
CREATE OR REPLACE
  TYPE BODY item_t IS

    -- Default constructor
    CONSTRUCTOR FUNCTION item_t
    ( oname               VARCHAR2
    , name                VARCHAR2
    , ITEM_ID             NUMBER
    , ITEM_BARCODE        VARCHAR2
    , ITEM_TYPE           NUMBER
    , ITEM_TITLE          VARCHAR2
    , ITEM_SUBTITLE       VARCHAR2
    , ITEM_RATING         VARCHAR2
    , ITEM_RATING_AGENCY  VARCHAR2
    , ITEM_RELEASE_DATE   DATE
    , CREATED_BY          NUMBER
    , CREATION_DATE       DATE
    , LAST_UPDATED_BY     NUMBER
    , LAST_UPDATE_DATE    DATE ) RETURN SELF AS RESULT IS
    BEGIN
      -- Assign inputs to instance variables.    
      self.oname := oname;

      -- Assign a designated value or assign a null value.
      IF name IS NOT NULL AND UPPER(name) IN ('NEW','OLD') THEN
        self.name := UPPER(name);
      END IF;

      -- Assign inputs to instance variables.  
      self.item_id            := 	item_id;
      self.item_barcode       := 	item_barcode;
      self.item_type          := 	item_type;
      self.item_title         := 	item_title;
      self.item_subtitle      := 	item_subtitle;
      self.item_rating        := 	item_rating;
      self.item_rating_agency := 	item_rating_agency;
      self.item_release_date  := 	item_release_date;
      self.created_by         := 	created_by;
      self.creation_date      := 	creation_date;
      self.last_updated_by    := 	last_updated_by;
      self.last_update_date   := 	last_update_date;

      -- Return an instance of self.
      RETURN;
    END;

    -- An overriding function for the generalized class.
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
      RETURN (self AS base_t).get_name();
    END get_name;

    -- An overriding function for the generalized class.
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
      RETURN (self AS base_t).to_string()||'.['||self.name||']';
    END to_string;
  END;
/


-- Create or replace the contact_t type.
CREATE OR REPLACE
  TYPE contact_t UNDER base_t
  ( CONTACT_ID             NUMBER
  , MEMBER_ID              NUMBER
  , CONTACT_TYPE           NUMBER
  , FIRST_NAME					   VARCHAR2(60)
  , MIDDLE_NAME					   VARCHAR2(60)
  , LAST_NAME					     VARCHAR2(60)
  , CREATED_BY             NUMBER
  , CREATION_DATE          DATE
  , LAST_UPDATED_BY        NUMBER
  , LAST_UPDATE_DATE       DATE
  , CONSTRUCTOR FUNCTION contact_t
    ( oname               VARCHAR2
    , name                VARCHAR2
    , CONTACT_ID           NUMBER
    , MEMBER_ID              NUMBER
    , CONTACT_TYPE           NUMBER
    , FIRST_NAME					   VARCHAR2
    , MIDDLE_NAME					   VARCHAR2
    , LAST_NAME					     VARCHAR2
    , CREATED_BY             NUMBER
    , CREATION_DATE          DATE
    , LAST_UPDATED_BY        NUMBER
    , LAST_UPDATE_DATE       DATE ) RETURN SELF AS RESULT
  , OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
  , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)
  INSTANTIABLE NOT FINAL;
/


-- Create or replace the contact_t object body.
CREATE OR REPLACE
  TYPE BODY contact_t IS

    -- Default constructor
    CONSTRUCTOR FUNCTION contact_t
    ( oname               VARCHAR2
    , name                VARCHAR2
    , CONTACT_ID             NUMBER
    , MEMBER_ID              NUMBER
    , CONTACT_TYPE           NUMBER
    , FIRST_NAME					   VARCHAR2
    , MIDDLE_NAME					   VARCHAR2
    , LAST_NAME					     VARCHAR2
    , CREATED_BY             NUMBER
    , CREATION_DATE          DATE
    , LAST_UPDATED_BY        NUMBER
    , LAST_UPDATE_DATE       DATE ) RETURN SELF AS RESULT IS
    BEGIN
      -- Assign inputs to instance variables.    
      self.oname := oname;

      -- Assign a designated value or assign a null value.
      IF name IS NOT NULL AND UPPER(name) IN ('NEW','OLD') THEN
        self.name := UPPER(name);
      END IF;

      -- Assign inputs to instance variables.  
      self.contact_id := contact_id;
      self.member_id := member_id;
      self.contact_type := contact_type;
      self.first_name := first_name;
      self.middle_name := middle_name;
      self.last_name := last_name;
      self.created_by := created_by;
      self.creation_date := creation_date;
      self.last_updated_by := last_updated_by;
      self.last_update_date := last_update_date;


      -- Return an instance of self.
      RETURN;
    END;

    -- An overriding function for the generalized class.
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
      RETURN (self AS base_t).get_name();
    END get_name;

    -- An overriding function for the generalized class.
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
      RETURN (self AS base_t).to_string()||'.['||self.name||']';
    END to_string;
  END;
/


-- Add logger rows
INSERT INTO logger
VALUES
( logger_s.NEXTVAL
, item_t(
    'ITEM_T'
  , 'NEW'
  , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
  , 1, TRUNC(SYSDATE), 1, TRUNC(SYSDATE)));
  
INSERT INTO logger
VALUES
( logger_s.NEXTVAL
, contact_t(
    'CONTACT_T'
  , 'NEW'
  , NULL, NULL, NULL, NULL, NULL, NULL
  , 1, TRUNC(SYSDATE), 1, TRUNC(SYSDATE)));


-- Test the two rows inserted into the logger table.
COLUMN oname     FORMAT A20
COLUMN get_name  FORMAT A20
COLUMN to_string FORMAT A20
SELECT t.logger_id
,      t.log.oname AS oname
,      t.log.get_name() AS get_name
,      t.log.to_string() AS to_string
FROM  (SELECT l.logger_id
       ,      TREAT(l.log_text AS base_t) AS log
       FROM   logger l) t
WHERE  t.log.oname IN ('CONTACT_T','ITEM_T');


-- Close log file.
SPOOL OFF
