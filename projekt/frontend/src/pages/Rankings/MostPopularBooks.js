import { useState, useEffect } from "react";
import axios from "axios";
import config from "../../config";

export const MostPopularBooks = () => {
    const [books, setBooks] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchPopularBooks = async () => {
            try {
                const response = await axios.get(`${config.API_BASE_URL}/books/ranking/most-popular`);
                setBooks(response.data);
                setLoading(false);
            } catch (err) {
                setError(err.response?.data || err.message);
                setLoading(false);
            }
        };
        fetchPopularBooks();
    }, []);

    if (loading) {
        return <p className="text-center mt-10">Ładowanie danych...</p>;
    }

    return (
        <div className="container mx-auto my-10 p-6 bg-white rounded-lg shadow-lg">
            <h1 className="text-3xl font-bold text-gray-800 text-center mb-6">
                Najbardziej Popularne Książki
            </h1>
            <table className="w-full border-collapse border border-gray-300">
                <thead>
                <tr className="bg-gray-100">
                    <th className="border border-gray-300 px-4 py-2">#</th>
                    <th className="border border-gray-300 px-4 py-2">Tytuł</th>
                    <th className="border border-gray-300 px-4 py-2">Liczba Wypożyczeń</th>
                    <th className="border border-gray-300 px-4 py-2">Średnia Ocena</th>
                </tr>
                </thead>
                <tbody>
                {books.map((book, index) => (
                    <tr key={book.id_ksiazki} className="hover:bg-gray-50">
                        <td className="border border-gray-300 px-4 py-2 text-center">{index + 1}</td>
                        <td className="border border-gray-300 px-4 py-2">{book.tytul}</td>
                        <td className="border border-gray-300 px-4 py-2 text-center">{book.liczba_wypozyczen}</td>
                        <td className="border border-gray-300 px-4 py-2 text-center">{book.srednia_ocen}</td>
                    </tr>
                ))}
                </tbody>
            </table>
        </div>
    );
};
