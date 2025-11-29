import React from 'react';
import { Outlet, Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../AuthContext';
import { 
  Home, FileText, Target, BarChart3, LogOut, 
  PlusCircle, Users 
} from 'lucide-react';

export default function Layout() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  const navigation = [
    { name: 'Dashboard', href: '/', icon: Home, roles: ['all'] },
    { 
      name: 'Submit Idea', 
      href: '/submit-idea', 
      icon: PlusCircle, 
      roles: ['startup_aspirant', 'system_admin'] 
    },
    { 
      name: 'Manage Use Cases', 
      href: '/usecases', 
      icon: Target, 
      roles: ['vc_representative', 'system_admin'] 
    },
    { name: 'Evaluate', href: '/evaluate', icon: BarChart3, roles: ['all'] },
    { name: 'Reports', href: '/reports', icon: FileText, roles: ['all'] },
  ];

  const filteredNav = navigation.filter(
    item => item.roles.includes('all') || item.roles.includes(user?.role)
  );

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Sidebar */}
      <div className="fixed inset-y-0 left-0 w-64 bg-white shadow-lg">
        <div className="flex flex-col h-full">
          <div className="flex items-center justify-center h-16 bg-primary-600">
            <h1 className="text-xl font-bold text-white">VC Scoring</h1>
          </div>
          
          <nav className="flex-1 px-4 py-6 space-y-2">
            {filteredNav.map((item) => (
              <Link
                key={item.name}
                to={item.href}
                className="flex items-center px-4 py-3 text-gray-700 rounded-lg hover:bg-primary-50 hover:text-primary-600 transition-colors"
              >
                <item.icon className="w-5 h-5 mr-3" />
                {item.name}
              </Link>
            ))}
          </nav>

          <div className="p-4 border-t">
            <div className="flex items-center mb-4">
              <div className="flex-1">
                <p className="text-sm font-medium text-gray-900">{user?.full_name}</p>
                <p className="text-xs text-gray-500">{user?.email}</p>
                <p className="text-xs text-primary-600 mt-1 capitalize">
                  {user?.role?.replace('_', ' ')}
                </p>
              </div>
            </div>
            <button
              onClick={handleLogout}
              className="flex items-center w-full px-4 py-2 text-sm text-gray-700 rounded-lg hover:bg-red-50 hover:text-red-600 transition-colors"
            >
              <LogOut className="w-4 h-4 mr-2" />
              Logout
            </button>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="ml-64 p-8">
        <Outlet />
      </div>
    </div>
  );
}
