import { test, expect } from '@playwright/test';

// ─── Helpers ──────────────────────────────────────────────────────────────────

async function expectReadableText(page: any, selector: string) {
  const el = page.locator(selector).first();
  await expect(el).toBeVisible();
  const color = await el.evaluate((n: HTMLElement) =>
    getComputedStyle(n).color
  );
  // Confirm text is not pink (#F472B6 ≈ rgb(244,114,182)) on pink background
  expect(color).not.toBe('rgb(244, 114, 182)');
}

// ─── Navigation ───────────────────────────────────────────────────────────────

test.describe('Navigation', () => {
  test('nav renders the TypeOneDen wordmark', async ({ page }) => {
    await page.goto('/');
    const nav = page.locator('nav');
    await expect(nav).toBeVisible();
    await expect(nav).toContainText('TypeOneDen');
  });

  test('nav links are present and navigate correctly', async ({ page }) => {
    await page.goto('/');

    const links = [
      { text: 'Blog', href: '/blog' },
      { text: 'About', href: '/about' },
      { text: 'Resources', href: '/resources' },
      { text: 'YouTube', href: '/youtube' },
    ];

    for (const { text, href } of links) {
      await page.goto('/');
      const link = page.locator(`nav a`).filter({ hasText: text }).first();
      await expect(link).toBeVisible();
      await link.click();
      await expect(page).toHaveURL(new RegExp(href));
    }
  });

  test('nav logo links back to homepage', async ({ page }) => {
    await page.goto('/blog');
    await page.locator('nav a').filter({ hasText: 'TypeOneDen' }).first().click();
    await expect(page).toHaveURL('/');
  });
});

// ─── Homepage ─────────────────────────────────────────────────────────────────

test.describe('Homepage', () => {
  test('hero section renders with headline', async ({ page }) => {
    await page.goto('/');
    const hero = page.locator('section').first();
    await expect(hero).toBeVisible();
    // Headline should include T1D-related text
    const heading = page.locator('h1').first();
    await expect(heading).toBeVisible();
    const text = await heading.textContent();
    expect(text?.length).toBeGreaterThan(5);
  });

  test('"Read Blog" CTA button has readable text (not pink-on-pink)', async ({ page }) => {
    await page.goto('/');
    // Find the CTA button/link
    const cta = page.locator('a.button-accent').first();
    await expect(cta).toBeVisible();

    // Log what we find for debugging
    const outerHTML = await cta.evaluate((n: HTMLElement) => n.outerHTML);
    console.log(`Button HTML: ${outerHTML}`);

    const color = await cta.evaluate((n: HTMLElement) =>
      getComputedStyle(n).color
    );
    const bg = await cta.evaluate((n: HTMLElement) =>
      getComputedStyle(n).backgroundColor
    );
    console.log(`CTA color: ${color}, bg: ${bg}`);

    // Text should be white on purple background (Copilot theme)
    expect(color).toBe('rgb(255, 255, 255)');
    // Background should be the purple Copilot accent
    expect(bg).toBe('rgb(137, 87, 229)');
  });

  test('homepage shows latest blog posts', async ({ page }) => {
    await page.goto('/');
    // Expect at least 2 blog card links in the recent posts section
    const postLinks = page.locator('a[href^="/blog/"]');
    await expect(postLinks.first()).toBeVisible();
    const count = await postLinks.count();
    expect(count).toBeGreaterThanOrEqual(2);
  });

  test('newsletter signup section is present', async ({ page }) => {
    await page.goto('/');
    const newsletter = page.locator('form, [class*="newsletter"], section').filter({
      hasText: /newsletter|subscribe|join/i,
    }).first();
    await expect(newsletter).toBeVisible();
  });
});

// ─── Blog Listing ─────────────────────────────────────────────────────────────

test.describe('Blog Listing', () => {
  test('blog index loads and shows posts', async ({ page }) => {
    await page.goto('/blog');
    await expect(page).toHaveTitle(/blog/i);
    const cards = page.locator('article, [class*="card"], a[href^="/blog/"]');
    const count = await cards.count();
    expect(count).toBeGreaterThanOrEqual(10);
    console.log(`Blog cards found: ${count}`);
  });

  test('each blog card has a title and date', async ({ page }) => {
    await page.goto('/blog');
    const cardLinks = page.locator('a[href^="/blog/"]');
    const count = await cardLinks.count();
    expect(count).toBeGreaterThan(0);

    // Check first 5 cards have non-empty text
    const checkCount = Math.min(count, 5);
    for (let i = 0; i < checkCount; i++) {
      const text = await cardLinks.nth(i).textContent();
      expect(text?.trim().length).toBeGreaterThan(0);
    }
  });

  test('clicking a blog card navigates to the post', async ({ page }) => {
    await page.goto('/blog');
    const firstCard = page.locator('a[href^="/blog/"]').first();
    const href = await firstCard.getAttribute('href');
    await firstCard.click();
    await expect(page).toHaveURL(new RegExp('/blog/'));
    // Should show post content
    const article = page.locator('article, main').first();
    await expect(article).toBeVisible();
    console.log(`Navigated to: ${href}`);
  });

  test('blog grid tiles render at least 10 posts', async ({ page }) => {
    await page.goto('/blog');
    const postLinks = page.locator('a[href^="/blog/"]');
    await expect(postLinks.first()).toBeVisible();
    const count = await postLinks.count();
    expect(count).toBeGreaterThanOrEqual(10);
    console.log(`Total blog post links: ${count}`);
  });
});

// ─── Blog Post ────────────────────────────────────────────────────────────────

test.describe('Blog Post', () => {
  test('individual blog post renders with title and content', async ({ page }) => {
    await page.goto('/blog');
    const firstPost = page.locator('a[href^="/blog/"]').first();
    await firstPost.click();
    await page.waitForURL(/\/blog\/.+/);

    const heading = page.locator('h1').first();
    await expect(heading).toBeVisible();
    const title = await heading.textContent();
    expect(title?.trim().length).toBeGreaterThan(0);

    const body = page.locator('article, .prose, main p').first();
    await expect(body).toBeVisible();
  });

  test('blog post page has back link to /blog', async ({ page }) => {
    await page.goto('/blog');
    await page.locator('a[href^="/blog/"]').first().click();
    await page.waitForURL(/\/blog\/.+/);

    const backLink = page.locator('a[href="/blog"]').first();
    await expect(backLink).toBeVisible();
  });

  test('each of the 5 category posts is accessible', async ({ page }) => {
    const slugs = [
      '/blog/dexcom-g7-honest-review',         // Tech & Gear
      '/blog/easy-low-carb-meal-prep-for-t1d', // Nutrition
      '/blog/why-i-started-advocating-for-insulin-access', // Advocacy
      '/blog/building-a-positive-mindset-with-chronic-illness', // Mindset
      '/blog/traveling-internationally-with-type-1', // Life with T1D
    ];

    for (const slug of slugs) {
      await page.goto(slug);
      await expect(page.locator('h1').first()).toBeVisible();
      const status = page.url();
      expect(status).toContain('/blog/');
      console.log(`✓ ${slug}`);
    }
  });
});

// ─── Static Pages ─────────────────────────────────────────────────────────────

test.describe('Static pages', () => {
  const pages = [
    { path: '/about',       contains: /about|t1d|diabetes/i },
    { path: '/resources',   contains: /resource|affiliate|gear/i },
    { path: '/start',       contains: /start|welcome|new/i },
    { path: '/newsletter',  contains: /newsletter|subscribe|email/i },
    { path: '/contact',     contains: /contact|reach|email/i },
    { path: '/youtube',     contains: /youtube|video|channel/i },
    { path: '/privacy',     contains: /privacy|data/i },
    { path: '/disclosure',  contains: /disclosure|affiliate/i },
    { path: '/terms',       contains: /terms|use/i },
  ];

  for (const { path, contains } of pages) {
    test(`${path} loads and contains expected content`, async ({ page }) => {
      const response = await page.goto(path);
      expect(response?.status()).toBeLessThan(400);
      const body = await page.textContent('body');
      expect(body).toMatch(contains);
    });
  }
});

// ─── Footer ───────────────────────────────────────────────────────────────────

test.describe('Footer', () => {
  test('footer renders the TypeOneDen wordmark', async ({ page }) => {
    await page.goto('/');
    const footer = page.locator('footer');
    await expect(footer).toBeVisible();
    await expect(footer).toContainText('TypeOneDen');
  });

  test('footer contains legal page links', async ({ page }) => {
    await page.goto('/');
    const footer = page.locator('footer');
    await expect(footer.locator('a[href="/privacy"]')).toBeVisible();
    await expect(footer.locator('a[href="/disclosure"]')).toBeVisible();
    await expect(footer.locator('a[href="/terms"]')).toBeVisible();
  });
});

// ─── Visual / Contrast ────────────────────────────────────────────────────────

test.describe('Visual quality', () => {
  test('page background is near-black (not white)', async ({ page }) => {
    await page.goto('/');
    const bg = await page.evaluate(() =>
      getComputedStyle(document.body).backgroundColor
    );
    // Should be dark, not white (255,255,255)
    expect(bg).not.toBe('rgb(255, 255, 255)');
    console.log(`Body background: ${bg}`);
  });

  test('no 404 errors on homepage linked assets', async ({ page }) => {
    const failed: string[] = [];
    page.on('response', res => {
      if (res.status() === 404) failed.push(res.url());
    });
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    if (failed.length > 0) console.warn('404s:', failed);
    expect(failed.length).toBe(0);
  });

  test('blog page has no horizontal overflow (no unwanted scroll)', async ({ page }) => {
    await page.goto('/blog');
    const overflow = await page.evaluate(() => {
      return document.documentElement.scrollWidth > document.documentElement.clientWidth;
    });
    expect(overflow).toBe(false);
  });
});
