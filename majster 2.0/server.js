const express = require("express");
const { pool } = require("./dbConfig");
const passport = require("passport");
const flash = require("express-flash");
const session = require("express-session");
const path = require("path");
require("dotenv").config();

const app = express();
const PORT = process.env.PORT || 5000; //port na którym działa aplikacja - jeśli nie znajdzie w pliku .env portu to domyślnie działa na porcie 5000

const initializePassport = require("./passportConfig"); //implementacja f. passport - do logowania 
initializePassport(passport);

app.use(express.static(path.join(__dirname, 'public'))); //ustawienie tego jako static pozwala np. na używanie css itp.
app.use(express.urlencoded({ extended: true })); //pozwala na przetwarzanie danych z formularzy - ta metoda automatycznie przetwarza dane z formularzy i tworzy obiekt, który jest dostępny w kodzie aplikacji
app.set("view engine", "ejs"); //ustawienie silnika widoku jako ejs
app.use(express.json()); //przetwarzanie danych w formacie JSON

app.use(session({
    secret: 'secret',
    resave: false,
    saveUninitialized: false,
    cookie: {
        maxAge: 60 * 60 * 1000 // ustaw maksymalny czas życia ciasteczka sesji na 1 godzinę
    }
}));

app.use(passport.initialize());
app.use(passport.session());
app.use(flash()); //przechowywanie i wyświetlanie informacji dla użytkowników w odpowiedzi na ich interakcje z serwerem


app.get("/", (req, res)=>{
  res.render("Login");
});

app.get("/Login", (req, res) =>{
  res.render("Login");
});



app.get("/users/UsersList", checkNotAuthenticated, (req, res) => {
  pool.query('SELECT user_name, user_surname, user_email, user_login, user_password, user_role FROM users', function(error, results, fields) {
    if (error) throw error;
    const users = results.rows.map(row => ({
      name: row.user_name,
      surname: row.user_surname,
      email: row.user_email,
      password:row.user_password,
      role:row.user_role
    }));
    let index = 0;
    res.render("users/UsersList", { users, index });
  });
});  //przejście na stronę Pracownicy




app.get("/users/AddUser", checkNotAuthenticated, (req, res) => {
  res.render("users/AddUser");
}); // obsługa żądania get, dodania nowego użytkownika - AddUser

app.get("/users/Dashboard", checkNotAuthenticated, (req, res) =>{
    res.render("users/Dashboard", {user: req.user.user_login }); 
}); // po zalogowaniu wyświetla login zalogowanego użytkownika - Dashboard

// obsługa żądania post, wylogowanie
app.post("/Logout", (req, res) =>{
    req.logout(() => {
        req.flash("success_msg", "Użytkownik wylogowany"); //komunikat flash - Użytkownik wylogowany w panelu logowania
        res.redirect("/Login"); //przekierowanie do strony logowania
      });
});


app.post("/Login", 
passport.authenticate("local", {
    successRedirect: "/users/Dashboard",
    failureRedirect: "/Login",
    failureFlash:true
}));

// Jest to funkcja pośrednicząca, która sprawdza, czy użytkownik jest 
// uwierzytelniony. Jeśli tak, przekierowuje go na stronę "/users Dashboard",
// a jeśli nie, przekazuje żądanie dalej za pomocą funkcji next().

function checkAuthenticated(req, res, next) {
    if (req.isAuthenticated()) {
      return next();
    } 
    res.redirect("/Login");
  }


// Jest to funkcja pośrednicząca, która sprawdza, czy użytkownik 
// jest nieuwierzytelniony. Jeśli tak, przekazuje żądanie dalej 
// za pomocą funkcji next(), a jeśli nie, przekierowuje użytkownika 
// z powrotem na stronę logowania "/users/logowanie".

function checkNotAuthenticated (req,res,next) {
    if (req.isAuthenticated()) {
        return next();
    }
    res.redirect("/Login");
}

app.listen(PORT, () => {
    console.log(`Serwer działa na porcie ${PORT}`);
});


