CREATE table if not exists lab02.wykładowca (
wykładowca_id INT PRIMARY key,
nazwisko VARCHAR(32) not null,
funkcja VARCHAR(32) not null,
kierownik_id INT,
rok_zatrudnienia INT not null check (rok_zatrudnienia>=1990),
wynagrodzenie NUMERIC(7,2) not null check (wynagrodzenie>=1000.0),
instytut VARCHAR(32) not null
);

insert into lab02.wykładowca(wykładowca_id,nazwisko, funkcja, kierownik_id, rok_zatrudnienia, wynagrodzenie, instytut)
values(1,'Smith','wykladowca',2,1992,2500,'informatyki');
insert into lab02.wykładowca(wykładowca_id,nazwisko, funkcja, kierownik_id, rok_zatrudnienia, wynagrodzenie, instytut)
values(2,'Adamski','kierownik',null,1990,5000,'zarzadzania');
insert into lab02.wykładowca(wykładowca_id,nazwisko, funkcja, kierownik_id, rok_zatrudnienia, wynagrodzenie, instytut)
values(3,'Kowalska','wykladowca',2,2002,3200,'chemii');
insert into lab02.wykładowca(wykładowca_id,nazwisko, funkcja, kierownik_id, rok_zatrudnienia, wynagrodzenie, instytut)
values(4,'Gryf','wykladowca',2,1998,2800,'matematyki');
insert into lab02.wykładowca(wykładowca_id,nazwisko, funkcja, kierownik_id, rok_zatrudnienia, wynagrodzenie, instytut)
values(5,'Maj','kierownik',null,1993,7200,'zarzadzania');
insert into lab02.wykładowca(wykładowca_id,nazwisko, funkcja, kierownik_id, rok_zatrudnienia, wynagrodzenie, instytut)
values(6,'Ptak','kierownik',null,1996,5200,'zarzadzania');
insert into lab02.wykładowca(wykładowca_id,nazwisko, funkcja, kierownik_id, rok_zatrudnienia, wynagrodzenie, instytut)
values(7,'Maj','zastepca kierownika',5,1996,4200,'zarzadzania');
insert into lab02.wykładowca(wykładowca_id,nazwisko, funkcja, kierownik_id, rok_zatrudnienia, wynagrodzenie, instytut)
values(8,'Niedzielski','wykladowca',2,1992,2500,'informatyki');
insert into lab02.wykładowca(wykładowca_id,nazwisko, funkcja, kierownik_id, rok_zatrudnienia, wynagrodzenie, instytut)
values(9,'Mach','wykladowca',6,2004,2500,'informatyki');
insert into lab02.wykładowca(wykładowca_id,nazwisko, funkcja, kierownik_id, rok_zatrudnienia, wynagrodzenie, instytut)
values(10,'Zychowicz','kierownik',null,1997,5100,'zarzadzania');
insert into lab02.wykładowca(wykładowca_id,nazwisko, funkcja, kierownik_id, rok_zatrudnienia, wynagrodzenie, instytut)
values(11,'Wieczorek','wykladowca',2,2007,3200,'chemii');
insert into lab02.wykładowca(wykładowca_id,nazwisko, funkcja, kierownik_id, rok_zatrudnienia, wynagrodzenie, instytut)
values(12,'Stefan','wykladowca',6,1999,3800,'matematyki');
insert into lab02.wykładowca(wykładowca_id,nazwisko, funkcja, kierownik_id, rok_zatrudnienia, wynagrodzenie, instytut)
values(13,'Skoczylas','zastepca kierownika',6,1999,4150,'zarzadzania');
insert into lab02.wykładowca(wykładowca_id,nazwisko, funkcja, kierownik_id, rok_zatrudnienia, wynagrodzenie, instytut)
values(14,'Matera','kierownik',null,2004,5200,'zarzadzania');
insert into lab02.wykładowca(wykładowca_id,nazwisko, funkcja, kierownik_id, rok_zatrudnienia, wynagrodzenie, instytut)
values(15,'Dziekan','wykladowca',null,2006,3200,'matematyki');

select wyk.nazwisko,wyk.wynagrodzenie AS płaca,CAST(2024-wyk.rok_zatrudnienia AS INT) as staż 
from lab02.wykładowca wyk
inner join lab02.wykładowca kierownik on kierownik.wykładowca_id = wyk.kierownik_id ;
order by wyk.funkcja, kierownik.nazwisko;

select nazwisko, instytut, rok_zatrudnienia from lab02.wykładowca
where kierownik_id is null;

select nazwisko, instytut from lab02.wykładowca
where funkcja='zastepca kierownika';

select distinct funkcja from lab02.wykładowca
order by funkcja;

UPDATE lab02.wykładowca SET wynagrodzenie = wynagrodzenie*1.1
where kierownik_id is not null;

select nazwisko, funkcja from lab02.wykładowca
where wynagrodzenie between 1000 and 3000;

DELETE FROM lab02.wykładowca
where 2024-rok_zatrudnienia < 1;
