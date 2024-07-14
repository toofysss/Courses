import React, { useState } from "react";
import "./SignIn.css";
import { useTranslation } from "react-i18next";
import firebase from "../../firebaseapi";
import {
  getAuth,
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  updateProfile,
} from "firebase/auth";
import { useNavigate } from "react-router-dom";

function App() {
  const [t] = useTranslation();
  const [isRightPanelActive, setRightPanelActive] = useState(false);
  //  Signin
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  // Sign up
  const [name, setName] = useState("");
  const [signemail, setsignEmail] = useState("");
  const [signpassword, setsignPassword] = useState("");
  const [signuperror, setsignupError] = useState("");

  const navigate = useNavigate();
  const auth = getAuth(firebase);

  const handleSignUpClick = () => {
    setRightPanelActive(true);
  };

  const handleSignInClick = () => {
    setRightPanelActive(false);
  };

  const handleSignup = async (e) => {
    e.preventDefault();
    try {
      const userCredential = await createUserWithEmailAndPassword(
        auth,
        signemail,
        signpassword
      );
      if (
        userCredential.user &&
        typeof userCredential.user.getIdToken === "function"
      ) {
        await updateProfile(userCredential.user, { displayName: name });
        setsignupError();
        localStorage.setItem("accessToken", userCredential.accessToken);
        navigate("/home");
      }
    } catch (error) {
      if (error.code === "auth/email-already-in-use") {
        setsignupError(t("signupAlredyAccount"));
      }
    }
  };
  const handleSignIn = async (e) => {
    e.preventDefault();
    try {
      const userCredential = await signInWithEmailAndPassword(
        auth,
        email,
        password
      );
      const user = userCredential.user;
      setError();
      localStorage.setItem("accessToken", user.accessToken);
      navigate("/home");
    } catch (error) {
      setError(t("signinfailed"));
      console.error("Error signing in:", error);
    }
  };
  return (
    <section className="Signin">
      <div className={`wrapper ${isRightPanelActive ? "active" : ""}`}>
        <span className="bg-animate"></span>
        <span className="bg-animate2"></span>
        <div className="form-box login">
          <h2 className="animation" style={{ "--i": 0, "--j": 21 }}>
            {t("signinbutton")}
          </h2>
          <form onSubmit={handleSignIn}>
            <div
              className="input-box animation"
              style={{ "--i": 1, "--j": 22 }}
            >
              <input
                type="text"
                required
                onChange={(e) => setEmail(e.target.value)}
              ></input>
              <label>{t("signinName")}</label>
              <i className="bx bxs-envelope"></i>
            </div>
            <div
              className="input-box animation"
              style={{ "--i": 2, "--j": 23 }}
            >
              <input
                type="password"
                required
                onChange={(e) => setPassword(e.target.value)}
              ></input>
              <label>{t("signinPassword")}</label>
              <i className="bx bxs-lock-alt"></i>{" "}
            </div>
            {error && <p className="error-message">{error}</p>}

            <button
              style={{ "--i": 3, "--j": 24 }}
              type="submit"
              className="btn animation"
            >
              {t("signinbutton")}
            </button>
            <div
              style={{ "--i": 4, "--j": 25 }}
              className="logreg-link animation"
            >
              <p>
                {t("signupcreataccount")}{" "}
                <button
                  type="button"
                  onClick={handleSignUpClick}
                  className="register-link"
                >
                  {t("signupbutton")}
                </button>
              </p>
            </div>
          </form>
        </div>
        <div className="info-text login">
          <h2 className="animation" style={{ "--i": 0, "--j": 20 }}>
            {t("signinTitle")}
          </h2>
          <p className="animation" style={{ "--i": 1, "--j": 21 }}>
            {t("signinsubtitle")}
          </p>
        </div>
        <div className="form-box rigester">
          <h2 className="animation" style={{ "--i": 17, "--j": 0 }}>
            {t("signupbutton")}
          </h2>
          <form onSubmit={handleSignup}>
            <div
              className="input-box animation"
              style={{ "--i": 18, "--j": 1 }}
            >
              <input
                type="text"
                required
                onChange={(e) => setName(e.target.value)}
              ></input>
              <label>{t("signupName")}</label>
              <i className="bx bx-user"></i>
            </div>
            <div
              className="input-box animation"
              style={{ "--i": 19, "--j": 2 }}
            >
              <input
                type="email"
                required
                onChange={(e) => setsignEmail(e.target.value)}
              ></input>
              <label>{t("signupEamil")}</label>
              <i className="bx bxs-envelope"></i>
            </div>
            <div
              className="input-box animation"
              style={{ "--i": 19, "--j": 2 }}
            >
              <input
                type="password"
                required
                onChange={(e) => setsignPassword(e.target.value)}
              ></input>
              <label>{t("signupPassword")}</label>
              <i className="bx bxs-lock-alt"></i>
            </div>
            {signuperror && <p className="error-message">{signuperror}</p>}

            <button
              type="submit"
              style={{ "--i": 20, "--j": 3 }}
              className="btn animation"
            >
              {t("signupbutton")}
            </button>
            <div
              style={{ "--i": 21, "--j": 4 }}
              className="logreg-link animation"
            >
              <p>
                {t("signinhaveaccount")}{" "}
                <button
                  type="button"
                  onClick={handleSignInClick}
                  className="register-link"
                >
                  {t("signupbutton")}
                </button>
              </p>
            </div>
          </form>
        </div>
        <div className="info-text rigester">
          <h2 className="animation" style={{ "--i": 17, "--j": 0 }}>
            {t("signupTitle")}
          </h2>
          <p className="animation" style={{ "--i": 18, "--j": 1 }}>
            {t("signupsubtitle")}
          </p>
        </div>
      </div>
    </section>
  );
}

export default App;
