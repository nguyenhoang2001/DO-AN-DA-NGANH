// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.10/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.6.10/firebase-analytics.js";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyCMsYH0J7dGgLd7omjPvehk9xFuwrgvIvI",
  authDomain: "smarthome-comeherebae.firebaseapp.com",
  databaseURL: "https://smarthome-comeherebae-default-rtdb.firebaseio.com",
  projectId: "smarthome-comeherebae",
  storageBucket: "smarthome-comeherebae.appspot.com",
  messagingSenderId: "248113166726",
  appId: "1:248113166726:web:9ff9fdb4317863d0649407",
  measurementId: "G-M12QR210GZ",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
