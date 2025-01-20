import React, { useState, useEffect } from 'react';
import axios from 'axios';
import config from '../../config';

export default function Readers() {
    const [readers, setReaders] = useState([]);
    const [formData, setFormData] = useState({
        imie: '',
        nazwisko: '',
        data_urodzin: '',
        pesel: '',
        kraj: '',
        miejscowosc: '',
        ulica: '',
        numer_domu: '',
        kod_pocztowy: '',
        telefon: '',
        email: '',
    });
    const [editingId, setEditingId] = useState(null);

    useEffect(() => {
        fetchReaders();
    }, []);

    const fetchReaders = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/readers`);
            setReaders(response.data);
        } catch (error) {
            console.error('Błąd podczas pobierania czytelników:', error);
            alert('Błąd podczas pobierania czytelników. Spróbuj ponownie później.');
        }
    };

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData({ ...formData, [name]: value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            if (editingId) {
                await axios.put(`${config.API_BASE_URL}/readers/${editingId}`, formData);
            } else {
                await axios.post(`${config.API_BASE_URL}/readers`, formData);
            }
            setFormData({
                imie: '',
                nazwisko: '',
                data_urodzin: '',
                pesel: '',
                kraj: '',
                miejscowosc: '',
                ulica: '',
                numer_domu: '',
                kod_pocztowy: '',
                telefon: '',
                email: '',
            });
            setEditingId(null);
            fetchReaders();
        } catch (error) {
            console.error('Błąd podczas zapisu czytelnika:', error);
            alert(`Błąd podczas zapisu czytelnika. Szczegóły: ${error.response.data}`);
        }
    };

    const handleEdit = (reader) => {
        setEditingId(reader.id_czytelnika);
        setFormData({
            imie: reader.imie || '',
            nazwisko: reader.nazwisko || '',
            data_urodzin: reader.data_urodzin || '',
            pesel: reader.pesel || '',
            kraj: reader.kraj || '',
            miejscowosc: reader.miejscowosc || '',
            ulica: reader.ulica || '',
            numer_domu: reader.numer_domu || '',
            kod_pocztowy: reader.kod_pocztowy || '',
            telefon: reader.telefon || '',
            email: reader.email || '',
        });
    };

    const handleCancelEdit = () => {
        setEditingId(null);
        setFormData({
            imie: '',
            nazwisko: '',
            data_urodzin: '',
            pesel: '',
            kraj: '',
            miejscowosc: '',
            ulica: '',
            numer_domu: '',
            kod_pocztowy: '',
            telefon: '',
            email: '',
        });
    };

    const handleDelete = async (id) => {
        try {
            await axios.delete(`${config.API_BASE_URL}/readers/${id}`);
            fetchReaders();
        } catch (error) {
            console.error('Błąd podczas usuwania czytelnika:', error);
            alert('Błąd podczas usuwania czytelnika. Spróbuj ponownie później.');
        }
    };

    // if (!readers) return <p>Ładowanie danych...</p>;

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Czytelnicy</h1>
            <form onSubmit={handleSubmit} className="mb-6">
                {Object.keys(formData).map((key) => (
                    <input
                        key={key}
                        type={key === 'data_urodzin' ? 'date' : 'text'}
                        name={key}
                        placeholder={key}
                        value={formData[key]}
                        onChange={handleInputChange}
                        className="block w-full p-2 border mb-2"
                    />
                ))}
                <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded mr-2">
                    {editingId ? 'Zaktualizuj czytelnika' : 'Dodaj czytelnika'}
                </button>
                {editingId && (
                    <button onClick={handleCancelEdit} className="bg-gray-500 text-white px-4 py-2 rounded">
                        Anuluj
                    </button>
                )}
            </form>
            <ul>
                {readers.map((reader) => (
                    <li key={reader.id_czytelnika} className="border p-4 mb-2">
                        <h2 className="font-bold">
                            {reader.imie} {reader.nazwisko}
                        </h2>
                        <p>PESEL: {reader.pesel}</p>
                        <p>Email: {reader.email}</p>
                        <button
                            onClick={() => handleEdit(reader)}
                            className="bg-yellow-500 text-white px-4 py-2 rounded mr-2"
                        >
                            Edytuj
                        </button>
                        <button
                            onClick={() => handleDelete(reader.id_czytelnika)}
                            className="bg-red-500 text-white px-4 py-2 rounded"
                        >
                            Usuń
                        </button>
                    </li>
                ))}
            </ul>
        </div>
    );
}
