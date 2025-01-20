import React, { useState, useEffect } from 'react';
import axios from 'axios';
import config from '../../config';

const Copies = () => {
    const [copies, setCopies] = useState([]);
    const [editions, setEditions] = useState([]);
    const [locations, setLocations] = useState([]);
    const [formData, setFormData] = useState({
        id_wydania: '',
        stan: 'dostępny',
        id_lokalizacji: '',
    });
    const [editingCopy, setEditingCopy] = useState(null);

    useEffect(() => {
        fetchCopies();
        fetchEditions();
        fetchLocations();
    }, []);

    const fetchCopies = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/copies`);
            setCopies(response.data);
        } catch (error) {
            alert('Błąd podczas pobierania egzemplarzy: ' + error.message);
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

    const fetchLocations = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/locations`);
            setLocations(response.data);
        } catch (error) {
            alert('Błąd podczas pobierania lokalizacji: ' + error.message);
        }
    };

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData({ ...formData, [name]: value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            if (editingCopy) {
                await axios.put(`${config.API_BASE_URL}/copies/${editingCopy.id_egzemplarza}`, formData);
            } else {
                await axios.post(`${config.API_BASE_URL}/copies`, formData);
            }
            fetchCopies();
            resetForm();
        } catch (error) {
            alert('Błąd podczas zapisywania egzemplarza: ' + error.message);
        }
    };

    const resetForm = () => {
        setFormData({
            id_wydania: '',
            stan: 'dostępny',
            id_lokalizacji: '',
        });
        setEditingCopy(null);
    };

    const startEditing = (copy) => {
        setEditingCopy(copy);
        setFormData({
            id_wydania: copy.id_wydania,
            stan: copy.stan,
            id_lokalizacji: copy.id_lokalizacji || '',
        });
    };

    const deleteCopy = async (id) => {
        try {
            await axios.delete(`${config.API_BASE_URL}/copies/${id}`);
            fetchCopies();
        } catch (error) {
            alert('Błąd podczas usuwania egzemplarza: ' + error.message);
        }
    };

    // if (!copies) return <p>Ładowanie danych...</p>;

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Zarządzanie egzemplarzami</h1>
            <form onSubmit={handleSubmit} className="mb-6">
                <select
                    name="id_wydania"
                    value={formData.id_wydania}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                >
                    <option value="">Wybierz książkę (wydanie)</option>
                    {editions.map((edition) => (
                        <option key={edition.id_wydania} value={edition.id_wydania}>
                            {edition.tytul_ksiazki} ({edition.wydawnictwo} {edition.rok_wydania})
                        </option>
                    ))}
                </select>
                <select
                    name="id_lokalizacji"
                    value={formData.id_lokalizacji}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                >
                    <option value="">Wybierz lokalizację</option>
                    {locations.map((loc) => (
                        <option key={loc.id_lokalizacji} value={loc.id_lokalizacji}>
                            Półka {loc.numer_polki} ({loc.opis})
                        </option>
                    ))}
                </select>
                <select
                    name="stan"
                    value={formData.stan}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                >
                    <option value="">Wybierz stan</option>
                    <option value="dostępny">Dostępny</option>
                    <option value="wypożyczony">Wypożyczony</option>
                    <option value="zarezerwowany">Zarezerwowany</option>
                    <option value="zniszczony">Zniszczony</option>
                </select>
                <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded">
                    {editingCopy ? 'Zapisz zmiany' : 'Dodaj egzemplarz'}
                </button>
            </form>
            <ul>
                {copies.map((copy) => (
                    <li key={copy.id_egzemplarza} className="border p-4 mb-2">
                        <div className="w-full flex items-start justify-center">
                            <img
                                src={`${config.API_BASE_URL}/${copy.sciezka_do_okladki}`}
                                alt="Okładka"
                                className="w-36 h-auto mr-4"
                            />
                            <div>
                                <h2 className="font-bold">{copy.tytul_ksiazki}</h2>
                                <p>Autorzy: {copy.autorzy || 'Brak'}</p>
                                <p>Wydawnictwo: {copy.wydawnictwo} ({copy.rok_wydania})</p>
                                <p>Lokalizacja: {copy.numer_polki} - {copy.opis_lokalizacji}</p>
                                <p>Stan: {copy.stan}</p>
                                <div className="mt-2">
                                    <button onClick={() => startEditing(copy)}
                                            className="bg-yellow-500 text-white px-4 py-2 rounded mr-2">
                                        Edytuj
                                    </button>
                                    <button onClick={() => deleteCopy(copy.id_egzemplarza)}
                                            className="bg-red-500 text-white px-4 py-2 rounded">
                                        Usuń
                                    </button>
                                </div>
                            </div>
                        </div>
                    </li>
                    ))}
            </ul>

            {/*<div className="w-full flex items-start justify-center">*/}
            {/*    <img*/}
            {/*        src={`${config.API_BASE_URL}/${edition.sciezka_do_okladki}`}*/}
            {/*        alt="Okładka"*/}
            {/*        className="w-36 h-auto mr-4"*/}
            {/*    />*/}
            {/*    <div>*/}
            {/*        <h2 className="font-bold">{edition.tytul_ksiazki}</h2>*/}
            {/*        <p>Autorzy: {edition.autorzy}</p>*/}
            {/*        <p>Wydawnictwo: {edition.wydawnictwo || 'Brak'}</p>*/}
            {/*        <p>Rok: {edition.rok_wydania}</p>*/}
            {/*        <p>Język: {edition.jezyk}</p>*/}
            {/*        <p>Liczba stron: {edition.liczba_stron}</p>*/}
            {/*        <div className="mt-2">*/}
            {/*            <button*/}
            {/*                onClick={() => startEditing(edition)}*/}
            {/*                className="bg-yellow-500 text-white px-4 py-2 rounded mr-2"*/}
            {/*            >*/}
            {/*                Edytuj*/}
            {/*            </button>*/}
            {/*            <button*/}
            {/*                onClick={() => deleteEdition(edition.id_wydania)}*/}
            {/*                className="bg-red-500 text-white px-4 py-2 rounded"*/}
            {/*            >*/}
            {/*                Usuń*/}
            {/*            </button>*/}
            {/*        </div>*/}
            {/*    </div>*/}
            {/*</div>*/}
        </div>
    );
};

export default Copies;
