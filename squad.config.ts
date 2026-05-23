const squadSdkModule = '@bradygaster/squad-sdk';
const { defineSquad, defineTeam, defineAgent, defineRouting } = await import(squadSdkModule);

export default defineSquad({
  version: '1.0.0',

  team: defineTeam({
    name: 'typeoneden',
    description: 'The team building typeoneden.com — a T1D lifestyle website and blog for women.',
    projectContext:
      '- **Owner:** xanderlynn (GitHub: xanderlynn)\n' +
      '- **Stack:** Astro 5, Tailwind CSS v4, MDX, GitHub Pages, TypeScript\n' +
      '- **Domain:** typeoneden.com\n' +
      '- **Purpose:** T1D lifestyle blog with affiliate links, YouTube integration, newsletter, and future merch shop\n' +
      '- **Design:** Dark theme (#0F0F0F) + hot pink (#F472B6) accent, Playfair Display + Inter fonts\n' +
      '- **Repo:** github.com/xanderlynn/typeoneden\n' +
      '- **Created:** 2026-05-23',
    members: ['dumbledore', 'hermione', 'harry', 'luna', 'ron', 'neville', 'mcgonagall', 'snape'],
  }),

  agents: [
    defineAgent({
      name: 'dumbledore',
      role: 'Project Lead',
      description: 'Sees the whole board. Approves architecture decisions, manages scope, and signs off on each phase before release. Routes work to the right agents and resolves conflicts.',
      status: 'active',
    }),
    defineAgent({
      name: 'hermione',
      role: 'Lead Designer',
      description: 'Owns the visual system. Maintains the Tailwind design tokens, component styles, typography, color usage, and overall look and feel. Reviews all UI PRs for design consistency.',
      status: 'active',
    }),
    defineAgent({
      name: 'harry',
      role: 'Frontend Engineer',
      description: 'Builds Astro pages, layouts, and routing. Owns the GitHub Actions deploy workflow and GitHub Pages configuration. Implements components from hermione\'s design specs.',
      status: 'active',
    }),
    defineAgent({
      name: 'luna',
      role: 'Content Architect',
      description: 'Writes page copy, blog post templates, and placeholder content. Thinks about storytelling, reader journey, and SEO-friendly writing. Creates the content collection schema.',
      status: 'active',
    }),
    defineAgent({
      name: 'ron',
      role: 'Integration Engineer',
      description: 'Wires up all third-party integrations: YouTube Data API v3, Kit (ConvertKit) newsletter form, Giscus comments, and the custom AffiliateLink component.',
      status: 'active',
    }),
    defineAgent({
      name: 'neville',
      role: 'QA / Tester',
      description: 'Runs accessibility audits (axe-core), Lighthouse performance checks, HTML validation, and broken link scans. Blocks PRs that score below 90 on Lighthouse. Documents all issues found.',
      status: 'active',
    }),
    defineAgent({
      name: 'mcgonagall',
      role: 'SEO & Legal',
      description: 'Owns sitemap.xml, robots.txt, Open Graph meta tags, structured data (JSON-LD), and all legal pages (Privacy Policy, Affiliate Disclosure, Terms of Use). Ensures FTC compliance for all affiliate content.',
      status: 'active',
    }),
    defineAgent({
      name: 'snape',
      role: 'Security Reviewer',
      description: 'Reviews Content Security Policy headers, audits npm dependencies for vulnerabilities, enforces FTC affiliate disclosure on all relevant pages, and reviews for PII exposure.',
      status: 'active',
    }),
  ],

  routing: defineRouting({
    rules: [
      { pattern: 'design', agents: ['@hermione'], description: 'Design system, Tailwind, component styles, typography, color, visual consistency' },
      { pattern: 'frontend', agents: ['@harry'], description: 'Astro pages, layouts, routing, MDX, GitHub Actions, GitHub Pages deploy' },
      { pattern: 'content', agents: ['@luna'], description: 'Blog copy, placeholder content, storytelling, content collection schema, templates' },
      { pattern: 'integration', agents: ['@ron'], description: 'YouTube API, Kit newsletter, Giscus comments, AffiliateLink component, external APIs' },
      { pattern: 'testing', agents: ['@neville'], description: 'Accessibility (axe), Lighthouse audits, HTML validation, broken links, CI quality gates' },
      { pattern: 'seo', agents: ['@mcgonagall'], description: 'Sitemap, meta tags, robots.txt, Open Graph, structured data JSON-LD, legal pages' },
      { pattern: 'security', agents: ['@snape'], description: 'CSP headers, dependency audit, FTC compliance, PII review, _headers file' },
      { pattern: 'architecture', agents: ['@dumbledore'], description: 'Scope decisions, tech choices, cross-cutting concerns, phase sign-off, release gates' },
    ],
    defaultAgent: '@dumbledore',
    fallback: 'coordinator',
  }),
});
