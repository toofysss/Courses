import React from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter as Router } from "react-router-dom";
import App from "./Page/Header/Header";
import "./i18n";
import "./firebaseapi";

const root = createRoot(document.getElementById("root"));

root.render(
  <Router>
    <App />
  </Router>
);
