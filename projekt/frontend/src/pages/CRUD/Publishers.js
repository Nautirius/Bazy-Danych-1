import React, { useState, useEffect } from 'react';
import axios from 'axios';
import config from '../../config';

const Publishers = () => {
    const [publishers, setPublishers] = useState([]);
    const [formData, setFormData] = useState({
        nazwa: '',
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
        fetchPublishers();
    }, []);

    const fetchPublishers = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/publishers`);
            setPublishers(response.data);
        } catch (error) {
            console.error('Błąd podczas pobierania wydawnictw:', error);
            alert('Błąd podczas pobierania wydawnictw. Spróbuj ponownie później.');
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
                await axios.put(`${config.API_BASE_URL}/publishers/${editingId}`, formData);
            } else {
                await axios.post(`${config.API_BASE_URL}/publishers`, formData);
            }
            resetForm();
            fetchPublishers();
        } catch (error) {
            console.error('Błąd podczas zapisywania wydawnictwa:', error);
            alert('Błąd podczas zapisywania wydawnictwa. Upewnij się, że dane są poprawne i spróbuj ponownie.');
        }
    };

    const handleEdit = (publisher) => {
        setEditingId(publisher.id_wydawnictwa);
        setFormData({
            nazwa: publisher.nazwa,
            kraj: publisher.kraj,
            miejscowosc: publisher.miejscowosc,
            ulica: publisher.ulica,
            numer_domu: publisher.numer_domu,
            kod_pocztowy: publisher.kod_pocztowy,
            telefon: publisher.telefon,
            email: publisher.email,
        });
    };

    const handleDelete = async (id) => {
        try {
            await axios.delete(`${config.API_BASE_URL}/publishers/${id}`);
            fetchPublishers();
        } catch (error) {
            console.error('Błąd podczas usuwania wydawnictwa:', error);
            alert('Błąd podczas usuwania wydawnictwa. Spróbuj ponownie później.');
        }
    };

    const cancelEditing = () => {
        resetForm();
    };

    const resetForm = () => {
        setEditingId(null);
        setFormData({
            nazwa: '',
            kraj: '',
            miejscowosc: '',
            ulica: '',
            numer_domu: '',
            kod_pocztowy: '',
            telefon: '',
            email: '',
        });
    };

    // if (!publishers) return <p>Ładowanie danych...</p>;

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Wydawnictwa</h1>
            <form onSubmit={handleSubmit} className="mb-6">
                <input
                    type="text"
                    name="nazwa"
                    placeholder="Nazwa"
                    value={formData.nazwa}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <input
                    type="text"
                    name="kraj"
                    placeholder="Kraj"
                    value={formData.kraj}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <input
                    type="text"
                    name="miejscowosc"
                    placeholder="Miejscowość"
                    value={formData.miejscowosc}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <input
                    type="text"
                    name="ulica"
                    placeholder="Ulica"
                    value={formData.ulica}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <input
                    type="text"
                    name="numer_domu"
                    placeholder="Numer domu"
                    value={formData.numer_domu}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <input
                    type="text"
                    name="kod_pocztowy"
                    placeholder="Kod pocztowy"
                    value={formData.kod_pocztowy}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <input
                    type="text"
                    name="telefon"
                    placeholder="Telefon"
                    value={formData.telefon}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <input
                    type="email"
                    name="email"
                    placeholder="Email"
                    value={formData.email}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded mr-2">
                    {editingId ? 'Zaktualizuj' : 'Dodaj'}
                </button>
                {editingId && (
                    <button onClick={cancelEditing} type="button" className="bg-gray-500 text-white px-4 py-2 rounded">
                        Anuluj
                    </button>
                )}
            </form>
            <ul>
                {publishers.map((publisher) => (
                    <li key={publisher.id_wydawnictwa} className="border p-4 mb-2">
                        <h2 className="font-bold">{publisher.nazwa}</h2>
                        <p>{publisher.kraj}, {publisher.miejscowosc}</p>
                        <p>Ulica: {publisher.ulica} {publisher.numer_domu}, Kod: {publisher.kod_pocztowy}</p>
                        <p>Telefon: {publisher.telefon}, Email: {publisher.email}</p>
                        <button
                            onClick={() => handleEdit(publisher)}
                            className="bg-yellow-500 text-white px-4 py-2 rounded mr-2"
                        >
                            Edytuj
                        </button>
                        <button
                            onClick={() => handleDelete(publisher.id_wydawnictwa)}
                            className="bg-red-500 text-white px-4 py-2 rounded"
                        >
                            Usuń
                        </button>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default Publishers;
