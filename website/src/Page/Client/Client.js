import "./Client.css";
import { useTranslation } from "react-i18next";
import { collection, getDocs, getFirestore } from "firebase/firestore";
import Loading from "../Loading/loading";
import app from "../../firebaseapi";
import React, { useState, useEffect } from "react";
import NotFound from "../NotFound/NotFound";
function Client() {
  const [t, i18n] = useTranslation();
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      const db = getFirestore(app);
      const colRef = collection(db, "client");
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
    <section className="Client" id="Client">
      <h2 className="heading">
        <span>{t("A2")}</span>
      </h2>
      {loading && <Loading />}
      {!loading && data.length === 0 && <NotFound />}

      <div>
        {!loading &&
          data.length > 0 &&
          data.map((client, index) => (
            <div key={index} className="Client-column">
              <div>
                <h2>
                  {i18n.language === "en" ? client.titleE : client.titleA}
                </h2>
                {client.Dscrp.map((item, itemIndex) => (
                  <h3 key={itemIndex} className="item-container">
                    <i
                      className={`bx bx-chevrons-${
                        i18n.language === "en" ? "right" : "left"
                      }`}
                    ></i>
                    {i18n.language === "en" ? item.subtitleE : item.subtitleA}
                  </h3>
                ))}
              </div>
            </div>
          ))}
      </div>
    </section>
  );
}
export default Client;
