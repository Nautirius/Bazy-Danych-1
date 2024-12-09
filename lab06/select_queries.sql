-- a)
SELECT
    i.nazwa AS instytut,
    SUM(CASE WHEN k.nazwa = 'Matematyka' THEN 1 ELSE 0 END) AS Matematyka,
    SUM(CASE WHEN k.nazwa = 'Informatyka' THEN 1 ELSE 0 END) AS Informatyka,
    SUM(CASE WHEN k.nazwa = 'Bazy Danych' THEN 1 ELSE 0 END) AS BD
FROM
    lab06.zajecia z
JOIN
    lab06.wykladowca w ON z.wykladowca_id = w.wykladowca_id
JOIN
    lab06.kurs k ON z.kurs_id = k.kurs_id
JOIN
    lab06.instytut i ON w.instytut_id = i.instytut_id
GROUP BY
    i.nazwa
ORDER BY
    i.nazwa;


-- b) Proszę zapisać kwerendę z wyrażeniem tabelarycznym (CTE) zwracająca zestawienie w ile razy wykładowcy z danego instytutu prowadzili zajęcia w poszczególnym kursie (nazwa_instytutu, kurs, ilosc)
WITH InstituteCourseSummary AS (
    SELECT
        i.nazwa AS nazwa_instytutu,
        k.nazwa AS kurs,
        COUNT(z.wykladowca_id) AS ilosc
    FROM
        lab06.zajecia z
    JOIN
        lab06.wykladowca w ON z.wykladowca_id = w.wykladowca_id
    JOIN
        lab06.kurs k ON z.kurs_id = k.kurs_id
    JOIN
        lab06.instytut i ON w.instytut_id = i.instytut_id
    GROUP BY
        i.nazwa, k.nazwa
)
SELECT * FROM InstituteCourseSummary;


-- c) nazwisko pracownika i jego przełożonego
SELECT e.empno AS emp_no, e.empname AS emp_name, e.mgrno AS mgr_no, m.empname AS mgr_name
FROM lab06.staff e
JOIN lab06.staff m ON e.mgrno = m.empno
ORDER BY e.empno;


-- d) nazwisko pracownika, nazwisko bezpośredniego przełożonego i poziom w hierarchii
WITH RECURSIVE hierarchy AS (
    SELECT empname, CAST(NULL AS VARCHAR) AS mgrname, empno, mgrno, 1 AS lvl
    FROM lab06.staff
    WHERE mgrno IS NULL

    UNION ALL

    SELECT e.empname, h.empname AS mgrname, e.empno, e.mgrno, h.lvl + 1 AS lvl
    FROM lab06.staff e
    JOIN hierarchy h ON e.mgrno = h.empno
)
SELECT empname, CASE WHEN mgrname IS NOT NULL THEN mgrname ELSE '' END AS mgrname, lvl
FROM hierarchy
ORDER BY lvl, empname;


-- e) nazwisko pracownika, poziom w hierarchii i listę przełożonych
WITH RECURSIVE hierarchy AS (
    SELECT empname, 1 AS lvl, empno, mgrno, CAST(empname AS VARCHAR) AS path
    FROM lab06.staff
    WHERE mgrno IS NULL

    UNION

    SELECT e.empname, h.lvl + 1 AS lvl, e.empno, e.mgrno, CONCAT(h.path, '->', e.empname) AS path
    FROM lab06.staff e
    JOIN hierarchy h ON e.mgrno = h.empno
)
SELECT empname, lvl, path
FROM hierarchy
ORDER BY lvl, empname;
