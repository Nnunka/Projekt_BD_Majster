const express = require("express");
const { pool } = require("./dbConfig");
const passport = require("passport");
const flash = require("express-flash");
const session = require("express-session");
const path = require("path");
require("dotenv").config();

const app = express();

const PORT = process.env.PORT || 5000;

const initializePassport = require("./passportConfig");
initializePassport(passport);

app.use(express.static(path.join(__dirname, 'public')));

app.use(express.urlencoded({ extended: true }));
app.set("view engine", "ejs");

app.use(express.json());

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
    res.render("users/logowanie");
});


app.get("/logowanie", (req, res) =>{
    res.render("users/logowanie");
});



// obsługa żądania get, dodania nowego użytkownika - AddUser
app.get("/users/AddUser", checkNotAuthenticated, (req, res) => {
    res.render("users/AddUser");
});


app.get("/users/Dashboard", checkNotAuthenticated, (req, res) =>{
    res.render("users/Dashboard", {user: req.user.user_login }); // po zalogowaniu wyświetla login zalogowanego użytkownika - Dashboard
});

// obsługa żądania post, wylogowanie
app.post("/Logout", (req, res) =>{
    req.logout(() => {
        req.flash("success_msg", "Użytkownik wylogowany"); //komunikat flash - Użytkownik wylogowany w panelu logowania
        res.redirect("/logowanie"); //przekierowanie do strony logowania
      });
});


//dodanie nowego użytkownika do bazy poprzez formularz
app.post('/users/AddUser', async (req, res) => {

    let { name, surname, email, login, password, role } = req.body;
    console.log({
      name,
      surname,
      email,
      login,
      password,
      role
    })
    let errors = [];
  
    if (!name || !surname || !email || !login || !password || !role) {
      errors.push({ message: "Wypełnij wszystkie pola!" });
    }
    if (password.length < 4) {
      errors.push({ message: "Hasło musi mieć przynajmniej 4 znaki!" });
    }
    if (errors.length > 0) {
      res.render("users/AddUser", { errors });
    } else {  
      //spr czy dany login jest w bazie
      pool.query(
        `SELECT * FROM users 
        WHERE user_login = $1`, [login], (err, result) => {
          if (err) {
            throw err
          }
          console.log(result.rows);
          if (result.rows.length > 0) {
            errors.push({ message: "Taki login jest już w bazie!" })
            res.render("users/AddUser", { errors });
          } else {
            // dodanie użytkownika do bazy
            pool.query(
              `INSERT INTO users (user_name, user_surname, user_email, user_login, user_password, user_role)
              VALUES ($1, $2, $3, $4, $5, $6)
              RETURNING user_id, user_password`, [name, surname, email, login, password, role],
              (err, results) => {
                if (err) {
                  throw err;
                }
                console.log(results.rows);
                console.log("nowy uzytkownik w bazie") 
                req.flash("success_msg", "Dodano nowego użytkownika");
                res.redirect("/users/Dashboard");
              })
          }}
      )}
  });

app.post("/logowanie", 
passport.authenticate("local", {
    successRedirect: "/users/Dashboard",
    failureRedirect: "/logowanie",
    failureFlash:true
}));




// Jest to funkcja pośrednicząca, która sprawdza, czy użytkownik jest 
// uwierzytelniony. Jeśli tak, przekierowuje go na stronę "/users Dashboard",
// a jeśli nie, przekazuje żądanie dalej za pomocą funkcji next().

function checkAuthenticated(req, res, next) {
    if (req.isAuthenticated()) {
      return next();
    } 
    res.redirect("/users/logowanie");
  }


// Jest to funkcja pośrednicząca, która sprawdza, czy użytkownik 
// jest nieuwierzytelniony. Jeśli tak, przekazuje żądanie dalej 
// za pomocą funkcji next(), a jeśli nie, przekierowuje użytkownika 
// z powrotem na stronę logowania "/users/logowanie".

function checkNotAuthenticated (req,res,next) {
    if (req.isAuthenticated()) {
        return next();
    }
    res.redirect("/users/logowanie");
}

app.listen(PORT, () => {
    console.log(`Serwer działa na porcie ${PORT}`);
});


