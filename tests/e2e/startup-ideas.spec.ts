import { test, expect } from '@playwright/test';
import { startupIdeas } from './test-data';

test.describe('Startup Ideas Management', () => {
  test('should submit a startup idea successfully', async ({ request }) => {
    const startup = startupIdeas[0];
    
    const response = await request.post('/api/startups', {
      data: {
        name: startup.name,
        pitch: startup.pitch,
        sector: startup.sector,
        stage: startup.stage,
        traction: startup.traction,
        team: startup.team,
        funding_needed: startup.fundingNeeded,
        use_of_funds: startup.useOfFunds,
        differentiators: startup.differentiators
      }
    });
    
    expect(response.ok()).toBeTruthy();
    expect(response.status()).toBe(201);
    
    const data = await response.json();
    expect(data).toHaveProperty('id');
    expect(data).toHaveProperty('name', startup.name);
    expect(data).toHaveProperty('sector', startup.sector);
  });

  test('should submit all 5 startup ideas', async ({ request }) => {
    const results = [];
    
    for (const startup of startupIdeas) {
      const response = await request.post('/api/startups', {
        data: {
          name: startup.name,
          pitch: startup.pitch,
          sector: startup.sector,
          stage: startup.stage,
          traction: startup.traction,
          team: startup.team,
          funding_needed: startup.fundingNeeded,
          use_of_funds: startup.useOfFunds,
          differentiators: startup.differentiators
        }
      });
      
      expect(response.ok()).toBeTruthy();
      const data = await response.json();
      results.push(data);
    }
    
    expect(results).toHaveLength(5);
    
    // Verify all startup names are unique
    const names = results.map(r => r.name);
    expect(new Set(names).size).toBe(5);
    
    // Verify sectors match our test data
    const sectors = results.map(r => r.sector);
    expect(sectors).toContain('Healthcare');
    expect(sectors).toContain('Energy');
    expect(sectors).toContain('Enterprise Software');
    expect(sectors).toContain('Fintech');
    expect(sectors).toContain('Education Technology');
  });

  test('should retrieve list of startups', async ({ request }) => {
    // First, create a startup
    await request.post('/api/startups', {
      data: {
        name: startupIdeas[0].name,
        pitch: startupIdeas[0].pitch,
        sector: startupIdeas[0].sector,
        stage: startupIdeas[0].stage,
        traction: startupIdeas[0].traction,
        team: startupIdeas[0].team,
        funding_needed: startupIdeas[0].fundingNeeded,
        use_of_funds: startupIdeas[0].useOfFunds,
        differentiators: startupIdeas[0].differentiators
      }
    });
    
    // Then retrieve the list
    const response = await request.get('/api/startups');
    
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    
    expect(Array.isArray(data)).toBeTruthy();
    expect(data.length).toBeGreaterThan(0);
  });

  test('should validate startup traction metrics', async ({ request }) => {
    const startup = startupIdeas[0];
    
    const response = await request.post('/api/startups', {
      data: {
        name: startup.name,
        pitch: startup.pitch,
        sector: startup.sector,
        stage: startup.stage,
        traction: startup.traction,
        team: startup.team,
        funding_needed: startup.fundingNeeded,
        use_of_funds: startup.useOfFunds,
        differentiators: startup.differentiators
      }
    });
    
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    
    // Verify traction data is stored correctly
    expect(data.traction).toBeDefined();
    expect(data.traction).toHaveProperty('revenue');
    expect(data.traction).toHaveProperty('customers');
    expect(data.traction).toHaveProperty('growth');
  });

  test('should filter startups by sector', async ({ request }) => {
    // Create a startup
    await request.post('/api/startups', {
      data: {
        name: startupIdeas[3].name,
        pitch: startupIdeas[3].pitch,
        sector: startupIdeas[3].sector,
        stage: startupIdeas[3].stage,
        traction: startupIdeas[3].traction,
        team: startupIdeas[3].team,
        funding_needed: startupIdeas[3].fundingNeeded,
        use_of_funds: startupIdeas[3].useOfFunds,
        differentiators: startupIdeas[3].differentiators
      }
    });
    
    // Filter by Fintech sector
    const response = await request.get('/api/startups?sector=Fintech');
    
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    
    // All results should be Fintech sector
    data.forEach((startup: any) => {
      expect(startup.sector).toBe('Fintech');
    });
  });

  test('should calculate AI scoring for startup', async ({ request }) => {
    const startup = startupIdeas[0];
    
    const response = await request.post('/api/startups', {
      data: {
        name: startup.name,
        pitch: startup.pitch,
        sector: startup.sector,
        stage: startup.stage,
        traction: startup.traction,
        team: startup.team,
        funding_needed: startup.fundingNeeded,
        use_of_funds: startup.useOfFunds,
        differentiators: startup.differentiators
      }
    });
    
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    
    // Verify AI scoring is performed
    expect(data).toHaveProperty('score');
    expect(typeof data.score).toBe('number');
    expect(data.score).toBeGreaterThanOrEqual(0);
    expect(data.score).toBeLessThanOrEqual(100);
  });
});
