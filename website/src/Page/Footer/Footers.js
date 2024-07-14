import "./Footer.css";
import { useState, useEffect } from "react";
import { Link, useLocation } from "react-router-dom";
import { useTranslation } from "react-i18next";

function Footer() {
  const [t] = useTranslation();
  const location = useLocation();
  const [selectedLink, setSelectedLink] = useState(null);

  useEffect(() => {
    const currentPath = location.pathname;
    const footerId = currentPath.split("/")[1];
    setSelectedLink(footerId);
  }, [location.pathname]);

  const footer = [
    { id: "client", label: t("A2") },
    { id: "archive", label: t("A3") },
    { id: "news", label: t("A4") },
    { id: "gallery", label: t("A5") },
  ];

  const Follow = [
    // {
    //   id: "https://www.youtube.com/channel/UChfiJ6mxizzwE4SIgkFoi_Q",
    //   label: t("F1"),
    // },
    { id: "https://t.me/toofy_s", label: t("F2") },
    // { id: "https://twitter.com/iacedca", label: t("F3") },
    {
      id: "https://www.instagram.com/toofy_.s/?utm_source=qr&igsh=djNrb25lamUxaGEz",
      label: t("F4"),
    },
    {
      id: "https://www.facebook.com/people/Mustafa-Saad/pfbid0a9kfnmxFT2YwhaLXtEN41t4fZXc7tCvcHEmwnqgQ7GnMyWiFdcnNtZusCLG1RQYal/?mibextid=ZbWKwL",
      label: t("F5"),
    },
  ];

  const contact = [
    {
      id: "+9647737446118",
      label: t("C1"),
    },
    { id: "22124817@ruc.edu.iq", label: t("C2") },
  ];

  return (
    <footer className="footer">
      <div className="container">
        <div className="row">
          <div className="col-lg-3 col-md-6 col-sm-6">
            <div className="footer-col">
              <h4>{t("FT1")}</h4>
              {footer.map((link) => (
                <Link
                  onClick={() => window.scrollTo(0, 0)}
                  key={link.id}
                  to={`/${link.id.toLowerCase()}`}
                  className={selectedLink === link.id ? "active" : ""}
                >
                  {link.label}
                </Link>
              ))}
            </div>
          </div>
          <div className="col-lg-3 col-md-6 col-sm-6">
            <div className="footer-col">
              <h4>{t("FT2")}</h4>
              {Follow.map((link) => (
                <a key={link.id} href={link.id}>
                  {link.label}
                </a>
              ))}
            </div>
          </div>
          <div className="col-lg-3 col-md-6 col-sm-6">
            <div className="footer-col">
              <h4>{t("FT3")}</h4>
              <ul>
                {contact.map((contact) => (
                  <li key={contact.id}>
                    {contact.label} : {contact.id}
                  </li>
                ))}
              </ul>
            </div>
          </div>
          <div className="col-lg-3 col-md-6 col-sm-6">
            <div className="footer-col">
              <iframe
                className="Mapstyle"
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2913.3078416951666!2d-79.12289751547985!3d43.09804507914418!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89d344965dba3acd%3A0x31a6735f09a5a27c!2zNzc2OCBBc2NvdCBDaXIgIzg3LCBOaWFnYXJhIEZhbGxzLCBPTiBMMkggM1A52Iwg2YPZhtiv2Kc!5e0!3m2!1sar!2siq!4v1710860756494!5m2!1sar!2siq&zoom=15" // Set zoom level to 15
                allowFullScreen={false}
                loading="lazy"
                referrerPolicy="no-referrer-when-downgrade"
                title="Google Map"
              ></iframe>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
}

export default Footer;
