-- Create the sindar_t object type
CREATE OR REPLACE
  TYPE sindar_t UNDER elf_t
  ( elfkind VARCHAR2(30)

  , FINAL CONSTRUCTOR FUNCTION sindar_t
    ( elfkind VARCHAR2 )
    RETURN SELF AS RESULT DETERMINISTIC

  , MEMBER FUNCTION get_elfkind RETURN VARCHAR2

  , MEMBER PROCEDURE set_elfkind
    ( elfkind  VARCHAR2 )

  , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 )

  INSTANTIABLE NOT FINAL;
/


-- Implement the type body
CREATE OR REPLACE
  TYPE BODY sindar_t IS

  -- Implement constructor
  FINAL CONSTRUCTOR FUNCTION sindar_t
  ( elfkind VARCHAR2 )
  RETURN SELF AS RESULT DETERMINISTIC IS
  BEGIN
    -- Constructor is marked deterministic so that
    -- NEXTVAL only gets called once per operation
    self.oid := base_t_s.NEXTVAL;
    self.oname := 'Elf';
    self.genus := 'Elves';
    self.elfkind := elfkind;
    RETURN;
  END sindar_t;

  -- Implement get_elfkind
  MEMBER FUNCTION get_elfkind
  RETURN VARCHAR2 IS
  BEGIN
    RETURN self.elfkind;
  END get_elfkind;

  -- Implement set_elfkind
  MEMBER PROCEDURE set_elfkind
  ( elfkind  VARCHAR2 ) IS
  BEGIN
    self.elfkind := elfkind;
  END set_elfkind;

  -- Override to_string to include elfkind
  OVERRIDING MEMBER FUNCTION to_string
  RETURN VARCHAR2 IS
  BEGIN
    RETURN (self AS elf_t).to_string||'['||get_elfkind||']';
  END to_string;
END;
/

QUIT;
