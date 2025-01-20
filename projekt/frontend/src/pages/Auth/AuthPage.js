import React, {useState, useEffect, useContext} from "react";
import { useNavigate } from "react-router-dom";
import { AuthContext } from "../../context/AuthContext";

export default function AuthPage() {
    const navigate = useNavigate();
    const [isRegistering, setIsRegistering] = useState(false);

    const { user, login, register } = useContext(AuthContext);

    const [loginForm, setLoginForm] = useState({
        email: "",
        haslo: "",
    });

    const [registerForm, setRegisterForm] = useState({
        imie: "",
        nazwisko: "",
        data_urodzin: "",
        pesel: "",
        kraj: "",
        miejscowosc: "",
        ulica: "",
        numer_domu: "",
        kod_pocztowy: "",
        telefon: "",
        email: "",
        haslo: "",
    });

    useEffect(() => {
        if (user) {
            navigate("/");
        }
    }, [user, navigate]);

    const handleInputChange = (e, formType) => {
        const { name, value } = e.target;
        if (formType === "login") {
            setLoginForm({ ...loginForm, [name]: value });
        } else {
            setRegisterForm({ ...registerForm, [name]: value });
        }
    };

    const handleLogin = async (e) => {
        e.preventDefault();
        try {
            await login(loginForm)
            navigate("/");

        } catch (error) {
            console.log(error)
            alert("Błąd logowania: " + error.response?.data?.error || error.message);
        }
    };

    const handleRegister = async (e) => {
        e.preventDefault();
        try {
            await register(registerForm);
            alert("Rejestracja zakończona sukcesem! Możesz się teraz zalogować.");
            setIsRegistering(false);
        } catch (error) {
            alert("Błąd rejestracji: " + error.response?.data?.error || error.message);
        }
    };

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">{isRegistering ? "Rejestracja" : "Logowanie"}</h1>
            {isRegistering ? (
                <form onSubmit={handleRegister} className="space-y-4">
                    {["imie", "nazwisko", "data_urodzin", "pesel", "kraj", "miejscowosc", "ulica", "numer_domu", "kod_pocztowy", "telefon", "email", "haslo"].map((field) => (
                        <div key={field} className="mb-6">
                            <input
                                type={field === "haslo" ? "password" : field === "data_urodzin" ? "date" : "text"}
                                name={field}
                                placeholder={field.charAt(0).toUpperCase() + field.slice(1)}
                                value={registerForm[field]}
                                onChange={(e) => handleInputChange(e, "register")}
                                className="border rounded p-2 w-full"
                                required={["imie", "nazwisko", "data_urodzin", "pesel", "email", "haslo"].includes(field)}
                            />
                        </div>
                    ))}
                    <button className="bg-blue-500 text-white px-4 py-2 rounded" type="submit">Zarejestruj</button>
                </form>
            ) : (
                <form onSubmit={handleLogin} className="space-y-4 p-6">
                    {["email", "haslo"].map((field) => (
                        <div key={field} className="mb-6">
                            <input
                                type={field === "haslo" ? "password" : "text"}
                                name={field}
                                placeholder={field.charAt(0).toUpperCase() + field.slice(1)}
                                value={loginForm[field]}
                                onChange={(e) => handleInputChange(e, "login")}
                                className="border rounded p-2 w-full"
                                required
                            />
                        </div>
                    ))}
                    <button className="bg-blue-500 text-white px-4 py-2 rounded" type="submit">Zaloguj</button>
                </form>
            )}
            <button
                className="mt-4 text-blue-500 underline"
                onClick={() => setIsRegistering(!isRegistering)}
            >
                {isRegistering ? "Masz konto? Zaloguj się" : "Nie masz konta? Zarejestruj się"}
            </button>
        </div>
    );
}
