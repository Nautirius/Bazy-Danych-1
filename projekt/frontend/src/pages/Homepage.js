import React from 'react';
import { Link } from 'react-router-dom';

export default function Homepage() {
    return (
        <div className="min-h-screen bg-gray-100 flex flex-col">

            <header className="bg-blue-600 text-white p-4 shadow-lg">
                <h1 className="text-3xl font-bold text-center">Biblioteka Online</h1>
            </header>

            <main className="flex-grow flex items-center justify-center">
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 w-full max-w-4xl p-4">
                    <Link
                        to="/crud/kategorie"
                        className="bg-white rounded-lg shadow-lg p-6 text-center hover:bg-blue-100 transition"
                    >
                        <h2 className="text-2xl font-bold text-blue-600">Kategorie</h2>
                        <p className="text-gray-600 mt-2">Zarządzaj kategoriami książek.</p>
                    </Link>

                    <Link
                        to="/crud/autorzy"
                        className="bg-white rounded-lg shadow-lg p-6 text-center hover:bg-blue-100 transition"
                    >
                        <h2 className="text-2xl font-bold text-blue-600">Autorzy</h2>
                        <p className="text-gray-600 mt-2">Zarządzaj autorami w bazie danych.</p>
                    </Link>

                    <Link
                        to="/crud/ksiazki"
                        className="bg-white rounded-lg shadow-lg p-6 text-center hover:bg-blue-100 transition"
                    >
                        <h2 className="text-2xl font-bold text-blue-600">Książki</h2>
                        <p className="text-gray-600 mt-2">Przeglądaj, dodawaj i edytuj książki.</p>
                    </Link>

                    <Link
                        to="/crud/wydawnictwa"
                        className="bg-white rounded-lg shadow-lg p-6 text-center hover:bg-blue-100 transition"
                    >
                        <h2 className="text-2xl font-bold text-blue-600">Wydawnictwa</h2>
                        <p className="text-gray-600 mt-2">Zarządzaj wydawnictwami.</p>
                    </Link>

                    <Link
                        to="/crud/wydania"
                        className="bg-white rounded-lg shadow-lg p-6 text-center hover:bg-blue-100 transition"
                    >
                        <h2 className="text-2xl font-bold text-blue-600">Wydania</h2>
                        <p className="text-gray-600 mt-2">Zarządzaj wydaniami.</p>
                    </Link>

                    <Link
                        to="/crud/lokalizacje"
                        className="bg-white rounded-lg shadow-lg p-6 text-center hover:bg-blue-100 transition"
                    >
                        <h2 className="text-2xl font-bold text-blue-600">Lokalizacje</h2>
                        <p className="text-gray-600 mt-2">Zarządzaj lokalizacjami w bibliotece.</p>
                    </Link>

                    <Link
                        to="/crud/egzemplarze"
                        className="bg-white rounded-lg shadow-lg p-6 text-center hover:bg-blue-100 transition"
                    >
                        <h2 className="text-2xl font-bold text-blue-600">Egzemplarze</h2>
                        <p className="text-gray-600 mt-2">Zarządzaj egzemplarzami książek.</p>
                    </Link>

                    <Link
                        to="/crud/czytelnicy"
                        className="bg-white rounded-lg shadow-lg p-6 text-center hover:bg-blue-100 transition"
                    >
                        <h2 className="text-2xl font-bold text-blue-600">Czytelnicy</h2>
                        <p className="text-gray-600 mt-2">Zarządzaj czytelnikami.</p>
                    </Link>

                    <Link
                        to="/crud/wypozyczenia"
                        className="bg-white rounded-lg shadow-lg p-6 text-center hover:bg-blue-100 transition"
                    >
                        <h2 className="text-2xl font-bold text-blue-600">Wypożyczenia</h2>
                        <p className="text-gray-600 mt-2">Zarządzaj wypożyczeniami.</p>
                    </Link>

                    <Link
                        to="/crud/rezerwacje"
                        className="bg-white rounded-lg shadow-lg p-6 text-center hover:bg-blue-100 transition"
                    >
                        <h2 className="text-2xl font-bold text-blue-600">Rezerwacje</h2>
                        <p className="text-gray-600 mt-2">Zarządzaj rezerwacjami.</p>
                    </Link>

                    <Link
                        to="/lista-ksiazek"
                        className="bg-white rounded-lg shadow-lg p-6 text-center hover:bg-blue-100 transition"
                    >
                        <h2 className="text-2xl font-bold text-blue-600">Lista książek</h2>
                        <p className="text-gray-600 mt-2">Wyświetl listę książek, które są dostępne w bibliotece.</p>
                    </Link>

                    <Link
                        to="/ranking/ksiazki"
                        className="bg-white rounded-lg shadow-lg p-6 text-center hover:bg-blue-100 transition"
                    >
                        <h2 className="text-2xl font-bold text-blue-600">Ranking książek</h2>
                        <p className="text-gray-600 mt-2">Wyświetl ranking książek.</p>
                    </Link>

                    <Link
                        to="/ranking/czytelnicy"
                        className="bg-white rounded-lg shadow-lg p-6 text-center hover:bg-blue-100 transition"
                    >
                        <h2 className="text-2xl font-bold text-blue-600">Ranking czytelników</h2>
                        <p className="text-gray-600 mt-2">Wyświetl ranking czytelników.</p>
                    </Link>

                    <Link
                        to="/ranking/ksiazki/najbardziej-popularne"
                        className="bg-white rounded-lg shadow-lg p-6 text-center hover:bg-blue-100 transition"
                    >
                        <h2 className="text-2xl font-bold text-blue-600">Najbardziej popularne książki</h2>
                        <p className="text-gray-600 mt-2">Wyświetl listę najbardziej popularnych książek.</p>
                    </Link>

                </div>
            </main>
        </div>
    );
}
