import { Link } from "react-router-dom";
import { useEffect, useState } from "react";
import axios from 'axios';
import config from '../../config';

export const BooksRanking = () => {
    const [rankings, setRankings] = useState([]);
    const [rankingType, setRankingType] = useState('reviews');
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        const fetchRankings = async () => {
            setLoading(true);
            try {
                const endpoint =
                    rankingType === 'reviews'
                        ? `${config.API_BASE_URL}/editions/ranking/reviews`
                        : `${config.API_BASE_URL}/editions/ranking/rentals`;

                const response = await axios.get(endpoint);
                setRankings(response.data);
            } catch (error) {
                console.error('Error fetching rankings:', error.response?.data || error.message);
            } finally {
                setLoading(false);
            }
        };

        fetchRankings();
    }, [rankingType]);

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Ranking wydań książek</h1>
            <label className="block mb-4">
                <span className="font-semibold">Wybierz rodzaj rankingu:</span>
                <select
                    value={rankingType}
                    onChange={(e) => setRankingType(e.target.value)}
                    className="block w-full p-2 border mt-1"
                >
                    <option value="reviews">Ranking według ocen</option>
                    <option value="rentals">Ranking według liczby wypożyczeń</option>
                </select>
            </label>
            {loading ? (
                <p>Ładowanie danych...</p>
            ) : (
                <ul>
                    {rankings.map((edition, index) => (
                        <li
                            key={edition.id_wydania}
                            className="border p-4 mb-2 hover:bg-gray-100"
                        >
                            <Link to={`/wydania/${edition.id_wydania}`}>
                                <div className="w-full flex items-start justify-center">
                                    <img
                                        src={`${config.API_BASE_URL}/${edition.sciezka_do_okladki}`}
                                        alt="Okładka"
                                        className="w-36 h-auto mr-4"
                                    />
                                    <div>
                                        <h2 className="font-bold">
                                            {index + 1}. {edition.tytul_ksiazki}
                                        </h2>
                                        <p>Autorzy: {edition.autorzy}</p>
                                        {rankingType === 'reviews' ? (
                                            <p>
                                                Średnia ocen tytułu:{' '}
                                                {edition.srednia_ocen
                                                    ? parseFloat(edition.srednia_ocen).toFixed(2)
                                                    : 'Brak ocen'}
                                            </p>
                                        ) : (
                                            <p>
                                                Liczba wypożyczeń:{' '}
                                                {edition.liczba_wypozyczen || '0'}
                                            </p>
                                        )}
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
            )}
        </div>
    );
};
