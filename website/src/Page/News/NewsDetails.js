import React from "react";
import { useTranslation } from "react-i18next";

import { useLocation } from "react-router-dom";
import Loading from "../Loading/loading";
import "./NewsDetails.css";
function NewsDetails() {
  const [, il8n] = useTranslation();

  const location = useLocation();
  const { news } = location.state || {};

  if (!news) {
    return <Loading />;
  }
  return (
    <section className="newsdetails" id="newsdetails">
      <div className="newsdetails-content">
        <div className="text-animate">
          <h1>{il8n.language === "en" ? news.titleE : news.titleA}</h1>

          <p>{news.Dscrp}</p>
        </div>
      </div>

      <div className="newsdetails-img">
        <img src={news.img} alt="My Logo"></img>
      </div>
    </section>
  );
}

export default NewsDetails;
