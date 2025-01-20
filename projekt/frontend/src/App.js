import './App.css';
import {Navigate, Route, Routes} from "react-router-dom";

import Layout from "./components/layout_elements/layout/Layout";
import Homepage from "./pages/Homepage";
import Categories from "./pages/CRUD/Categories";
import Books from "./pages/CRUD/Books";
import Authors from "./pages/CRUD/Authors";
import Publishers from "./pages/CRUD/Publishers";
import Editions from "./pages/CRUD/Editions";
import Locations from "./pages/CRUD/Locations";
import Copies from "./pages/CRUD/Copies";
import Readers from "./pages/CRUD/Readers";
import Rentals from "./pages/CRUD/Rentals";
import Reservations from "./pages/CRUD/Reservations";

import {EditionsList} from "./pages/Books/EditionsList";
import {EditionDetails} from "./pages/Books/EditionDetails";

import {BooksRanking} from "./pages/Rankings/BooksRanking";
import {ReadersRanking} from "./pages/Rankings/ReadersRanking";
import {MostPopularBooks} from "./pages/Rankings/MostPopularBooks";

import AuthPage from "./pages/Auth/AuthPage";
import {AuthProvider} from "./context/AuthContext";
import {UserPage} from "./pages/User/UserPage";

function App() {
  return (
    <div className="App">
        <AuthProvider>
          <Routes>
            <Route element={<Layout/>}>
                <Route path="/" element={<Homepage/>}/>
                <Route path="/crud/kategorie" element={<Categories />}/>
                <Route path="/crud/ksiazki" element={<Books />}/>
                <Route path="/crud/autorzy" element={<Authors />}/>
                <Route path="/crud/wydawnictwa" element={<Publishers />}/>
                <Route path="/crud/wydania" element={<Editions />}/>
                <Route path="/crud/lokalizacje" element={<Locations />}/>
                <Route path="/crud/egzemplarze" element={<Copies />}/>
                <Route path="/crud/czytelnicy" element={<Readers />}/>
                <Route path="/crud/wypozyczenia" element={<Rentals />}/>
                <Route path="/crud/rezerwacje" element={<Reservations />}/>

                <Route path="/moj-profil" element={<UserPage />}/>

                <Route path="/lista-ksiazek" element={<EditionsList />} />
                <Route path="/wydania/:id_wydania" element={<EditionDetails />} />

                <Route path="/ranking/ksiazki" element={<BooksRanking />}/>
                <Route path="/ranking/czytelnicy" element={<ReadersRanking />}/>
                <Route path="/ranking/ksiazki/najbardziej-popularne" element={<MostPopularBooks />}/>

                <Route path="/auth" element={<AuthPage />}/>

                <Route path="/*" element={<Navigate to="/"/>}/>
            </Route>
          </Routes>
        </AuthProvider>
    </div>
  );
}

export default App;
