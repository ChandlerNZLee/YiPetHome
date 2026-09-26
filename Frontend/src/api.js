import axios from "axios";

export const API_URL = import.meta.env.VITE_API_URL || "https://api.nzdc.co.uk";

const api = axios.create({
  baseURL: API_URL,
  timeout: 15000,
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem("token");
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem("token");
      localStorage.removeItem("userrole");
    }
    return Promise.reject(error);
  },
);

export const getErrorMessage = (error, fallback = "Request failed. Please try again.") => {
  const message = error?.response?.data?.message || error?.response?.data?.error;
  if (Array.isArray(message)) return message.join(", ");
  return message || error?.message || fallback;
};

export default api;
