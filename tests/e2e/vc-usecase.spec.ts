import { test, expect } from '@playwright/test';
import { vcUseCases } from './test-data';

test.describe('VC Use Case Management', () => {
  test('should submit a VC use case successfully', async ({ request }) => {
    const vcUseCase = vcUseCases[0];
    
    const response = await request.post('/api/vc-usecases', {
      data: {
        title: vcUseCase.title,
        description: vcUseCase.description,
        sector: vcUseCase.sector,
        stage: vcUseCase.stage,
        investment_range: vcUseCase.investmentRange,
        key_requirements: vcUseCase.keyRequirements,
        geography: vcUseCase.geography
      }
    });
    
    expect(response.ok()).toBeTruthy();
    expect(response.status()).toBe(201);
    
    const data = await response.json();
    expect(data).toHaveProperty('id');
    expect(data).toHaveProperty('title', vcUseCase.title);
    expect(data).toHaveProperty('sector', vcUseCase.sector);
  });

  test('should submit all 5 VC use cases', async ({ request }) => {
    const results = [];
    
    for (const vcUseCase of vcUseCases) {
      const response = await request.post('/api/vc-usecases', {
        data: {
          title: vcUseCase.title,
          description: vcUseCase.description,
          sector: vcUseCase.sector,
          stage: vcUseCase.stage,
          investment_range: vcUseCase.investmentRange,
          key_requirements: vcUseCase.keyRequirements,
          geography: vcUseCase.geography
        }
      });
      
      expect(response.ok()).toBeTruthy();
      const data = await response.json();
      results.push(data);
    }
    
    expect(results).toHaveLength(5);
    
    // Verify all sectors are represented
    const sectors = results.map(r => r.sector);
    expect(sectors).toContain('Healthcare');
    expect(sectors).toContain('Energy');
    expect(sectors).toContain('Enterprise Software');
    expect(sectors).toContain('Fintech');
    expect(sectors).toContain('Education Technology');
  });

  test('should retrieve list of VC use cases', async ({ request }) => {
    // First, create a VC use case
    await request.post('/api/vc-usecases', {
      data: {
        title: vcUseCases[0].title,
        description: vcUseCases[0].description,
        sector: vcUseCases[0].sector,
        stage: vcUseCases[0].stage,
        investment_range: vcUseCases[0].investmentRange,
        key_requirements: vcUseCases[0].keyRequirements,
        geography: vcUseCases[0].geography
      }
    });
    
    // Then retrieve the list
    const response = await request.get('/api/vc-usecases');
    
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    
    expect(Array.isArray(data)).toBeTruthy();
    expect(data.length).toBeGreaterThan(0);
  });

  test('should validate required fields for VC use case', async ({ request }) => {
    const response = await request.post('/api/vc-usecases', {
      data: {
        title: 'Test VC'
        // Missing required fields
      }
    });
    
    expect(response.status()).toBeGreaterThanOrEqual(400);
    expect(response.status()).toBeLessThan(500);
  });

  test('should filter VC use cases by sector', async ({ request }) => {
    // Create VC use cases
    await request.post('/api/vc-usecases', {
      data: {
        title: vcUseCases[0].title,
        description: vcUseCases[0].description,
        sector: vcUseCases[0].sector,
        stage: vcUseCases[0].stage,
        investment_range: vcUseCases[0].investmentRange,
        key_requirements: vcUseCases[0].keyRequirements,
        geography: vcUseCases[0].geography
      }
    });
    
    // Filter by Healthcare sector
    const response = await request.get('/api/vc-usecases?sector=Healthcare');
    
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    
    // All results should be Healthcare sector
    data.forEach((vc: any) => {
      expect(vc.sector).toBe('Healthcare');
    });
  });
});
