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
      login: row.user_login,
      password: row.user_password,
      role: row.user_role
    }));
    let index = 0;
    res.render("users/UsersList", { users, index });
  });
});  //przejście na stronę Pracownicy wraz z wyświetleniem pracowników zawartych w bazie danych

app.get("/users/MachList", checkNotAuthenticated, (req, res) => {
  pool.query('SELECT machine_name, machine_type, machine_status FROM machines', function(error, results, fields) {
    if (error) throw error;
    const machines = results.rows.map(row => ({
      name: row.machine_name,
      type: row.machine_type,
      status: row.machine_status,
    }));
    let index = 0;
    res.render("users/MachList", { machines, index });
  });
});  //przejście na stronę Maszyny wraz z wyświetleniem maszyn zawartych w bazie danych

app.get("/users/TaskList", checkNotAuthenticated, (req, res) => {
  pool.query('SELECT task_title, task_details, task_add_date, task_start_date, task_end_date FROM tasks', function(error, results, fields) {
    if (error) throw error;
    const tasks = results.rows.map(row => ({
      title: row.task_title,
      details: row.task_details,
      add_date: row.task_add_date,
      start_date: row.task_start_date,
      end_date: row.task_end_date
    }));
    let index = 0;
    res.render("users/TaskList", { tasks, index });
  });
});  //przejście na stronę Zadania wraz z wyświetleniem zadań zawartych w bazie danych

app.get("/users/ServiceList", checkNotAuthenticated, (req, res) => {
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
    res.render("users/ServiceList", { users, index });
  });
});  //przejście na stronę Serwis

app.get("/users/AlertList", checkNotAuthenticated, (req, res) => {
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
    res.render("users/AlertList", { users, index });
  });
});  //przejście na stronę Zgłoszenia




app.get("/users/AddUser", checkNotAuthenticated, (req, res) => {
  res.render("users/AddUser");
}); // obsługa żądania get, przejście na stronę - AddUser

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

//////////////////////////////////////////////

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
              res.redirect("/users/UsersList");
            })
        }}
    )}
});


//////////////////////////////////////////////

app.get("/users/AddTask", checkNotAuthenticated, (req, res) => {
  res.render("users/AddTask");
}); // obsługa żądania get, przejście na stronę - AddTask

// dodanie nowego zadania do bazy poprzez formularz
app.post('/users/AddTask', async (req, res) => {

  let { title, details, add_date, start_date } = req.body;
  console.log({
    title,
    details,
    add_date,
    start_date,
  })
  let errors = [];

  if (!title || !details || !add_date || !start_date) {
    errors.push({ message: "Wypełnij wszystkie pola!" });
  }
  if (errors.length > 0) {
    res.render("users/AddTask", { errors });
  } else {  
    // spr czy dany tytuł zadania jest już w bazie
    pool.query(
      `SELECT * FROM tasks 
      WHERE task_title = $1`, [title], (err, result) => {
        if (err) {
          throw err
        }
        console.log(result.rows);
        if (result.rows.length > 0) {
          errors.push({ message: "Takie zadanie jest już w bazie!" })
          res.render("users/AddTask", { errors });
        } else {
          // dodanie użytkownika do bazy
          pool.query(
            `INSERT INTO tasks (task_title, task_details, task_add_date, task_start_date)
            VALUES ($1, $2, $3, $4)
            RETURNING task_id`, [title, details, add_date, start_date],
            (err, results) => {
              if (err) {
                throw err;
              }
              console.log(results.rows);
              console.log("nowy zadanie w bazie") 
              req.flash("success_msg", "Dodano nowe zadanie");
              res.redirect("/users/TaskList");
            })
        }}
    )}
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


