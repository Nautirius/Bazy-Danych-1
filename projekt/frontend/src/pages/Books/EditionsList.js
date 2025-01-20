import { Link } from "react-router-dom";
import { useEffect, useState } from "react";
import axios from 'axios';
import config from '../../config';

export const EditionsList = () => {
    const [editions, setEditions] = useState([]);
    const [search, setSearch] = useState('');
    const [filteredEditions, setFilteredEditions] = useState([]);

    useEffect(() => {
        const fetchEditions = async () => {
            try {
                const response = await axios.get(`${config.API_BASE_URL}/editions`);
                setEditions(response.data);
                setFilteredEditions(response.data); // Domyślnie wszystkie edycje są wyświetlane
            } catch (error) {
                console.error('Error fetching editions:', error.response?.data || error.message);
            }
        };
        fetchEditions();
    }, []);

    useEffect(() => {
        if (search === '') {
            setFilteredEditions(editions); // Jeśli brak wyszukiwania, pokaż wszystko
        } else {
            const lowercasedSearch = search.toLowerCase();
            setFilteredEditions(
                editions.filter((edition) =>
                    edition.tytul_ksiazki?.toLowerCase().includes(lowercasedSearch) ||
                    edition.autorzy?.toLowerCase().includes(lowercasedSearch) ||
                    edition.sciezka_kategorii?.toLowerCase().includes(lowercasedSearch)
                )
            );
        }
    }, [search, editions]);

    // if (!editions) return <p>Ładowanie danych...</p>;

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Lista książek</h1>
            <input
                type="text"
                placeholder="Szukaj po tytule, autorze lub kategorii..."
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                className="block w-full p-2 border mb-2"
            />
            <ul>
                {filteredEditions.map((edition) => (
                    <li key={edition.id_wydania} className="border p-4 mb-2 hover:bg-gray-100">
                        <Link to={`/wydania/${edition.id_wydania}`}>
                            <div className="w-full flex items-start justify-center">
                                <img
                                    src={`${config.API_BASE_URL}/${edition.sciezka_do_okladki}`}
                                    alt="Okładka"
                                    className="w-36 h-auto mr-4"
                                />
                                <div>
                                    <h2 className="font-bold">{edition.tytul_ksiazki}</h2>
                                    <p>Autorzy: {edition.autorzy}</p>
                                    <p>Średnia ocen tytułu: {edition.srednia_ocen || 'Brak ocen'}</p>
                                    <p>Wydawnictwo: {edition.wydawnictwo || 'Brak'}</p>
                                    <p>Rok: {edition.rok_wydania}</p>
                                    <p>Język: {edition.jezyk}</p>
                                    <p>Liczba stron: {edition.liczba_stron}</p>
                                    <p>Kategoria: {edition.sciezka_kategorii}</p>
                                </div>
                            </div>
                        </Link>
                    </li>
                ))}
            </ul>
        </div>
    );
};
