CREATE OR REPLACE VIEW biblioteka.hierarchia_kategorii AS
WITH RECURSIVE hierarchia AS (
    SELECT
        id_kategorii,
        nazwa,
        id_kategorii_nadrzednej,
        ARRAY[nazwa::VARCHAR] AS sciezka
    FROM biblioteka.kategorie
    WHERE id_kategorii_nadrzednej IS NULL
    UNION ALL
    SELECT
        k.id_kategorii,
        k.nazwa,
        k.id_kategorii_nadrzednej,
        h.sciezka || k.nazwa::VARCHAR
    FROM biblioteka.kategorie k
         INNER JOIN hierarchia h ON k.id_kategorii_nadrzednej = h.id_kategorii
)
SELECT id_kategorii, nazwa, id_kategorii_nadrzednej, array_to_string(sciezka, ' > ') AS sciezka
FROM hierarchia;
