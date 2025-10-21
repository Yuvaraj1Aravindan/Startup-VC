import axios from 'axios';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000';

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add auth token to requests
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Handle auth errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export const authAPI = {
  register: (data) => api.post('/api/register', data),
  login: (email, password) => {
    const formData = new URLSearchParams();
    formData.append('username', email);
    formData.append('password', password);
    return api.post('/api/token', formData, {
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    });
  },
  getCurrentUser: () => api.get('/api/users/me'),
};

export const usecaseAPI = {
  create: (data) => api.post('/api/vc/usecases', data),
  createBulk: (data) => api.post('/api/vc/usecases/bulk', data),
  getAll: () => api.get('/api/vc/usecases'),
};

export const ideaAPI = {
  create: (data) => api.post('/api/ideas', data),
  getAll: () => api.get('/api/ideas'),
  getById: (id) => api.get(`/api/ideas/${id}`),
  getReport: (id) => api.get(`/api/ideas/${id}/report`),
};

export const evaluationAPI = {
  evaluate: (data) => api.post('/api/evaluate', data),
  evaluateBulk: (data) => api.post('/api/evaluate/bulk', data),
};

export default api;
