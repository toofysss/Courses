import React from "react";
import Lottie from "lottie-react";
import groovyWalkAnimation from "../../Assets/NotFound.json";
import "./NotFound.css";
const NotFound = () => (
  <div className="LoadingContainer">
    <div className="Loading">
      <Lottie animationData={groovyWalkAnimation} loop={true} />
    </div>
  </div>
);

export default NotFound;
