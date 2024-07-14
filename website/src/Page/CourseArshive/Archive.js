import "./Archive.css";
import { useTranslation } from "react-i18next";
import { collection, getDocs, getFirestore } from "firebase/firestore";
import Loading from "../Loading/loading";
import app from "../../firebaseapi";
import React, { useState, useEffect } from "react";
import NotFound from "../NotFound/NotFound";
function Archive() {
  const [t, i18n] = useTranslation();
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      const db = getFirestore(app);

      const colRef = collection(db, "archive");
      const snapshot = await getDocs(colRef);
      const newData = snapshot.docs.map((doc) => ({
        ...doc.data(),
        active: false,
      }));
      newData.sort((a, b) => b.year - a.year);
      setData(newData);
      setLoading(false);
    };

    fetchData();
  }, []);

  return (
    <section className="Archive" id="Archive">
      <h2 className="heading">
        <span>{t("A3")}</span>
      </h2>
      {loading && <Loading />}
      {!loading && data.length === 0 && <NotFound />}
      <div className="row">
        {!loading &&
          data.length > 0 &&
          data.map((archive, index) => (
            <div
              key={index}
              className="Archive-column col-lg-6 col-md-6 col-sm-6"
            >
              <div>
                <h2>{archive.year}</h2>
                {archive &&
                  archive.Dscrp &&
                  archive.Dscrp.length > 0 &&
                  archive.Dscrp.map((item, itemIndex) => (
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
export default Archive;
