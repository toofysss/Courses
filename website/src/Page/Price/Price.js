import React, { useState, useEffect } from "react";
import { useTranslation } from "react-i18next";
import app from "../../firebaseapi";
import "./Price.css";
import { collection, getDocs, getFirestore } from "firebase/firestore";
import Loading from "../Loading/loading";
import NotFound from "../NotFound/NotFound";

function Price() {
  const [t, i18n] = useTranslation();
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      const db = getFirestore(app);

      const colRef = collection(db, "price");
      const snapshot = await getDocs(colRef);
      const newData = snapshot.docs.map((doc) => ({
        ...doc.data(),
        active: false,
      }));
      setData(newData);
      setInitialActive(newData);
      setLoading(false);
    };

    fetchData();
  }, []);

  const setInitialActive = (newData) => {
    const nullIndex = newData.findIndex((item) => item.active === null);
    if (nullIndex !== -1) {
      newData[nullIndex].active = true;
    } else if (newData.length > 1) {
      newData[1].active = true;
    }
    setData([...newData]);
  };
  return (
    <section dir={"ltr"} id="Price" className="Price">
      <h2 className="heading">
        <span>{t("N3")}</span>
      </h2>
      {loading && <Loading />}
      <div className="Cards">
        {!loading && data.length === 0 && <NotFound />}
        {!loading &&
          data.map((item, index) => (
            <div key={index} className="offer">
              <div className="offer-info">
                <h1>{i18n.language === "en" ? item.titleE : item.titleA}</h1>
                <div className="offer-options">
                  {item.Dscrp.map((description, idx) => (
                    <p key={idx} className="item-container">
                      <span>&#10004; </span> {description}
                    </p>
                  ))}
                </div>
                <div className="footer-info">
                  <h1>{item.Price}</h1>
                </div>
              </div>
              <div className="btnContainer">
                <button>{t("ChoidePrice")}</button>
              </div>
            </div>
          ))}
      </div>
    </section>
  );
}

export default Price;
