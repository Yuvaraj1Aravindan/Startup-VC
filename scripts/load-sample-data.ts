import axios from 'axios';
import * as fs from 'fs';
import * as path from 'path';

const API_BASE_URL = 'http://4.213.154.131';

interface VCUseCase {
  title: string;
  description: string;
  industry: string;
  stage: string;
  investment_range: string;
  key_criteria: string[];
  preferences: Record<string, string>;
}

interface StartupIdea {
  name: string;
  tagline: string;
  description: string;
  problem: string;
  solution: string;
  market: string;
  business_model: string;
  target_customers: string;
  competition: string;
  differentiation: string;
  traction: Record<string, any>;
  team: Record<string, any>;
  funding_need: string;
  use_of_funds: string;
}

interface TestData {
  vc_usecases: VCUseCase[];
  startup_ideas: StartupIdea[];
}

// Colors for console output
const colors = {
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  reset: '\x1b[0m',
};

async function checkHealth(): Promise<boolean> {
  try {
    const response = await axios.get(`${API_BASE_URL}/api/health`, { timeout: 5000 });
    console.log(`${colors.green}✓${colors.reset} API is healthy`);
    return response.data.status === 'healthy';
  } catch (error) {
    console.error(`${colors.red}✗${colors.reset} API health check failed:`, error.message);
    return false;
  }
}

async function createUser(email: string, password: string, role: string): Promise<any> {
  try {
    const response = await axios.post(`${API_BASE_URL}/api/auth/register`, {
      email,
      password,
      full_name: role === 'vc' ? 'Demo VC Investor' : 'Demo Startup Founder',
      role,
    });
    console.log(`${colors.green}✓${colors.reset} Created ${role} user: ${email}`);
    return response.data;
  } catch (error) {
    if (error.response?.status === 400 && error.response?.data?.detail?.includes('already registered')) {
      console.log(`${colors.yellow}→${colors.reset} User already exists: ${email}`);
      return { email };
    }
    throw error;
  }
}

async function login(email: string, password: string): Promise<string> {
  try {
    const formData = new URLSearchParams();
    formData.append('username', email);
    formData.append('password', password);
    
    const response = await axios.post(`${API_BASE_URL}/api/auth/login`, formData, {
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    });
    console.log(`${colors.green}✓${colors.reset} Logged in as: ${email}`);
    return response.data.access_token;
  } catch (error) {
    console.error(`${colors.red}✗${colors.reset} Login failed for ${email}:`, error.response?.data || error.message);
    throw error;
  }
}

async function createVCUseCase(token: string, usecase: VCUseCase): Promise<any> {
  try {
    const response = await axios.post(
      `${API_BASE_URL}/api/vc-usecases`,
      {
        title: usecase.title,
        description: usecase.description,
        industry: usecase.industry,
        stage: usecase.stage,
        investment_range: usecase.investment_range,
        key_criteria: usecase.key_criteria,
        preferences: usecase.preferences,
      },
      {
        headers: { Authorization: `Bearer ${token}` },
      }
    );
    console.log(`${colors.green}✓${colors.reset} Created VC use case: ${usecase.title}`);
    return response.data;
  } catch (error) {
    console.error(`${colors.red}✗${colors.reset} Failed to create VC use case:`, error.response?.data || error.message);
    throw error;
  }
}

async function createStartupIdea(token: string, startup: StartupIdea): Promise<any> {
  try {
    const response = await axios.post(
      `${API_BASE_URL}/api/startup-ideas`,
      {
        name: startup.name,
        tagline: startup.tagline,
        description: startup.description,
        problem: startup.problem,
        solution: startup.solution,
        market: startup.market,
        business_model: startup.business_model,
        target_customers: startup.target_customers,
        competition: startup.competition,
        differentiation: startup.differentiation,
        traction: startup.traction,
        team: startup.team,
        funding_need: startup.funding_need,
        use_of_funds: startup.use_of_funds,
      },
      {
        headers: { Authorization: `Bearer ${token}` },
      }
    );
    console.log(`${colors.green}✓${colors.reset} Created startup idea: ${startup.name}`);
    return response.data;
  } catch (error) {
    console.error(`${colors.red}✗${colors.reset} Failed to create startup:`, error.response?.data || error.message);
    throw error;
  }
}

async function main() {
  console.log(`\n${colors.blue}=== Loading Sample Data to Azure Application ===${colors.reset}\n`);
  console.log(`Target: ${API_BASE_URL}\n`);

  // Step 1: Health check
  console.log(`${colors.blue}Step 1: Health Check${colors.reset}`);
  const isHealthy = await checkHealth();
  if (!isHealthy) {
    console.error(`${colors.red}✗ Application is not healthy. Exiting.${colors.reset}`);
    process.exit(1);
  }
  console.log('');

  // Step 2: Load test data
  console.log(`${colors.blue}Step 2: Loading Test Data${colors.reset}`);
  const dataPath = path.join(__dirname, '../test-data/sample-data.json');
  const testData: TestData = JSON.parse(fs.readFileSync(dataPath, 'utf-8'));
  console.log(`${colors.green}✓${colors.reset} Loaded ${testData.vc_usecases.length} VC use cases and ${testData.startup_ideas.length} startup ideas`);
  console.log('');

  // Step 3: Create demo users
  console.log(`${colors.blue}Step 3: Creating Demo Users${colors.reset}`);
  await createUser('vc@demo.com', 'Demo@123', 'vc');
  await createUser('startup@demo.com', 'Demo@123', 'startup');
  console.log('');

  // Step 4: Login as VC
  console.log(`${colors.blue}Step 4: Logging in as VC${colors.reset}`);
  const vcToken = await login('vc@demo.com', 'Demo@123');
  console.log('');

  // Step 5: Create VC use cases
  console.log(`${colors.blue}Step 5: Creating VC Use Cases${colors.reset}`);
  for (const usecase of testData.vc_usecases) {
    await createVCUseCase(vcToken, usecase);
    await new Promise(resolve => setTimeout(resolve, 500)); // Rate limiting
  }
  console.log('');

  // Step 6: Login as Startup
  console.log(`${colors.blue}Step 6: Logging in as Startup${colors.reset}`);
  const startupToken = await login('startup@demo.com', 'Demo@123');
  console.log('');

  // Step 7: Create startup ideas
  console.log(`${colors.blue}Step 7: Creating Startup Ideas${colors.reset}`);
  for (const startup of testData.startup_ideas) {
    await createStartupIdea(startupToken, startup);
    await new Promise(resolve => setTimeout(resolve, 500)); // Rate limiting
  }
  console.log('');

  // Summary
  console.log(`${colors.green}=== ✓ Sample Data Loaded Successfully ===${colors.reset}\n`);
  console.log(`${colors.blue}Summary:${colors.reset}`);
  console.log(`  • VC Use Cases: ${testData.vc_usecases.length}`);
  console.log(`  • Startup Ideas: ${testData.startup_ideas.length}`);
  console.log(`  • Demo Accounts:`);
  console.log(`    - vc@demo.com (password: Demo@123)`);
  console.log(`    - startup@demo.com (password: Demo@123)`);
  console.log(`\n${colors.blue}Access your application at:${colors.reset}`);
  console.log(`  ${API_BASE_URL}\n`);
}

// Run the script
main().catch((error) => {
  console.error(`\n${colors.red}✗ Error loading data:${colors.reset}`, error.message);
  process.exit(1);
});
