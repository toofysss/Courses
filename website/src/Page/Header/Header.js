import "./Header.css";
import { useState, useEffect, useRef } from "react";
import { Link, useLocation } from "react-router-dom";
import Routing from "../../Routing";
import Footers from "../Footer/Footers";
import { useTranslation } from "react-i18next";

function App() {
  const [t, il8n] = useTranslation();
  const [isMenuOpen, setMenuOpen] = useState(false);
  const [selectedLink, setSelectedLink] = useState(null);
  const dropdownRef = useRef(null);
  const location = useLocation();
  const accessToken = localStorage.getItem("accessToken");

  const links = [
    { id: "home", label: t("N1") },
    { id: "about", label: t("N2") },
    { id: "price", label: t("N3") },
    { id: "services", label: t("N4") },
    { id: "course", label: t("N5") },
  ];

  useEffect(() => {
    const currentPath = location.pathname;
    if (currentPath === "/") {
      setSelectedLink(links[0].id);
    } else {
      const linkId = currentPath.split("/")[1];
      setSelectedLink(linkId);
    }
  }, [location.pathname]);

  const handleMenuClick = (event) => {
    event.stopPropagation();
    setMenuOpen(!isMenuOpen);
    window.scrollTo(0, 0);
  };
  const handleSignOut = (event) => {
    event.stopPropagation();
    setMenuOpen(!isMenuOpen);
    localStorage.removeItem("accessToken");
  };
  const handleDropdownChange = (e) => {
    il8n.changeLanguage(e.target.value);
    setMenuOpen(false);
  };
  return (
    <div dir={il8n.language === "en" ? "ltr" : "rtl"}>
      <header className="header">
        <h2 className="logo">
          <span>My </span>Course
        </h2>
        <i className="bx bx-menu" id="menu-icon" onClick={handleMenuClick}></i>
        <nav className={`Navbar ${isMenuOpen ? "open" : ""}`}>
          {links.map((link) => (
            <Link
              key={link.id}
              onClick={handleMenuClick}
              to={`/${link.id.toLowerCase()}`}
              className={`navbtn ${selectedLink === link.id ? "active" : ""}`}
            >
              {link.label}
            </Link>
          ))}

          <div ref={dropdownRef}>
            <select className="dropdown-select" onChange={handleDropdownChange}>
              <option hidden>{t("lang")}</option>
              <option value="en">{t("En")}</option>
              <option value="ar">{t("Ar")}</option>
            </select>
          </div>
          {accessToken ? (
            <Link to={`/home`} onClick={handleSignOut} className="signBtn">
              {t("N7")}
            </Link>
          ) : (
            <Link to={`/signIn`} onClick={handleMenuClick} className="signBtn">
              {t("N6")}
            </Link>
          )}
        </nav>
      </header>
      <Routing />
      <footer>
        <Footers />
      </footer>
    </div>
  );
}

export default App;
