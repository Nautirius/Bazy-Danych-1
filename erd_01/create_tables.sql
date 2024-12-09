CREATE SCHEMA IF NOT EXISTS erd_01;

-- Tworzenie tabel:
CREATE TABLE IF NOT EXISTS erd_01.Linia (
    id_linii SERIAL PRIMARY KEY,
    nazwa VARCHAR(50) UNIQUE,  -- Unikalna nazwa linii
    typ VARCHAR(10) NOT NULL CHECK (typ IN ('autobus', 'tramwaj'))
);

CREATE TABLE IF NOT EXISTS erd_01.Przystanek (
    id_przystanku SERIAL PRIMARY KEY,
    nazwa VARCHAR(100) UNIQUE,  -- Unikalna nazwa przystanku
    dwustronny BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS erd_01.Trasa (
    id_trasy SERIAL PRIMARY KEY,
    id_linii INT NOT NULL REFERENCES erd_01.Linia(id_linii),
    nazwa VARCHAR(50),
    typ_dni VARCHAR(20) NOT NULL CHECK (typ_dni IN ('dni_robocze', 'weekend', 'święta')),
    UNIQUE (id_linii, nazwa)  -- Unikalna nazwa trasy dla danej linii
);

CREATE TABLE IF NOT EXISTS erd_01.Pojazd (
    id_pojazdu SERIAL PRIMARY KEY,
    numer VARCHAR(20) UNIQUE,  -- Unikalny numer pojazdu (identyfikator publiczny - numer boczny)
    id_linii INT REFERENCES erd_01.Linia(id_linii),
    pojemność INT CHECK (pojemność > 0),
    typ VARCHAR(10) NOT NULL CHECK (typ IN ('autobus', 'tramwaj'))
);

CREATE TABLE IF NOT EXISTS erd_01.Przystanek_Trasa (
    id_trasy INT REFERENCES erd_01.Trasa(id_trasy),
    id_przystanku INT REFERENCES erd_01.Przystanek(id_przystanku),
    kolejność INT NOT NULL,
    UNIQUE (id_trasy, id_przystanku, kolejność)  -- Unikalna kombinacja trasy, przystanku i kolejności
);

-- Tabela: Linia_Przystanek
CREATE TABLE IF NOT EXISTS erd_01.Linia_Przystanek (
    id_linii INT REFERENCES erd_01.Linia(id_linii),
    id_przystanku INT REFERENCES erd_01.Przystanek(id_przystanku),
    czas_odjazdu TIME NOT NULL,
    kierunek VARCHAR(100),
    UNIQUE (id_linii, id_przystanku, czas_odjazdu, kierunek)  -- Unikalne połączenie linii, przystanku, czasu i kierunku
);
