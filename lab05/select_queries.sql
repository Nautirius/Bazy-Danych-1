-- zapytania select:

-- a) wszystkich wykładowców o tym samym stopien_ID (tabela funkcja) co wykładowca  XXXXX (nazwiska)
-- funkcja określana na podstawie wysokości wynagrodzenia (widełki)
SELECT w.nazwisko
FROM lab05.wykladowca w
WHERE w.wynagrodzenie BETWEEN (
    SELECT f.min_wynagrodzenia
    FROM lab05.wykladowca w2
    JOIN lab05.funkcja f ON w2.wynagrodzenie BETWEEN f.min_wynagrodzenia AND f.max_wynagrodzenia
    WHERE w2.nazwisko = 'Adamski'
) AND (
    SELECT f.max_wynagrodzenia
    FROM lab05.wykladowca w2
    JOIN lab05.funkcja f ON w2.wynagrodzenie BETWEEN f.min_wynagrodzenia AND f.max_wynagrodzenia
    WHERE w2.nazwisko = 'Adamski'
);

-- b) wszystkich wykładowców zatrudnionych w tych samych kursach co wykładowca  XXXXX. (nazwisko, instytut)
SELECT DISTINCT w.nazwisko, i.nazwa AS instytut
FROM lab05.wykladowca w
JOIN lab05.zajecia z ON w.wykladowca_id = z.wykladowca_id
JOIN lab05.kurs k ON z.kurs_id = k.kurs_id
JOIN lab05.instytut i ON w.instytut_id = i.instytut_id
WHERE z.kurs_id IN (
    SELECT z2.kurs_id
    FROM lab05.zajecia z2
    JOIN lab05.wykladowca w2 ON z2.wykladowca_id = w2.wykladowca_id
    WHERE w2.nazwisko = 'Małysz'
);

-- c) wykładowców o pensjach z listy najniższych pensji osiąganych we wszystkich instytutach (nazwisko)
SELECT w.nazwisko
FROM lab05.wykladowca w
WHERE w.wynagrodzenie IN (
    SELECT MIN(wynagrodzenie)
    FROM lab05.wykladowca
    GROUP BY instytut_id
);

-- d) pracowników o najniższych zarobkach w ich instytutach (nazwisko, pensja)
SELECT w.nazwisko, w.wynagrodzenie
FROM lab05.wykladowca w
WHERE w.wynagrodzenie = (
    SELECT MIN(wynagrodzenie)
    FROM lab05.wykladowca
    WHERE instytut_id = w.instytut_id
);

-- e) stosując operator ANY wybrać wykładowców zarabiających powyżej najniższego zarobku z instytutu XXXXXX. (nazwisko)
SELECT w.nazwisko
FROM lab05.wykladowca w
WHERE w.wynagrodzenie > ANY (
    SELECT MIN(wynagrodzenie)
    FROM lab05.wykladowca
    WHERE instytut_id = (SELECT instytut_id FROM lab05.instytut WHERE nazwa = 'Matematyki')
);

-- f) wykładowca, który brał udział w największej ilości różnych kursów (bez LIMIT)  (nazwisko, ilość)
SELECT w.nazwisko, COUNT(DISTINCT z.kurs_id) AS liczba_kursow
FROM lab05.wykladowca w
JOIN lab05.zajecia z ON w.wykladowca_id = z.wykladowca_id
GROUP BY w.wykladowca_id
HAVING COUNT(DISTINCT z.kurs_id) = (
    SELECT MAX(liczba_kursow)
    FROM (
        SELECT COUNT(DISTINCT kurs_id) AS liczba_kursow
        FROM lab05.zajecia
        GROUP BY wykladowca_id
    ) AS max_kursy
);

-- g) instytut, w którym są najwyższe średnie zarobki. (nazwa)
SELECT nazwa
FROM lab05.instytut
WHERE instytut_id = (
    SELECT instytut_id
    FROM (
        SELECT instytut_id, AVG(wynagrodzenie) AS srednia_wynagrodzen
        FROM lab05.wykladowca
        GROUP BY instytut_id
    ) AS instytut_srednia
    ORDER BY srednia_wynagrodzen DESC
    LIMIT 1
);

-- h) dla każdego instytutu ostatnio zatrudnionych wykładowców. Uporządkować według dat zatrudnienia. (nazwa_instytutu,nazwisko)
SELECT i.nazwa AS nazwa_instytutu, w.nazwisko
FROM lab05.instytut i
JOIN lab05.wykladowca w ON i.instytut_id = w.instytut_id
WHERE w.rok_zatrudnienia = (
    SELECT MAX(rok_zatrudnienia)
    FROM lab05.wykladowca
    WHERE instytut_id = i.instytut_id
)
ORDER BY w.rok_zatrudnienia DESC;

-- i) zapytanie zwracające procentowy udział liczby pracowników  każdego instytutu w stosunku do całej firmy (nazwa, wartosc)
SELECT i.nazwa, (COUNT(w.wykladowca_id) * 100.0 / (SELECT COUNT(*) FROM lab05.wykladowca)) AS procentowy_udzial
FROM lab05.instytut i
JOIN lab05.wykladowca w ON i.instytut_id = w.instytut_id
GROUP BY i.nazwa;
