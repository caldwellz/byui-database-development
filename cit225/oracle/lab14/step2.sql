BEGIN
  /* Create the student_dad. */
  dbms_epg.create_dad(
      dad_name => 'STUDENT_DAD'
    , path => '/studentdb/*');
END;
/

BEGIN
  /* Authorize the student_dad for the student user. */
  dbms_epg.authorize_dad(
      dad_name => 'STUDENT_DAD'
    , USER => 'STUDENT');
END;
/

CREATE OR REPLACE PROCEDURE student.helloworld AS
BEGIN
  -- Set an HTML meta tag and render page.
  owa_util.mime_header('text/html'); -- <META Content-type:text/html>
  htp.htmlopen; -- <HTML>
  htp.headopen; -- <HEAD>
  htp.htitle('Hello World!'); -- <TITLE>HelloWorld!</TITLE>
  htp.headclose; -- </HEAD>
  htp.bodyopen; -- <BODY>
  htp.line; -- <HR>
  htp.print('Hello ['||USER||']!'); -- Hello [dynamic user_name]!
  htp.line; -- <HR>
  htp.bodyclose; -- </BODY>
  htp.htmlclose; -- </HTML>
END HelloWorld;
/
