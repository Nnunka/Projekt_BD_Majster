const LocalStrategy = require ("passport-local").Strategy; 
const {pool} = require("./dbConfig"); 


function initialize (passport) {
  const authenticateUser = (login, password, done) => {
    pool.query(
      `SELECT * FROM users WHERE user_login = $1`, 
      [login],
      (err, results) => {
        if (err) {
          throw err;
        }
        console.log(results.rows);

          if (results.rows.length > 0) {
            const user = results.rows[0];
            if (password === user.user_password) { 
              return done(null, user);
              } else {
                return done(null, false, { message: "Podałeś złe hasło!" });
              }
            } else {
              return done(null, false, { message: "Taki użytkownik nie istnieje!" });
              }
            }
          );
    };

    passport.use(new LocalStrategy({
        usernameField: "login", 
        passwordField: "password" 
    },
    authenticateUser // Funkcja uwierzytelniająca użytkownika
    )
    );

    // Serializuj użytkownika
    passport.serializeUser((user, done) => done(null, user.user_id));

    passport.deserializeUser((id, done) => {
        pool.query(`SELECT * FROM users WHERE user_id = $1`, [id], (err, results) => {
          if (err) {
            throw err;
          }
          return done(null, results.rows[0]);
        });
      });
}

module.exports = initialize;