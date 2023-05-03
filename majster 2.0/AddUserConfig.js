const {pool} = require("./dbConfig"); 

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
