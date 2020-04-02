-- Create the goblin_t object type
CREATE OR REPLACE
  TYPE goblin_t UNDER base_t
  ( name  VARCHAR2(30)
  , genus VARCHAR2(30)

  , FINAL CONSTRUCTOR FUNCTION goblin_t
    ( name    VARCHAR2
    , genus   VARCHAR2 )
    RETURN SELF AS RESULT DETERMINISTIC

  , OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2

  , MEMBER PROCEDURE set_name
    ( name  VARCHAR2 )

  , MEMBER FUNCTION get_genus RETURN VARCHAR2

  , MEMBER PROCEDURE set_genus
    ( genus  VARCHAR2 )

  , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 )

  INSTANTIABLE NOT FINAL;
/


-- Implement the type body
CREATE OR REPLACE
  TYPE BODY goblin_t IS

  -- Implement constructor
  FINAL CONSTRUCTOR FUNCTION goblin_t
  ( name    VARCHAR2
  , genus   VARCHAR2 )
  RETURN SELF AS RESULT DETERMINISTIC IS
  BEGIN
    -- Constructor is marked deterministic so that
    -- NEXTVAL only gets called once per operation
    self.oid := base_t_s.NEXTVAL;
    self.oname := 'Goblin';
    self.name := name;
    self.genus := genus;
    RETURN;
  END goblin_t;

  -- Override get_name
  OVERRIDING MEMBER FUNCTION get_name
  RETURN VARCHAR2 IS
  BEGIN
    RETURN self.name;
  END get_name;

  -- Implement set_name
  MEMBER PROCEDURE set_name
  ( name  VARCHAR2 ) IS
  BEGIN
    self.name := name;
  END set_name;

  -- Implement get_genus
  MEMBER FUNCTION get_genus
  RETURN VARCHAR2 IS
  BEGIN
    RETURN self.genus;
  END get_genus;

  -- Implement set_genus
  MEMBER PROCEDURE set_genus
  ( genus  VARCHAR2 ) IS
  BEGIN
    self.genus := genus;
  END set_genus;

  -- Override to_string to include genus
  OVERRIDING MEMBER FUNCTION to_string
  RETURN VARCHAR2 IS
  BEGIN
    RETURN (self AS base_t).to_string||'['||get_genus||']';
  END to_string;
END;
/

QUIT;
