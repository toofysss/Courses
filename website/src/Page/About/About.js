import "./About.css";
import { useTranslation } from "react-i18next";

function About() {
  const [t, i18n] = useTranslation();
  const Abouts = [
    {
      Title: "The Idea of Found",
      Subtitle:
        "We are center that establish based on international agreement with specialized global centers have experience for many years in field of organization and management development which decided to unite the effort and cooperate on:",
      Data: [
        {
          Dscrp: "Upgrading administrative systems and quality of employees.",
        },
        {
          Dscrp:
            "Regulating the standard of management development quality and scientific global to ensure the quality of outcome.",
        },
        {
          Dscrp:
            "Supporting the communities and members to contribute in lifting of economic.",
        },
        {
          Dscrp:
            "Building close relations of international cooperate between individuals and institutions",
        },
      ],
    },
    {
      Title: "Founding of the Center",
      Subtitle: "",
      Data: [
        {
          Dscrp:
            "The center was founded in 2015 with a license of UK- Britain- London government.",
        },
        {
          Dscrp:
            "In 2016 other branch were opened in Qatar based on licensing from Qatari ministry education and higher education.",
        },
        {
          Dscrp: "In 2019 the centre was moved and settled in Canada.",
        },
      ],
    },
  ];
  // const Abouts2 = [
  //   {
  //     Title: "Training and Personal Development Field:",
  //     Subtitle:
  //       "We are not considering the course or training program an output of ours. But we regard our output as a skill that earn by our clients, which mean we are not introducing just a training course but also we make sure that our client gain a fully skill.In case where the skill of our clients are incomplete, the training program will be restored at the centre’s expense to address the failure that leads to incomplete of skill and we continue pursue until the client reach to level that has remarkable skill befitting to be one of our output that that we proud of to presenting it to community",
  //   },
  //   {
  //     Title:
  //       "In Field of Organizations and Administrative Development (companies, organizations, universities, schools, hospitals, factors, ministries … others)",
  //     Subtitle:
  //       "We make sure to develop of existing systems and establishing standards of global quality systems and following up until we make sure that they get certification of global quality; we also pursued output of their management to ensure that become achieving satisfaction of their client.",
  //   },
  // ];
  return (
    <section className="about" id="about">
      <h2 className="heading">
        <span>{t("N2")}</span>
      </h2>
      <div className="about-content">
        <div className="about-row">
          {Abouts.map((about, index) => (
            <div key={index} className="about-column">
              <div>
                <h2>{about.Title}</h2>
                <p>{about.Subtitle}</p>
                {about.Data.map((item, itemIndex) => (
                  <h3 key={itemIndex} className="item-container">
                    <i
                      className={`bx bx-chevrons-${
                        i18n.language === "en" ? "right" : "left"
                      }`}
                    ></i>
                    {item.Dscrp}
                  </h3>
                ))}
              </div>
            </div>
          ))}
        </div>
        {/* <div>
          <h2 className="heading">
            <span>OUR VISION</span>
          </h2>
          <h4>
            To be most common center in societies and markets and highest
            quality of services that introduces to our client.
          </h4>
        </div>
        <div>
          <h2 className="heading">
            <span>OUR MISSION</span>
          </h2>
          <h4>
            Making distinct professional skills for our client of individuals
            and organizations to support the community that have high quality of
            using the most successful developing training programs which based
            on scientific standards concludes by humanity development experts
            and leaders of professional and administrative development and
            providing global standards education.
          </h4>
        </div>
        <div>
          <h2 className="heading">
            <span>WHAT MAKE US REMARKABLE</span>
          </h2>
          <h4>
            We earned the trust of our client’s customers from individuals,
            communities and governments that we cooperated with through way in
            which we work on:
          </h4>
        </div>
        <div className="content">
          {Abouts2.map((about, index) => (
            <div key={index}>
              <h2>{about.Title}</h2>
              <p>{about.Subtitle}</p>
            </div>
          ))}
        </div> */}
      </div>
    </section>
  );
}

export default About;
