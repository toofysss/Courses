import i18n from "i18next";
import { initReactI18next } from "react-i18next";
const resources = {
  en: {
    translation: {
      // Navbar
      N1: "Home",
      N2: "About Us",
      N3: "Plans & Price",
      N4: "Services",
      N5: "Courses",
      N6: "Sign In",
      N7: "Sign Out",

      // Footer Title
      FT1: "About",
      FT2: "Follow Us",
      FT3: "Contact",

      // About
      A1: "Our Team & Leadership",
      A2: "Client’s Privileges",
      A3: "Courses Archives",
      A4: "News",
      A5: "Gallery",
      // Follow Us
      F1: "Youtube",
      F2: "Telegram",
      F3: "Twitter",
      F4: "Instagram",
      F5: "Facebook",
      // Contact
      C1: "Phone",
      C2: "Email",
      C3: "Telefax",

      // Lang
      lang: "Language",
      Ar: "Arabic",
      En: "English",
      // Home
      HomeTitle: "Learn Any New Skills From Us From Our Expert Mentor",
      HomeSubTitle:
        "Let's Discover New Lnowledge And Get Training From Professional Mentors",
      GetStrated: "Get Strated",
      Started: " See How it's Work",

      // Singup
      signupTitle: "Create Account",
      signupName: "Full Name",
      signupEamil: "Email",
      signupPassword: "Password",
      signupbutton: "Sign Up",
      signupsubtitle: "Join us today and become part of our growing community!",
      signupcreataccount: "Dont Have Account?",
      signupAlredyAccount: "The Email Is Alredy Account",
      // Sign in
      signinbutton: "Sign In",
      signinName: "Email",
      signinPassword: "Password",
      signinTitle: "Welcome Back",
      signinsubtitle: "Log in now and enjoy access to our exclusive features!",
      signinhaveaccount: "Alredy Have Account ?",
      signinfailed: "The Email Or Password Not Correct",
      forget: "Forget Your Password ?",
      allcatagory: "All",
      Rigester: "Rigester",

      ChoidePrice: "Choose A Plan",
    },
  },
  ar: {
    translation: {
      // Navbar
      N1: "الصفحة الرئيسية",
      N2: "من نحن",
      N3: "الخطط والاسعار",
      N4: "الخدمات",
      N5: "الكورسات",
      N6: "تسجيل الدخول",
      N7: "تسجيل الخروج",
      // Footer Title
      FT1: "عن",
      FT2: "تابعنا",
      FT3: "التواصل",

      // About
      A2: "امتيازات العميل",
      A3: "الأرشيف",
      A4: "الأخبار",
      A5: "الصور",
      // Follow Us
      F1: "يوتيوب",
      F2: "تلكرام",
      F3: "تويتر",
      F4: "انستغرام",
      F5: "فيس بوك",
      // Contact
      C1: "رقم الهاتف",
      C2: "الايميل",
      C3: "Telefax",

      // Lang
      lang: "اللغة",
      Ar: "العربية",
      En: "الأنكليزية",
      // Home
      HomeTitle: "تعلم أي مهارات جديدة منا من معلمنا الخبير",
      HomeSubTitle:
        "دعونا نكتشف معرفة جديدة ونحصل على التدريب من الموجهين المحترفين",
      GetStrated: "البدء",
      Started: "انظر كيف يعمل",
      // Singup
      signupTitle: "انشاء حساب",
      signupName: "الأسم كامل",
      signupEamil: "الأيميل",
      signupPassword: "كلمة المرور",
      signupbutton: "انشاء حساب",
      signupsubtitle: "انضم إلينا اليوم وكن جزءًا من مجتمعنا المتنامي!",
      signupcreataccount: "ليس لديك حساب؟",
      signupAlredyAccount: "البريد الإلكتروني هو حساب بالفعل",

      // Sign in
      signinbutton: "تسجيل الدخول",
      signinName: "الأيميل",
      signinPassword: "كلمة المرور",
      signinTitle: "مرحبًا بعودتك",
      signinsubtitle:
        "قم بتسجيل الدخول الآن واستمتع بالوصول إلى ميزاتنا الحصرية!",
      signinhaveaccount: "لديك حساب بالفعل؟",
      signinfailed: "البريد الإلكتروني أو كلمة المرور غير صحيحة",

      forget: "نسيت كلمة المرور؟",
      allcatagory: "All",
      Rigester: "الأشتراك",
      ChoidePrice: "اختر خطة",
    },
  },
};

i18n.use(initReactI18next).init({
  resources,
  lng: "en",
  interpolation: {
    escapeValue: false,
  },
  react: {
    useSuspense: false,
  },
});

export default i18n;
