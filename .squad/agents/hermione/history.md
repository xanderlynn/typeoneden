# Hermione's Work Log

## Phase 2 — SEO Structured Data (May 24, 2026)

### Completed Tasks

1. **Updated BaseLayout.astro**
   - Added `jsonLd?: string` prop to Props interface
   - Added destructuring for `jsonLd` parameter
   - Implemented fallback Organization JSON-LD for homepage (when ogType='website')
   - Added JSON-LD script tag render in `<head>` with `set:html={jsonLd || defaultJsonLd}`

2. **Updated BlogLayout.astro**
   - Added `updatedDate?: Date` to Props interface
   - Built Article JSON-LD with schema.org/Article context
   - JSON-LD includes: headline, description, datePublished, dateModified (uses updatedDate fallback to pubDate), author, publisher, mainEntityOfPage, and image
   - Passed `jsonLd={articleJsonLd}` to BaseLayout component

3. **Updated src/content/config.ts**
   - Added `updatedDate: z.coerce.date().optional()` field for blog posts
   - Added `tags: z.array(z.string()).optional().default([])` field for blog posts

4. **Build Verification**
   - Ran `npx astro build` successfully with all 25 pages built
   - No errors or breaking changes

### Key Decisions

- JSON-LD is passed as stringified JSON via prop (consistent with Astro's `set:html`)
- defaultJsonLd only renders when no custom jsonLd is provided AND ogType='website' (homepage)
- Blog posts always override with Article schema (more specific for Google Search)
- updatedDate is optional; falls back to pubDate if not provided
- Tags field is optional with empty array default (future-proofing for tag-based filtering)

## Learnings

- Astro's `set:html` directive safely renders JSON-LD scripts without escaping
- JSON.stringify() used for Article data structure (simpler than building a raw script string)
- ContentCollection schema expansion is backward-compatible when fields are optional with defaults
- Build succeeded without needing to update any blog post frontmatter (new fields are optional)
