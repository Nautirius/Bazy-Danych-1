import { useState, useEffect } from "react";
import { useContext } from "react";
import {Link} from "react-router-dom";
import { AuthContext } from "../../context/AuthContext";
import axios from "axios";
import config from "../../config";

export const UserPage = () => {
    const [rentals, setRentals] = useState([]);
    const [reservations, setReservations] = useState([]);
    const { user } = useContext(AuthContext);

    const fetchRentals = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/rentals/user/${user.id_czytelnika}`);
            setRentals(response.data);
        } catch (error) {
            alert("Błąd podczas pobierania wypożyczeń: " + error.message);
        }
    };

    const fetchReservations = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/reservations/user/${user.id_czytelnika}`);
            setReservations(response.data);
        } catch (error) {
            alert("Błąd podczas pobierania rezerwacji: " + error.message);
        }
    };

    const cancelReservation = async (id_rezerwacji) => {
        try {
            await axios.delete(`${config.API_BASE_URL}/reservations/${id_rezerwacji}`);
            setReservations((prev) => prev.filter((res) => res.id_rezerwacji !== id_rezerwacji));
        } catch (error) {
            alert("Błąd podczas anulowania rezerwacji: " + error.message);
        }
    };

    useEffect(() => {
        fetchRentals();
        fetchReservations();
    }, []);

    return (
        <div className="flex flex-col bg-white rounded-lg p-8">
            {/* Dane czytelnika */}
            <div className="mb-6">
                <h1 className="text-2xl font-bold mb-2">Profil użytkownika</h1>
                <p>
                    <strong>Imię:</strong> {user.imie}
                </p>
                <p>
                    <strong>Nazwisko:</strong> {user.nazwisko}
                </p>
                <p>
                    <strong>PESEL:</strong> {user.pesel}
                </p>
                <p>
                    <strong>Email:</strong> {user.email}
                </p>
            </div>

            {/* Lista wypożyczeń */}
            <div className="mb-6">
                <h2 className="text-xl font-bold mb-2">Wypożyczenia</h2>
                {rentals.length > 0 ? (
                    <>
                        <h2 className="text-lg font-bold mb-2">Aktywne</h2>
                        <ul className="space-y-4">
                            {rentals.map((rental) => {
                                if (rental.status === 'aktywne') return (
                                    <li
                                        key={rental.id_wypozyczenia}
                                        className="border p-4 rounded-lg bg-gray-50 hover:bg-gray-100"
                                    >
                                        <Link to={`/wydania/${rental.id_wydania}`}>
                                            <h3 className="font-semibold">{rental.tytul_ksiazki}</h3>
                                            <p>
                                                <strong>Autorzy:</strong> {rental.autorzy}
                                            </p>
                                            <p>
                                                <strong>Data wypożyczenia:</strong> {rental.data_wypozyczenia}
                                            </p>
                                            <p>
                                                <strong>Data zwrotu:</strong>{" "}
                                                {rental.data_zwrotu || "Brak"}
                                            </p>
                                            <p>Kara: {rental.kara} zł</p>
                                        </Link>
                                    </li>
                                )
                            })}
                        </ul>
                        <h2 className="text-lg font-bold mb-2">Oczekujące na rozliczenie</h2>
                        <ul className="space-y-4">
                            {rentals.map((rental) => {
                                if (rental.status === 'oddane') return (
                                    <li
                                        key={rental.id_wypozyczenia}
                                        className="border p-4 rounded-lg bg-gray-50 hover:bg-gray-100"
                                    >
                                        <Link to={`/wydania/${rental.id_wydania}`}>
                                            <h3 className="font-semibold">{rental.tytul_ksiazki}</h3>
                                            <p>
                                                <strong>Autorzy:</strong> {rental.autorzy}
                                            </p>
                                            <p>
                                                <strong>Data wypożyczenia:</strong> {rental.data_wypozyczenia}
                                            </p>
                                            <p>
                                                <strong>Data zwrotu:</strong>{" "}
                                                {rental.data_zwrotu || "Brak"}
                                            </p>
                                            <p>Kara: {rental.kara} zł</p>
                                        </Link>
                                    </li>
                                )
                            })}
                        </ul>
                        <h2 className="text-lg font-bold mb-2">Zakończone</h2>
                        <ul className="space-y-4">
                            {rentals.map((rental) => {
                                if (rental.status === 'zakonczone') return (
                                    <li
                                        key={rental.id_wypozyczenia}
                                        className="border p-4 rounded-lg bg-gray-50 hover:bg-gray-100"
                                    >
                                        <Link to={`/wydania/${rental.id_wydania}`}>
                                            <h3 className="font-semibold">{rental.tytul_ksiazki}</h3>
                                            <p>
                                                <strong>Autorzy:</strong> {rental.autorzy}
                                            </p>
                                            <p>
                                                <strong>Data wypożyczenia:</strong> {rental.data_wypozyczenia}
                                            </p>
                                            <p>
                                                <strong>Data zwrotu:</strong>{" "}
                                                {rental.data_zwrotu || "Brak"}
                                            </p>
                                            <p>Kara: {rental.kara} zł</p>
                                        </Link>
                                    </li>
                                )
                            })}
                        </ul>
                    </>
                ) : (
                    <p>Nie masz żadnych wypożyczeń.</p>
                )}
            </div>

            {/* Lista rezerwacji */}
            <div>
                <h2 className="text-xl font-bold mb-2">Rezerwacje</h2>
                {reservations.length > 0 ? (
                    <ul className="space-y-4">
                        {reservations.map((reservation) => (
                            <li
                                key={reservation.id_rezerwacji}
                                className="border p-4 rounded-lg bg-gray-50 hover:bg-gray-100 flex justify-center items-center"
                            >
                                <Link to={`/wydania/${reservation.id_wydania}`}>
                                    <h3 className="font-semibold">{reservation.tytul_ksiazki}</h3>
                                    <p>
                                        <strong>Autorzy:</strong> {reservation.autorzy}
                                    </p>
                                    <p>
                                        <strong>Data rezerwacji:</strong>{" "}
                                        {reservation.data_rezerwacji}
                                    </p>
                                    <button
                                        onClick={() => cancelReservation(reservation.id_rezerwacji)}
                                        className="bg-red-500 text-white px-4 py-2 mt-2 rounded-lg hover:bg-red-600"
                                    >
                                        Anuluj
                                    </button>
                                </Link>
                            </li>
                        ))}
                    </ul>
                ) : (
                    <p>Nie masz żadnych rezerwacji.</p>
                )}
            </div>
        </div>
    );
};
