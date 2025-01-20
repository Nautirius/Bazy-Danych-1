import { useEffect, useState } from "react";
import axios from 'axios';
import config from '../../config';

export const ReadersRanking = () => {
    const [readers, setReaders] = useState([]);
    const [rankingType, setRankingType] = useState('rentals');
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchReaders = async () => {
            setLoading(true);
            try {
                const endpoint =
                    rankingType === 'rentals'
                        ? `${config.API_BASE_URL}/readers/ranking/rentals`
                        : `${config.API_BASE_URL}/readers/ranking/penalties`;
                const response = await axios.get(endpoint);
                setReaders(response.data);
            } catch (error) {
                console.error('Error fetching readers ranking:', error.response?.data || error.message);
            } finally {
                setLoading(false);
            }
        };
        fetchReaders();
    }, [rankingType]);

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Ranking Czytelników</h1>
            <div className="mb-4">
                <label htmlFor="rankingType" className="block font-semibold mb-2">
                    Sortuj według:
                </label>
                <select
                    id="rankingType"
                    value={rankingType}
                    onChange={(e) => setRankingType(e.target.value)}
                    className="block w-full p-2 border"
                >
                    <option value="rentals">Ranking według liczby wypożyczeń</option>
                    <option value="penalties">Ranking według sumy kar</option>
                </select>
            </div>
            {loading ? (
                <p>Ładowanie rankingu...</p>
            ) : (
                <ul>
                    {readers.map((reader, index) => (
                        <li
                            key={reader.id_czytelnika}
                            className="border p-4 mb-2 hover:bg-gray-100 flex justify-center items-start"
                        >
                            <div>
                                <h2 className="font-bold text-lg">{index + 1}. {reader.imie} {reader.nazwisko}</h2>
                                <p>Adres: {reader.ulica} {reader.numer_domu}, {reader.kod_pocztowy} {reader.miejscowosc}</p>
                                <p>Email: {reader.email}</p>
                                <p>Telefon: {reader.telefon}</p>
                                {rankingType === 'rentals' && (
                                    <p className="font-semibold">
                                        Liczba wypożyczeń: {reader.liczba_wypozyczen}
                                    </p>
                                )}
                                {rankingType === 'penalties' && (
                                    <p className="font-semibold">
                                        Suma kar: {reader.suma_kar} zł
                                    </p>
                                )}
                            </div>
                        </li>
                    ))}
                </ul>
            )}
        </div>
    );
};
