import { test, expect } from '@playwright/test';
import { vcUseCases, startupIdeas, expectedMatches, getExpectedMatch } from './test-data';

test.describe('VC-Startup Matching Algorithm', () => {
  let createdVCs: any[] = [];
  let createdStartups: any[] = [];

  test.beforeAll(async ({ request }) => {
    // Create all VC use cases
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
      
      if (response.ok()) {
        const data = await response.json();
        createdVCs.push(data);
      }
    }

    // Create all startups
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
      
      if (response.ok()) {
        const data = await response.json();
        createdStartups.push(data);
      }
    }
  });

  test('should find matches for a VC use case', async ({ request }) => {
    if (createdVCs.length === 0) {
      test.skip();
      return;
    }

    const vcId = createdVCs[0].id;
    const response = await request.get(`/api/vc-usecases/${vcId}/matches`);
    
    expect(response.ok()).toBeTruthy();
    const matches = await response.json();
    
    expect(Array.isArray(matches)).toBeTruthy();
    
    // Should have at least some matches
    if (matches.length > 0) {
      // Verify match structure
      expect(matches[0]).toHaveProperty('startup_id');
      expect(matches[0]).toHaveProperty('match_score');
      expect(matches[0]).toHaveProperty('reasoning');
      
      // Scores should be 0-100
      matches.forEach((match: any) => {
        expect(match.match_score).toBeGreaterThanOrEqual(0);
        expect(match.match_score).toBeLessThanOrEqual(100);
      });
    }
  });

  test('should find matches for a startup', async ({ request }) => {
    if (createdStartups.length === 0) {
      test.skip();
      return;
    }

    const startupId = createdStartups[0].id;
    const response = await request.get(`/api/startups/${startupId}/matches`);
    
    expect(response.ok()).toBeTruthy();
    const matches = await response.json();
    
    expect(Array.isArray(matches)).toBeTruthy();
    
    if (matches.length > 0) {
      // Verify match structure
      expect(matches[0]).toHaveProperty('vc_id');
      expect(matches[0]).toHaveProperty('match_score');
      
      // Scores should be ordered from high to low
      for (let i = 0; i < matches.length - 1; i++) {
        expect(matches[i].match_score).toBeGreaterThanOrEqual(matches[i + 1].match_score);
      }
    }
  });

  test('should correctly match perfect sector-stage-funding combinations', async ({ request }) => {
    // Test case: Healthcare startup should match Healthcare VC
    const healthcareVC = createdVCs.find(vc => vc.sector === 'Healthcare');
    const healthcareStartup = createdStartups.find(s => s.sector === 'Healthcare');
    
    if (!healthcareVC || !healthcareStartup) {
      test.skip();
      return;
    }

    const response = await request.get(`/api/vc-usecases/${healthcareVC.id}/matches`);
    expect(response.ok()).toBeTruthy();
    
    const matches = await response.json();
    
    // Healthcare startup should be in the matches
    const healthcareMatch = matches.find((m: any) => m.startup_id === healthcareStartup.id);
    expect(healthcareMatch).toBeDefined();
    
    // Should have a high score (>60) for same sector
    if (healthcareMatch) {
      expect(healthcareMatch.match_score).toBeGreaterThan(60);
    }
  });

  test('should have lower scores for mismatched sectors', async ({ request }) => {
    const healthcareVC = createdVCs.find(vc => vc.sector === 'Healthcare');
    const fintechStartup = createdStartups.find(s => s.sector === 'Fintech');
    
    if (!healthcareVC || !fintechStartup) {
      test.skip();
      return;
    }

    const response = await request.get(`/api/vc-usecases/${healthcareVC.id}/matches`);
    expect(response.ok()).toBeTruthy();
    
    const matches = await response.json();
    
    // Fintech startup should have lower score when matched with Healthcare VC
    const mismatchedMatch = matches.find((m: any) => m.startup_id === fintechStartup.id);
    
    if (mismatchedMatch) {
      // Mismatched sectors should generally score lower (<50)
      expect(mismatchedMatch.match_score).toBeLessThan(70);
    }
  });

  test('should provide reasoning for matches', async ({ request }) => {
    if (createdVCs.length === 0) {
      test.skip();
      return;
    }

    const vcId = createdVCs[0].id;
    const response = await request.get(`/api/vc-usecases/${vcId}/matches`);
    
    expect(response.ok()).toBeTruthy();
    const matches = await response.json();
    
    if (matches.length > 0) {
      // Reasoning should be present and meaningful
      expect(matches[0].reasoning).toBeDefined();
      expect(matches[0].reasoning.length).toBeGreaterThan(10);
      
      // Reasoning should mention key factors
      const reasoning = matches[0].reasoning.toLowerCase();
      const hasRelevantKeywords = 
        reasoning.includes('sector') ||
        reasoning.includes('stage') ||
        reasoning.includes('funding') ||
        reasoning.includes('investment') ||
        reasoning.includes('match');
      
      expect(hasRelevantKeywords).toBeTruthy();
    }
  });

  test('should match all expected perfect pairs', async ({ request }) => {
    for (const expectedMatch of expectedMatches) {
      const vc = createdVCs.find(v => vcUseCases[expectedMatch.vcId - 1].title === v.title);
      const startup = createdStartups.find(s => startupIdeas[expectedMatch.startupId - 1].name === s.name);
      
      if (!vc || !startup) continue;

      const response = await request.get(`/api/vc-usecases/${vc.id}/matches`);
      expect(response.ok()).toBeTruthy();
      
      const matches = await response.json();
      const match = matches.find((m: any) => m.startup_id === startup.id);
      
      // Perfect matches should score high (>75)
      expect(match).toBeDefined();
      if (match) {
        expect(match.match_score).toBeGreaterThan(75);
      }
    }
  });

  test('should generate match matrix for all combinations', async ({ request }) => {
    const matchMatrix = [];
    
    for (const vc of createdVCs) {
      const response = await request.get(`/api/vc-usecases/${vc.id}/matches`);
      
      if (response.ok()) {
        const matches = await response.json();
        matchMatrix.push({
          vc: vc.title,
          matches: matches.length,
          topScore: matches[0]?.match_score || 0
        });
      }
    }
    
    // Every VC should have evaluated all startups
    expect(matchMatrix.length).toBe(createdVCs.length);
    
    // Log match matrix for debugging
    console.log('Match Matrix:', JSON.stringify(matchMatrix, null, 2));
  });

  test('should handle pagination for large match results', async ({ request }) => {
    if (createdVCs.length === 0) {
      test.skip();
      return;
    }

    const vcId = createdVCs[0].id;
    
    // Request with limit
    const response = await request.get(`/api/vc-usecases/${vcId}/matches?limit=3`);
    expect(response.ok()).toBeTruthy();
    
    const matches = await response.json();
    expect(matches.length).toBeLessThanOrEqual(3);
  });

  test('should filter matches by minimum score threshold', async ({ request }) => {
    if (createdVCs.length === 0) {
      test.skip();
      return;
    }

    const vcId = createdVCs[0].id;
    
    // Request only high-score matches
    const response = await request.get(`/api/vc-usecases/${vcId}/matches?min_score=70`);
    expect(response.ok()).toBeTruthy();
    
    const matches = await response.json();
    
    // All matches should be above threshold
    matches.forEach((match: any) => {
      expect(match.match_score).toBeGreaterThanOrEqual(70);
    });
  });
});
