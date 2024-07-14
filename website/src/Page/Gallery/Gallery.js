import React, { useState, useEffect } from "react";
import "./Gallery.css";
import { useTranslation } from "react-i18next";
import { collection, getDocs, getFirestore } from "firebase/firestore";
import Loading from "../Loading/loading";
import app from "../../firebaseapi";
import NotFound from "../NotFound/NotFound";

function Gallery() {
  const [t] = useTranslation();
  const [currentPage, setCurrentPage] = useState(1);
  const imagesPerPage = 10;
  const [maxButtons, setMaxButtons] = useState(10);
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState([]);
  const [model, setmodel] = useState(false);
  const [tempimgSrc, setTempimgSrc] = useState("");
  const viewimg = (imgsrc) => {
    setTempimgSrc(imgsrc);
    setmodel(true);
  };
  const closePopup = () => {
    setmodel(false);
  };
  useEffect(() => {
    const fetchData = async () => {
      const db = getFirestore(app);

      const colRef = collection(db, "gallery");
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
        onClick={() => setCurrentPage(i)}
        className={(currentPage === i ? "active " : "") + "pagging-btn"}
      >
        {i}
      </button>
    );
  }

  return (
    <section id="gallery" className="gallery">
      {model && (
        <div className="popup" onClick={closePopup}>
          <span className="close-btn" onClick={closePopup}>
            <i class="bx bx-x"></i>
          </span>
          <img src={tempimgSrc} alt="" onClick={(e) => e.stopPropagation()} />
        </div>
      )}
      <h2 className="heading">
        <span>{t("A5")}</span>
      </h2>
      {loading && <Loading />}
      {!loading && currentImages.length === 0 && <NotFound />}

      <div>
        {!loading && currentImages.length > 0 && (
          <>
            <div className="gallery-img">
              {currentImages.map((gallery, index) => (
                <div key={index} onClick={() => viewimg(gallery.img)}>
                  <img src={gallery.img} alt={`${index}`} />
                </div>
              ))}
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
      </div>
    </section>
  );
}

export default Gallery;
