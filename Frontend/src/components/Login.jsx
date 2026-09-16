// src/components/Login.jsx
import { useState } from "react";
import "../css/login.css";
import logo from "../assets/imgs/login_logo.png";

function UserIcon() {
    return (
        <svg viewBox="0 0 24 24" aria-hidden="true">
            <path d="M12 12.25a4.25 4.25 0 1 0 0-8.5 4.25 4.25 0 0 0 0 8.5Z" />
            <path d="M4.75 20.25c.35-4.05 2.78-6.1 7.25-6.1s6.9 2.05 7.25 6.1" />
        </svg>
    );
}

function LockIcon() {
    return (
        <svg viewBox="0 0 24 24" aria-hidden="true">
            <rect x="5.5" y="10" width="13" height="10" rx="2.2" />
            <path d="M8.5 10V7.8a3.5 3.5 0 0 1 7 0V10" />
        </svg>
    );
}

function EyeIcon({ visible }) {
    if (visible) {
        return (
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M2.8 12s3.1-5.2 9.2-5.2S21.2 12 21.2 12s-3.1 5.2-9.2 5.2S2.8 12 2.8 12Z" />
                <circle cx="12" cy="12" r="2.4" />
                <path d="m4 4 16 16" />
            </svg>
        );
    }

    return (
        <svg viewBox="0 0 24 24" aria-hidden="true">
            <path d="M2.8 12s3.1-5.2 9.2-5.2S21.2 12 21.2 12s-3.1 5.2-9.2 5.2S2.8 12 2.8 12Z" />
            <circle cx="12" cy="12" r="2.4" />
        </svg>
    );
}

function ShieldPawIcon() {
    return (
        <svg viewBox="0 0 64 64" aria-hidden="true">
            <path d="M32 6c8 5 15 6.5 22 7.6v14.8C54 42.6 45.2 52.5 32 58 18.8 52.5 10 42.6 10 28.4V13.6C17 12.5 24 11 32 6Z" />
            <ellipse cx="32" cy="35" rx="6.7" ry="5.4" />
            <ellipse cx="23.5" cy="27.5" rx="3.3" ry="4.3" />
            <ellipse cx="40.5" cy="27.5" rx="3.3" ry="4.3" />
            <ellipse cx="27.7" cy="22.7" rx="3.2" ry="4.1" />
            <ellipse cx="36.3" cy="22.7" rx="3.2" ry="4.1" />
        </svg>
    );
}

function Login({
    username,
    setUsername,
    password,
    setPassword,
    error,
    message,
    onLogin,
}) {
    const [rememberMe, setRememberMe] = useState(true);
    const [showPassword, setShowPassword] = useState(false);

    const handleSubmit = (event) => {
        if (onLogin) {
            onLogin(event, { rememberMe });
        }
    };

    return (
        <main className="login-page">
            <section className="login-visual">
                <div className="login-brand">
                    <img className="login-brand-logo" src={logo} alt="YiPet" />
                    <span className="login-brand-yipet">YiPet</span>
                </div>
                <div className="login-welcome">
                    <h1>
                        Welcome Back! <span className="wave">👋</span>
                    </h1>
                    <p>Sign in to access your YiPet admin dashboard</p>
                </div>
            </section>
            <section className="login-panel-wrap">
                <div className="login-panel">
                    <div className="login-security-icon">
                        <ShieldPawIcon />
                    </div>
                    <h2>
                        <span>Admin</span> Login
                    </h2>
                    <p className="login-subtitle">Enter your credentials to continue</p>
                    <form className="login-form" onSubmit={handleSubmit}>
                        <label className="login-field">
                            <span className="login-label">Username</span>
                            <span className="login-input-wrap">
                                <span className="login-input-icon">
                                    <UserIcon />
                                </span>
                                <input
                                    type="text"
                                    name="username"
                                    placeholder="Enter your username"
                                    value={username}
                                    onChange={(event) => setUsername(event.target.value)}
                                    autoComplete="username"
                                    required
                                />
                            </span>
                        </label>
                        <label className="login-field">
                            <span className="login-label">Password</span>
                            <span className="login-input-wrap">
                                <span className="login-input-icon">
                                    <LockIcon />
                                </span>
                                <input
                                    type={showPassword ? "text" : "password"}
                                    name="password"
                                    placeholder="Enter your password"
                                    value={password}
                                    onChange={(event) => setPassword(event.target.value)}
                                    autoComplete="current-password"
                                    required
                                />
                                <button
                                    type="button"
                                    className="password-toggle"
                                    onClick={() => setShowPassword((value) => !value)}
                                    aria-label={showPassword ? "Hide password" : "Show password"}
                                >
                                    <EyeIcon visible={showPassword} />
                                </button>
                            </span>
                        </label>
                        <label className="remember-row">
                            <input
                                type="checkbox"
                                checked={rememberMe}
                                onChange={(event) => setRememberMe(event.target.checked)}
                            />
                            <span>Remember me</span>
                        </label>
                        {error && <p className="login-message error">{error}</p>}
                        {message && <p className="login-message success">{message}</p>}
                        <button className="login-btn" type="submit">
                            Login
                        </button>
                    </form>
                    <p className="login-copyright">
                        © 2026 YiPet Admin. All rights reserved.
                    </p>
                </div>
            </section>
        </main>
    );
}

export default Login;
