-- Zapytania do bazy danych:
-- 1. Linie zatrzymujące się na wybranym przystanku (z podziałem na autobusy i tramwaje)
SELECT DISTINCT l.nazwa AS linia, p.nazwa AS przystanek
FROM erd_01.Linia l
JOIN erd_01.Linia_Przystanek lp ON l.id_linii = lp.id_linii
JOIN erd_01.Przystanek p ON lp.id_przystanku = p.id_przystanku
WHERE p.nazwa = 'Park';

-- 2. Czas odjazdu dla wybranego przystanku i linii, z uwzględnieniem kierunku jazdy
SELECT l.nazwa AS linia, p.nazwa AS przystanek, lp.czas_odjazdu, lp.kierunek
FROM erd_01.Linia l
JOIN erd_01.Linia_Przystanek lp ON l.id_linii = lp.id_linii
JOIN erd_01.Przystanek p ON lp.id_przystanku = p.id_przystanku
WHERE p.nazwa = 'Dworzec' AND l.nazwa = 'Linia 1';

-- 3. Przystanki i czasy odjazdu dla wybranej linii, z uwzględnieniem kierunku jazdy
SELECT l.nazwa AS linia, p.nazwa AS przystanek, lp.czas_odjazdu, lp.kierunek
FROM erd_01.Linia l
JOIN erd_01.Linia_Przystanek lp ON l.id_linii = lp.id_linii
JOIN erd_01.Przystanek p ON lp.id_przystanku = p.id_przystanku
WHERE l.nazwa = 'Linia 1'
ORDER BY lp.czas_odjazdu;
