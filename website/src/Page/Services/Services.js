import "./Services.css";
import { useTranslation } from "react-i18next";
import { collection, getDocs, getFirestore } from "firebase/firestore";
import Loading from "../Loading/loading";
import app from "../../firebaseapi";
import React, { useState, useEffect } from "react";
import NotFound from "../NotFound/NotFound";

function Services() {
  const [t, i18n] = useTranslation();
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      const db = getFirestore(app);

      const colRef = collection(db, "service");
      const snapshot = await getDocs(colRef);
      const newData = snapshot.docs.map((doc) => ({
        ...doc.data(),
        active: false,
      }));
      setData(newData);
      setLoading(false);
    };

    fetchData();
  }, []);

  return (
    <section id="Services" className="Services">
      <h2 className="heading">
        <span>{t("N4")}</span>
      </h2>
      {loading && <Loading />}
      {!loading && data.length === 0 && <NotFound />}
      <div>
        <div className="Services-img">
          {!loading &&
            data.length > 0 &&
            data.map((service, index) => (
              <div key={index} className="card">
                <div className="content">
                  <div className="icon">
                    <i className={service.icon}></i>
                  </div>
                  <div className="title">
                    {i18n.language === "en" ? service.titleE : service.titleA}
                  </div>
                  <p>
                    {i18n.language === "en"
                      ? service.subtitleE
                      : service.subtitleA}
                  </p>
                </div>
              </div>
            ))}
        </div>
      </div>
    </section>
  );
}

export default Services;
