-- baza danych do zadania:
CREATE TABLE TRANSAKCJE (
ID_TRANSAKCJI DECIMAL(12, 0) NOT NULL ,
NR_KONTA VARCHAR(30) NOT NULL ,
DATA DATE NOT NULL ,
KWOTA DECIMAL(10, 2) NOT NULL ,
TYP VARCHAR(10),
KATEGORIA VARCHAR(20));
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10000, '11-11111111', TO_DATE('03.01.1997','DD.MM.YYYY'), 1500, 'WPŁATA', 'PENSJA');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10010,'11-11111111',TO_DATE('12.01.1997','DD.MM.YYYY'), -100, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10020, '11-11111111', TO_DATE('02.02.1997','DD.MM.YYYY'), 750, 'WPŁATA', 'UMOWA O DZIEŁO');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10030, '11-11111111', TO_DATE('22.05.1998','DD.MM.YYYY'), -150, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10040, '11-11111111', TO_DATE('04.11.1999','DD.MM.YYYY'), 1800, 'WPŁATA', 'PENSJA');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10050, '11-11111111', TO_DATE('02.12.1999','DD.MM.YYYY'), 1800, 'WPŁATA', 'PENSJA');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10060, '11-11111111', TO_DATE('24.12.1999','DD.MM.YYYY'), -120.5, 'WYPŁATA', 'RACHUNEK ZA PRAD');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10070, '11-11111111', TO_DATE('24.12.1999','DD.MM.YYYY'), -300, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10080, '11-11111111', TO_DATE('19.01.2000','DD.MM.YYYY'), -150, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10090, '11-11111111', TO_DATE('03.05.2000','DD.MM.YYYY'), 900, 'WPŁATA', 'UMOWA O DZIEŁO');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10100, '11-11111111', TO_DATE('16.07.2001','DD.MM.YYYY'), -600, 'WYPŁATA', 'RACHUNEK ZA PRAD');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10110, '11-11111111', TO_DATE('24.07.2001','DD.MM.YYYY'), -150, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10120, '11-11111111', TO_DATE('03.09.2001','DD.MM.YYYY'), 1400, 'WPŁATA', 'PENSJA');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10130, '11-11111111', TO_DATE('29.09.2001','DD.MM.YYYY'), -250, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10140, '11-11111111', TO_DATE('03.12.2001','DD.MM.YYYY'), 1650, 'WPŁATA', 'PENSJA');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10150, '11-11111111', TO_DATE('05.01.2002','DD.MM.YYYY'), -500, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10001, '22-22222222', TO_DATE('03.04.1998','DD.MM.YYYY'), 1650, 'WPŁATA', 'PENSJA');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10011, '22-22222222', TO_DATE('12.01.1997','DD.MM.YYYY'), 1000, 'WPŁATA', 'PENSJA');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10021, '22-22222222', TO_DATE('02.09.1997','DD.MM.YYYY'), 830, 'WPŁATA', 'UMOWA O DZIEŁO');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10031, '22-22222222', TO_DATE('22.03.1998','DD.MM.YYYY'), -170, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10041, '22-22222222', TO_DATE('04.05.2001','DD.MM.YYYY'), 1980, 'WPŁATA', 'PENSJA');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10051, '22-22222222', TO_DATE('02.07.2001','DD.MM.YYYY'), 2090, 'WPŁATA', 'PENSJA');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10061, '22-22222222', TO_DATE('24.10.1999','DD.MM.YYYY'), -130.5, 'WYPŁATA', 'RACHUNEK ZA PRAD');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10071, '22-22222222', TO_DATE('02.10.1999','DD.MM.YYYY'), -330, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10081, '22-22222222', TO_DATE('19.12.1999','DD.MM.YYYY'), -110, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10091, '22-22222222', TO_DATE('03.02.2001','DD.MM.YYYY'), 990, 'WPŁATA', 'UMOWA O DZIEŁO');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10101, '22-22222222', TO_DATE('16.01.2001','DD.MM.YYYY'), -660, 'WYPŁATA', 'RACHUNEK ZA PRAD');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10111, '22-22222222', TO_DATE('24.05.2001','DD.MM.YYYY'), -170, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10121, '22-22222222', TO_DATE('03.11.2002','DD.MM.YYYY'), 1540, 'WPŁATA', 'PENSJA');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10131, '22-22222222', TO_DATE('29.06.2001','DD.MM.YYYY'), -280, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10141, '22-22222222', TO_DATE('03.04.2003','DD.MM.YYYY'), 1820, 'WPŁATA', 'PENSJA');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10151, '22-22222222', TO_DATE('05.08.2001','DD.MM.YYYY'), -550, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10002, '33-33333333', TO_DATE('03.10.1995','DD.MM.YYYY'), 1350, 'WPŁATA', 'PENSJA');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10012, '33-33333333', TO_DATE('12.02.1997','DD.MM.YYYY'), -90, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10022, '33-33333333', TO_DATE('02.07.1996','DD.MM.YYYY'), 670, 'WPŁATA', 'UMOWA O DZIEŁO');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10032, '33-33333333', TO_DATE('22.07.1998','DD.MM.YYYY'), -130, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10042, '33-33333333', TO_DATE('04.05.1998','DD.MM.YYYY'), 1620, 'WPŁATA', 'PENSJA');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10052, '33-33333333', TO_DATE('02.05.1998','DD.MM.YYYY'), 1710, 'WPŁATA', 'PENSJA');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10062, '33-33333333', TO_DATE('24.02.2000','DD.MM.YYYY'), -110.5, 'WYPŁATA', 'RACHUNEK ZA PRAD');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10072, '33-33333333', TO_DATE('02.04.2000','DD.MM.YYYY'), -270, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10082, '33-33333333', TO_DATE('19.02.2000','DD.MM.YYYY'), -90, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10092, '33-33333333', TO_DATE('03.08.1999','DD.MM.YYYY'), 810, 'WPŁATA', 'UMOWA O DZIEŁO');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10102, '33-33333333', TO_DATE('16.01.2002','DD.MM.YYYY'), -540, 'WYPŁATA', 'RACHUNEK ZA PRAD');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10112, '33-33333333', TO_DATE('24.09.2001','DD.MM.YYYY'), -130, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10122, '33-33333333', TO_DATE('03.07.2000','DD.MM.YYYY'), 1260, 'WPŁATA', 'PENSJA');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10132, '33-33333333', TO_DATE('29.12.2001','DD.MM.YYYY'), -220, 'WYPŁATA', 'RACHUNEK ZA TELEFON');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10142, '33-33333333', TO_DATE('03.08.2000','DD.MM.YYYY'), 1480, 'WPŁATA', 'PENSJA');
INSERT INTO TRANSAKCJE(ID_TRANSAKCJI, NR_KONTA, DATA, KWOTA, TYP, KATEGORIA) VALUES (10152, '33-33333333', TO_DATE('05.06.2002','DD.MM.YYYY'), -450, 'WYPŁATA', 'WYPŁATA W BANKOMACIE');