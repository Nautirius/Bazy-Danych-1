import React, { useState, useEffect } from 'react';
import axios from 'axios';
import config from '../../config';

const Reservations = () => {
    const [reservations, setReservations] = useState([]);
    const [readers, setReaders] = useState([]);
    const [editions, setEditions] = useState([]);
    const [formData, setFormData] = useState({
        id_czytelnika: '',
        id_wydania: '',
        // status: 'aktywne',
        data_rezerwacji: ''
    });
    const [editingReservation, setEditingReservation] = useState(null);

    useEffect(() => {
        fetchReservations();
        fetchReaders();
        fetchEditions();
    }, []);

    const fetchReservations = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/reservations`);
            setReservations(response.data);
        } catch (error) {
            alert('Błąd podczas pobierania rezerwacji: ' + error.message);
        }
    };

    const fetchReaders = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/readers`);
            setReaders(response.data);
        } catch (error) {
            alert('Błąd podczas pobierania czytelników: ' + error.message);
        }
    };

    const fetchEditions = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/editions`);
            setEditions(response.data);
        } catch (error) {
            alert('Błąd podczas pobierania wydań: ' + error.message);
        }
    };

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData({ ...formData, [name]: value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();

        try {
            if (editingReservation) {
                await axios.put(`${config.API_BASE_URL}/reservations/${editingReservation.id_rezerwacji}`, formData);
            } else {
                await axios.post(`${config.API_BASE_URL}/reservations`, formData);
            }
            fetchReservations();
            resetForm();
        } catch (error) {
            alert('Błąd podczas zapisywania rezerwacji: ' + error.message);
        }
    };

    const resetForm = () => {
        setFormData({
            id_czytelnika: '',
            id_wydania: '',
            // status: 'aktywne',
            data_rezerwacji: ''
        });
        setEditingReservation(null);
    };

    const startEditing = (reservation) => {
        setEditingReservation(reservation);
        setFormData({
            id_czytelnika: reservation.id_czytelnika,
            id_wydania: reservation.id_wydania,
            // status: reservation.status,
            data_rezerwacji: reservation.data_rezerwacji
        });
    };

    const deleteReservation = async (id) => {
        try {
            await axios.delete(`${config.API_BASE_URL}/reservations/${id}`);
            fetchReservations();
        } catch (error) {
            alert('Błąd podczas usuwania rezerwacji: ' + error.message);
        }
    };

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Zarządzanie rezerwacjami</h1>

            <form onSubmit={handleSubmit} className="mb-6">
                <select
                    name="id_czytelnika"
                    value={formData.id_czytelnika}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                >
                    <option value="">Wybierz czytelnika</option>
                    {readers.map((reader) => (
                        <option key={reader.id_czytelnika} value={reader.id_czytelnika}>
                            {reader.imie} {reader.nazwisko} ({reader.pesel})
                        </option>
                    ))}
                </select>
                <select
                    name="id_wydania"
                    value={formData.id_wydania}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                >
                    <option value="">Wybierz wydanie</option>
                    {editions.map((edition) => (
                        <option key={edition.id_wydania} value={edition.id_wydania}>
                            {edition.tytul_ksiazki} ({edition.autorzy}, {edition.wydawnictwo} {edition.rok_wydania})
                        </option>
                    ))}
                </select>
                <input
                    type="date"
                    name="data_rezerwacji"
                    value={formData.data_rezerwacji}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                {/*<select*/}
                {/*    name="status"*/}
                {/*    value={formData.status}*/}
                {/*    onChange={handleInputChange}*/}
                {/*    className="block w-full p-2 border mb-2"*/}
                {/*>*/}
                {/*    <option value="aktywne">Aktywne</option>*/}
                {/*    <option value="nieaktywne">Nieaktywne</option>*/}
                {/*    <option value="anulowane">Anulowane</option>*/}
                {/*</select>*/}
                <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded mr-2">
                    {editingReservation ? 'Zapisz zmiany' : 'Dodaj rezerwację'}
                </button>
                {editingReservation && (
                    <button onClick={resetForm} className="bg-gray-500 text-white px-4 py-2 rounded">
                        Anuluj
                    </button>
                )}
            </form>

            <ul>
                {reservations.map((reservation) => (
                    <li key={reservation.id_rezerwacji} className="border p-4 mb-2">
                    <h3 className="font-bold">{reservation.tytul_ksiazki} ({reservation.wydawnictwo} {reservation.rok_wydania})</h3>
                        <p>Rezerwujący: {reservation.czytelnik_imie} {reservation.czytelnik_nazwisko} ({reservation.czytelnik_pesel})</p>
                        <p>Data rezerwacji: {reservation.data_rezerwacji}</p>
                        {/*<p>Status: {reservation.status}</p>*/}
                        <div className="mt-2">
                            <button
                                onClick={() => startEditing(reservation)}
                                className="bg-yellow-500 text-white px-4 py-2 rounded mr-2"
                            >
                                Edytuj
                            </button>
                            <button
                                onClick={() => deleteReservation(reservation.id_rezerwacji)}
                                className="bg-red-500 text-white px-4 py-2 rounded"
                            >
                                Usuń
                            </button>
                        </div>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default Reservations;
