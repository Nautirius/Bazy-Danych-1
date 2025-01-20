import React, { createContext, useState, useEffect } from 'react';
import axios from 'axios';
import config from '../config';

export const AuthContext = createContext({
    user: null,
    login: () => {},
    logout: () => {},
    register: () => {},
});

export const AuthProvider = ({ children }) => {
    const [user, setUser] = useState(null);

    const login = async (credentials) => {
        try {
            const response = await axios.post(`${config.API_BASE_URL}/auth/login`, credentials);
            const { token, user } = response.data;
            localStorage.setItem('jwt', token);
            setUser(user);
        } catch (error) {
            console.error('Login error:', error.response?.data || error.message);
            throw error;
        }
    };

    const logout = async () => {
        try {
            localStorage.removeItem('jwt');
            setUser(null);
        } catch (error) {
            console.error('Logout error:', error.response?.data || error.message);
        }
    };

    const register = async (userData) => {
        try {
            await axios.post(`${config.API_BASE_URL}/auth/register`, userData);
        } catch (error) {
            console.error('Registration error:', error.response?.data || error.message);
            throw error;
        }
    };

    const verifyToken = async () => {
        const token = localStorage.getItem('jwt');
        if (!token) {
            setUser(null);
            return;
        }

        try {
            const response = await axios.post(`${config.API_BASE_URL}/auth/verify`, { token });
            setUser(response.data.user);
        } catch (error) {
            console.error('Token verification error:', error.response?.data || error.message);
            localStorage.removeItem('jwt');
            setUser(null);
        }
    };

    useEffect(() => {
        verifyToken();
    }, []);

    return (
        <AuthContext.Provider value={{
            user: user,
            login: login,
            logout: logout,
            register: register
        }}>
            {children}
        </AuthContext.Provider>
    );
};
