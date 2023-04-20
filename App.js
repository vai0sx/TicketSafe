import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import { Container } from 'react-bootstrap';
import './App.css';
import CreateExperience from './components/CreateExperience';
import ExperienceList from './components/ExperienceList';
import BuyTicket from './components/BuyTicket';
import ConfirmAttendance from './components/ConfirmAttendance';
import Withdraw from './components/Withdraw';
import NavBar from './components/NavBar';
import Welcome from './components/Welcome';
import Transactions from './components/Transactions';
import Wallet from './components/Wallet';
import { Web3ReactProvider } from '@web3-react/core';
import { Web3Provider } from '@ethersproject/providers';

function getLibrary(provider) {
  const library = new Web3Provider(provider);
  library.pollingInterval = 12000;
  return library;
}

function App() {
  return (
    <Web3ReactProvider getLibrary={getLibrary}>
      <Router>
        <NavBar />
        <Container>
          <Welcome />
          <Routes>
            <Route path="/" element={<ExperienceList />} index />
            <Route path="/create-experience" element={<CreateExperience />} />
            <Route path="/buy-ticket/:experienceId" element={<BuyTicket />} />
            <Route
              path="/confirm-attendance/:experienceId"
              element={<ConfirmAttendance />}
            />
            <Route path="/withdraw/:experienceId" element={<Withdraw />} />
            <Route path="/transactions" element={<Transactions />} />
            <Route path="/wallet" element={<Wallet />} />
          </Routes>
        </Container>
      </Router>
    </Web3ReactProvider>
  );
}

export default App;
