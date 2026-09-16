// src/components/Reset.jsx
import axios from "axios";
import { useState } from "react";
import { useSearchParams } from 'react-router-dom'
import "../css/reset.css";
import resetBg from "../assets/imgs/login_img.png";

// const API_URL = "http://localhost:3001";
const API_URL = "https://api.nzdc.co.uk";

function LockIcon() {
    return (
        <svg viewBox="0 0 24 24" aria-hidden="true">
            <rect x="5.5" y="10" width="13" height="10" rx="2.2" />
            <path d="M8.5 10V7.8a3.5 3.5 0 0 1 7 0V10" />
        </svg>
    );
}

function EyeIcon({ visible }) {
    return (
        <svg viewBox="0 0 24 24" aria-hidden="true">
            <path d="M2.8 12s3.1-5.2 9.2-5.2S21.2 12 21.2 12s-3.1 5.2-9.2 5.2S2.8 12 2.8 12Z" />
            <circle cx="12" cy="12" r="2.4" />
            {visible && <path d="m4 4 16 16" />}
        </svg>
    );
}

function HeaderLockIcon() {
    return (
        <svg viewBox="0 0 64 64" aria-hidden="true">
            <rect x="18" y="28" width="28" height="24" rx="4" />
            <path d="M24 28v-7a8 8 0 0 1 16 0v7" />
            <circle cx="32" cy="39" r="2.4" />
            <path d="M32 41.5V46" />
        </svg>
    );
}

function ResetPassword({
    loading = false,
    error = "",
    message = "",
}) {
    const [password, setPassword] = useState("");
    const [confirmPassword, setConfirmPassword] = useState("");
    const [showPassword, setShowPassword] = useState(false);
    const [showConfirmPassword, setShowConfirmPassword] = useState(false);
    const [localError, setLocalError] = useState("");

    const [searchParams] = useSearchParams()
    const token = searchParams.get('token')
    const [resetSuccess, setResetSuccess] = useState(false)

    const handleSubmit = (event) => {
        event.preventDefault();
        setLocalError("");

        if (password !== confirmPassword) {
            setLocalError("Passwords do not match.");
            return;
        }

        axios
            .post(`${API_URL}/auth/web/reset`, { token, password })
            .then((res) => {
                setResetSuccess(true);
            })
            .catch((error) => {
                console.log("reset error:", error);
                console.log("backend response:", error.response?.data);
                setLocalError(
                    Array.isArray(error.response?.data?.message)
                        ? error.response.data.message.join(", ")
                        : error.response?.data?.message ||
                        "Reset password failed"
                );

            });
    };

    if (resetSuccess) {
        return (
            <main
                className="reset-page"
                style={{ "--reset-bg": `url(${resetBg})` }}>
                <section className="reset-card reset-success-card">
                    <div className="success-icon">
                        <span>✓</span>
                        <i className="success-heart">♥</i>
                    </div>
                    <h1 className="success-title">
                        <span>Password Reset</span> Successful!
                    </h1>
                    <div className="success-divider"><span>♥</span></div>
                    <p className="success-description">
                        Your password has been reset successfully.
                        <br />
                        You can now use your new password to
                        <br />
                        log in to your account.

                    </p>
                    <div className="secure-box">
                        <div className="secure-icon">✓</div>
                        <div>
                            <strong>Your account is now secure.</strong>
                            <p>Make sure to keep your password<br />safe and secure.</p>
                        </div>
                    </div>
                    <p className="support-text">
                        Need help?
                        <a href="mailto:support@yipet.com">Contact Support</a>
                    </p>
                </section>
            </main>
        )
    }

    return (
        <main
            className="reset-page"
            style={{ "--reset-bg": `url(${resetBg})` }}
        >
            <section className="reset-card">
                <div className="reset-header-icon">
                    <HeaderLockIcon />
                </div>
                <h1>
                    <span>Reset</span> Your Password
                </h1>
                <p className="reset-subtitle">
                    Please enter your new password below.
                    <br />
                    Make sure it&apos;s strong and unique.
                </p>
                <form className="reset-form" onSubmit={handleSubmit}>
                    <label className="reset-field">
                        <span className="reset-label">New Password</span>
                        <span className="reset-input-wrap">
                            <span className="reset-input-icon">
                                <LockIcon />
                            </span>
                            <input
                                type={showPassword ? "text" : "password"}
                                value={password}
                                onChange={(event) => setPassword(event.target.value)}
                                placeholder="Enter your new password"
                                autoComplete="new-password"
                                required
                            />
                            <button
                                type="button"
                                className="reset-password-toggle"
                                onClick={() => setShowPassword((value) => !value)}
                                aria-label={showPassword ? "Hide password" : "Show password"}
                            >
                                <EyeIcon visible={showPassword} />
                            </button>
                        </span>
                    </label>
                    <label className="reset-field confirm-field">
                        <span className="reset-label">Confirm Password</span>
                        <span className="reset-input-wrap">
                            <span className="reset-input-icon">
                                <LockIcon />
                            </span>
                            <input
                                type={showConfirmPassword ? "text" : "password"}
                                value={confirmPassword}
                                onChange={(event) => setConfirmPassword(event.target.value)}
                                placeholder="Confirm your new password"
                                autoComplete="new-password"
                                required
                            />
                            <button
                                type="button"
                                className="reset-password-toggle"
                                onClick={() =>
                                    setShowConfirmPassword((value) => !value)
                                }
                                aria-label={
                                    showConfirmPassword
                                        ? "Hide confirm password"
                                        : "Show confirm password"
                                }
                            >
                                <EyeIcon visible={showConfirmPassword} />
                            </button>
                        </span>
                    </label>

                    {(localError || error) && (
                        <p className="reset-message error">{localError || error}</p>
                    )}

                    {message && (
                        <p className="reset-message success">{message}</p>
                    )}

                    <button
                        className="reset-submit"
                        type="submit"
                        disabled={loading}
                    >
                        {loading ? "Resetting..." : "Reset Password"}
                    </button>
                </form>
            </section>
        </main>
    );
}

export default ResetPassword;
