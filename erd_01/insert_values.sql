-- Wpisywanie wartości do tabel:
INSERT INTO erd_01.Linia (nazwa, typ) VALUES
('Linia 1', 'autobus'),
('Linia 2', 'tramwaj');

INSERT INTO erd_01.Przystanek (nazwa, dwustronny) VALUES
('Dworzec', TRUE),
('Centrum', TRUE),
('Park', FALSE);

INSERT INTO erd_01.Trasa (id_linii, nazwa, typ_dni) VALUES
(1, 'Trasa A', 'dni_robocze'),
(1, 'Trasa B', 'weekend'),
(2, 'Trasa C', 'dni_robocze');

INSERT INTO erd_01.Pojazd (numer, id_linii, pojemność, typ) VALUES
('A1', 1, 50, 'autobus'),
('T1', 2, 100, 'tramwaj');

INSERT INTO erd_01.Przystanek_Trasa (id_trasy, id_przystanku, kolejność) VALUES
(1, 1, 1),  -- Start trasy A - Dworzec
(1, 3, 2),  -- do Parku
(1, 2, 3),  -- do Centrum
(2, 1, 1),  -- Start trasy B - Dworzec
(2, 3, 2);  -- do Parku

INSERT INTO erd_01.Linia_Przystanek (id_linii, id_przystanku, czas_odjazdu, kierunek) VALUES
(1, 1, '08:00', 'Dworzec -> Centrum'),
(1, 3, '08:10', 'Dworzec -> Centrum'),
(1, 2, '08:15', 'Dworzec -> Centrum'),
(1, 1, '09:00', 'Dworzec -> Centrum'),
(1, 3, '09:10', 'Dworzec -> Centrum'),
(1, 2, '09:15', 'Dworzec -> Centrum'),
(2, 1, '07:30', 'Dworzec -> Park'),
(2, 3, '07:45', 'Dworzec -> Park');
