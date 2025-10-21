import { test, expect } from '@playwright/test';

test.describe('Application Health Tests', () => {
  test('should load the homepage successfully', async ({ page }) => {
    await page.goto('/');
    
    // Wait for React app to load
    await page.waitForLoadState('networkidle');
    
    // Check for React root element
    const rootElement = page.locator('#root');
    await expect(rootElement).toBeVisible();
    
    // Verify page title
    await expect(page).toHaveTitle(/VC UseCase Scoring/i);
  });

  test('should have working API health endpoint', async ({ request }) => {
    const response = await request.get('/api/health');
    
    expect(response.ok()).toBeTruthy();
    expect(response.status()).toBe(200);
    
    const data = await response.json();
    expect(data).toHaveProperty('status', 'healthy');
    expect(data).toHaveProperty('timestamp');
  });

  test('should have accessible API documentation', async ({ page }) => {
    await page.goto('/docs');
    
    // Wait for Swagger UI to load
    await page.waitForLoadState('networkidle');
    
    // Check for Swagger UI elements
    const swaggerUI = page.locator('.swagger-ui');
    await expect(swaggerUI).toBeVisible({ timeout: 10000 });
    
    // Verify API title
    const apiTitle = page.locator('.title');
    await expect(apiTitle).toBeVisible();
  });

  test('should handle CORS correctly', async ({ request }) => {
    const response = await request.get('/api/health', {
      headers: {
        'Origin': 'http://example.com'
      }
    });
    
    expect(response.ok()).toBeTruthy();
    const headers = response.headers();
    
    // Check CORS headers exist
    expect(headers['access-control-allow-origin']).toBeDefined();
  });

  test('should return 404 for non-existent routes', async ({ page }) => {
    const response = await page.goto('/api/nonexistent-endpoint');
    expect(response?.status()).toBe(404);
  });

  test('frontend should serve static assets correctly', async ({ page }) => {
    await page.goto('/');
    
    // Check that CSS and JS assets load
    const responses = await Promise.all([
      page.waitForResponse(response => 
        response.url().includes('.css') && response.status() === 200
      ),
      page.waitForResponse(response => 
        response.url().includes('.js') && response.status() === 200
      )
    ]);
    
    expect(responses).toHaveLength(2);
  });
});
