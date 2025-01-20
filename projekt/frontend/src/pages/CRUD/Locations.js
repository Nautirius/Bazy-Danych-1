import React, { useState, useEffect } from 'react';
import axios from 'axios';
import config from '../../config';

export default function Locations() {
    const [locations, setLocations] = useState([]);
    const [formData, setFormData] = useState({
        numer_polki: '',
        opis: '',
    });
    const [editingId, setEditingId] = useState(null);

    useEffect(() => {
        fetchLocations();
    }, []);

    const fetchLocations = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/locations`);
            setLocations(response.data);
        } catch (error) {
            console.error('Błąd podczas pobierania lokalizacji:', error);
            alert('Błąd podczas pobierania lokalizacji. Spróbuj ponownie później.');
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
                await axios.put(`${config.API_BASE_URL}/locations/${editingId}`, formData);
            } else {
                await axios.post(`${config.API_BASE_URL}/locations`, formData);
            }
            setFormData({
                numer_polki: '',
                opis: '',
            });
            setEditingId(null);
            fetchLocations();
        } catch (error) {
            console.error('Błąd podczas zapisu lokalizacji:', error);
            alert('Błąd podczas zapisu lokalizacji. Sprawdź dane i spróbuj ponownie.');
        }
    };

    const handleEdit = (location) => {
        setEditingId(location.id_lokalizacji);
        setFormData({
            numer_polki: location.numer_polki || '',
            opis: location.opis || '',
        });
    };

    const handleCancelEdit = () => {
        setEditingId(null);
        setFormData({
            numer_polki: '',
            opis: '',
        });
    };

    const handleDelete = async (id) => {
        try {
            await axios.delete(`${config.API_BASE_URL}/locations/${id}`);
            fetchLocations();
        } catch (error) {
            console.error('Błąd podczas usuwania lokalizacji:', error);
            alert('Błąd podczas usuwania lokalizacji. Spróbuj ponownie później.');
        }
    };

    // if (!locations) return <p>Ładowanie danych...</p>;

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Lokalizacje</h1>
            <form onSubmit={handleSubmit} className="mb-6">
                <input
                    type="number"
                    name="numer_polki"
                    placeholder="Numer półki"
                    value={formData.numer_polki}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <textarea
                    name="opis"
                    placeholder="Opis"
                    value={formData.opis}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                ></textarea>
                <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded mr-2">
                    {editingId ? 'Zaktualizuj lokalizację' : 'Dodaj lokalizację'}
                </button>
                {editingId && (
                    <button onClick={handleCancelEdit} className="bg-gray-500 text-white px-4 py-2 rounded">
                        Anuluj
                    </button>
                )}
            </form>
            <ul>
                {locations.map((location) => (
                    <li key={location.id_lokalizacji} className="border p-4 mb-2">
                        <h2 className="font-bold">Numer półki: {location.numer_polki}</h2>
                        <p>Opis: {location.opis}</p>
                        <button
                            onClick={() => handleEdit(location)}
                            className="bg-yellow-500 text-white px-4 py-2 rounded mr-2"
                        >
                            Edytuj
                        </button>
                        <button
                            onClick={() => handleDelete(location.id_lokalizacji)}
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
