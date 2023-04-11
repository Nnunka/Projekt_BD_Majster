import React, { Component } from "react";
import { Router, Switch, Route } from "react-router-dom";
import Logowanie from "./componentsJS/Logowanie";
import Menu from "./componentsJS/Menu";
import history from "./history";

function Routes() {
    return (
        <Router history={history}>
                <Switch>
                <Route path="/" exact component={Logowanie} />
                    <Route path="/Logowanie" exact component={Logowanie} />
                    <Route path="/Menu" component={Menu} />
                </Switch>
            </Router>
    )
}
export default Routes;