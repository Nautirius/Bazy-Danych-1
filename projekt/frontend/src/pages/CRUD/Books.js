import React, { useState, useEffect } from 'react';
import axios from 'axios';
import config from '../../config';

const Books = () => {
    const [books, setBooks] = useState([]);
    const [categories, setCategories] = useState([]);
    const [authors, setAuthors] = useState([]);
    const [formData, setFormData] = useState({
        tytul: '',
        jezyk_oryginalu: '',
        id_kategorii: '',
        opis: '',
        authors: [],
    });
    const [editingBook, setEditingBook] = useState(null);

    useEffect(() => {
        fetchBooks();
        fetchCategories();
        fetchAuthors();
    }, []);

    const fetchBooks = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/books`);
            setBooks(response.data);
        } catch (error) {
            alert('Błąd podczas pobierania książek: ' + error.message);
        }
    };

    const fetchCategories = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/categories`);
            setCategories(response.data);
        } catch (error) {
            alert('Błąd podczas pobierania kategorii: ' + error.message);
        }
    };

    const fetchAuthors = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/authors`);
            setAuthors(response.data);
        } catch (error) {
            alert('Błąd podczas pobierania autorów: ' + error.message);
        }
    };

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData({ ...formData, [name]: value });
    };

    const handleAuthorsChange = (e) => {
        const selectedAuthors = Array.from(e.target.selectedOptions, (option) => option.value);
        setFormData({ ...formData, authors: selectedAuthors });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            if (editingBook) {
                await axios.put(`${config.API_BASE_URL}/books/${editingBook.id_ksiazki}`, formData);
            } else {
                await axios.post(`${config.API_BASE_URL}/books`, formData);
            }
            fetchBooks();
            resetForm();
        } catch (error) {
            alert('Błąd podczas zapisywania książki: ' + error.message);
        }
    };

    const resetForm = () => {
        setFormData({
            tytul: '',
            jezyk_oryginalu: '',
            id_kategorii: '',
            opis: '',
            authors: [],
        });
        setEditingBook(null);
    };

    const startEditing = (book) => {
        setEditingBook(book);
        setFormData({
            tytul: book.tytul,
            jezyk_oryginalu: book.jezyk_oryginalu,
            id_kategorii: book.id_kategorii || '',
            opis: book.opis,
            authors: book.authors || [],
        });
    };

    const deleteBook = async (id) => {
        try {
            await axios.delete(`${config.API_BASE_URL}/books/${id}`);
            fetchBooks();
        } catch (error) {
            alert('Błąd podczas usuwania książki: ' + error.message);
        }
    };

    // if (!books) return <p>Ładowanie danych...</p>;

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Zarządzanie książkami</h1>
            <form onSubmit={handleSubmit} className="mb-6">
                <input
                    type="text"
                    name="tytul"
                    placeholder="Tytuł"
                    value={formData.tytul}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <input
                    type="text"
                    name="jezyk_oryginalu"
                    placeholder="Język oryginału"
                    value={formData.jezyk_oryginalu}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                />
                <select
                    name="id_kategorii"
                    value={formData.id_kategorii}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                >
                    <option value="">Wybierz kategorię</option>
                    {categories.map((cat) => (
                        <option key={cat.id_kategorii} value={cat.id_kategorii}>
                            {cat.sciezka}
                        </option>
                    ))}
                </select>
                <textarea
                    name="opis"
                    placeholder="Opis"
                    value={formData.opis}
                    onChange={handleInputChange}
                    className="block w-full p-2 border mb-2"
                ></textarea>
                <select
                    multiple
                    name="authors"
                    value={formData.authors}
                    onChange={handleAuthorsChange}
                    className="block w-full p-2 border mb-2"
                >
                    {authors.map((author) => (
                        <option key={author.id_autora} value={author.id_autora}>
                            {author.imie} {author.nazwisko}
                        </option>
                    ))}
                </select>
                <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded mr-2">
                    {editingBook ? 'Zapisz zmiany' : 'Dodaj książkę'}
                </button>
                {editingBook && (
                    <button onClick={resetForm} className="bg-gray-500 text-white px-4 py-2 rounded">
                        Anuluj
                    </button>
                )}
            </form>
            <ul>
                {books.map((book) => (
                    <li key={book.id_ksiazki} className="border p-4 mb-2">
                        <h2 className="font-bold">{book.tytul}</h2>
                        <p>Kategoria: {book.sciezka_kategorii || 'Brak'}</p>
                        <p>Autorzy: {book.autorzy || 'Brak'}</p>
                        <p className="italic">{book.opis}</p>
                        <div className="mt-2">
                            <button onClick={() => startEditing(book)} className="bg-yellow-500 text-white px-4 py-2 rounded mr-2">
                                Edytuj
                            </button>
                            <button onClick={() => deleteBook(book.id_ksiazki)} className="bg-red-500 text-white px-4 py-2 rounded">
                                Usuń
                            </button>
                        </div>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default Books;
