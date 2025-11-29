import React, { useState, useEffect } from 'react';
import { ideaAPI, usecaseAPI, evaluationAPI } from '../api';
import { Activity, CheckCircle, TrendingUp } from 'lucide-react';

export default function Evaluate() {
  const [ideas, setIdeas] = useState([]);
  const [usecases, setUsecases] = useState([]);
  const [selectedIdea, setSelectedIdea] = useState('');
  const [selectedUsecase, setSelectedUsecase] = useState('');
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      const [ideasRes, usecasesRes] = await Promise.all([
        ideaAPI.getAll(),
        usecaseAPI.getAll()
      ]);
      setIdeas(ideasRes.data);
      setUsecases(usecasesRes.data);
    } catch (error) {
      console.error('Error loading data:', error);
    }
  };

  const handleEvaluate = async () => {
    if (!selectedIdea || !selectedUsecase) return;
    
    setLoading(true);
    setResult(null);
    
    try {
      const response = await evaluationAPI.evaluate({
        idea_id: parseInt(selectedIdea),
        usecase_id: parseInt(selectedUsecase)
      });
      setResult(response.data);
    } catch (error) {
      console.error('Error evaluating:', error);
      alert('Evaluation failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const getScoreColor = (score) => {
    if (score >= 75) return 'text-green-600';
    if (score >= 50) return 'text-yellow-600';
    return 'text-red-600';
  };

  const getScoreBgColor = (score) => {
    if (score >= 75) return 'bg-green-100';
    if (score >= 50) return 'bg-yellow-100';
    return 'bg-red-100';
  };

  return (
    <div className="max-w-5xl mx-auto">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 flex items-center">
          <Activity className="w-8 h-8 mr-3 text-primary-600" />
          Evaluate Ideas
        </h1>
        <p className="text-gray-600 mt-2">
          Match startup ideas against VC use cases for scoring
        </p>
      </div>

      <div className="bg-white rounded-lg shadow p-8 mb-8">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Select Idea
            </label>
            <select
              value={selectedIdea}
              onChange={(e) => setSelectedIdea(e.target.value)}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500"
            >
              <option value="">-- Choose an idea --</option>
              {ideas.map((idea) => (
                <option key={idea.id} value={idea.id}>
                  {idea.title}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Select Use Case
            </label>
            <select
              value={selectedUsecase}
              onChange={(e) => setSelectedUsecase(e.target.value)}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500"
            >
              <option value="">-- Choose a use case --</option>
              {usecases.map((usecase) => (
                <option key={usecase.id} value={usecase.id}>
                  {usecase.title}
                </option>
              ))}
            </select>
          </div>
        </div>

        <button
          onClick={handleEvaluate}
          disabled={!selectedIdea || !selectedUsecase || loading}
          className="w-full bg-primary-600 text-white py-3 px-4 rounded-lg hover:bg-primary-700 focus:ring-4 focus:ring-primary-300 disabled:opacity-50 disabled:cursor-not-allowed transition-colors font-medium flex items-center justify-center"
        >
          <Activity className="w-5 h-5 mr-2" />
          {loading ? 'Evaluating...' : 'Evaluate'}
        </button>
      </div>

      {result && (
        <div className="bg-white rounded-lg shadow p-8">
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-2xl font-bold text-gray-900">Evaluation Results</h2>
            <div className={`${getScoreBgColor(result.overall_score)} px-6 py-3 rounded-lg`}>
              <span className={`text-3xl font-bold ${getScoreColor(result.overall_score)}`}>
                {result.overall_score.toFixed(1)}%
              </span>
            </div>
          </div>

          <div className="grid grid-cols-3 gap-4 mb-8">
            <div className="bg-blue-50 p-4 rounded-lg">
              <p className="text-sm text-gray-600">Alignment Score</p>
              <p className="text-2xl font-bold text-blue-600">
                {(result.per_usecase_scores[0]?.alignment_score * 100).toFixed(1)}%
              </p>
            </div>
            <div className="bg-purple-50 p-4 rounded-lg">
              <p className="text-sm text-gray-600">Confidence</p>
              <p className="text-2xl font-bold text-purple-600">
                {(result.confidence * 100).toFixed(1)}%
              </p>
            </div>
            <div className="bg-green-50 p-4 rounded-lg">
              <p className="text-sm text-gray-600">Status</p>
              <p className="text-lg font-bold text-green-600 flex items-center">
                <CheckCircle className="w-5 h-5 mr-1" />
                Complete
              </p>
            </div>
          </div>

          <div className="mb-8">
            <h3 className="text-lg font-bold text-gray-900 mb-4">Explanation</h3>
            <div className="prose prose-sm max-w-none bg-gray-50 p-6 rounded-lg">
              <div dangerouslySetInnerHTML={{ __html: result.aggregated_explanation.replace(/\n/g, '<br/>').replace(/##/g, '<h3>').replace(/###/g, '<h4>') }} />
            </div>
          </div>

          {result.per_usecase_scores[0]?.matched_evidence && result.per_usecase_scores[0].matched_evidence.length > 0 && (
            <div className="mb-8">
              <h3 className="text-lg font-bold text-gray-900 mb-4">Matched Evidence</h3>
              <div className="flex flex-wrap gap-2">
                {result.per_usecase_scores[0].matched_evidence.map((evidence, idx) => (
                  <span key={idx} className="bg-primary-100 text-primary-700 px-3 py-1 rounded-full text-sm">
                    {evidence}
                  </span>
                ))}
              </div>
            </div>
          )}

          <div>
            <h3 className="text-lg font-bold text-gray-900 mb-4 flex items-center">
              <TrendingUp className="w-5 h-5 mr-2" />
              Recommended Actions
            </h3>
            <ul className="space-y-2">
              {result.recommended_actions.map((action, idx) => (
                <li key={idx} className="flex items-start">
                  <CheckCircle className="w-5 h-5 text-green-500 mr-2 mt-0.5 flex-shrink-0" />
                  <span className="text-gray-700">{action}</span>
                </li>
              ))}
            </ul>
          </div>
        </div>
      )}

      {ideas.length === 0 && (
        <div className="text-center py-12 bg-white rounded-lg shadow">
          <Activity className="w-16 h-16 text-gray-400 mx-auto mb-4" />
          <h3 className="text-lg font-medium text-gray-900 mb-2">
            No ideas available
          </h3>
          <p className="text-gray-600">
            Submit an idea first to start evaluating
          </p>
        </div>
      )}
    </div>
  );
}
