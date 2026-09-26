import { useNavigate } from "react-router-dom";
import "../css/mainPage.css";

export default function NotFound({ unauthorized = false }) {
  const navigate = useNavigate();
  return (
    <main className="system-page">
      <div className="system-card">
        <div className="system-code">{unauthorized ? "403" : "404"}</div>
        <h1>{unauthorized ? "Access denied" : "Page not found"}</h1>
        <p>{unauthorized ? "Your account does not have permission to access this area." : "The page you requested does not exist or has been moved."}</p>
        <div className="system-actions"><button onClick={() => navigate("/index")}>Back to Dashboard</button><button className="secondary" onClick={() => navigate(-1)}>Go Back</button></div>
      </div>
    </main>
  );
}
