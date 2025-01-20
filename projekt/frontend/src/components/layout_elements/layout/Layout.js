import {Outlet} from "react-router-dom";
import Navbar from "../navbar/Navbar";
import Footer from "../footer/Footer";
import "./Layout.css"

export default function Layout() {
    return (
        <div id="wrapper">
            <Navbar/>
            <div id="outlet">
                <Outlet/>
            </div>
            <Footer/>
        </div>
    );
}