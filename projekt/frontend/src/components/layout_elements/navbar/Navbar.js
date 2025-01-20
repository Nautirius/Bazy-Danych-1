import {Link} from "react-router-dom";
import { useContext } from "react";
import { AuthContext } from "../../../context/AuthContext"
import "./Navbar.css";


export default function Navbar() {
    const { user, logout } = useContext(AuthContext);

    return (
        <>
            <div className="top">
                <div className="bar black card" id="myNavbar">
                    <Link to="/" className="bar-item bar-button">
                        Strona główna
                    </Link>
                    {/*<Link to="/crud/kategorie" className="bar-item bar-button">*/}
                    {/*    Kategorie*/}
                    {/*</Link>*/}
                    {/*<Link to="/crud/autorzy" className="bar-item bar-button">*/}
                    {/*    Autorzy*/}
                    {/*</Link>*/}
                    {/*<Link to="/crud/ksiazki" className="bar-item bar-button">*/}
                    {/*    Książki*/}
                    {/*</Link>*/}
                    {/*<Link to="/crud/wydawnictwa" className="bar-item bar-button">*/}
                    {/*    Wydawnictwa*/}
                    {/*</Link>*/}
                    {/*<Link to="/crud/wydania" className="bar-item bar-button">*/}
                    {/*    Wydania*/}
                    {/*</Link>*/}
                    {/*<Link to="/crud/lokalizacje" className="bar-item bar-button">*/}
                    {/*    Lokalizacje*/}
                    {/*</Link>*/}
                    {/*<Link to="/crud/egzemplarze" className="bar-item bar-button">*/}
                    {/*    Egzemplarze*/}
                    {/*</Link>*/}
                    {/*<Link to="/crud/czytelnicy" className="bar-item bar-button">*/}
                    {/*    Czytelnicy*/}
                    {/*</Link>*/}

                    <Link to="/lista-ksiazek" className="bar-item bar-button">
                        Lista książek
                    </Link>

                    <Link to="/ranking/ksiazki" className="bar-item bar-button">
                        Ranking książek
                    </Link>

                    <Link to="/ranking/ksiazki/najbardziej-popularne" className="bar-item bar-button">
                        Najbardziej popularne książki
                    </Link>

                    <Link to="/ranking/czytelnicy" className="bar-item bar-button">
                        Ranking czytelników
                    </Link>

                    {/*Right-sided navbar links */}
                    <div style={{float: "right", display: "flex", flexDirection: "row"}}>
                        <a href="/"></a>
                        {user ? (
                            <div>
                            <Link to="/moj-profil" className="bar-item bar-button">
                                Witaj, {user.imie}
                            </Link>
                            <button onClick={logout} className="bar-item bar-button">Wyloguj</button>
                            </div>
                            ) : (
                            <Link to="/auth" className="bar-item bar-button">Zaloguj</Link>
                        )}
                    </div>
                </div>
            </div>
        </>
    );
}
