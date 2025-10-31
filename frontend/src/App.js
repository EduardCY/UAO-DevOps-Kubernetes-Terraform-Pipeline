import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3000';

function App() {
  const [users, setUsers] = useState([]);
  const [name, setName] = useState('');
  const [editingId, setEditingId] = useState(null);
  const [editingName, setEditingName] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // Fetch all users
  const fetchUsers = async () => {
    try {
      setLoading(true);
      setError(null);
      const response = await axios.get(`${API_URL}/users`);
      setUsers(response.data);
    } catch (err) {
      setError('Error fetching users. Please check if the backend is running.');
      console.error('Error fetching users:', err);
    } finally {
      setLoading(false);
    }
  };

  // Create new user
  const addUser = async (e) => {
    e.preventDefault();
    if (!name.trim()) return;

    try {
      setLoading(true);
      setError(null);
      const response = await axios.post(`${API_URL}/users`, { name: name.trim() });
      setUsers([...users, response.data]);
      setName('');
    } catch (err) {
      setError('Error creating user. Please try again.');
      console.error('Error creating user:', err);
    } finally {
      setLoading(false);
    }
  };

  // Update user
  const updateUser = async (id) => {
    if (!editingName.trim()) return;

    try {
      setLoading(true);
      setError(null);
      const response = await axios.put(`${API_URL}/users/${id}`, { name: editingName.trim() });
      setUsers(users.map(user => (user.id === id ? response.data : user)));
      setEditingId(null);
      setEditingName('');
    } catch (err) {
      setError('Error updating user. Please try again.');
      console.error('Error updating user:', err);
    } finally {
      setLoading(false);
    }
  };

  // Delete user
  const deleteUser = async (id) => {
    if (!window.confirm('Are you sure you want to delete this user?')) return;

    try {
      setLoading(true);
      setError(null);
      await axios.delete(`${API_URL}/users/${id}`);
      setUsers(users.filter(user => user.id !== id));
    } catch (err) {
      setError('Error deleting user. Please try again.');
      console.error('Error deleting user:', err);
    } finally {
      setLoading(false);
    }
  };

  // Start editing
  const startEdit = (user) => {
    setEditingId(user.id);
    setEditingName(user.name);
  };

  // Cancel editing
  const cancelEdit = () => {
    setEditingId(null);
    setEditingName('');
  };

  // Load users on mount
  useEffect(() => {
    fetchUsers();
  }, []);

  return (
    <div className="App">
      <div className="container">
        <header className="header">
          <h1>👥 User Management</h1>
          <p>CRUD Application with React + Express + PostgreSQL</p>
        </header>

        {error && (
          <div className="error-message">
            ⚠️ {error}
          </div>
        )}

        <div className="add-user-section">
          <form onSubmit={addUser} className="add-user-form">
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="Enter user name..."
              className="input-field"
              disabled={loading}
            />
            <button type="submit" className="btn btn-primary" disabled={loading || !name.trim()}>
              {loading ? '⏳ Adding...' : '➕ Add User'}
            </button>
          </form>
        </div>

        <div className="users-section">
          <div className="section-header">
            <h2>Users List</h2>
            <button onClick={fetchUsers} className="btn btn-refresh" disabled={loading}>
              {loading ? '⏳' : '🔄'} Refresh
            </button>
          </div>

          {loading && users.length === 0 ? (
            <div className="loading">Loading users...</div>
          ) : users.length === 0 ? (
            <div className="empty-state">
              <p>No users found. Add your first user above! 👆</p>
            </div>
          ) : (
            <ul className="users-list">
              {users.map(user => (
                <li key={user.id} className="user-item">
                  {editingId === user.id ? (
                    <div className="edit-mode">
                      <input
                        type="text"
                        value={editingName}
                        onChange={(e) => setEditingName(e.target.value)}
                        className="input-field"
                        autoFocus
                      />
                      <div className="edit-actions">
                        <button
                          onClick={() => updateUser(user.id)}
                          className="btn btn-success btn-sm"
                          disabled={loading || !editingName.trim()}
                        >
                          ✓ Save
                        </button>
                        <button
                          onClick={cancelEdit}
                          className="btn btn-secondary btn-sm"
                          disabled={loading}
                        >
                          ✕ Cancel
                        </button>
                      </div>
                    </div>
                  ) : (
                    <div className="view-mode">
                      <div className="user-info">
                        <span className="user-id">#{user.id}</span>
                        <span className="user-name">{user.name}</span>
                      </div>
                      <div className="user-actions">
                        <button
                          onClick={() => startEdit(user)}
                          className="btn btn-edit btn-sm"
                          disabled={loading}
                        >
                          ✏️ Edit
                        </button>
                        <button
                          onClick={() => deleteUser(user.id)}
                          className="btn btn-danger btn-sm"
                          disabled={loading}
                        >
                          🗑️ Delete
                        </button>
                      </div>
                    </div>
                  )}
                </li>
              ))}
            </ul>
          )}
        </div>

        <footer className="footer">
          <p>Built with ❤️ using React, Express & PostgreSQL</p>
          <p className="tech-stack">
            <span className="badge">React</span>
            <span className="badge">Node.js</span>
            <span className="badge">PostgreSQL</span>
            <span className="badge">Docker</span>
            <span className="badge">Kubernetes</span>
          </p>
        </footer>
      </div>
    </div>
  );
}

export default App;
