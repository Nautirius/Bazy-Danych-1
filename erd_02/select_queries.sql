-- Zapytania

-- 1. Informacje o wybranej osobie
SELECT * FROM erd_02.Person WHERE first_name = 'Emilia' AND last_name = 'Abacki';

-- 2. Informacje o rodzicach
SELECT *
FROM erd_02.Person
WHERE person_id IN (
    (SELECT parent1 FROM erd_02.Person WHERE first_name = 'Emilia' AND last_name = 'Abacki'),
    (SELECT parent2 FROM erd_02.Person WHERE first_name = 'Emilia' AND last_name = 'Abacki')
);

-- 3. Czy posiada dzieci, jeżeli tak, podać ich imiona
SELECT first_name, last_name
FROM erd_02.Person
WHERE parent1 = (SELECT person_id FROM erd_02.Person WHERE first_name = 'Jan')
   OR parent2 = (SELECT person_id FROM erd_02.Person WHERE first_name = 'Jan');

-- -- 4. Rodzeństwo
-- SELECT p.*
-- FROM erd_02.Person p
-- JOIN (
--     SELECT parent1, parent2
--     FROM erd_02.Person
--     WHERE first_name = 'Emma'
-- ) AS parents
-- ON (p.parent1 = parents.parent1 AND p.parent2 = parents.parent2)
-- WHERE p.first_name != 'Emma';