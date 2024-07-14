import "./News.css";
import React, { useState, useEffect } from "react";
import { useTranslation } from "react-i18next";
import { collection, getDocs, getFirestore } from "firebase/firestore";
import Loading from "../Loading/loading";
import app from "../../firebaseapi";
import { useNavigate } from "react-router-dom";
import NotFound from "../NotFound/NotFound";

function News() {
  const [t, i18n] = useTranslation();
  const [currentPage, setCurrentPage] = useState(1);
  const imagesPerPage = 6;
  const [maxButtons, setMaxButtons] = useState(10);
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      const db = getFirestore(app);

      const colRef = collection(db, "News");
      const snapshot = await getDocs(colRef);
      const newData = snapshot.docs.map((doc) => ({
        ...doc.data(),
        active: false,
      }));
      setData(newData);
      setLoading(false);
    };

    fetchData();
    window.addEventListener("resize", handleResize);
    return () => {
      window.removeEventListener("resize", handleResize);
    };
  }, []);

  useEffect(() => {
    handleResize();
  }, [currentPage]);

  const handleResize = () => {
    window.innerWidth <= 500 ? setMaxButtons(6) : setMaxButtons(10);
  };

  const PageChange = (page) => {
    if (page === "next") {
      setCurrentPage(currentPage === totalPages ? 1 : currentPage + 1);
    } else if (page === "prev") {
      setCurrentPage(currentPage === 1 ? totalPages : currentPage - 1);
    } else if (page === "first") {
      setCurrentPage(1);
    } else if (page === "last") {
      setCurrentPage(totalPages);
    } else {
      setCurrentPage(page);
    }
  };
  const indexlast = currentPage * imagesPerPage;
  const indexfirst = indexlast - imagesPerPage;
  const currentImages = data.slice(indexfirst, indexlast);

  const totalImages = data.length;
  const totalPages = Math.ceil(totalImages / imagesPerPage);
  const startPage = Math.max(1, currentPage - Math.floor(maxButtons / 2));
  const endPage = Math.min(totalPages, startPage + maxButtons - 1);
  const pageButtons = [];
  for (let i = startPage; i <= endPage; i++) {
    pageButtons.push(
      <button
        key={i}
        onClick={() => PageChange(i)}
        className={(currentPage === i ? "active " : "") + "pagging-btn"}
      >
        {i}
      </button>
    );
  }
  const navigate = useNavigate();

  const handleCardClick = (news) => {
    navigate("/news/details", { state: { news: news } });
  };
  return (
    <section id="News" className="News">
      <h2 className="heading">
        <span>{t("A4")}</span>
      </h2>
      {loading && <Loading />}
      {!loading && currentImages.length === 0 && <NotFound />}
      {!loading && currentImages.length > 0 && (
        <>
          <div className="news-grid">
            <div className="column-card">
              {currentImages.map((news, index) => (
                <div key={index} className="card">
                  <div onClick={() => handleCardClick(news)}>
                    <img alt="" src={news.img}></img>
                    <div className="panel">
                      <span className="date">{news.year}</span>
                      <div>
                        <span className="breaker"></span>
                      </div>
                      <p>
                        {i18n.language === "en" ? news.titleE : news.titleA}
                      </p>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
          <div className="pagination col-lg-9 col-md-9 col-sm-12 ">
            <button
              key="first"
              onClick={() => PageChange("first")}
              className="pagging-btn"
            >
              <i className="bx bx-chevrons-left"></i>
            </button>
            <button
              key="prev"
              onClick={() => PageChange("prev")}
              className="pagging-btn"
            >
              <i className="bx bx-chevron-left"></i>
            </button>
            {pageButtons}
            <button
              key="next"
              onClick={() => PageChange("next")}
              className="pagging-btn"
            >
              <i className="bx bx-chevron-right"></i>
            </button>
            <button
              key="last"
              onClick={() => PageChange("last")}
              className="pagging-btn"
            >
              <i className="bx bx-chevrons-right"></i>
            </button>
          </div>
        </>
      )}
    </section>
  );
}

export default News;
