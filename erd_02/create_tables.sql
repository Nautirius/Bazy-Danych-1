-- Tworzenie tabel
CREATE SCHEMA IF NOT EXISTS erd_02;

CREATE TABLE IF NOT EXISTS erd_02.Person (
    person_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    birth_place VARCHAR(100) NOT NULL,
    death_date DATE,
    death_place VARCHAR(100),
    parent1 INT REFERENCES erd_02.Person(person_id) ON DELETE SET NULL ON UPDATE CASCADE,
    parent2 INT REFERENCES erd_02.Person(person_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS erd_02.Marriage (
    spouse1 INT NOT NULL REFERENCES erd_02.Person(person_id) ON DELETE CASCADE ON UPDATE CASCADE,
    spouse2 INT NOT NULL REFERENCES erd_02.Person(person_id) ON DELETE CASCADE ON UPDATE CASCADE,
    current BOOLEAN DEFAULT TRUE NOT NULL,
    CONSTRAINT marriage_pk PRIMARY KEY (spouse1, spouse2)
);
