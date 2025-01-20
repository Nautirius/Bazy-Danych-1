import React, { useState, useEffect } from 'react';
import axios from 'axios';
import config from '../../config';

const Editions = () => {
    const [editions, setEditions] = useState([]);
    const [books, setBooks] = useState([]);
    const [publishers, setPublishers] = useState([]);
    const [formData, setFormData] = useState({
        id_ksiazki: '',
        id_wydawnictwa: '',
        rok_wydania: '',
        jezyk: '',
        liczba_stron: '',
        okladka: null,
    });
    const [editingEdition, setEditingEdition] = useState(null);

    useEffect(() => {
        fetchEditions();
        fetchBooks();
        fetchPublishers();
    }, []);

    const fetchEditions = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/editions`);
            setEditions(response.data);
        } catch (error) {
            alert('Błąd podczas pobierania wydań: ' + error.message);
        }
    };

    const fetchBooks = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/books`);
            setBooks(response.data);
        } catch (error) {
            alert('Błąd podczas pobierania książek: ' + error.message);
        }
    };

    const fetchPublishers = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/publishers`);
            setPublishers(response.data);
        } catch (error) {
            alert('Błąd podczas pobierania wydawnictw: ' + error.message);
        }
    };

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData({ ...formData, [name]: value });
    };

    const handleFileChange = (e) => {
        setFormData({ ...formData, okladka: e.target.files[0] });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        const formDataObj = new FormData();
        for (const key in formData) {
            if (formData[key]) {
                formDataObj.append(key, formData[key]);
            }
        }

        try {
            if (editingEdition) {
                await axios.put(`${config.API_BASE_URL}/editions/${editingEdition.id_wydania}`, formDataObj, {
                    headers: { 'Content-Type': 'multipart/form-data' },
                });
            } else {
                await axios.post(`${config.API_BASE_URL}/editions`, formDataObj, {
                    headers: { 'Content-Type': 'multipart/form-data' },
                });
            }
            fetchEditions();
            resetForm();
        } catch (error) {
            alert('Błąd podczas zapisywania wydania: ' + error.message);
        }
    };

    const resetForm = () => {
        setFormData({
            id_ksiazki: '',
            id_wydawnictwa: '',
            rok_wydania: '',
            jezyk: '',
            liczba_stron: '',
            okladka: null,
        });
        setEditingEdition(null);
    };

    const startEditing = (edition) => {
        setEditingEdition(edition);
        setFormData({
            id_ksiazki: edition.id_ksiazki,
            id_wydawnictwa: edition.id_wydawnictwa || '',
            rok_wydania: edition.rok_wydania || '',
            jezyk: edition.jezyk,
            liczba_stron: edition.liczba_stron || '',
            okladka: null,
        });
    };

    const deleteEdition = async (id) => {
        try {
            await axios.delete(`${config.API_BASE_URL}/editions/${id}`);
            fetchEditions();
        } catch (error) {
            alert('Błąd podczas usuwania wydania: ' + error.message);
        }
    };

    // if (!editions) return <p>Ładowanie danych...</p>;

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Zarządzanie wydaniami</h1>
            <form onSubmit={handleSubmit} className="mb-6">
                <select
                    name="id_ksiazki"
                    value={formData.id_ksiazki}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                >
                    <option value="">Wybierz książkę</option>
                    {books.map((book) => (
                        <option key={book.id_ksiazki} value={book.id_ksiazki}>
                            {book.tytul} ({book.autorzy})
                        </option>
                    ))}
                </select>
                <select
                    name="id_wydawnictwa"
                    value={formData.id_wydawnictwa}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                >
                    <option value="">Wybierz wydawnictwo</option>
                    {publishers.map((pub) => (
                        <option key={pub.id_wydawnictwa} value={pub.id_wydawnictwa}>
                            {pub.nazwa}
                        </option>
                    ))}
                </select>
                <input
                    type="number"
                    name="rok_wydania"
                    placeholder="Rok wydania"
                    value={formData.rok_wydania}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <input
                    type="text"
                    name="jezyk"
                    placeholder="Język"
                    value={formData.jezyk}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <input
                    type="number"
                    name="liczba_stron"
                    placeholder="Liczba stron"
                    value={formData.liczba_stron}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <input
                    type="file"
                    name="okladka"
                    onChange={handleFileChange}
                    className="block w-full p-2 border mb-2"
                />
                <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded mr-2">
                    {editingEdition ? 'Zapisz zmiany' : 'Dodaj wydanie'}
                </button>
                {editingEdition && (
                    <button onClick={resetForm} className="bg-gray-500 text-white px-4 py-2 rounded">
                        Anuluj
                    </button>
                )}
            </form>
            <ul>
                {editions.map((edition) => (
                    <li key={edition.id_wydania} className="border p-4 mb-2">
                        <div className="w-full flex items-start justify-center">
                            <img
                                src={`${config.API_BASE_URL}/${edition.sciezka_do_okladki}`}
                                alt="Okładka"
                                className="w-36 h-auto mr-4"
                            />
                            <div>
                                <h2 className="font-bold">{edition.tytul_ksiazki}</h2>
                                <p>Autorzy: {edition.autorzy}</p>
                                <p>Wydawnictwo: {edition.wydawnictwo || 'Brak'}</p>
                                <p>Rok: {edition.rok_wydania}</p>
                                <p>Język: {edition.jezyk}</p>
                                <p>Liczba stron: {edition.liczba_stron}</p>
                                <div className="mt-2">
                                    <button
                                        onClick={() => startEditing(edition)}
                                        className="bg-yellow-500 text-white px-4 py-2 rounded mr-2"
                                    >
                                        Edytuj
                                    </button>
                                    <button
                                        onClick={() => deleteEdition(edition.id_wydania)}
                                        className="bg-red-500 text-white px-4 py-2 rounded"
                                    >
                                        Usuń
                                    </button>
                                </div>
                            </div>
                        </div>
                    </li>
                ))}
            </ul>

        </div>
    );
};

export default Editions;
