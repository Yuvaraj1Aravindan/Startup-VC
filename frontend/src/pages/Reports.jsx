import React, { useState, useEffect } from 'react';
import { ideaAPI } from '../api';
import { FileText, TrendingUp, Target } from 'lucide-react';

export default function Reports() {
  const [ideas, setIdeas] = useState([]);
  const [selectedIdea, setSelectedIdea] = useState('');
  const [report, setReport] = useState(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    loadIdeas();
  }, []);

  const loadIdeas = async () => {
    try {
      const response = await ideaAPI.getAll();
      setIdeas(response.data);
    } catch (error) {
      console.error('Error loading ideas:', error);
    }
  };

  const loadReport = async (ideaId) => {
    setLoading(true);
    setReport(null);
    
    try {
      const response = await ideaAPI.getReport(ideaId);
      setReport(response.data);
    } catch (error) {
      console.error('Error loading report:', error);
      if (error.response?.status === 404) {
        alert('No evaluations found for this idea. Please evaluate it first.');
      }
    } finally {
      setLoading(false);
    }
  };

  const handleSelectIdea = (e) => {
    const ideaId = e.target.value;
    setSelectedIdea(ideaId);
    if (ideaId) {
      loadReport(ideaId);
    }
  };

  return (
    <div className="max-w-5xl mx-auto">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 flex items-center">
          <FileText className="w-8 h-8 mr-3 text-primary-600" />
          Evaluation Reports
        </h1>
        <p className="text-gray-600 mt-2">
          View comprehensive evaluation reports for your ideas
        </p>
      </div>

      <div className="bg-white rounded-lg shadow p-8 mb-8">
        <label className="block text-sm font-medium text-gray-700 mb-2">
          Select Idea to View Report
        </label>
        <select
          value={selectedIdea}
          onChange={handleSelectIdea}
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

      {loading && (
        <div className="flex items-center justify-center h-64">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
        </div>
      )}

      {report && !loading && (
        <div className="space-y-6">
          {/* Summary Card */}
          <div className="bg-gradient-to-r from-primary-600 to-primary-700 rounded-lg shadow-lg p-8 text-white">
            <h2 className="text-2xl font-bold mb-2">{report.idea.title}</h2>
            <p className="text-primary-100 mb-4">{report.idea.short_pitch}</p>
            <div className="grid grid-cols-3 gap-4">
              <div className="bg-white bg-opacity-20 rounded-lg p-4">
                <p className="text-sm opacity-90">Average Score</p>
                <p className="text-3xl font-bold">{report.average_score.toFixed(1)}%</p>
              </div>
              <div className="bg-white bg-opacity-20 rounded-lg p-4">
                <p className="text-sm opacity-90">Evaluations</p>
                <p className="text-3xl font-bold">{report.evaluations.length}</p>
              </div>
              <div className="bg-white bg-opacity-20 rounded-lg p-4">
                <p className="text-sm opacity-90">Top Match</p>
                <p className="text-3xl font-bold">
                  {report.top_matches[0]?.score.toFixed(1) || 'N/A'}%
                </p>
              </div>
            </div>
          </div>

          {/* Insights */}
          <div className="bg-white rounded-lg shadow p-6">
            <h3 className="text-lg font-bold text-gray-900 mb-4 flex items-center">
              <TrendingUp className="w-5 h-5 mr-2 text-primary-600" />
              Key Insights
            </h3>
            <p className="text-gray-700">{report.insights}</p>
          </div>

          {/* Top Matches */}
          {report.top_matches && report.top_matches.length > 0 && (
            <div className="bg-white rounded-lg shadow p-6">
              <h3 className="text-lg font-bold text-gray-900 mb-4 flex items-center">
                <Target className="w-5 h-5 mr-2 text-primary-600" />
                Top Matching Use Cases
              </h3>
              <div className="space-y-4">
                {report.top_matches.map((match, idx) => (
                  <div key={idx} className="border-l-4 border-primary-500 pl-4">
                    <div className="flex items-start justify-between mb-2">
                      <h4 className="font-semibold text-gray-900">{match.usecase_title}</h4>
                      <span className={`px-3 py-1 rounded-full text-sm font-bold ${
                        match.score >= 75 ? 'bg-green-100 text-green-700' :
                        match.score >= 50 ? 'bg-yellow-100 text-yellow-700' :
                        'bg-red-100 text-red-700'
                      }`}>
                        {match.score.toFixed(1)}%
                      </span>
                    </div>
                    <p className="text-sm text-gray-600 mb-2">
                      Alignment: {(match.alignment_score * 100).toFixed(1)}%
                    </p>
                    {match.matched_evidence && match.matched_evidence.length > 0 && (
                      <div className="flex flex-wrap gap-2 mt-2">
                        {match.matched_evidence.slice(0, 5).map((evidence, i) => (
                          <span key={i} className="bg-gray-100 text-gray-700 px-2 py-1 rounded text-xs">
                            {evidence}
                          </span>
                        ))}
                      </div>
                    )}
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* All Evaluations */}
          <div className="bg-white rounded-lg shadow p-6">
            <h3 className="text-lg font-bold text-gray-900 mb-4">All Evaluations</h3>
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Use Case
                    </th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Overall Score
                    </th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Alignment
                    </th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Novelty
                    </th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Viability
                    </th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                      Date
                    </th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-200">
                  {report.evaluations.map((evaluation) => (
                    <tr key={evaluation.id}>
                      <td className="px-4 py-3 text-sm text-gray-900">
                        Use Case #{evaluation.usecase_id}
                      </td>
                      <td className="px-4 py-3 text-sm">
                        <span className={`font-bold ${
                          evaluation.overall_score >= 75 ? 'text-green-600' :
                          evaluation.overall_score >= 50 ? 'text-yellow-600' :
                          'text-red-600'
                        }`}>
                          {evaluation.overall_score.toFixed(1)}%
                        </span>
                      </td>
                      <td className="px-4 py-3 text-sm text-gray-700">
                        {(evaluation.alignment_score * 100).toFixed(1)}%
                      </td>
                      <td className="px-4 py-3 text-sm text-gray-700">
                        {(evaluation.novelty_score * 100).toFixed(1)}%
                      </td>
                      <td className="px-4 py-3 text-sm text-gray-700">
                        {(evaluation.viability_score * 100).toFixed(1)}%
                      </td>
                      <td className="px-4 py-3 text-sm text-gray-500">
                        {new Date(evaluation.created_at).toLocaleDateString()}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {!loading && !report && selectedIdea && (
        <div className="text-center py-12 bg-white rounded-lg shadow">
          <FileText className="w-16 h-16 text-gray-400 mx-auto mb-4" />
          <h3 className="text-lg font-medium text-gray-900 mb-2">
            No report available
          </h3>
          <p className="text-gray-600">
            This idea hasn't been evaluated yet
          </p>
        </div>
      )}

      {ideas.length === 0 && (
        <div className="text-center py-12 bg-white rounded-lg shadow">
          <FileText className="w-16 h-16 text-gray-400 mx-auto mb-4" />
          <h3 className="text-lg font-medium text-gray-900 mb-2">
            No ideas available
          </h3>
          <p className="text-gray-600">
            Submit ideas and evaluate them to view reports
          </p>
        </div>
      )}
    </div>
  );
}
