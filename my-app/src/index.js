import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter as Router } from 'react-router-dom';

import './componentsCSS/index.css';
import Logownaie from './componentsJS/Logowanie';



const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <Router>
      <Logownaie/>
      <Routers/>
    </Router>

  </React.StrictMode>
);
