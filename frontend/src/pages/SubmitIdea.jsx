import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ideaAPI } from '../api';
import { Send, Lightbulb } from 'lucide-react';

export default function SubmitIdea() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);
  const [formData, setFormData] = useState({
    title: '',
    short_pitch: '',
    problem_statement: '',
    target_industry: '',
    proposed_solution: '',
    differentiators: '',
    market_signals: ''
  });

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      await ideaAPI.create(formData);
      setSuccess(true);
      setTimeout(() => navigate('/evaluate'), 2000);
    } catch (err) {
      setError(err.response?.data?.detail || 'Failed to submit idea');
    } finally {
      setLoading(false);
    }
  };

  if (success) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-center">
          <div className="inline-flex items-center justify-center w-16 h-16 bg-green-100 rounded-full mb-4">
            <Lightbulb className="w-8 h-8 text-green-600" />
          </div>
          <h2 className="text-2xl font-bold text-gray-900 mb-2">
            Idea Submitted Successfully!
          </h2>
          <p className="text-gray-600">Redirecting to evaluation...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-3xl mx-auto">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 flex items-center">
          <Lightbulb className="w-8 h-8 mr-3 text-primary-600" />
          Submit Your Startup Idea
        </h1>
        <p className="text-gray-600 mt-2">
          Share your idea and we'll evaluate it against VC use cases
        </p>
      </div>

      {error && (
        <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg text-red-600">
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="bg-white rounded-lg shadow p-8 space-y-6">
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Idea Title *
          </label>
          <input
            type="text"
            name="title"
            value={formData.title}
            onChange={handleChange}
            required
            className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            placeholder="AI-Powered Supply Chain Optimizer"
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Short Pitch *
          </label>
          <textarea
            name="short_pitch"
            value={formData.short_pitch}
            onChange={handleChange}
            required
            rows="2"
            className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            placeholder="A one-sentence description of your idea"
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Problem Statement *
          </label>
          <textarea
            name="problem_statement"
            value={formData.problem_statement}
            onChange={handleChange}
            required
            rows="4"
            className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            placeholder="What problem are you solving?"
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Target Industry
          </label>
          <input
            type="text"
            name="target_industry"
            value={formData.target_industry}
            onChange={handleChange}
            className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            placeholder="e.g., logistics, fintech, healthcare"
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Proposed Solution *
          </label>
          <textarea
            name="proposed_solution"
            value={formData.proposed_solution}
            onChange={handleChange}
            required
            rows="4"
            className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            placeholder="How does your solution work?"
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Key Differentiators
          </label>
          <textarea
            name="differentiators"
            value={formData.differentiators}
            onChange={handleChange}
            rows="3"
            className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            placeholder="What makes your solution unique?"
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Market Signals
          </label>
          <textarea
            name="market_signals"
            value={formData.market_signals}
            onChange={handleChange}
            rows="3"
            className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            placeholder="Any traction, pilot customers, revenue, etc."
          />
        </div>

        <button
          type="submit"
          disabled={loading}
          className="w-full bg-primary-600 text-white py-3 px-4 rounded-lg hover:bg-primary-700 focus:ring-4 focus:ring-primary-300 disabled:opacity-50 disabled:cursor-not-allowed transition-colors font-medium flex items-center justify-center"
        >
          <Send className="w-5 h-5 mr-2" />
          {loading ? 'Submitting...' : 'Submit Idea'}
        </button>
      </form>
    </div>
  );
}
