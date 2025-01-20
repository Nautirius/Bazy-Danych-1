import React, { useState, useEffect } from 'react';
import axios from 'axios';
import config from '../../config';

const Categories = () => {
    const [categories, setCategories] = useState([]);
    const [name, setName] = useState('');
    const [upperId, setUpperId] = useState(null);
    const [editingCategory, setEditingCategory] = useState(null);

    useEffect(() => {
        fetchCategories();
    }, []);

    const fetchCategories = async () => {
        try {
            const response = await axios.get(`${config.API_BASE_URL}/categories`);
            setCategories(response.data);
        } catch (error) {
            console.error('Błąd podczas pobierania kategorii:', error);
            alert('Błąd podczas pobierania kategorii. Spróbuj ponownie później.');
        }
    };

    const addOrEditCategory = async () => {
        try {
            if (editingCategory) {
                await axios.put(`${config.API_BASE_URL}/categories/${editingCategory.id_kategorii}`, {
                    nazwa: name,
                    id_kategorii_nadrzednej: upperId,
                });
            } else {
                await axios.post(`${config.API_BASE_URL}/categories`, {
                    nazwa: name,
                    id_kategorii_nadrzednej: upperId,
                });
            }
            setName('');
            setUpperId(null);
            setEditingCategory(null);
            fetchCategories();
        } catch (error) {
            console.error('Błąd podczas dodawania lub edycji kategorii:', error);
            alert('Błąd podczas dodawania lub edycji kategorii. Upewnij się, że dane są poprawne i spróbuj ponownie.');
        }
    };

    const deleteCategory = async (id) => {
        try {
            await axios.delete(`${config.API_BASE_URL}/categories/${id}`);
            fetchCategories();
        } catch (error) {
            console.error('Błąd podczas usuwania kategorii:', error);
            alert('Błąd podczas usuwania kategorii. Spróbuj ponownie później.');
        }
    };

    const startEditing = (category) => {
        setEditingCategory(category);
        setName(category.nazwa);
        setUpperId(category.id_kategorii_nadrzednej);
    };

    const cancelEditing = () => {
        setEditingCategory(null);
        setName('');
        setUpperId(null);
    };

    // if (!categories) return <p>Ładowanie danych...</p>;

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Zarządzanie kategoriami</h1>
            <div className="mb-6">
                <input
                    type="text"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    placeholder="Nazwa kategorii"
                    className="border rounded p-2 mr-2"
                />
                <select
                    value={upperId || ''}
                    onChange={(e) => setUpperId(e.target.value || null)}
                    className="border rounded p-2 mr-2"
                >
                    <option value="">Brak nadrzędnej kategorii</option>
                    {categories.map((cat) => (
                        <option key={cat.id_kategorii} value={cat.id_kategorii}>
                            {cat.nazwa}
                        </option>
                    ))}
                </select>
                <button onClick={addOrEditCategory} className="bg-blue-500 text-white px-4 py-2 rounded mr-2">
                    {editingCategory ? 'Zapisz zmiany' : 'Dodaj'}
                </button>
                {editingCategory && (
                    <button onClick={cancelEditing} className="bg-gray-500 text-white px-4 py-2 rounded">
                        Anuluj
                    </button>
                )}
            </div>
            <div>
                {categories.map((kategoria) => (
                    <div key={kategoria.id_kategorii} className="flex items-center justify-between mb-2">
                        <span>
                            {kategoria.nazwa} ({kategoria.sciezka})
                        </span>
                        <div>
                            <button
                                onClick={() => startEditing(kategoria)}
                                className="bg-yellow-500 text-white px-4 py-2 rounded mr-2"
                            >
                                Edytuj
                            </button>
                            <button
                                onClick={() => deleteCategory(kategoria.id_kategorii)}
                                className="bg-red-500 text-white px-4 py-2 rounded"
                            >
                                Usuń
                            </button>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default Categories;
