import React from 'react';
import {
  BrowserRouter as Router
} from 'react-router-dom'

import Routes from './Routes'
import AppTopNavigation from './Components/AppTopNavigation'
import AppFooter from './Components/AppFooter'

function App() {
  return (
    <Router>
      <div style={{display: 'flex', flexDirection: 'column', minHeight: '100vh'}}>
        <AppTopNavigation />
        <Routes />
        <AppFooter />
      </div>
    </Router>
  );
}

export default App;
