import React, { useState, useEffect } from "react";
import { collection, query, getDocs, getFirestore } from "firebase/firestore";
import app from "../../firebaseapi";
import Loading from "../Loading/loading";
import { useTranslation } from "react-i18next";
import "./Courses.css";
import NotFound from "../NotFound/NotFound";

function Portfolio() {
  const [filter, setFilter] = useState("*");
  const [t] = useTranslation();

  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      const db = getFirestore(app);

      const colRef = collection(db, "course");
      const snapshot = await getDocs(colRef);

      const coursesData = await Promise.all(
        snapshot.docs.map(async (doc) => {
          const courseData = doc.data();
          const projectId = doc.id;
          const projectQuery = query(collection(doc.ref, "Project"));
          const projectSnapshot = await getDocs(projectQuery);
          const projects = projectSnapshot.docs.map((projectDoc) => ({
            id: projectDoc.id,
            ...projectDoc.data(),
            active: false,
          }));
          return { id: projectId, ...courseData, projects };
        })
      );

      setData(coursesData);
      setLoading(false);
    };

    fetchData();
  }, []);

  const handleFilterClick = (value) => {
    setFilter(value);
  };

  return (
    <section className="course">
      <h2 className="heading">
        <span>{t("N5")}</span>
      </h2>
      {loading && <Loading />}
      {!loading && data.length === 0 && <NotFound />}
      <div>
        {!loading && data.length > 0 && (
          <>
            <main className="mainContainer">
              <div className="button-group">
                <button
                  className={`button ${filter === "*" ? "active" : ""}`}
                  onClick={() => handleFilterClick("*")}
                >
                  All
                </button>
                {data.length > 0 &&
                  data
                    .map((item) => item.category)
                    .filter(
                      (value, index, self) => self.indexOf(value) === index
                    )
                    .map((category, index) => (
                      <button
                        onClick={() => handleFilterClick(category)}
                        className={`button ${
                          filter === category ? "active" : ""
                        }`}
                        key={index}
                      >
                        {category}
                      </button>
                    ))}
              </div>

              <div className="gallery">
                {data
                  .filter(
                    (course) =>
                      (course.projects.length > 0 && filter === "*") ||
                      course.category === filter
                  )
                  .map((course, courseIndex) => (
                    <div className={`grid-item ${filter}`} key={courseIndex}>
                      {course &&
                        course.projects &&
                        course.projects.length > 0 &&
                        course.projects.map((project, index) => (
                          <div key={index} className="card">
                            <div>
                              <img alt="" src={project.img}></img>
                              <div className="panel">
                                <span className="date">{project.Title}</span>
                                <div className="customer rwobtn">
                                  <div>
                                    <i className="bx bx-user"></i>{" "}
                                    {project.Customer &&
                                    project.Customer.length > 0
                                      ? project.Customer.length
                                      : 0}
                                  </div>
                                  <button className="btn">
                                    {t("Rigester")}
                                  </button>
                                </div>
                              </div>
                            </div>
                          </div>
                        ))}
                    </div>
                  ))}
              </div>
            </main>
          </>
        )}
      </div>
    </section>
  );
}

export default Portfolio;
