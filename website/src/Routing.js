import React from "react";
import { Routes, Route } from "react-router-dom";
import Layout from "./Page/layout";
import Home from "./Page/Home/Home";
import AboutPage from "./Page/About/About";
import Services from "./Page/Services/Services";
import Price from "./Page/Price/Price";
import Gallery from "./Page/Gallery/Gallery";
import News from "./Page/News/News";
import Archive from "./Page/CourseArshive/Archive";
import Client from "./Page/Client/Client";
import SignIn from "./Page/SignIn/SignIn";
import NewsDetails from "./Page/News/NewsDetails";
import Courses from "./Page/Courses/Courses";

function Routing() {
  return (
    <Layout>
      <Routes>
        <Route path="*" element={<Home />} />
        <Route path="/about" element={<AboutPage />} />
        <Route path="/services" element={<Services />} />
        <Route path="/price" element={<Price />} />
        <Route path="/gallery" element={<Gallery />} />
        <Route path="/news" element={<News />} />
        <Route path="/archive" element={<Archive />} />
        <Route path="/client" element={<Client />} />
        <Route path="/signIn" element={<SignIn />} />
        <Route path="/course" element={<Courses />} />
        <Route path="/news/details" element={<NewsDetails />} />
      </Routes>
    </Layout>
  );
}

export default Routing;
