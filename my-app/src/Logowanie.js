import './Logowanie.css';

function Logowanie() {
    return(
        <div className="login-form">
      <div className="login-container">
        <div className="logo">
          <img src='./logo.png' alt="logo"></img>
        </div>
        <p>Witamy w systemie Majster, proszę się zalogować.</p>
        <form>
          <div className="input-container">
            <lable>Login: </lable>
            <input type="text" name="" required></input>
          </div>
          <div className="input-container">
            <lable>Hasło: </lable>
            <input type="password" name="" required></input>
          </div>
          <div className="button-container">
            <input type="button" value="Zaloguj"></input>
          </div>
        </form>
      </div>
    </div>

        );
}
export default Logowanie;