-- Create the base_t object type
CREATE OR REPLACE
  TYPE base_t IS OBJECT
  ( oid   NUMBER
  , oname VARCHAR2(30)

  , FINAL CONSTRUCTOR FUNCTION base_t
    ( oid    NUMBER
    , oname  VARCHAR2  )
    RETURN SELF AS RESULT

  , MEMBER FUNCTION get_oname RETURN VARCHAR2

  , MEMBER PROCEDURE set_oname
    ( oname  VARCHAR2 )

  , MEMBER FUNCTION get_name RETURN VARCHAR2

  , MEMBER FUNCTION to_string RETURN VARCHAR2 )

  NOT FINAL;
/


-- Implement the type body
CREATE OR REPLACE
  TYPE BODY base_t IS

  -- Implement constructor
  FINAL CONSTRUCTOR FUNCTION base_t
  ( oid    NUMBER
  , oname  VARCHAR2 )
  RETURN SELF AS RESULT IS
  BEGIN
    self.oid := oid;
    self.oname := oname;
    RETURN;
  END base_t;

  -- Implement get_oname
  MEMBER FUNCTION get_oname
  RETURN VARCHAR2 IS
  BEGIN
    RETURN self.oname;
  END get_oname;

  -- Implement set_oname
  MEMBER PROCEDURE set_oname
  ( oname  VARCHAR2 ) IS
  BEGIN
    self.oname := oname;
  END set_oname;

  -- Implement get_name
  MEMBER FUNCTION get_name
  RETURN VARCHAR2 IS
  BEGIN
    RETURN NULL;
  END get_name;

  -- Implement to_string
  MEMBER FUNCTION to_string
  RETURN VARCHAR2 IS
  BEGIN
    RETURN '['||self.oid||']['||get_name||']';
  END to_string;
END;
/


-- Create a sequence for automatically adding oids
CREATE SEQUENCE base_t_s;

QUIT;
