import { useState, useEffect } from "react";
import { useParams, Link } from "react-router-dom";
import { useContext } from "react";
import { AuthContext } from "../../context/AuthContext";
import axios from "axios";
import config from "../../config";

export const EditionDetails = () => {
    const { id_wydania } = useParams();
    const [edition, setEdition] = useState(null);
    const [availableNum, setAvailableNum] = useState(0);
    const [userRating, setUserRating] = useState(null);
    const [rating, setRating] = useState(0);
    const [comment, setComment] = useState("");
    const [reviews, setReviews] = useState([]);
    const { user } = useContext(AuthContext);

    const fetchEdition = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/editions/${id_wydania}`);
            setEdition(response.data);
        } catch (error) {
            console.error('Error fetching edition details:', error.response?.data || error.message);
        }
    };

    useEffect(() => {
        fetchEdition();
    }, [id_wydania]);

    useEffect(() => {
        const fetchAvailability = async () => {
            try {
                const response = await axios.get(`${config.API_BASE_URL}/editions/check-availability/${id_wydania}`);
                setAvailableNum(response.data.sprawdz_dostepne_egzemplarze);
            } catch (error) {
                console.error('Error checking availability:', error.response?.data || error.message);
            }
        };
        fetchAvailability();
    }, []);

    useEffect(() => {
        if (user && edition) {
            const fetchUserRating = async () => {
                try {
                    const response = await axios.get(`${config.API_BASE_URL}/user-actions/rating`, {
                        params: { id_ksiazki: edition.id_ksiazki, id_czytelnika: user.id_czytelnika },
                    });
                    if (response.data) {
                        setUserRating(response.data);
                        setRating(response.data.ocena);
                        setComment(response.data.komentarz);
                    }
                } catch (error) {
                    console.error("Error fetching user rating:", error.response?.data || error.message);
                }
            };
            fetchUserRating();
        }
    }, [user, id_wydania, edition]);

    useEffect(() => {

        if (edition) {
            fetchReviews();
        }
    }, [edition]);

    const fetchReviews = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/books/reviews/${edition?.id_ksiazki}`);
            setReviews(response.data);
        } catch (error) {
            console.error("Error fetching reviews:", error.response?.data || error.message);
        }
    };

    const handleRent = async () => {
        if (!user || availableNum === 0) return;

        try {
            await axios.post(`${config.API_BASE_URL}/user-actions/rent`, {
                id_wydania,
                id_czytelnika: user.id_czytelnika,
            });

            setAvailableNum((prev) => prev - 1);
            alert("Wypożyczenie zakończone sukcesem!");
        } catch (error) {
            console.error("Błąd podczas wypożyczania:", error.response?.data || error.message);
            alert("Nie udało się wypożyczyć egzemplarza.");
        }
    };

    const handleReserve = async () => {
        if (!user) return;

        try {
            await axios.post(`${config.API_BASE_URL}/user-actions/reserve`, {
                id_wydania,
                id_czytelnika: user.id_czytelnika,
            });

            alert("Rezerwacja zakończona sukcesem!");
        } catch (error) {
            console.error("Błąd podczas rezerwacji:", error.response?.data || error.message);
            alert("Nie udało się zarezerwować wydania.");
        }
    };

    const handleRatingSubmit = async () => {
        try {
            await axios.post(`${config.API_BASE_URL}/user-actions/rate`, {
                id_ksiazki: edition.id_ksiazki,
                id_czytelnika: user.id_czytelnika,
                ocena: rating,
                komentarz: comment,
            });
            fetchReviews();
            fetchEdition();
            alert("Ocena została zapisana!");
        } catch (error) {
            console.error("Error submitting rating:", error.response?.data || error.message);
            alert("Nie udało się zapisać oceny.");
        }
    };

    const handleRatingDelete = async () => {
        try {
            await axios.delete(`${config.API_BASE_URL}/user-actions/rate`, {
                data: { id_ksiazki: edition.id_ksiazki, id_czytelnika: user.id_czytelnika },
            });
            setUserRating(null);
            setRating(0);
            setComment("");
            fetchReviews();
            fetchEdition();
            alert("Ocena została usunięta!");
        } catch (error) {
            console.error("Error deleting rating:", error.response?.data || error.message);
            alert("Nie udało się usunąć oceny.");
        }
    };

    if (!edition) return <p className="mt-4">Ładowanie danych...</p>;

    return (
        <div className="flex flex-col bg-white rounded-lg p-8">
            <div className="flex w-full">
                {/* Obrazek okładki */}
                <img
                    src={`${config.API_BASE_URL}/${edition.sciezka_do_okladki}`}
                    alt="Okładka"
                    className="w-48 h-auto rounded-md shadow-md mr-8 object-contain"
                />

                {/* Sekcja szczegółów książki */}
                <div className="flex-grow flex flex-col">
                    <div className="flex justify-between">
                        {/* Informacje po lewej stronie */}
                        <div className="flex flex-col">
                            <h1 className="text-3xl font-bold text-gray-800 mb-4">{edition.tytul_ksiazki}</h1>
                            <h2 className="text-xl text-gray-700 mb-2">
                                <span className="font-semibold">Autorzy:</span> {edition.autorzy}
                            </h2>
                            <p className="text-lg text-gray-600">
                                <span
                                    className="font-semibold">Średnia ocen tytułu:</span> {edition.srednia_ocen || 'Brak ocen'}
                            </p>
                            <p className="text-lg text-gray-600">
                                <span className="font-semibold">Wydawnictwo:</span> {edition.wydawnictwo || 'Brak'}
                            </p>
                            <p className="text-lg text-gray-600">
                                <span className="font-semibold">Rok wydania:</span> {edition.rok_wydania}
                            </p>
                            <p className="text-lg text-gray-600">
                                <span className="font-semibold">Język:</span> {edition.jezyk}
                            </p>
                            <p className="text-lg text-gray-600">
                                <span className="font-semibold">Liczba stron:</span> {edition.liczba_stron}
                            </p>
                            <p className="text-lg text-gray-600">
                                <span className="font-semibold">Kategoria:</span> {edition.sciezka_kategorii}
                            </p>
                            <p className="text-lg text-gray-600">
                                <span className="font-semibold">Dostępność:</span> {availableNum}
                            </p>
                        </div>

                        {/* Opis po prawej stronie */}
                        <div className="w-1/2 pl-8">
                            <h3 className="text-xl font-semibold text-gray-800 mb-4">Opis:</h3>
                            <p className="text-lg text-gray-700 leading-relaxed">
                                {edition.opis || 'Brak opisu.'}
                            </p>
                        </div>
                    </div>
                    <div className="mt-10">
                        {user ?
                            availableNum > 0 ?
                                <button onClick={handleRent}
                                        className="px-4 py-2 rounded bg-blue-500 text-white hover:bg-blue-600">
                                    Wypożycz
                                </button>
                                :
                                <button onClick={handleReserve}
                                        className="px-4 py-2 rounded bg-blue-500 text-white hover:bg-blue-600">
                                    Zarezerwuj
                                </button>
                            :
                            <Link to="/auth" className="px-4 py-2 rounded bg-blue-500 text-white hover:bg-blue-600">
                                Zaloguj się by wypożyczyć książkę lub dokonać rezerwacji
                            </Link>
                        }
                    </div>
                </div>
            </div>
            <div className="mt-10">
                {/* Wystawianie oceny */}
                {user ? (
                    <div className="mt-6">
                        <h3 className="text-xl font-semibold mb-2">Twoja ocena:</h3>
                        <div>
                            <label className="mr-2">Ocena:</label>
                            <select value={rating} onChange={(e) => setRating(Number(e.target.value))}
                                    className="border rounded p-2 mr-2">
                                <option value="0">Wybierz...</option>
                                {[1, 2, 3, 4, 5].map((value) => (
                                    <option key={value} value={value}>
                                        {value}
                                    </option>
                                ))}
                            </select>
                        </div>
                        <div className="mt-2">
                            <label className="mr-2">Komentarz:</label>
                            <textarea
                                value={comment}
                                onChange={(e) => setComment(e.target.value)}
                                className="border rounded px-2 py-1 w-full mt-5 mb-2"
                            />
                        </div>
                        <button
                            onClick={handleRatingSubmit}
                            className="mt-2 mx-2 px-4 py-2 rounded bg-green-500 text-white hover:bg-green-600"
                        >
                            Zapisz
                        </button>
                        {userRating && (
                            <button
                                onClick={handleRatingDelete}
                                className="mt-2 mx-2 px-4 py-2 rounded bg-red-500 text-white hover:bg-red-600"
                            >
                                Usuń ocenę
                            </button>
                        )}
                    </div>
                ) : (
                    <Link to="/auth" className="px-4 py-2 rounded bg-blue-500 text-white hover:bg-blue-600">
                        Zaloguj się, aby ocenić
                    </Link>
                )}
            </div>
            <div className="mt-10">
                <h3 className="text-xl font-semibold mb-4">Opinie czytelników:</h3>
                {reviews.length > 0 ? (
                    <ul className="space-y-4">
                        {reviews.map((review) => (
                            <li
                                key={review.id_opinii}
                                className="border p-4 rounded-lg shadow-md hover:bg-gray-50"
                            >
                                <h4 className="font-bold text-lg">
                                    {review.imie} {review.nazwisko}
                                </h4>
                                <p className="text-gray-600">Ocena: {review.ocena}/5</p>
                                <p className="text-gray-800 mt-2">{review.komentarz || "Brak komentarza."}</p>
                                <p className="text-gray-800">Data dodania: {review.data_dodania}/5</p>
                            </li>
                        ))}
                    </ul>
                ) : (
                    <p className="text-gray-600">Brak opinii dla tej książki.</p>
                )}
            </div>
        </div>
    );
};
