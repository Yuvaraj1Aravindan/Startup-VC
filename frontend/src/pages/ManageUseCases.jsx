import React, { useState, useEffect } from 'react';
import { usecaseAPI } from '../api';
import { Target, Plus, Trash2 } from 'lucide-react';

export default function ManageUseCases() {
  const [usecases, setUsecases] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    industry: '',
    domain: '',
    tags: '',
    importance_weight: 0.5
  });

  useEffect(() => {
    loadUseCases();
  }, []);

  const loadUseCases = async () => {
    try {
      const response = await usecaseAPI.getAll();
      setUsecases(response.data);
    } catch (error) {
      console.error('Error loading use cases:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const data = {
        ...formData,
        tags: formData.tags.split(',').map(t => t.trim()).filter(Boolean),
        importance_weight: parseFloat(formData.importance_weight)
      };
      
      await usecaseAPI.create(data);
      setShowForm(false);
      setFormData({
        title: '',
        description: '',
        industry: '',
        domain: '',
        tags: '',
        importance_weight: 0.5
      });
      loadUseCases();
    } catch (error) {
      console.error('Error creating use case:', error);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 flex items-center">
            <Target className="w-8 h-8 mr-3 text-primary-600" />
            VC Use Cases
          </h1>
          <p className="text-gray-600 mt-2">
            Manage your portfolio's pain points and investment priorities
          </p>
        </div>
        <button
          onClick={() => setShowForm(!showForm)}
          className="bg-primary-600 text-white px-6 py-3 rounded-lg hover:bg-primary-700 transition-colors flex items-center"
        >
          <Plus className="w-5 h-5 mr-2" />
          Add Use Case
        </button>
      </div>

      {showForm && (
        <div className="bg-white rounded-lg shadow p-8 mb-8">
          <h2 className="text-xl font-bold text-gray-900 mb-4">New Use Case</h2>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Title *
                </label>
                <input
                  type="text"
                  name="title"
                  value={formData.title}
                  onChange={handleChange}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500"
                  placeholder="Supply Chain Automation"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Industry
                </label>
                <input
                  type="text"
                  name="industry"
                  value={formData.industry}
                  onChange={handleChange}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500"
                  placeholder="logistics"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Description *
              </label>
              <textarea
                name="description"
                value={formData.description}
                onChange={handleChange}
                required
                rows="4"
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500"
                placeholder="Describe the pain point or use case..."
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Domain
                </label>
                <input
                  type="text"
                  name="domain"
                  value={formData.domain}
                  onChange={handleChange}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500"
                  placeholder="operations"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Importance Weight (0-1)
                </label>
                <input
                  type="number"
                  name="importance_weight"
                  value={formData.importance_weight}
                  onChange={handleChange}
                  min="0"
                  max="1"
                  step="0.1"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Tags (comma-separated)
              </label>
              <input
                type="text"
                name="tags"
                value={formData.tags}
                onChange={handleChange}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500"
                placeholder="automation, efficiency, IoT"
              />
            </div>

            <div className="flex gap-4">
              <button
                type="submit"
                className="bg-primary-600 text-white px-6 py-2 rounded-lg hover:bg-primary-700 transition-colors"
              >
                Create Use Case
              </button>
              <button
                type="button"
                onClick={() => setShowForm(false)}
                className="bg-gray-200 text-gray-700 px-6 py-2 rounded-lg hover:bg-gray-300 transition-colors"
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {usecases.map((usecase) => (
          <div key={usecase.id} className="bg-white rounded-lg shadow p-6">
            <div className="flex items-start justify-between mb-4">
              <h3 className="text-lg font-bold text-gray-900">{usecase.title}</h3>
              <span className="bg-primary-100 text-primary-700 px-3 py-1 rounded-full text-sm font-medium">
                Weight: {usecase.importance_weight}
              </span>
            </div>
            
            <p className="text-gray-600 mb-4 line-clamp-3">{usecase.description}</p>
            
            <div className="flex items-center gap-4 text-sm text-gray-500 mb-4">
              {usecase.industry && (
                <span className="bg-gray-100 px-2 py-1 rounded">
                  {usecase.industry}
                </span>
              )}
              {usecase.domain && (
                <span className="bg-gray-100 px-2 py-1 rounded">
                  {usecase.domain}
                </span>
              )}
            </div>
            
            {usecase.tags && usecase.tags.length > 0 && (
              <div className="flex flex-wrap gap-2">
                {usecase.tags.map((tag, idx) => (
                  <span key={idx} className="bg-blue-100 text-blue-700 px-2 py-1 rounded text-xs">
                    {tag}
                  </span>
                ))}
              </div>
            )}
          </div>
        ))}
      </div>

      {usecases.length === 0 && (
        <div className="text-center py-12 bg-white rounded-lg shadow">
          <Target className="w-16 h-16 text-gray-400 mx-auto mb-4" />
          <h3 className="text-lg font-medium text-gray-900 mb-2">
            No use cases yet
          </h3>
          <p className="text-gray-600">
            Create your first use case to start evaluating ideas
          </p>
        </div>
      )}
    </div>
  );
}
