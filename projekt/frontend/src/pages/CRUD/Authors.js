import React, { useState, useEffect } from 'react';
import axios from 'axios';
import config from '../../config';

export default function Authors() {
    const [authors, setAuthors] = useState([]);
    const [formData, setFormData] = useState({
        imie: '',
        nazwisko: '',
        pseudonim: '',
        rok_urodzenia: '',
        kraj_pochodzenia: '',
        notka_biograficzna: '',
    });
    const [editingId, setEditingId] = useState(null);

    useEffect(() => {
        fetchAuthors();
    }, []);

    const fetchAuthors = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/authors`);
            setAuthors(response.data);
        } catch (error) {
            console.error('Błąd podczas pobierania autorów:', error);
            alert('Błąd podczas pobierania autorów. Spróbuj ponownie później.');
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
                await axios.put(`${config.API_BASE_URL}/authors/${editingId}`, formData);
            } else {
                await axios.post(`${config.API_BASE_URL}/authors`, formData);
            }
            setFormData({
                imie: '',
                nazwisko: '',
                pseudonim: '',
                rok_urodzenia: '',
                kraj_pochodzenia: '',
                notka_biograficzna: '',
            });
            setEditingId(null);
            fetchAuthors();
        } catch (error) {
            console.error('Błąd podczas zapisu autora:', error);
            alert('Błąd podczas zapisu autora. Sprawdź dane i spróbuj ponownie.');
        }
    };

    const handleEdit = (author) => {
        setEditingId(author.id_autora);
        setFormData({
            imie: author.imie || '',
            nazwisko: author.nazwisko || '',
            pseudonim: author.pseudonim || '',
            rok_urodzenia: author.rok_urodzenia || '',
            kraj_pochodzenia: author.kraj_pochodzenia || '',
            notka_biograficzna: author.notka_biograficzna || '',
        });
    };

    const handleCancelEdit = () => {
        setEditingId(null);
        setFormData({
            imie: '',
            nazwisko: '',
            pseudonim: '',
            rok_urodzenia: '',
            kraj_pochodzenia: '',
            notka_biograficzna: '',
        });
    };

    const handleDelete = async (id) => {
        try {
            await axios.delete(`${config.API_BASE_URL}/authors/${id}`);
            fetchAuthors();
        } catch (error) {
            console.error('Błąd podczas usuwania autora:', error);
            alert('Błąd podczas usuwania autora. Spróbuj ponownie później.');
        }
    };

    // if (!authors) return <p>Ładowanie danych...</p>;

    return (

        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Autorzy</h1>
            <form onSubmit={handleSubmit} className="mb-6">
                <input
                    type="text"
                    name="imie"
                    placeholder="Imię"
                    value={formData.imie}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <input
                    type="text"
                    name="nazwisko"
                    placeholder="Nazwisko"
                    value={formData.nazwisko}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <input
                    type="text"
                    name="pseudonim"
                    placeholder="Pseudonim"
                    value={formData.pseudonim}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <input
                    type="number"
                    name="rok_urodzenia"
                    placeholder="Rok urodzenia"
                    value={formData.rok_urodzenia}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <input
                    type="text"
                    name="kraj_pochodzenia"
                    placeholder="Kraj pochodzenia"
                    value={formData.kraj_pochodzenia}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <textarea
                    name="notka_biograficzna"
                    placeholder="Notka biograficzna"
                    value={formData.notka_biograficzna}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                ></textarea>
                <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded mr-2">
                    {editingId ? 'Zaktualizuj autora' : 'Dodaj autora'}
                </button>
                {editingId && (
                    <button onClick={handleCancelEdit} className="bg-gray-500 text-white px-4 py-2 rounded">
                        Anuluj
                    </button>
                )}
            </form>
            <ul>
                {authors.map((author) => (
                    <li key={author.id_autora} className="border p-4 mb-2">
                        <h2 className="font-bold">
                            {author.imie || ''} {author.nazwisko || ''}{' '}
                            {author.pseudonim ? `(${author.pseudonim})` : ''}
                        </h2>
                        <p>Kraj: {author.kraj_pochodzenia}</p>
                        <p>Rok urodzenia: {author.rok_urodzenia}</p>
                        <p>Notka: {author.notka_biograficzna}</p>
                        <button
                            onClick={() => handleEdit(author)}
                            className="bg-yellow-500 text-white px-4 py-2 rounded mr-2"
                        >
                            Edytuj
                        </button>
                        <button
                            onClick={() => handleDelete(author.id_autora)}
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
