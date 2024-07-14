import React from "react";
import "./Home.css";
import homeimg from "../../Assets/Homeimg.png";
import { useTranslation } from "react-i18next";
import { Link, useNavigate } from "react-router-dom";

function Home() {
  const [t] = useTranslation();
  const navigate = useNavigate();

  const handleCourseClick = (news) => {
    navigate("/course");
  };
  return (
    <section className="home" id="home">
      <div className="home-content">
        <div className="text-animate">
          <h1>{t("HomeTitle")}</h1>
          <p>{t("HomeSubTitle")}</p>
          <div className="rwobtn">
            <button className="btn" onClick={handleCourseClick}>
              {t("GetStrated")}
            </button>
            <Link to={`/price`} className="Discovery">
              <i className="bx bx-play-circle"></i>
              {t("Started")}
            </Link>
          </div>
        </div>
      </div>

      <div className="home-img">
        <img src={homeimg} alt="My Logo"></img>
      </div>
    </section>
  );
}

export default Home;
