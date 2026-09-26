// src/App.jsx
import api from "./api";
import { useState } from "react";
import { Routes, Route, Navigate, useNavigate } from 'react-router-dom'
import Login from "./components/Login";
import Reset from "./components/Reset";
import MainPage from "./components/MainPage";
import NotFound from "./components/NotFound";


function App() {
  const navigate = useNavigate()

  const [isLoggedIn, setIsLoggedIn] = useState(
    !!localStorage.getItem("token")
  );
  const [userrole, setUserrole] = useState(
    Number(localStorage.getItem('userrole') ?? 2)
  );

  const [username, setUsername] = useState(localStorage.getItem("username") || "");
  const [password, setPassword] = useState("");

  const [error, setError] = useState("");

  const handleLogin = (e) => {
    e.preventDefault();

    api
      .post(`/auth/web/login`, { username, password })
      .then((res) => {
        let token = res.data.token;
        let userrole = res.data.user.role;
        if (userrole !== 2) {
          localStorage.setItem("token", token);
          localStorage.setItem("userrole", userrole);
          localStorage.setItem("username", username);
          setUserrole(userrole);

          setUsername(username);
          setPassword(password);

          setError("");

          setIsLoggedIn(true);

          navigate('/index')
        } else {
          setError("Invalid user");
        }
      })
      .catch(() => {
        setError("Invalid username or password");
      });
  };

  const handleLogout = () => {
    localStorage.removeItem("token");
    localStorage.removeItem('userrole');
    localStorage.removeItem('username');

    setIsLoggedIn(false);

    navigate('/login')
  };

  return (
    <Routes>
      <Route path="/" element={
        <Navigate
          to={
            isLoggedIn
              ? '/index'
              : '/login'
          }
          replace />
      } />
      <Route path="/login" element={
        isLoggedIn ? (
          <Navigate
            to="/index"
            replace />
        ) : (
          <Login
            username={username}
            setUsername={setUsername}
            password={password}
            setPassword={setPassword}
            error={error}
            onLogin={handleLogin}
          />
        )
      } />
      <Route path="/reset-password" element={
        <Reset />
      } />
      <Route
        path="/index"
        element={
          isLoggedIn ? (
            <MainPage
              username={username}
              userrole={userrole}
              onLogout={handleLogout} />
          ) : (
            <Navigate
              to="/login"
              replace />
          )
        } />
      <Route path="/unauthorized" element={<NotFound unauthorized />} />
      <Route path="*" element={<NotFound />} />
    </Routes>
  );
}

export default App;