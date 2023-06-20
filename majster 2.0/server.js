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
const { machine } = require("os");
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
    pool.query(`SELECT s.service_id, s.service_title, mc.machine_name, s.service_details, mc.machine_type, mc.machine_id 
    FROM services s 
    LEFT JOIN machines mc ON s.service_machine_id = mc.machine_id 
    WHERE s.service_exist = true AND s.service_status = 'W trakcie' AND s.service_user_id = $1;`,[req.user.user_id], function(error, results, fields) {
      if (error) throw error;
      const service = results.rows.map(row => ({
        id: row.service_id,
        title: row.service_title,
        machine: row.machine_name,
        details: row.service_details,
        type: row.machine_type,
        MID: row.machine_id,
      }));
      pool.query(`
      SELECT a.alert_id, a.alert_title, a.alert_details, a.alert_add_date, a.alert_status, mc.machine_id, mc.machine_name, u.user_id
      FROM alerts a
      LEFT JOIN machines mc ON a.alert_machine_id = mc.machine_id 
      LEFT JOIN users u ON a.alert_repairer_id = u.user_id 
      WHERE a.alert_status='W trakcie' AND a.alert_exist=true AND a.alert_repairer_id = $1;`, [req.user.user_id], function(error, results, fields) {
      if (error) throw error;
      const alert = results.rows.map(row => ({
        id: row.alert_id,
        alertTitle: row.alert_title,
        alertDetails: row.alert_details,
        alertData: row.alert_add_date,
        alertStatus: row.alert_status,
        MID: row.machine_id,
        alertMachineName: row.machine_name
      }));
      let index = 0;
      res.locals.moment = moment; //trzeba zdefiniować aby móc użyć biblioteki moment do formatu daty
      res.render("users/Dashboard", { service, alert, index, userRole: req.user.user_role, user_name: req.user.user_name, user_surname: req.user.user_surname });
    });
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
          `SELECT s.service_id, s.service_title, m.machine_name, s.service_details, s.service_start_date, s.service_status
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
              status: row.service_status
            }));

            pool.query(
              `SELECT a.alert_id, a.alert_title, a.alert_details, a.alert_exist, a.alert_machine_id, a.alert_status, mc.machine_id, mc.machine_name FROM alerts a
              JOIN machines mc ON a.alert_machine_id = mc.machine_id
              WHERE a.alert_exist=true AND a.alert_status='W trakcie' ORDER BY a.alert_id;`,
              function (error, results, fields) {
                if (error) throw error;
                const adminA = results.rows.map((row) => ({
                  alerId: row.alert_id,
                  alertTitle: row.alert_title,
                  alertDetails: row.alert_details,
                  alertExist: row.alert_exist,
                  alertStatus: row.alert_status,
                  machineName: row.machine_name
                }));
  
            let index = 0;
            res.locals.moment = moment; // trzeba zdefiniować, aby móc użyć biblioteki moment do formatu daty
            res.render("users/Dashboard", {
              adminT,
              adminS,
              adminA,
              index,
              userRole: req.user.user_role,
              user_name: req.user.user_name,
              user_surname: req.user.user_surname,
            });
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
  pool.query(`SELECT s.service_id, s.service_title, m.machine_id, m.machine_name, s.service_details, s.service_start_date, s.service_end_date, s.service_exist, s.service_status, s.service_user_id
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
      service_status: row.service_status,
      service_user_id: row.service_user_id
    }));

    pool.query(`SELECT user_id, CONCAT(user_name, ' ', user_surname) AS person FROM users;`, function(error, results, fields) {
      if (error) throw error;
      const user = results.rows.map(row => ({
        user_id: row.user_id,
        person: row.person
      }));

      let index = 0;
    res.locals.moment = moment; //trzeba zdefiniować aby móc użyć biblioteki moment do formatu daty
    res.render("services/ServicesList", { services, user, index, userRole: req.user.user_role });
    });
  });
}); //przejście na stronę Serwis wraz z wyświetleniem serwisów zawartych w bazie danych

app.get("/alerts/AlertsList", checkNotAuthenticated, (req, res) => {
  pool.query(`SELECT a.alert_id, a.alert_title, a.alert_exist, CONCAT(u.user_name, ' ', u.user_surname ) AS who_add ,
   a.alert_details, a.alert_add_date, a.alert_status, a.alert_machine_id, m.machine_name, m.machine_id
   FROM alerts a INNER JOIN machines m ON a.alert_machine_id = m.machine_id
   INNER JOIN users u ON a.alert_who_add_id=u.user_id WHERE alert_exist=true ORDER BY alert_id`, function(error, results, fields) {
    if (error) throw error;
    const alerts = results.rows.map(row => ({
      id: row.alert_id,
      title: row.alert_title,
      who_add_id: row.who_add,
      details: row.alert_details,
      add_date: row.alert_add_date,
      status: row.alert_status,
      machine: row.alert_machine_id,
      machine_name: row.machine_name
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
  pool.query(`SELECT s.service_id, s.service_title, m.machine_id, m.machine_name, s.service_details, s.service_start_date, s.service_end_date, 
  s.service_exist, s.service_status, s.service_user_id FROM services s 
  INNER JOIN machines m ON s.service_machine_id = m.machine_id WHERE service_exist=false 
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
      service_status: row.service_status,
      service_user_id: row.service_user_id
    }));

    pool.query(`SELECT user_id, CONCAT(user_name, ' ', user_surname) AS person FROM users;`, function(error, results, fields) {
      if (error) throw error;
      const userH = results.rows.map(row => ({
        user_id: row.user_id,
        person: row.person
      }));

      let index = 0;
      res.locals.moment = moment;
      res.render("services/ServiceHistory", { servicesH, userH, index, userRole: req.user.user_role });
    });
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
app.get("/users/AddUser", checkNotAuthenticated, (req, res) => {
  res.render("users/AddUser");
}); // obsługa żądania get, przejście na stronę - AddUser

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

  if (errors.length > 0) {
    res.render("users/AddUser", { errors });
  } else {
    // spr czy dany login jest już w bazie
    pool.query(
      `SELECT * FROM users WHERE user_login = $1 AND user_exist=true`, [login], (err, result) => {
        if (err) {
          throw err;
        }
        console.log(result.rows);
        if (result.rows.length > 0) {
          errors.push({ message: "Taki login jest już w bazie!" })
          res.render("users/AddUser", { errors });
        } else {
          // spr czy dany email jest już w bazie
          pool.query(
            `SELECT * FROM users WHERE user_email = $1 AND user_exist=true`, [email], (err, result) => {
              if (err) {
                throw err;
              }
              console.log(result.rows);
              if (result.rows.length > 0) {
                errors.push({ message: "Taki email jest już w bazie!" })
                res.render("users/AddUser", { errors });
              } else {
                // jeśli wszystko git - dodanie użytkownika do bazy
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
  const { name, type } = req.body;
  console.log({ name, type });
  const errors = [];

  if (errors.length > 0) {
    res.render("machines/AddMachine", { errors });
  } else {
    // Sprawdzenie, czy dana nazwa maszyny już istnieje w bazie
    pool.query(
      `SELECT * FROM machines 
      WHERE machine_name = $1 and machine_exist=true`, 
      [name], 
      (err, result) => {
        if (err) {
          throw err;
        }
        console.log(result.rows);
        if (result.rows.length > 0) {
          errors.push({ message: "Maszyna o tej nazwie jest jest już w bazie!" });
          res.render("machines/AddMachine", { errors });
        } else {
          // Dodanie maszyny do bazy danych
          pool.query(
            `INSERT INTO machines (machine_name, machine_type, machine_status)
            VALUES ($1, $2, $3)
            RETURNING machine_id`, 
            [name, type, 'Sprawna'],
            (err, results) => {
              if (err) {
                throw err;
              }
              console.log(results.rows);
              console.log("Nowa maszyna w bazie.");
              req.flash("success_msg", "Dodano nową maszynę");
              res.redirect("/machines/MachinesList");
          });
        }
    });
}});


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

  const { title, machine, details } = req.body;

  const end_date = new Date(1970, 0, 1, 0, 0, 0);
  const obecnaData = new Date();

  pool.query(
    `INSERT INTO services (service_title, service_machine_id, service_details, service_start_date, service_end_date)
     VALUES ($1, $2, $3, $4, $5) RETURNING service_id`,
    [title, serviceId, details, obecnaData, end_date],
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

          pool.query(
            `UPDATE tasks t
            SET task_start_date = $2
            FROM realize_tasks rt
            WHERE t.task_id = rt.realize_task_id
              AND rt.realize_machine_id = $1::bigint;`,
            [serviceId, end_date],
            (err, result) => {
              if (err) {
                console.error(err);
                res.sendStatus(500);
                return;
              }

              pool.query(
                `DELETE FROM realize_tasks WHERE realize_machine_id = $1`,
                [serviceId],
                (err, results) => {
                  if (err) {
                    throw err;
                  }

                  console.log(results.rows);
                  console.log("Nowe zlecenie serwisowe w bazie");

                  req.flash("success_msg", "Dodano nowe zlecenie serwisowe");
                  res.redirect("/machines/MachinesList");
                    });
                });
            });
        });
    });

//////////////////////////////////DODANIE NOWEGO ZGŁOSZENIA/////////////////////////////////////////////////
app.get("/alerts/AddAlert", checkNotAuthenticated, (req, res) => {
  const alertId = req.params.id;

  pool.query(
    `SELECT machine_id, machine_name
    FROM machines WHERE machine_exist=true AND machine_status!='W serwisie';`,
    function(error, results) {
      if (error) throw error;

      const realize = results.rows.map(row => ({
        Mid: row.machine_id,
        machine: row.machine_name,
      }));

      res.render("alerts/AddAlert", {
        realizeData: realize,
        alertId: alertId,
        userRole: req.user.user_role
      });
    });
});

// dodanie nowej zlecenia serwisowego do bazy poprzez formularz
app.post('/alerts/AddAlert', async (req, res) => {
  const userRole = req.user.user_role;
  const userId = req.user.user_id;
  const { title, details, machine } = req.body;

  const obecnaData = new Date();

  // dodanie zgłoszenia do bazy
  pool.query(
    `INSERT INTO alerts (alert_title, alert_who_add_id, alert_details, alert_add_date, alert_machine_id, alert_status)
    VALUES ($1, $2, $3, $4, $5, 'Nie zaczęte')
    RETURNING alert_id`,
    [title, userId, details, obecnaData, machine],
    (err, results) => {
      if (err) {
        throw err;
      }
      pool.query(
        `UPDATE machines SET machine_status = 'Awaria'
        WHERE machine_id = $1::bigint;`,
        [machine],
        (err, results) => {
          if (err) {
            throw err;
          }

          console.log(results.rows);
          console.log("Nowe zgłoszenie w bazie");
          req.flash("success_msg", "Dodano nowe zgłoszenie");

          if (userRole === 'admin' || userRole === 'repairer') {
            res.redirect("/alerts/AlertsList");
          } else if (userRole === 'user') {
            res.redirect("/users/Dashboard");
          }
        });
    });
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

  const { title, details} = req.body;

  pool.query(
    'UPDATE tasks SET task_title = $1, task_details = $2 WHERE task_id = $3',
    [title, details, taskId],
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

  if (errors.length > 0) {
    const userData = { name, surname, email, login, password, role };
    res.render("users/EditUser", { userId: userId, userData: userData, errors });
  } else {
    pool.query(
      `SELECT * FROM users WHERE user_login = $1 AND user_id != $2 AND user_exist=true`, //spr czy jest już taki login w bazie jest już taki login 
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
            `SELECT * FROM users WHERE user_email = $1 AND user_id != $2 AND user_exist=true`, //spr czy jest już taki login w bazie jest już taki emial
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
                // jeśli wszystko git - dodanie użytkownika do bazy
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

  const { name, type } = req.body;
  let errors = [];

  if (errors.length > 0) {
    const machineData = { name, type };
    res.render("machines/EditMachine", { machineId, machineData, errors });
  } else {
    pool.query(
      `SELECT * FROM machines WHERE machine_name = $1 AND machine_id != $2 AND machine_exist=true`, //spr czy jest już taka nazwa maszyny jest już w bazie 
      [name, machineId],
      (err, result) => {
        if (err) {
          console.error(err);
          res.sendStatus(500);
          return;
        }

        if (result.rows.length > 0) {
          errors.push({ message: "Maszyna o tej nazwie jest jest już w bazie!" });
          const machineData = {
            machine_name: name,
            machine_type: type
          };
          res.render("machines/EditMachine", { machineId, machineData, errors });
        } else {
          pool.query(
            'UPDATE machines SET machine_name = $1, machine_type = $2 WHERE machine_id = $3',
            [name, type, machineId],
            (err, result) => {
              if (err) {
                console.error(err);
                res.sendStatus(500);
                return;
              }

              res.redirect('/machines/MachinesList');
            }
          );
        }
      }
    );
  }
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

    pool.query('SELECT service_id FROM services WHERE service_id = $1', [serviceId], function(error, results) {
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
    'UPDATE services SET service_title = $1, service_machine_id = $2, service_details = $3 WHERE service_id = $4',
    [title, machine, details, serviceId],
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

  pool.query('SELECT alert_id FROM alerts WHERE alert_id = $1', [alertId], function(error, results) {
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

  const { title, user, details } = req.body;
 
  pool.query(
    'UPDATE alerts SET alert_title = $1, alert_who_add_id = $2, alert_details = $3 WHERE alert_id = $4',
    [title, user, details, alertId],
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

////////////////////////////////////////USUWANIE ZADAŃ - TRNASAKCJA///////////////////////////////////////////
app.get('/tasks/DeleteTask/:id', checkAuthenticated, async (req, res) => {
  const taskId = req.params.id;

  const client = await pool.connect();

  try {
    await client.query('BEGIN'); // Rozpoczęcie transakcji

    await client.query('UPDATE tasks SET task_exist = false WHERE task_id = $1', [taskId]);

    await client.query(`UPDATE machines SET machine_status = 'Sprawna'
      FROM realize_tasks WHERE machines.machine_id = realize_tasks.realize_machine_id
      AND realize_tasks.realize_task_id = $1::bigint`, [taskId]);


    await client.query('DELETE FROM realize_tasks WHERE realize_task_id = $1', [taskId]);

    await client.query('COMMIT'); // Zatwierdzenie transakcji

    res.redirect('/tasks/TaskList');
  } catch (error) {
    await client.query('ROLLBACK'); // Wycofanie transakcji w przypadku błędu
    console.error(error);
    res.sendStatus(500);
  } finally {
    client.release(); // Zwolnienie klienta po zakończeniu transakcji
  }
});


////////////////////////////////////////USUWANIE UŻYTKOWNIKA - TRANSAKCJA///////////////////////////////////////////
app.get('/users/DeleteUser/:id', checkAuthenticated, async (req, res) => {
  const userId = req.params.id;
  const client = await pool.connect();

  try {
    await client.query('BEGIN'); // Rozpoczęcie transakcji

    const userRoleResult = await client.query(
      `SELECT * FROM users WHERE user_id = $1 AND user_role = 'repairer'`,
      [userId]
    );

    if (userRoleResult.rows.length > 0) {
      await client.query('UPDATE users SET user_exist = false WHERE user_id = $1', [userId]);
      await client.query('UPDATE services SET service_status = $1 WHERE service_user_id = $2', [
        'Nie zaczęte, service_user_id=0',
        userId
      ]);
    } else {
      await client.query('UPDATE users SET user_exist = false WHERE user_id = $1', [userId]);
      await client.query(
        `UPDATE machines m SET machine_status = 'Sprawna'
        FROM realize_tasks rt
        WHERE m.machine_id = rt.realize_machine_id
        AND rt.realize_user_id = $1::bigint;`,
        [userId]
      );
      await client.query(
        `UPDATE tasks t SET task_exist=false
        FROM realize_tasks rt
        WHERE t.task_id = rt.realize_task_id
        AND rt.realize_user_id = $1::bigint;`, //to poprawiłam i zmienia tylko flagę w taskach bo idk po co zmieniać datę przydzielenia zadania na 0 
        [userId]
      );
      await client.query('DELETE FROM realize_tasks WHERE realize_user_id = $1', [userId]);
    }

    await client.query('COMMIT'); // Zatwierdzenie transakcji

    res.redirect('/users/UsersList');
  } catch (error) {
    await client.query('ROLLBACK'); // Wycofanie transakcji w przypadku błędu
    console.error(error);
    res.sendStatus(500);
  } finally {
    client.release(); // Zwolnienie klienta po zakończeniu transakcji
  }
});

////////////////////////////////////////USUWANIE MASZYN - TRANSAKCJA///////////////////////////////////////////
app.get('/machines/DeleteMachine/:id', checkAuthenticated, async (req, res) => {
  const machineId = req.params.id;
  const start_date = new Date(1970, 0, 1, 0, 0, 0);

  const client = await pool.connect();

  try {
    await client.query('BEGIN'); // Rozpoczęcie transakcji

    await client.query('UPDATE machines SET machine_exist = false WHERE machine_id = $1', [machineId]);

    await client.query(`UPDATE tasks t SET task_start_date = $2
      FROM realize_tasks rt WHERE t.task_id = rt.realize_task_id
      AND rt.realize_machine_id = $1::bigint`, [machineId, start_date]);

    await client.query('DELETE FROM realize_tasks WHERE realize_machine_id = $1', [machineId]);

    await client.query('UPDATE services SET service_exist = false WHERE service_machine_id = $1', [machineId]);

    await client.query('COMMIT'); // Zatwierdzenie transakcji

    res.redirect('/machines/MachinesList');
  } catch (error) {
    await client.query('ROLLBACK'); // Wycofanie transakcji w przypadku błędu
    console.error(error);
    res.sendStatus(500);
  } finally {
    client.release(); // Zwolnienie klienta po zakończeniu transakcji
  }
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
      pool.query(
        'UPDATE machines SET machine_status = $1 FROM alerts WHERE machine_id = alert_machine_id;',
        ['Sprawna'],
        (err, result) => {
          if (err) {
            console.error(err);
            res.sendStatus(500);
            return;
          }
          res.redirect('/alerts/AlertsList');
        })
    });
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

////////////////////////////////////////ZAKONCZENIE REALIZACJI - TRANSAKCJA///////////////////////////////////////////
app.get('/realizes/EndRealize/:Tid/:Mid', checkAuthenticated, async (req, res) => {
  const taskId = req.params.Tid;
  const machineId = req.params.Mid;
  const obecnaData = new Date();

  const client = await pool.connect();

  try {
    await client.query('BEGIN'); // Rozpoczęcie transakcji

    await client.query('UPDATE tasks SET task_end_date = $2 WHERE task_id = $1;', [taskId, obecnaData]);
    await client.query('UPDATE machines SET machine_status = $2 WHERE machine_id = $1;', [machineId, 'Sprawna']);
    await client.query('DELETE FROM realize_tasks WHERE realize_task_id = $1;', [taskId]);

    await client.query('COMMIT'); // Zatwierdzenie transakcji

    res.redirect('/users/Dashboard');
  } catch (error) {
    await client.query('ROLLBACK'); // Wycofanie transakcji w przypadku błędu
    console.error(error);
    res.sendStatus(500);
  } finally {
    client.release(); // Zwolnienie klienta po zakończeniu transakcji
  }
});

////////////////////////////////////////ROZPOCZĘCIE SERWISOWANIA///////////////////////////////////////////
app.get('/services/StartService/:Sid', checkAuthenticated, (req, res) => {
  const serviceId = req.params.Sid;

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

////////////////////////////////////////ZAKONCZENIE SERWISU - TRANSAKCJA///////////////////////////////////////////
app.get('/service/EndService/:id/:Mid', checkAuthenticated, async (req, res) => {
  const serviceId = req.params.id;
  const machineId = req.params.Mid;

  const obecnaData = new Date();

  const client = await pool.connect();

  try {
    await client.query('BEGIN'); // Rozpoczęcie transakcji

    await client.query('UPDATE services SET service_end_date = $2, service_status=$3 WHERE service_id = $1;', [serviceId, obecnaData, 'Wykonane']);
    await client.query('UPDATE machines SET machine_status = $2 WHERE machine_id = $1;', [machineId, 'Sprawna']);

    await client.query('COMMIT'); // Zatwierdzenie transakcji

    res.redirect('/users/Dashboard');
  } catch (error) {
    await client.query('ROLLBACK'); // Wycofanie transakcji w przypadku błędu
    console.error(error);
    res.sendStatus(500);
  } finally {
    client.release(); // Zwolnienie klienta po zakończeniu transakcji
  }
});

////////////////////////////////////////ROZPOCZĘCIE AWARII///////////////////////////////////////////
app.get('/alerts/StartAlert/:Aid', checkAuthenticated, (req, res) => {
  const alertId = req.params.Aid;

  pool.query(
    'UPDATE alerts SET alert_status= $1, alert_repairer_id =$2 WHERE alert_id=$3',
    ['W trakcie',req.user.user_id,alertId],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }

      res.redirect('/alerts/AlertsList');
  });
});

////////////////////////////////////////ZAKONCZENIE AWARII - TRANSAKCJA///////////////////////////////////////////
app.get('/alerts/EndAlert/:Aid/:Mid', checkAuthenticated, async (req, res) => {
  const alertId = req.params.Aid;
  const machineId = req.params.Mid;

  const client = await pool.connect();

  try {
    await client.query('BEGIN'); // Rozpoczęcie transakcji

    await client.query('UPDATE alerts SET alert_status = $1 WHERE alert_id = $2', ['Wykonane', alertId]);
    await client.query('UPDATE machines SET machine_status = $1 WHERE machine_id = $2', ['Sprawna', machineId]);

    await client.query('COMMIT'); // Zatwierdzenie transakcji

    res.redirect('/users/Dashboard');
  } catch (error) {
    await client.query('ROLLBACK'); // Wycofanie transakcji w przypadku błędu
    console.error(error);
    res.sendStatus(500);
  } finally {
    client.release(); // Zwolnienie klienta po zakończeniu transakcji
  }
});

////////////////////////////////////////USUWANIE ZGŁOSZEŃ Z HISTORII - TRIGGER///////////////////////////////////////////
app.get('/alerts/ArchiveAlert/:id', checkAuthenticated, (req, res) => {
  const alertId = req.params.id;

  pool.query(
    'DELETE FROM alerts WHERE alert_id = $1',
    [alertId],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }   
      res.redirect('/alerts/AlertHistory'); 
    });
});

////////////////////////////////////////USUWANIE ZADAŃ Z HISTORII - TRIGGER///////////////////////////////////////////
app.get('/tasks/ArchiveTask/:id', checkAuthenticated, (req, res) => {
  const taskId = req.params.id;

  pool.query(
    'DELETE FROM tasks WHERE task_id = $1',
    [taskId],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }   
      res.redirect('/tasks/TaskHistory'); 
    });
});

////////////////////////////////////////USUWANIE SERWISÓW Z HISTORII - TRIGGER///////////////////////////////////////////
app.get('/services/ArchiveService/:id', checkAuthenticated, (req, res) => {
  const serviceId = req.params.id;

  pool.query(
    'DELETE FROM services WHERE service_id = $1',
    [serviceId],
    (err, result) => {
      if (err) {
        console.error(err);
        res.sendStatus(500);
        return;
      }   
      res.redirect('/services/ServiceHistory'); 
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


