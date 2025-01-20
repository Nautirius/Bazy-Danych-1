import React, { useState, useEffect } from 'react';
import axios from 'axios';
import config from '../../config';

const Rentals = () => {
    const [rentals, setRentals] = useState([]);
    const [readers, setReaders] = useState([]);
    const [copies, setCopies] = useState([]);
    const [formData, setFormData] = useState({
        id_czytelnika: '',
        id_egzemplarza: '',
        status: '',
        data_wypozyczenia: '',
        data_zwrotu: '',
    });
    const [editingRental, setEditingRental] = useState(null);

    useEffect(() => {
        fetchRentals();
        fetchReaders();
        fetchCopies();
    }, []);

    const fetchRentals = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/rentals`);
            setRentals(response.data);
        } catch (error) {
            alert('Błąd podczas pobierania wypożyczeń: ' + error.message);
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

    const fetchCopies = async () => {
        try {
            // const response = await axios.get(`${config.API_BASE_URL}/copies/available`);
            const response = await axios.get(`${config.API_BASE_URL}/copies`);
            setCopies(response.data);
        } catch (error) {
            alert('Błąd podczas pobierania egzemplarzy: ' + error.message);
        }
    };

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData({ ...formData, [name]: value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();

        try {
            if (editingRental) {
                await axios.put(`${config.API_BASE_URL}/rentals/${editingRental.id_wypozyczenia}`, formData);
            } else {
                await axios.post(`${config.API_BASE_URL}/rentals`, formData);
            }
            fetchRentals();
            resetForm();
        } catch (error) {
            alert('Błąd podczas zapisywania wypożyczenia: ' + error.message);
        }
    };

    const resetForm = () => {
        setFormData({
            id_czytelnika: '',
            id_egzemplarza: '',
            status: '',
            data_wypozyczenia: '',
            data_zwrotu: '',
        });
        setEditingRental(null);
    };

    const startEditing = (rental) => {
        setEditingRental(rental);
        setFormData({
            id_czytelnika: rental.id_czytelnika,
            id_egzemplarza: rental.id_egzemplarza,
            status: rental.status,
            data_wypozyczenia: rental.data_wypozyczenia,
            data_zwrotu: rental.data_zwrotu,
        });
    };

    const deleteRental = async (id) => {
        try {
            await axios.delete(`${config.API_BASE_URL}/rentals/${id}`);
            fetchRentals();
        } catch (error) {
            alert('Błąd podczas usuwania wypożyczenia: ' + error.message);
        }
    };

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Zarządzanie wypożyczeniami</h1>

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
                    name="id_egzemplarza"
                    value={formData.id_egzemplarza}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                >
                    <option value="">Wybierz egzemplarz</option>
                    {copies.map((copy) => (
                        <option key={copy.id_egzemplarza} value={copy.id_egzemplarza}>
                            {copy.tytul_ksiazki} ({copy.autorzy}, {copy.wydawnictwo} {copy.rok_wydania}, id: {copy.id_egzemplarza})
                        </option>
                    ))}
                </select>
                <select
                    name="status"
                    value={formData.status}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                >
                    <option value="">Wybierz status</option>
                    <option value="aktywne">Aktywne</option>
                    <option value="oddane">Oddane</option>
                    <option value="zakonczone">Zakończone</option>
                </select>
                <input
                    type="date"
                    name="data_wypozyczenia"
                    value={formData.data_wypozyczenia}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <input
                    type="date"
                    name="data_zwrotu"
                    value={formData.data_zwrotu}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded mr-2">
                    {editingRental ? 'Zapisz zmiany' : 'Dodaj wypożyczenie'}
                </button>
                {editingRental && (
                    <button onClick={resetForm} className="bg-gray-500 text-white px-4 py-2 rounded">
                        Anuluj
                    </button>
                )}
            </form>

            <ul>
                {rentals.map((rental) => (
                    <li key={rental.id_wypozyczenia} className="border p-4 mb-2">
                        <h3 className="font-bold">{rental.tytul_ksiazki}({rental.wydawnictwo} {rental.rok_wydania} id: {rental.id_egzemplarza})</h3>
                        <p>Wypożyczający: {rental.czytelnik_imie} {rental.czytelnik_nazwisko} ({rental.czytelnik_pesel})</p>
                        <p>Data wypożyczenia: {rental.data_wypozyczenia}</p>
                        <p>Data zwrotu: {rental.data_zwrotu || 'Brak'}</p>
                        <p>Status: {rental.status}</p>
                        <p>Kara: {rental.kara} zł</p>
                        <div className="mt-2">
                            <button
                                onClick={() => startEditing(rental)}
                                className="bg-yellow-500 text-white px-4 py-2 rounded mr-2"
                            >
                                Edytuj
                            </button>
                            <button
                                onClick={() => deleteRental(rental.id_wypozyczenia)}
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

export default Rentals;
