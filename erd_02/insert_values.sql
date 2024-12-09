-- Dodawanie przykładowych danych
INSERT INTO erd_02.Person (first_name, last_name, birth_date, birth_place) VALUES
('Jan', 'Abacki', '1997-03-15', 'Kraków'),
('Anna', 'Tokarz', '1995-07-20', 'Kraków'),
('Michał', 'Niedziela', '1999-10-05', 'Warszawa'),
('Klaudia', 'Biel', '1998-11-25', 'Gdańsk'),
('Józef', 'K', '2005-08-30', 'Wrocław');

INSERT INTO erd_02.Person (first_name, last_name, birth_date, birth_place, death_date, death_place) VALUES
('Ewa', 'Ryś', '1945-03-02', 'Gliwice', '2020-04-15', 'Gliwice');


INSERT INTO erd_02.Marriage (spouse1, spouse2) VALUES
((SELECT person_id FROM erd_02.Person WHERE first_name = 'Jan' AND last_name = 'Abacki'), (SELECT person_id FROM erd_02.Person WHERE first_name = 'Anna' AND last_name = 'Tokarz')),
((SELECT person_id FROM erd_02.Person WHERE first_name = 'Michał' AND last_name = 'Niedziela'), (SELECT person_id FROM erd_02.Person WHERE first_name = 'Klaudia' AND last_name = 'Biel'));

INSERT INTO erd_02.Person (first_name, last_name, birth_date, birth_place, parent1, parent2) VALUES
('Emilia', 'Abacki', '2005-02-12', 'Kraków',
 (SELECT person_id FROM erd_02.Person WHERE first_name = 'Jan' AND last_name = 'Abacki'),
 (SELECT person_id FROM erd_02.Person WHERE first_name = 'Anna' AND last_name = 'Tokarz')),
('Krzysztof', 'Abacki', '2008-06-18', 'Kraków',
 (SELECT person_id FROM erd_02.Person WHERE first_name = 'Jan' AND last_name = 'Abacki'),
 (SELECT person_id FROM erd_02.Person WHERE first_name = 'Anna' AND last_name = 'Tokarz')),
('Piotr', 'Niedziela', '2010-01-10', 'Warszawa',
 (SELECT person_id FROM erd_02.Person WHERE first_name = 'Michał' AND last_name = 'Niedziela'),
 (SELECT person_id FROM erd_02.Person WHERE first_name = 'Klaudia' AND last_name = 'Biel'));
