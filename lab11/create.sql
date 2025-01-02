CREATE SCHEMA lab11;

CREATE TABLE lab11.osoba  ( id INT PRIMARY KEY, fname VARCHAR(20), lname VARCHAR(20) );

insert into  lab11.osoba values
(1, 'Adam', 'Abacki'),
(2 ,'Tosia', 'Wieczorek');


CREATE OR REPLACE FUNCTION lab11.f1_osoba ( int )
RETURNS char(30) AS
' SELECT lname FROM lab11.osoba WHERE id = $1 ;
' LANGUAGE sql;

CREATE OR REPLACE FUNCTION lab11.get_table()
RETURNS table ( id int, fn char(30), ln char(30)) AS
' SELECT id, fname, lname FROM lab11.osoba ;
' LANGUAGE sql ;

CREATE OR REPLACE FUNCTION lab11.get_cursor()
RETURNS refcursor AS
' DECLARE curosoby refcursor  ;
BEGIN
  OPEN curosoby FOR SELECT id, fname, lname FROM lab11.osoba ;
  RETURN curosoby ;
END;
' LANGUAGE plpgsql;