import React, { useEffect, useState } from 'react';
import { useAuth } from '../AuthContext';
import { ideaAPI, usecaseAPI, evaluationAPI } from '../api';
import { TrendingUp, Target, Lightbulb, Activity } from 'lucide-react';

export default function Dashboard() {
  const { user } = useAuth();
  const [stats, setStats] = useState({
    ideas: 0,
    usecases: 0,
    evaluations: 0,
    avgScore: 0
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadDashboardData();
  }, []);

  const loadDashboardData = async () => {
    try {
      const [ideasRes, usecasesRes] = await Promise.all([
        ideaAPI.getAll().catch(() => ({ data: [] })),
        usecaseAPI.getAll().catch(() => ({ data: [] }))
      ]);

      setStats({
        ideas: ideasRes.data.length,
        usecases: usecasesRes.data.length,
        evaluations: 0,
        avgScore: 0
      });
    } catch (error) {
      console.error('Error loading dashboard:', error);
    } finally {
      setLoading(false);
    }
  };

  const statCards = [
    {
      title: 'My Ideas',
      value: stats.ideas,
      icon: Lightbulb,
      color: 'bg-blue-500',
      show: user?.role === 'startup_aspirant' || user?.role === 'system_admin'
    },
    {
      title: 'Use Cases',
      value: stats.usecases,
      icon: Target,
      color: 'bg-green-500',
      show: true
    },
    {
      title: 'Evaluations',
      value: stats.evaluations,
      icon: Activity,
      color: 'bg-purple-500',
      show: true
    },
    {
      title: 'Avg Score',
      value: `${stats.avgScore}%`,
      icon: TrendingUp,
      color: 'bg-orange-500',
      show: true
    }
  ].filter(card => card.show);

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">
          Welcome back, {user?.full_name}!
        </h1>
        <p className="text-gray-600 mt-2">
          Here's an overview of your activity
        </p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        {statCards.map((card, index) => (
          <div key={index} className="bg-white rounded-lg shadow p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">{card.title}</p>
                <p className="text-3xl font-bold text-gray-900 mt-2">
                  {card.value}
                </p>
              </div>
              <div className={`${card.color} p-3 rounded-lg`}>
                <card.icon className="w-6 h-6 text-white" />
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Quick Actions */}
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-bold text-gray-900 mb-4">Quick Actions</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {user?.role === 'startup_aspirant' && (
            <a
              href="/submit-idea"
              className="p-4 border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:bg-primary-50 transition-colors"
            >
              <Lightbulb className="w-8 h-8 text-primary-600 mb-2" />
              <h3 className="font-semibold text-gray-900">Submit New Idea</h3>
              <p className="text-sm text-gray-600 mt-1">
                Share your startup idea for evaluation
              </p>
            </a>
          )}
          
          {user?.role === 'vc_representative' && (
            <a
              href="/usecases"
              className="p-4 border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:bg-primary-50 transition-colors"
            >
              <Target className="w-8 h-8 text-primary-600 mb-2" />
              <h3 className="font-semibold text-gray-900">Add Use Case</h3>
              <p className="text-sm text-gray-600 mt-1">
                Define new pain points to match against
              </p>
            </a>
          )}
          
          <a
            href="/evaluate"
            className="p-4 border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:bg-primary-50 transition-colors"
          >
            <Activity className="w-8 h-8 text-primary-600 mb-2" />
            <h3 className="font-semibold text-gray-900">Evaluate Ideas</h3>
            <p className="text-sm text-gray-600 mt-1">
              Match ideas against use cases
            </p>
          </a>
          
          <a
            href="/reports"
            className="p-4 border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:bg-primary-50 transition-colors"
          >
            <TrendingUp className="w-8 h-8 text-primary-600 mb-2" />
            <h3 className="font-semibold text-gray-900">View Reports</h3>
            <p className="text-sm text-gray-600 mt-1">
              Analyze evaluation results and insights
            </p>
          </a>
        </div>
      </div>
    </div>
  );
}
