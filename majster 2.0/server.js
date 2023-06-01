const express = require("express");
const { pool } = require("./dbConfig");
const passport = require("passport");
const flash = require("express-flash");
const session = require("express-session");
const path = require("path");

const moment = require('moment'); //biblioteka moment to zmiany formatu daty
const momentTimezone = require('moment-timezone'); //bibioteka do ustawienia domyślnej strefy czasowej 
momentTimezone.tz.setDefault('Europe/Warsaw'); //ustawienie strefy czasowej 
moment.locale('pl'); //żeby ładnie daty się wyświetlały 

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
    saveUninitialized: true, //wartość true pozwala na przechowywanie danych w sesji
    cookie: {
        maxAge: 60 * 60 * 1000 // ustaw maksymalny czas życia ciasteczka sesji na 1 godzinę
    }
}));

app.use(passport.initialize());
app.use(passport.session());
app.use(flash()); //przechowywanie i wyświetlanie informacji dla użytkowników w odpowiedzi na ich interakcje z serwerem

app.get("/", (req, res)=>{
  res.render("Login");
}); // ustawienie strony Logowania jako startowej

app.get("/Login", (req, res) =>{
  res.render("Login");
}); // obsługa żądania get, przejście na stronę - Login

app.get("/users/AddUser", checkNotAuthenticated, (req, res) => {
  res.render("users/AddUser");
}); // obsługa żądania get, przejście na stronę - AddUser

app.get("/users/Dashboard", checkNotAuthenticated, (req, res) =>{
  if(req.user.user_role=='user')
  {
    pool.query(`SELECT  CONCAT(u.user_name,' ' , u.user_surname) AS person_details, m.machine_name, m.machine_status, m.machine_id, t.task_id, t.task_title, t.task_details, 
    t.task_start_date_by_user, rt.realize_id
    FROM realize_tasks rt
    INNER JOIN users u ON u.user_id = rt.realize_user_id
    INNER JOIN machines m ON m.machine_id = rt.realize_machine_id
    INNER JOIN tasks t ON t.task_id = rt.realize_task_id
    WHERE u.user_id=$1;`,[req.user.user_id], function(error, results, fields) {  // wstawić z sesji user id albo co kolwiek i będzie grać
      if (error) throw error;
      const realize = results.rows.map(row => ({
        id: row.realize_id,
        person: row.person_details,
        machine: row.machine_name,
        machine_s:row.machine_status,
        details:row.task_details,
        task_start_date_by_user: row.task_start_date_by_user,
        task: row.task_title,
        TID:row.task_id,
        MID:row.machine_id
      }));
      let index = 0;
      res.locals.moment = moment; //trzeba zdefiniować aby móc użyć biblioteki moment do formatu daty
      res.render("users/Dashboard", { realize, index, userRole: req.user.user_role, user_name: req.user.user_name, user_surname: req.user.user_surname });
    });
  } 
  else if (req.user.user_role=='repairer') {
    pool.query(`SELECT s.service_id, s.service_title, mc.machine_name, s.service_details, mc.machine_type, mc.machine_id, a.alert_title, a.alert_details, a.alert_add_date 
    FROM services s 
    LEFT JOIN machines mc ON s.service_machine_id = mc.machine_id 
    LEFT JOIN alerts a ON a.alert_machine_id = mc.machine_id 
    WHERE s.service_exist = true AND s.service_status = 'W trakcie' AND s.service_user_id = $1;`,[req.user.user_id], function(error, results, fields) {
      if (error) throw error;
      const service = results.rows.map(row => ({
        id: row.service_id,
        title: row.service_title,
        machine: row.machine_name,
        details: row.service_details,
        type: row.machine_type,
        MID: row.machine_id,
        alertTitle: row.alert_title,
        alertDetails: row.alert_details,
        alertData: row.alert_add_date
      }));
      let index = 0;
      res.locals.moment = moment; //trzeba zdefiniować aby móc użyć biblioteki moment do formatu daty
      res.render("users/Dashboard", { service, index, userRole: req.user.user_role, user_name: req.user.user_name, user_surname: req.user.user_surname });
    });
  } 
  else {
    const date = new Date(1970, 0, 1, 0, 0, 0);
    pool.query(
      `SELECT task_id, task_title, task_details, task_start_date, task_exist, task_start_date_by_user
      FROM tasks WHERE task_exist=true AND task_start_date_by_user != $1 AND task_end_date=$1 ORDER BY task_id`,
      [date],
      function (error, results, fields) {
        if (error) throw error;
        const adminT = results.rows.map((row) => ({
          id: row.task_id,
          title: row.task_title,
          details: row.task_details,
          start_date: row.task_start_date,
          task_exist: row.task_exist,
          start_date_by_user: row.task_start_date_by_user,
        }));
  
        pool.query(
          `SELECT s.service_id, s.service_title, m.machine_name, s.service_details, s.service_start_date
          FROM services s 
          INNER JOIN machines m ON s.service_machine_id = m.machine_id 
          WHERE s.service_exist=true AND s.service_status='W trakcie'
          ORDER BY s.service_id;`,
          function (error, results, fields) {
            if (error) throw error;
            const adminS = results.rows.map((row) => ({
              id: row.service_id,
              title: row.service_title,
              machine_id: row.machine_name,
              details: row.service_details,
              start_date: row.service_start_date,
            }));
  
            let index = 0;
            res.locals.moment = moment; // trzeba zdefiniować, aby móc użyć biblioteki moment do formatu daty
            res.render("users/Dashboard", {
              adminT,
              adminS,
              index,
              userRole: req.user.user_role,
              user_name: req.user.user_name,
              user_surname: req.user.user_surname,
            });
          });
      });
    }
}); // po zalogowaniu wyświetla login i role zalogowanego użytkownika - Dashboard





app.get("/users/UsersList", checkNotAuthenticated, (req, res) => {
  pool.query('SELECT user_id, user_name, user_surname, user_email, user_login, user_password, user_role FROM users WHERE user_exist=true ORDER BY user_id', function(error, results, fields) {
    if (error) throw error;
    const users = results.rows.map(row => ({
      id: row.user_id,
      name: row.user_name,
      surname: row.user_surname,
      email: row.user_email,
      login: row.user_login,
      password: row.user_password,
      role: row.user_role
    }));
    let index = 0;
    res.render("users/UsersList", { users, index, userRole: req.user.user_role}); //odwołanie się do roli użytkownika poprzez zmienną userRole
  });
}); //przejście na stronę Pracownicy wraz z wyświetleniem pracowników zawartych w bazie danych

app.get("/machines/MachinesList", checkNotAuthenticated, (req, res) => {
  pool.query('SELECT machine_id, machine_name, machine_type, machine_status FROM machines WHERE machine_exist=true ORDER BY machine_id', function(error, results, fields) {
    if (error) throw error;
    const machines = results.rows.map(row => ({
      id: row.machine_id,
      name: row.machine_name,
      type: row.machine_type,
      status: row.machine_status,
    }));
    let index = 0;
    res.render("machines/MachinesList", { machines, index, userRole: req.user.user_role });
  });
}); //przejście na stronę Maszyny wraz z wyświetleniem maszyn zawartych w bazie danych

app.get("/tasks/TaskList", checkNotAuthenticated, (req, res) => {
  pool.query(`SELECT task_id, task_title, task_details, task_add_date, task_start_date, task_end_date, task_exist, task_start_date_by_user
  FROM tasks WHERE task_exist=true ORDER BY task_id`, function(error, results, fields) {
    if (error) throw error;
    const tasks = results.rows.map(row => ({
      id: row.task_id,
      title: row.task_title,
      details: row.task_details,
      add_date: row.task_add_date,
      start_date: row.task_start_date,
      end_date: row.task_end_date,
      task_exist: row.task_exist,
      start_date_by_user: row.task_start_date_by_user
    }));
    let index = 0;
    res.locals.moment = moment; //trzeba zdefiniować aby móc użyć biblioteki moment do formatu daty
    res.render("tasks/TaskList", { tasks, index, userRole: req.user.user_role});
  });
}); //przejście na stronę Zadania wraz z wyświetleniem zadań zawartych w bazie danych

app.get("/services/ServicesList", checkNotAuthenticated, (req, res) => {
  pool.query(`SELECT s.service_id, s.service_title, m.machine_id, m.machine_name, s.service_details, s.service_start_date, s.service_end_date, s.service_exist, s.service_status
  FROM services s 
  INNER JOIN machines m ON s.service_machine_id = m.machine_id 
  WHERE service_exist=true
  ORDER BY s.service_id;`, function(error, results, fields) {
    if (error) throw error;
    const services = results.rows.map(row => ({
      id: row.service_id,
      title: row.service_title,
      machine_id: row.machine_name,
      machine_ID_RLY: row.machine_id,
      details: row.service_details,
      start_date: row.service_start_date,
      end_date: row.service_end_date,
      service_exist: row.service_exist,
      service_status: row.service_status
    }));
    let index = 0;
    res.locals.moment = moment; //trzeba zdefiniować aby móc użyć biblioteki moment do formatu daty
    res.render("services/ServicesList", { services, index, userRole: req.user.user_role });
  });
}); //przejście na stronę Serwis wraz z wyświetleniem serwisów zawartych w bazie danych

app.get("/alerts/AlertsList", checkNotAuthenticated, (req, res) => {
  pool.query(`SELECT a.alert_id, a.alert_title, a.alert_exist, CONCAT(u.user_name, ' ', u.user_surname ) AS who_add , alert_details, alert_add_date
   FROM alerts a INNER JOIN users u ON a.alert_who_add_id=u.user_id WHERE alert_exist=true ORDER BY alert_id`, function(error, results, fields) {
    if (error) throw error;
    const alerts = results.rows.map(row => ({
      id: row.alert_id,
      title: row.alert_title,
      who_add_id: row.who_add,
      details: row.alert_details,
      add_date: row.alert_add_date
    }));
    let index = 0;
    res.locals.moment = moment; //trzeba zdefiniować aby móc użyć biblioteki moment do formatu daty
    res.render("alerts/AlertsList", { alerts, index, userRole: req.user.user_role });
  });
}); //przejście na stronę Zgłoszenia wraz z wyświetleniem zgłoszeń zawartych w bazie danych

app.get("/realizes/RealizesList", checkNotAuthenticated, (req, res) => {
  pool.query(`SELECT  CONCAT(u.user_name,' ' , u.user_surname) AS person_details, m.machine_name, t.task_title, rt.realize_id
  FROM realize_tasks rt
  INNER JOIN users u ON u.user_id = rt.realize_user_id
  INNER JOIN machines m ON m.machine_id = rt.realize_machine_id
  INNER JOIN tasks t ON t.task_id = rt.realize_task_id;`, function(error, results, fields) {
    if (error) throw error;
    const realize = results.rows.map(row => ({
      id: row.realize_id,
      person: row.person_details,
      machine: row.machine_name,
      task: row.task_title
    }));
    let index = 0;
    res.render("realizes/RealizesList", { realize, index, userRole: req.user.user_role });
  });
}); //przejście na stronę Zgłoszenia wraz z wyświetleniem zgłoszeń zawartych w bazie danych


////////////////////////////////////HISTORIA////////////////////////////////////////
app.get("/tasks/TaskHistory", checkNotAuthenticated, (req, res) => {
  pool.query(`SELECT task_id, task_title, task_details, task_add_date, task_start_date, task_end_date, task_exist, task_start_date_by_user,
  TO_CHAR(ROUND(EXTRACT(EPOCH FROM (task_end_date - task_start_date_by_user)) / 3600.0, 2), 'FM00') || ':' || 
  TO_CHAR(EXTRACT(MINUTE FROM (task_end_date - task_start_date_by_user)), 'FM00') AS czas_pracy
  FROM tasks WHERE task_exist=false ORDER BY task_id DESC`, function(error, results, fields) {
    if (error) throw error;
    const tasksH = results.rows.map(row => ({
      id: row.task_id,
      title: row.task_title,
      details: row.task_details,
      add_date: row.task_add_date,
      start_date: row.task_start_date,
      end_date: row.task_end_date,
      start_date_by_user: row.task_start_date_by_user,
      czas_pracy: row.czas_pracy
    }));
    let index = 0;
    res.locals.moment = moment; //trzeba zdefiniować aby móc użyć biblioteki moment do formatu daty
    res.render("tasks/TaskHistory", { tasksH, index, userRole: req.user.user_role});
  });
});

app.get("/services/ServiceHistory", checkNotAuthenticated, (req, res) => {
  pool.query(`SELECT s.service_id, s.service_title, m.machine_id, m.machine_name, s.service_details, s.service_start_date, s.service_end_date, s.service_exist, s.service_status
  FROM services s INNER JOIN machines m ON s.service_machine_id = m.machine_id WHERE service_exist=false
  ORDER BY s.service_id;`, function(error, results, fields) {
    if (error) throw error;
    const servicesH = results.rows.map(row => ({
      id: row.service_id,
      title: row.service_title,
      machine_id: row.machine_name,
      machine_ID_RLY: row.machine_id,
      details: row.service_details,
      start_date: row.service_start_date,
      end_date: row.service_end_date,
      service_exist: row.service_exist,
      service_status: row.service_status
    }));
    let index = 0;
    res.locals.moment = moment; //trzeba zdefiniować aby móc użyć biblioteki moment do formatu daty
    res.render("services/ServiceHistory", { servicesH, index, userRole: req.user.user_role });
  });
});

app.get("/alerts/AlertHistory", checkNotAuthenticated, (req, res) => {
  pool.query(`SELECT a.alert_id, a.alert_title, a.alert_exist, CONCAT(u.user_name, ' ', u.user_surname ) AS who_add , alert_details, alert_add_date
   FROM alerts a INNER JOIN users u ON a.alert_who_add_id=u.user_id WHERE alert_exist=false ORDER BY alert_id`, function(error, results, fields) {
    if (error) throw error;
    const alertsH = results.rows.map(row => ({
      id: row.alert_id,
      title: row.alert_title,
      who_add_id: row.who_add,
      details: row.alert_details,
      add_date: row.alert_add_date
    }));
    let index = 0;
    res.locals.moment = moment; //trzeba zdefiniować aby móc użyć biblioteki moment do formatu daty
    res.render("alerts/AlertHistory", { alertsH, index, userRole: req.user.user_role });
  });
}); //przejście na stronę Zgłoszenia wraz z wyświetleniem zgłoszeń zawartych w bazie danych


//////////////////////////////////DODANIE NOWEGO UŻYTKOWNIKA/////////////////////////////////////////////////
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
    // Sprawdzenie czy dany login jest już w bazie
    pool.query(
      `SELECT * FROM users WHERE user_login = $1`, [login], (err, result) => {
        if (err) {
          throw err;
        }
        console.log(result.rows);
        if (result.rows.length > 0) {
          errors.push({ message: "Taki login jest już w bazie!" })
          res.render("users/AddUser", { errors });
        } else {
          // Sprawdzenie czy dany email jest już w bazie
          pool.query(
            `SELECT * FROM users WHERE user_email = $1`, [email], (err, result) => {
              if (err) {
                throw err;
              }
              console.log(result.rows);
              if (result.rows.length > 0) {
                errors.push({ message: "Taki email jest już w bazie!" })
                res.render("users/AddUser", { errors });
              } else {
                // Jeśli wszystko git - Dodanie użytkownika do bazy
                pool.query(
                  `INSERT INTO users (user_name, user_surname, user_email, user_login, user_password, user_role)
                  VALUES ($1, $2, $3, $4, $5, $6) RETURNING user_id, user_password`, [name, surname, email, login, password, role],
                  (err, results) => {
                    if (err) {
                      throw err;
                    }
                    console.log(results.rows);
                    console.log("Nowy użytkownik w bazie") 
                    req.flash("success_msg", "Dodano nowego użytkownika");
                    res.redirect("/users/UsersList");
                });
          }});
    }});
}});

//////////////////////////////////DODANIE NOWEGO ZADANIA/////////////////////////////////////////////////
app.get("/tasks/AddTask", checkNotAuthenticated, (req, res) => {
  res.render("tasks/AddTask");
}); // obsługa żądania get, przejście na stronę - AddTask

// dodanie nowego zadania do bazy poprzez formularz
app.post('/tasks/AddTask', async (req, res) => {
  const { title, details } = req.body;

  const start_date = new Date(1970, 0, 1, 0, 0, 0);
  const end_date = new Date(1970, 0, 1, 0, 0, 0);
  const start_date_by_user = new Date(1970, 0, 1, 0, 0, 0);
  

  // Pobierz obecną datę jako timestamp
  const obecnaData = new Date();

  // dodanie zadania do bazy
  pool.query(
    `INSERT INTO tasks (task_title, task_details, task_add_date, task_start_date, task_end_date, task_start_date_by_user)
    VALUES ($1, $2, $3, $4, $5, $6)
    RETURNING task_id`,
    [title, details, obecnaData, start_date, end_date, start_date_by_user],
    (err, results) => {
      if (err) {
        throw err;
      }
      console.log(results.rows);
      console.log("Nowe zadanie w bazie");
      req.flash("success_msg", "Dodano nowe zadanie");
      res.redirect("/tasks/TaskList");
    }
  );
});

//////////////////////////////////DODANIE NOWEJ MASZYNY/////////////////////////////////////////////////
app.get("/machines/AddMachine", checkNotAuthenticated, (req, res) => {
  res.render("machines/AddMachine");
}); // obsługa żądania get, przejście na stronę - AddMachine


// dodanie nowej maszyny do bazy poprzez formularz
app.post('/machines/AddMachine', async (req, res) => {

  let { name, type, status} = req.body;
  console.log({
    name,
    type,
    status,
  })
  let errors = [];

  if (!name || !type || !status) {
    errors.push({ message: "Wypełnij wszystkie pola!" });
  }
  if (errors.length > 0) {
    res.render("/machines/AddMachine", { errors });
  } else {  
    // spr czy dana maszyna jest już w bazie
    pool.query(
      `SELECT * FROM machines 
      WHERE machine_name = $1`, [name], (err, result) => {
        if (err) {
          throw err
        }
        console.log(result.rows);
        if (result.rows.length > 0) {
          errors.push({ message: "Taka maszyna jest już w bazie!" })
          res.render("/machines/AddMachine", { errors });
        } else {
          // dodanie maszyny do bazy
          pool.query(
            `INSERT INTO machines (machine_name, machine_type, machine_status)
            VALUES ($1, $2, $3)
            RETURNING machine_id`, [name, type, status,],
            (err, results) => {
              if (err) {
                throw err;
              }
              console.log(results.rows);
              console.log("nowa maszyna w bazie") 
              req.flash("success_msg", "Dodano nową maszynę");
              res.redirect("/machines/MachinesList");
            })
        }}
    )}
});

//////////////////////////////////DODANIE NOWEGO SERWISOWANIA/////////////////////////////////////////////////
app.get('/machines/ServiceMachine/:id', checkAuthenticated, (req, res) => {
  const serviceId = req.params.id;

  pool.query('SELECT * FROM machines WHERE machine_id = $1', [serviceId], (err, result) => {
    if (err) {
      console.error(err);
      res.sendStatus(500);
      return;
    }

    if (result.rows.length === 0) {
      res.sendStatus(404);
      return;
    }

    const service = result.rows[0];
    res.render('machines/ServiceMachine', { serviceId: serviceId, serviceData: service });
  });
}); // obsługa żądania get, przejście na stronę - EditService


app.post('/machines/ServiceMachine/:id', checkAuthenticated, (req, res) => {
  const serviceId = req.params.id;

  const { title, machine, details} = req.body;

  const end_date = new Date(1970, 0, 1, 0, 0, 0);
  const obecnaData = new Date();

  pool.query(
    `INSERT INTO services (service_title, service_machine_id, service_details, service_start_date, service_end_date)
     VALUES ($1,$2,$3,$4,$5) RETURNING service_id`,[title, serviceId, details, obecnaData, end_date],
     (err, results) => {
      if (err) {
        throw err;
      }
      pool.query(
        'UPDATE machines SET machine_status = $2 WHERE machine_id = $1;',
        [serviceId, 'Serwis'],
         (err, results) => {
          if (err) {
            throw err;
          }
      console.log(results.rows);
      console.log("nowa zlecenie serwisowe w bazie")

      req.flash("success_msg", "Dodano nowego zlecenie serwisowe");
      res.redirect("/machines/MachinesList");
    });
  });
});

//////////////////////////////////DODANIE NOWEGO ZGŁOSZENIA/////////////////////////////////////////////////
app.get("/alerts/AddAlert", checkNotAuthenticated, (req, res) => {
  const alertId = req.params.id;
    res.render("alerts/AddAlert", { alertId: alertId, userRole: req.user.user_role });
});

// dodanie nowej zlecenia serwisowego do bazy poprzez formularz
app.post('/alerts/AddAlert', async (req, res) => {
  const userRole = req.user.user_role;
  const user= req.user.user_id;
  const { title, details} = req.body;

  const obecnaData = new Date();

  // dodanie zgłoszenia do bazy
  pool.query(
    `INSERT INTO alerts (alert_title, alert_who_add_id, alert_details, alert_add_date, alert_machine_id)
    VALUES ($1, $2, $3, $4, COALESCE((SELECT realize_machine_id FROM realize_tasks WHERE realize_user_id = $5), 0))
    RETURNING alert_id`,
    [title, user, details, obecnaData, user],
    (err, results) => {
      if (err) {
        throw err;
      }

      console.log(results.rows);
      console.log("nowe zgłoszenie w bazie");
      req.flash("success_msg", "Dodano nowe zgłoszenie");

      if (userRole === 'admin' || userRole === 'repairer') { res.redirect("/alerts/AlertsList"); }
      if (userRole === 'user'){ res.redirect("/users/Dashboard"); }
    }
  );
});


//////////////////////////////////DODANIE ZADANIA DO REALIZACJI/////////////////////////////////////////////////
app.get('/realizes/AddRealize/:id', checkAuthenticated, (req, res) => {
  const realizeId = req.params.id;

  pool.query(`SELECT u.user_id, CONCAT(u.user_name, ' ', u.user_surname) AS person_details, NULL AS machine_id, NULL AS machine_name, NULL AS task_title
  FROM users u LEFT JOIN realize_tasks rt ON u.user_id = rt.realize_user_id
  WHERE u.user_exist = true
    AND u.user_role = 'user'
    AND rt.realize_id IS NULL
    UNION ALL
    SELECT NULL AS user_id, NULL AS person_details, machine_id, machine_name, NULL AS task_title
    FROM machines WHERE machine_exist=true AND machine_status='Sprawna'
    UNION ALL
    SELECT NULL AS user_id, NULL AS person_details, NULL AS machine_id, NULL AS machine_name, task_title
    FROM tasks;`, function(error, results) {
    if (error) throw error;
    const realize = results.rows.map(row => ({
      Uid: row.user_id,
      person: row.person_details,
      Mid: row.machine_id,
      machine: row.machine_name,
      task: row.task_title
    }));
    res.render("realizes/AddRealize", { realizeId:realizeId, realizeData:realize });
  });
}) // obsługa żądania get, przejście na stronę - EditService


app.post('/realizes/AddRealize/:id', checkAuthenticated, (req, res) => {
  const realizeId = req.params.id;

  const { who_do, machine} = req.body;
 
  pool.query(
    `INSERT INTO realize_tasks (realize_user_id, realize_machine_id,realize_task_id)
     VALUES ( $1::bigint, $2::bigint , $3) RETURNING realize_id; `,[who_do, machine, realizeId],
     (err, results) => {
      if (err) {
        throw err;
      }
      pool.query(
        `UPDATE machines SET machine_status = 'W użyciu'
        WHERE machine_id = $1::bigint;`,[machine],
         (err, results) => {
          if (err) {
            throw err;
          }}
        );

        const obecnaData = new Date();

        pool.query(
          `UPDATE tasks SET task_start_date = $1
          WHERE task_id = $2::bigint;`,[obecnaData,realizeId],
           (err, results) => {
            if (err) {
              throw err;
            }}
          );
      req.flash("success_msg", "Dodano realizacjie do bazy");
      res.redirect("/realizes/RealizesList");
    });
});





////////////////////////////////////////EDYCJA ZADAŃ///////////////////////////////////////////
app.get('/tasks/EditTask/:id', checkAuthenticated, (req, res) => {
  const taskId = req.params.id;
  res.locals.moment = moment; //trzeba zdefiniować aby móc użyć biblioteki moment do formatu daty


  pool.query(`SELECT * FROM tasks WHERE task_id=$1`, [taskId], (err, result) => {
    if (err) {
      console.error(err);
      res.sendStatus(500);
      return;
    }

    if (result.rows.length === 0) {
      res.sendStatus(404);
      return;
    }

    const task = result.rows[0];
    res.render('tasks/EditTask', { taskId: taskId, taskData: task });
  });
}); // obsługa żądania get, przejście na stronę - EditTask


app.post('/tasks/EditTask/:id', checkAuthenticated, (req, res) => {
  const taskId = req.params.id;

  const { title, details, add_date, start_date, end_date } = req.body;

  pool.query(
    'UPDATE tasks SET task_title = $1, task_details = $2, task_add_date = $3, task_start_date = $4, task_end_date = $5 WHERE task_id = $6',
    [title, details, add_date, start_date, end_date, taskId],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }
      
      res.redirect('/tasks/TaskList');
    }
  );
});

////////////////////////////////////////EDYCJA UŻYTKOWNIKÓW///////////////////////////////////////////
app.get('/users/EditUser/:id', checkAuthenticated, (req, res) => {
  const userId = req.params.id;

  pool.query('SELECT * FROM users WHERE user_id = $1', [userId], (err, result) => {
    if (err) {
      console.error(err);
      res.sendStatus(500);
      return;
    }
    if (result.rows.length === 0) {
      res.sendStatus(404);
      return;
    }

    const user = result.rows[0];
    res.render('users/EditUser', { userId: userId, userData: user, errors: [] });
  });
});

app.post('/users/EditUser/:id', checkAuthenticated, (req, res) => {
  const userId = req.params.id;

  const { name, surname, email, login, password, role } = req.body;
  let errors = [];

  if (!name || !surname || !email || !login || !password || !role) {
    errors.push({ message: "Wypełnij wszystkie pola!" });
  }
  if (password.length < 4) {
    errors.push({ message: "Hasło musi mieć przynajmniej 4 znaki!" });
  }

  if (errors.length > 0) {
    const userData = { name, surname, email, login, password, role };
    res.render("users/EditUser", { userId: userId, userData: userData, errors });
  } else {
    pool.query(
      `SELECT * FROM users WHERE user_login = $1 AND user_id != $2`, //spr czy jest już taki login w bazie dla innych użytkowników niż ten którego edytujemy
      [login, userId],
      (err, result) => {
        if (err) {
          throw err;
        }

        if (result.rows.length > 0) {
          errors.push({ message: "Taki login jest już w bazie!" });
          const user = { 
            user_name: name,
            user_surname: surname,
            user_email: email,
            user_login: login,
            user_password: password,
            user_role: role
          }; //potrzebujemy tego, aby po wyręderowaniu błędu na stronie związanego z złym uzupełnieniem formularza, nie znikły dane domyślne pobrane z bazy
          res.render("users/EditUser", { userId: userId, userData: user, errors });
        } else {
          pool.query(
            `SELECT * FROM users WHERE user_email = $1 AND user_id != $2`, //spr czy jest już taki email w bazie dla innych użytkowników niż ten którego edytujemy
            [email, userId],
            (err, result) => {
              if (err) {
                throw err;
              }

              if (result.rows.length > 0) {
                errors.push({ message: "Taki email jest już w bazie!" });
                const user = {
                  user_name: name,
                  user_surname: surname,
                  user_email: email,
                  user_login: login,
                  user_password: password,
                  user_role: role
                }; //potrzebujemy tego, aby po wyręderowaniu błędu na stronie związanego z złym uzupełnieniem formularza, nie znikły dane domyślne pobrane z bazy
                res.render("users/EditUser", { userId: userId, userData: user, errors });
              } else {
                pool.query(
                  `UPDATE users SET user_name = $1, user_surname = $2, user_email = $3, user_login = $4, user_password = $5, user_role = $6  WHERE user_id = $7`,
                  [name, surname, email, login, password, role, userId],
                  (err, result) => {
                    if (err) {
                      console.error(err);
                      res.sendStatus(500);
                      return;
                    }

                    res.redirect('/users/UsersList');
                });
            }});
      }});
}});



////////////////////////////////////////EDYCJA MASZYNY///////////////////////////////////////////
app.get('/machines/EditMachine/:id', checkAuthenticated, (req, res) => {
  const machineId = req.params.id;

  pool.query('SELECT * FROM machines WHERE machine_id = $1', [machineId], (err, result) => {
    if (err) {
      console.error(err);
      res.sendStatus(500);
      return;
    }

    if (result.rows.length === 0) {
      res.sendStatus(404);
      return;
    }

    const machine = result.rows[0];
    res.render( 'machines/EditMachine', { machineId: machineId, machineData: machine });
  });
}); // obsługa żądania get, przejście na stronę - EditUser


app.post('/machines/EditMachine/:id', checkAuthenticated, (req, res) => {
  const machineId = req.params.id;

  const {name, type, status} = req.body;

  pool.query(
    'UPDATE machines SET machine_name = $1, machine_type = $2, machine_status = $3 WHERE machine_id = $4',
    [name, type, status, machineId],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }

      res.redirect('/machines/MachinesList');
    }
  );
});

////////////////////////////////////////EDYCJA SERWISOWANIA///////////////////////////////////////////
app.get('/services/EditService/:id', checkAuthenticated, (req, res) => {
  const serviceId = req.params.id;
  res.locals.moment = moment; //trzeba zdefiniować aby móc użyć biblioteki moment do formatu daty

  pool.query('SELECT * FROM services WHERE service_id = $1', [serviceId], (err, result) => {
    if (err) {
      console.error(err);
      res.sendStatus(500);
      return;
    }

    if (result.rows.length === 0) {
      res.sendStatus(404);
      return;
    }

    const service = result.rows[0];

    pool.query('SELECT service_id, service_title, service_machine_id, service_details, service_start_date, service_end_date FROM services WHERE service_id = $1', [serviceId], function(error, results) {
      if (error) throw error;
    const ONEidService = results.rows.map(row => ({
      service_machine_id: row.service_machine_id
    })); // pobranie ID z url 

    pool.query('SELECT * FROM machines', function(error, results) {
      if (error) throw error;
    const machine = results.rows.map(row => ({
      Mid: row.machine_id,
      machine: row.machine_name,
      exist: row.machine_exist
    }));
      res.render('services/EditService', { serviceId: serviceId, serviceData: service, machineData: machine, machineDataID: ONEidService, userRole: req.user.user_role });
    });
  });
});
}); // obsługa żądania get, przejście na stronę - EditService


app.post('/services/EditService/:id', checkAuthenticated, (req, res) => {
  const serviceId = req.params.id;

  const { title, machine, details, start_date, end_date } = req.body;
 
  pool.query(
    'UPDATE services SET service_title = $1, service_machine_id = $2, service_details = $3, service_start_date = $4, service_end_date = $5 WHERE service_id = $6',
    [title, machine, details, start_date, end_date, serviceId],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }

      res.redirect('/services/ServicesList');
    }
  );
});

////////////////////////////////////////EDYCJA ZGŁOSZEŃ///////////////////////////////////////////
app.get('/alerts/EditAlert/:id', checkAuthenticated, (req, res) => {
  const alertId = req.params.id;
  res.locals.moment = moment; //trzeba zdefiniować aby móc użyć biblioteki moment do formatu daty

  pool.query('SELECT * FROM alerts WHERE alert_id = $1', [alertId], (err, result) => {
    if (err) {
      console.error(err);
      res.sendStatus(500);
      return;
    }

    if (result.rows.length === 0) {
      res.sendStatus(404);
      return;
    }
    const alert = result.rows[0];

  pool.query('SELECT alert_id, alert_title, alert_who_add_id, alert_details, alert_add_date FROM alerts WHERE alert_id = $1', [alertId], function(error, results) {
    if (error) throw error;
  const ONEidAlert = results.rows.map(row => ({
    alert_who_add_id: row.alert_who_add_id,
  })); //POBRANIE ID Z URL

    pool.query(`SELECT user_id, CONCAT(user_name,' ', user_surname) AS person_name FROM users`, function(error, results) {
      if (error) throw error;
    const user = results.rows.map(row => ({
      Uid: row.user_id,
      person: row.person_name,
      exist: row.user_exist
    }));

      res.render('alerts/EditAlert', { alertId: alertId, alertData: alert, userData: user, alertDataID: ONEidAlert });
    });
  });
  });
}); // obsługa żądania get, przejście na stronę - EditAlert


app.post('/alerts/EditAlert/:id', checkAuthenticated, (req, res) => {
  const alertId = req.params.id;

  const { title, user, details, add_date } = req.body;
 
  pool.query(
    'UPDATE alerts SET alert_title = $1, alert_who_add_id = $2, alert_details = $3, alert_add_date = $4 WHERE alert_id = $5',
    [title, user, details, add_date, alertId],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }

      res.redirect('/alerts/AlertsList');
    }
  );
});

////////////////////////////////////////EDYCJA REALIZACJI///////////////////////////////////////////
app.get('/realizes/EditRealize/:id', checkAuthenticated, (req, res) => {
  const realizeId = req.params.id;
  res.locals.moment = moment; // Trzeba zdefiniować, aby móc używać biblioteki moment do formatowania daty

  pool.query(
    `SELECT u.user_id, CONCAT(u.user_name,' ', u.user_surname) AS person, m.machine_id, m.machine_name AS machine, t.task_title, t.task_id
    FROM realize_tasks rt
    INNER JOIN users u ON rt.realize_user_id = u.user_id
    INNER JOIN machines m ON rt.realize_machine_id = m.machine_id
    INNER JOIN tasks t ON rt.realize_task_id = t.task_id
    WHERE rt.realize_id = $1`, [realizeId], function(error, results) {
      if (error) throw error;
      const realizeUser = results.rows.map((row) => ({
        UidUSER: row.user_id,
        personUSER: row.person,
        MIdUSER: row.machine_id,
        machineUSER: row.machine,
        TIdUSER: row.task_id,
        taskUSER: row.task_title
      })); //pobierane dane TYLKO DLA ID WYŚWIETLAJĄCEGO SIĘ W URL
      

      pool.query(`SELECT u.user_id, CONCAT(u.user_name,' ', u.user_surname) AS person, m.machine_id, m.machine_name AS machine, t.task_title, t.task_id
      FROM realize_tasks rt
      INNER JOIN users u ON rt.realize_user_id = u.user_id
      INNER JOIN machines m ON rt.realize_machine_id = m.machine_id
      INNER JOIN tasks t ON rt.realize_task_id = t.task_id`, function(error, results) {
        if (error) throw error;
        const AllRealizeData = results.rows.map((row) => ({
          Uid: row.user_id,
          person: row.person,
          MId: row.machine_id,
          machine: row.machine,
          TId: row.task_id,
          task: row.task_title
        }));

        console.log(realizeUser);
        console.log(realizeId);
        console.log(AllRealizeData);
      res.render('realizes/EditRealize', {realizeId: realizeId, realizeUser: realizeUser, AllRealizeData: AllRealizeData });
    });
  });
});


app.post('/realizes/EditRealize/:id', checkAuthenticated, (req, res) => {
  const realizeId = req.params.id;

  const { who_do, machine, task } = req.body;
 
  pool.query(
    'UPDATE realize_tasks SET realize_user_id = $1, realize_machine_id = $2, realize_task_id = $3 WHERE realize_id = $4',
    [who_do, machine, task, realizeId],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }

      res.redirect('/realizes/RealizesList');
    }
  );
});


////////////////////////////////////////USUWANIE ZADAŃ///////////////////////////////////////////
app.get('/tasks/DeleteTask/:id', checkAuthenticated, (req, res) => {
  const taskId = req.params.id;

  pool.query(
    'UPDATE tasks SET task_exist=false WHERE task_id=$1',
    [taskId],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }
      pool.query(
        `UPDATE machines m
        SET machine_status = 'Sprawna'
        FROM realize_tasks rt
        WHERE m.machine_id = rt.realize_machine_id
              AND rt.realize_task_id = $1::bigint;`,
        [taskId],
        (err, result) => {
          if (err) {
            console.error(err);
            res.sendStatus(500);
            return;
          }
          pool.query(
            `DELETE FROM realize_tasks WHERE realize_task_id = $1`,[taskId],
             (err, results) => {
              if (err) {
                throw err;
              }
              res.redirect('/tasks/TaskList');
            });
        });
    });
});

////////////////////////////////////////USUWANIE UŻYTKOWNIKA///////////////////////////////////////////
app.get('/users/DeleteUser/:id', checkAuthenticated, (req, res) => {
  const userId = req.params.id;

  pool.query(
    'UPDATE users SET user_exist=false WHERE user_id = $1',
    [userId],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }

      res.redirect('/users/UsersList');
    }
  );
});

////////////////////////////////////////USUWANIE MASZYN///////////////////////////////////////////
app.get('/machines/DeleteMachine/:id', checkAuthenticated, (req, res) => {
  const machineId = req.params.id;

  pool.query(
    'UPDATE machines SET machine_exist=false WHERE machine_id = $1',
    [machineId],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }

      res.redirect('/machines/MachinesList');
    }
  );
});

////////////////////////////////////////USUWANIE SERWISOWANIA///////////////////////////////////////////
app.get('/services/DeleteService/:id/:Mid', checkAuthenticated, (req, res) => {
  const serviceId = req.params.id;
  const machineId = req.params.Mid;

  pool.query(
    'UPDATE machines SET machine_status = $2 WHERE machine_id = $1;',
    [machineId, 'Sprawna'],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }

  pool.query(
    'UPDATE services SET service_exist=false WHERE service_id=$1',
    [serviceId],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }



      res.redirect('/services/ServicesList');
    });
  });
});


////////////////////////////////////////USUWANIE ZGŁOSZEŃ///////////////////////////////////////////
app.get('/alerts/DeleteAlert/:id', checkAuthenticated, (req, res) => {
  const alertId = req.params.id;

  pool.query(
    'UPDATE alerts SET alert_exist=false WHERE alert_id = $1',
    [alertId],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }

      res.redirect('/alerts/AlertsList');
    }
  );
});

////////////////////////////////////////USUWANIE REALIZACJI///////////////////////////////////////////
app.get('/realizes/DeleteRealize/:id', checkAuthenticated, (req, res) => {
  const realizeId = req.params.id;

  pool.query(
    'DELETE FROM realize_tasks WHERE realize_id = $1',
    [realizeId],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }

      res.redirect('/realizes/RealizesList');
    }
  );
});

////////////////////////////////////////ROZPOCZĘCIE REALIZACJI///////////////////////////////////////////
app.get('/realizes/StartRealize/:Tid', checkAuthenticated, (req, res) => {
  const taskId = req.params.Tid;

  const obecnaData = new Date();

  pool.query(
    'UPDATE tasks SET task_start_date_by_user = $2 WHERE task_id = $1;',
    [taskId, obecnaData],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }

      res.redirect('/users/Dashboard');
  });
});

////////////////////////////////////////ZAKONCZENIE REALIZACJI///////////////////////////////////////////
app.get('/realizes/EndRealize/:Tid/:Mid', checkAuthenticated, (req, res) => {
  const taskId = req.params.Tid;
  const machineId = req.params.Mid;

  const obecnaData = new Date();

  pool.query(
    'UPDATE tasks SET task_end_date = $2 WHERE task_id = $1;',
    [taskId, obecnaData],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }
  
      pool.query(
        'UPDATE machines SET machine_status = $2 WHERE machine_id = $1;',
        [machineId, 'Sprawna'],
        (err, result) => {
          if (err) {
            console.error(err);
            res.sendStatus(500);
            return;
          }
  
          pool.query(
            'DELETE FROM realize_tasks WHERE realize_task_id = $1;',
            [taskId],
            (err, result) => {
              if (err) {
                console.error(err);
                res.sendStatus(500);
                return;
              }
              res.redirect('/users/Dashboard');
            });
        });
    });
  });

////////////////////////////////////////ROZPOCZĘCIE SERWISOWANIA///////////////////////////////////////////
app.get('/services/StartService/:Sid', checkAuthenticated, (req, res) => {
  const serviceId = req.params.Sid;

  const obecnaData = new Date();

  pool.query(
    'UPDATE services SET service_user_id= $2, service_status = $3 WHERE service_id = $1;',
    [serviceId, req.user.user_id, 'W trakcie'],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }

      res.redirect('/users/Dashboard');
  });
});

////////////////////////////////////////ZAKONCZENIE SERWISU///////////////////////////////////////////
app.get('/service/EndService/:id/:Mid', checkAuthenticated, (req, res) => {
  const serviceId = req.params.id;
  const machineId = req.params.Mid;

  const obecnaData = new Date();

  pool.query(
    `UPDATE services SET service_end_date = $2, service_status=$3 WHERE service_id = $1;`,
    [serviceId, obecnaData,'Wykonane'],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }
  
      pool.query(
        'UPDATE machines SET machine_status = $2 WHERE machine_id = $1;',
        [machineId, 'Sprawna'],
        (err, result) => {
          if (err) {
            console.error(err);
            res.sendStatus(500);
            return;
            }
          res.redirect('/users/Dashboard');
        });
    });
  });





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

// funkcja która sprawdza, czy użytkownik jest uwierzytelniony. Jeśli tak, przekierowuje go na stronę /users/Dashboard, jeśli nie, przekazuje żądanie dalej za pomocą funkcji next()
function checkAuthenticated(req, res, next) {
    if (req.isAuthenticated()) {
      return next();
    } 
    res.redirect("/Login");
  }

// funkcja która sprawdza, czy użytkownik jest uwierzytelniony. Jeśli tak, przekierowuje go na stronę /users/Dashboard, jeśli nie, przekierowuje z powrotem na stronę logowania - /Login.
function checkNotAuthenticated (req, res, next) {
    if (req.isAuthenticated()) {
        return next();
    }
    res.redirect("/Login");
}


app.listen(PORT, () => {
    console.log(`Serwer działa na porcie ${PORT}`);
});


