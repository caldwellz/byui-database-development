@?/rdbms/admin/epgstat.sql

ALTER USER anonymous ACCOUNT UNLOCK;
ALTER USER anonymous IDENTIFIED BY NULL;

SET SERVEROUTPUT ON
DECLARE
  lv_configxml XMLTYPE;
  lv_value VARCHAR2(5) := 'true'; -- (true/false)
BEGIN
  lv_configxml := DBMS_XDB.cfg_get();
 
  -- Check for the element.
  IF lv_configxml.EXISTSNODE('/xdbconfig/sysconfig/protocolconfig/httpconfig/allow-repository-anonymous-access') = 0 THEN
    -- Add missing element.
    SELECT INSERTCHILDXML
            ( lv_configxml
            ,'/xdbconfig/sysconfig/protocolconfig/httpconfig'
            ,'allow-repository-anonymous-access'
            , XMLType('<allow-repository-anonymous-access xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd">'
              || lv_value
              || '</allow-repository-anonymous-access>')
            ,'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"')
    INTO lv_configxml
    FROM dual;
 
    dbms_output.put_line('Element inserted.');
  ELSE
    -- Update existing element.
    SELECT UPDATEXML
            ( DBMS_XDB.cfg_get()
            ,'/xdbconfig/sysconfig/protocolconfig/httpconfig/allow-repository-anonymous-access/text()'
            , lv_value
            ,'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"')
    INTO lv_configxml
    FROM dual;
 
    dbms_output.put_line('Element updated.');
  END IF;
 
  -- Configure the element.
  dbms_xdb.cfg_update(lv_configxml);
  dbms_xdb.cfg_refresh;
END;
/

@?/rdbms/admin/epgstat.sql

BEGIN
  /* Create the student_dad. */
  dbms_epg.create_dad(
      dad_name => 'GENERIC_DAD'
    , path => '/db/*');
END;
/

BEGIN
  /* Authorize the student_dad for the student user. */
  dbms_epg.authorize_dad(
      dad_name => 'GENERIC_DAD'
    , USER => 'ANONYMOUS');
END;
/

BEGIN
  dbms_epg.set_dad_attribute(
      dad_name => 'GENERIC_DAD'
    , attr_name => 'database-username'
    , attr_value => 'ANONYMOUS');
END;
/

SELECT   extractValue(VALUE(dad)
                     ,'/servlet/servlet-name'
                     ,'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"') dad_name
,        VALUE(param).getRootElement() param_name
,        extractValue(VALUE(param), '/*') param_value
FROM     xdb.xdb$config cfg
,        TABLE(XMLSequence(EXTRACT(cfg.object_value
                                  , '/xdbconfig/sysconfig/protocolconfig/httpconfig'
                                  ||'/webappconfig/servletconfig/servlet-list'
                                  ||'/servlet[servlet-language="PL/SQL"]'
                                  , 'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'))) dad
,        TABLE(XMLSequence(EXTRACT(VALUE(dad)
              ,'/servlet/security-role-ref/*'
              ,'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'))) param
ORDER BY dad_name;

DECLARE
  cfg XMLType := dbms_xdb.cfg_get();
BEGIN
  cfg := cfg.deleteXML('/xdbconfig/sysconfig/protocolconfig/httpconfig'
      ||               '/webappconfig/servletconfig/servlet-list'
      ||               '/servlet[servlet-name="DMSWU"]'
      ||               '/security-role-ref');
  dbms_xdb.cfg_update(cfg);
END;
/

CREATE OR REPLACE PROCEDURE student.helloworld2 AS
BEGIN
  -- Set an HTML meta tag and render page.
  owa_util.mime_header('text/html'); -- <META Content-type:text/html>
  htp.htmlopen; -- <HTML>
  htp.headopen; -- <HEAD>
  htp.htitle('Hello Anonymous World!'); -- <TITLE>HelloWorld!</TITLE>
  htp.headclose; -- </HEAD>
  htp.bodyopen; -- <BODY>
  htp.line; -- <HR>
  htp.print('Hello ['||USER||']!'); -- Hello [dynamic user_name]!
  htp.line; -- <HR>
  htp.bodyclose; -- </BODY>
  htp.htmlclose; -- </HTML>
END HelloWorld2;
/

GRANT EXECUTE ON student.helloworld2 TO anonymous;
CREATE SYNONYM anonymous.helloworld FOR student.helloworld2;
