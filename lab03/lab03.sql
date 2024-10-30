CREATE SCHEMA IF NOT EXISTS lab03;
SET datestyle = 'ISO, DMY';


CREATE TABLE IF NOT EXISTS lab03.instytut(
    instytut_id INTEGER NOT NULL,
    nazwa VARCHAR(32) NOT NULL,
    lokal VARCHAR(32) NOT NULL,
    CONSTRAINT instytut_pk PRIMARY KEY(instytut_id)
);

CREATE TABLE IF NOT EXISTS lab03.kurs(
    kurs_id INTEGER NOT NULL,
    nazwa VARCHAR(32) NOT NULL,
    start DATE NOT NULL,
    koniec DATE, --może być NULL dla kursu, który jeszcze się nie zakończył
    CONSTRAINT kurs_pk PRIMARY KEY(kurs_id)
);

CREATE TABLE IF NOT EXISTS lab03.funkcja(
    funkcja_id INTEGER NOT NULL,
    nazwa VARCHAR(32) UNIQUE NOT NULL,
    min_wynagrodzenia INTEGER NOT NULL CHECK (min_wynagrodzenia<funkcja.max_wynagrodzenia),
    max_wynagrodzenia INTEGER NOT NULL,
    CONSTRAINT funkcja_pk PRIMARY KEY(funkcja_id)
);

-- pole manager_id mozna bylo usunac
CREATE TABLE IF NOT EXISTS lab03.wykladowca(
    wykladowca_id INTEGER NOT NULL,
    instytut_id INTEGER NOT NULL,
    wynagrodzenie INTEGER NOT NULL CHECK (wynagrodzenie>=1000),
    rok_zatrudnienia INTEGER NOT NULL,
    nazwisko VARCHAR(32) NOT NULL,
    CONSTRAINT wykladowca_pk PRIMARY KEY(wykladowca_id),
    CONSTRAINT wykladowca_instytut_id_fk FOREIGN KEY(instytut_id) REFERENCES lab03.instytut(instytut_id)
);

CREATE TABLE IF NOT EXISTS lab03.kurs_wykladowca(
    kurs_id INTEGER NOT NULL,
    wykladowca_id INTEGER NOT NULL,
    CONSTRAINT kurs_wykladowca_pk PRIMARY KEY(kurs_id, wykladowca_id),
    CONSTRAINT kurs_wykladowca_kurs_id_fk FOREIGN KEY(kurs_id) REFERENCES lab03.kurs(kurs_id),
    CONSTRAINT kurs_wykladowca_wykladowca_id_fk FOREIGN KEY(wykladowca_id) REFERENCES lab03.wykladowca(wykladowca_id)
);

insert into lab03.instytut(instytut_id, nazwa, lokal) values(1, 'matematyki', 'D-10');
insert into lab03.instytut(instytut_id, nazwa, lokal) values(2, 'informatyki', 'D-17');
insert into lab03.instytut(instytut_id, nazwa, lokal) values(3, 'chemii', 'C-7');
insert into lab03.instytut(instytut_id, nazwa, lokal) values(4, 'zarzadzania', 'D-12');

insert into lab03.kurs(kurs_id, nazwa, start, koniec) values(1, 'ABC', '10-10-2023','22-10-2023');
insert into lab03.kurs(kurs_id, nazwa, start, koniec) values(2, 'EFG', '10-08-2023','27-11-2023');
insert into lab03.kurs(kurs_id, nazwa, start, koniec) values(3, 'XYZ', '20-12-2023','30-05-2024');
insert into lab03.kurs(kurs_id, nazwa, start, koniec) values(4, 'FGO', '17-02-2024','01-07-2024');
insert into lab03.kurs(kurs_id, nazwa, start, koniec) values(5, 'ALA', '18-03-2024', NULL);
insert into lab03.kurs(kurs_id, nazwa, start, koniec) values(6, 'CUDA', '28-06-2024', NULL);


insert into lab03.funkcja(funkcja_id, nazwa, min_wynagrodzenia, max_wynagrodzenia) values(1, 'Dziekan', 5001,7000);
insert into lab03.funkcja(funkcja_id, nazwa, min_wynagrodzenia, max_wynagrodzenia) values(2, 'Doktor', 3001,5000);
insert into lab03.funkcja(funkcja_id, nazwa, min_wynagrodzenia, max_wynagrodzenia) values(3, 'Adiunkt', 2001,3000);
insert into lab03.funkcja(funkcja_id, nazwa, min_wynagrodzenia, max_wynagrodzenia) values(4, 'Asystent', 1001,2000);

insert into lab03.wykladowca(wykladowca_id, instytut_id,nazwisko, rok_zatrudnienia, wynagrodzenie) values(1, 1,'Adam', 2020,1020);
insert into lab03.wykladowca(wykladowca_id, instytut_id,nazwisko, rok_zatrudnienia, wynagrodzenie) values(2, 2,'Iksinski', 2010,2030);
insert into lab03.wykladowca(wykladowca_id, instytut_id,nazwisko, rok_zatrudnienia, wynagrodzenie) values(3, 3,'Stach', 2008,3200);
insert into lab03.wykladowca(wykladowca_id, instytut_id,nazwisko, rok_zatrudnienia, wynagrodzenie) values(4, 4,'Zygmuntowicz', 2002,6600);

insert into lab03.kurs_wykladowca(kurs_id, wykladowca_id) values(1, 3);
insert into lab03.kurs_wykladowca(kurs_id, wykladowca_id) values(2, 4);
insert into lab03.kurs_wykladowca(kurs_id, wykladowca_id) values(2, 2);
insert into lab03.kurs_wykladowca(kurs_id, wykladowca_id) values(3, 3);
insert into lab03.kurs_wykladowca(kurs_id, wykladowca_id) values(4, 3);
insert into lab03.kurs_wykladowca(kurs_id, wykladowca_id) values(1, 1);


SELECT i.nazwa, w.nazwisko FROM lab03.instytut i JOIN lab03.wykladowca w ON i.instytut_id=w.wykladowca_id
ORDER BY i.nazwa;

---TODO

SELECT w.nazwisko FROM lab03.instytut i JOIN lab03.wykladowca w ON i.instytut_id=w.wykladowca_id
WHERE i.lokal='D-10';

SELECT lab03.kurs.nazwa, lab03.wykladowca.nazwisko
FROM ((lab03.wykladowca JOIN lab03.kurs ON lab03.wykladowca.wykladowca_id = lab03.kurs.kurs_id) JOIN lab03.kurs_wykladowca ON lab03.wykladowca.wykladowca_id = lab03.kurs_wykladowca.kurs_id)
ORDER BY lab03.kurs.nazwa, lab03.wykladowca.nazwisko;




