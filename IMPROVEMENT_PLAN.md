# TypeOneDen — Performance, Optimization & Modernization Plan

**Author:** Dumbledore (Project Lead)  
**Date:** 2026-05-24  
**Branch:** agents-code-performance-optimization-analysis  
**Sources:** Harry (Frontend), Hermione (Design), Neville (QA), Snape (Security)

---

## Executive Summary

TypeOneDen is a Type 1 Diabetes lifestyle blog built on Astro 5 with Tailwind v4. The codebase has a solid foundation — good content structure, a well-defined dark design token system, and modern tooling — but suffers from **incomplete implementations** (placeholder URLs, empty config values, broken HTML), **performance bottlenecks** (render-blocking Google Fonts, eager YouTube iframes, unoptimized images), and **design system fragmentation** (37+ hardcoded hex values across 7 files). Security posture is weak with no CSP headers, unvalidated link props, and GDPR-exposing third-party requests.

**Current Estimated Lighthouse Scores:**

| Category | Score |
|----------|-------|
| Performance | 62–70 🔴 |
| Accessibility | 74–80 🟠 |
| Best Practices | 83–88 🟡 |
| SEO | 78–84 🟡 |

**Target Scores (after Phase 1+2):** All categories ≥ 90

**Total Issues Found:** 58 items across 5 categories — 8 Critical, 12 High, 19 Medium, 19 Low

---

## Issue Inventory Table

| # | Issue | Severity | Category | Owner | Phase |
|---|-------|----------|----------|-------|-------|
| 1 | Kit newsletter form placeholder URL | 🔴 Critical | Security | snape | 1 |
| 2 | AffiliateLink unvalidated `href` (XSS vector) | 🔴 Critical | Security | snape | 1 |
| 3 | Giscus loaded with empty config | 🔴 Critical | Security | snape | 1 |
| 4 | All affiliate links are `#` placeholders | 🔴 Critical | Security | snape | 1 |
| 5 | Duplicate `class` attributes (broken layout) | 🔴 Critical | Performance | harry | 1 |
| 6 | Nested `<main>` landmark (invalid HTML) | 🔴 Critical | A11y | neville | 1 |
| 7 | Blog card images with empty `alt` | 🔴 Critical | A11y | neville | 1 |
| 8 | Theme init script below content (FOUC) | 🔴 Critical | Performance | harry | 1 |
| 9 | No security headers (CSP, X-Frame-Options) | 🟠 High | Security | snape | 1 |
| 10 | Google Fonts GDPR privacy leakage | 🟠 High | Security | snape | 1 |
| 11 | Render-blocking Google Fonts stylesheet | 🟠 High | Performance | harry | 2 |
| 12 | YouTube eager iframe (1.5MB third-party JS) | 🟠 High | Performance | harry | 2 |
| 13 | Dynamic script injection pattern (Giscus) | 🟠 High | Security | snape | 2 |
| 14 | Astro generator version disclosure | 🟠 High | Security | snape | 1 |
| 15 | YouTube iframe overpermissive `allow` | 🟠 High | Security | snape | 2 |
| 16 | Color contrast `#484F58` fails WCAG AA | 🟠 High | A11y | neville | 2 |
| 17 | Footer uses wrong background color | 🟠 High | Design | hermione | 2 |
| 18 | Stray purple hover on featured card | 🟠 High | Design | hermione | 2 |
| 19 | Border color 6 locations, 4 different values | 🟠 High | Design | hermione | 2 |
| 20 | `post: any` type cast (type safety loss) | 🟡 Medium | Modernization | harry | 1 |
| 21 | Silent error swallowing on `getCollection` | 🟡 Medium | Modernization | harry | 1 |
| 22 | `post.render()` deprecated in Astro 5 | 🟡 Medium | Modernization | harry | 1 |
| 23 | No `<Image>` component (no optimization) | 🟡 Medium | Performance | harry | 2 |
| 24 | No hero/critical asset preload | 🟡 Medium | Performance | neville | 2 |
| 25 | `filter:blur(40px)` paint storm risk | 🟡 Medium | Performance | neville | 2 |
| 26 | `backdrop-filter` on Nav without `will-change` | 🟡 Medium | Performance | neville | 2 |
| 27 | Theme toggle missing `aria-pressed` | 🟡 Medium | A11y | neville | 2 |
| 28 | Mobile menu focus management | 🟡 Medium | A11y | neville | 2 |
| 29 | `prefers-reduced-motion` not respected | 🟡 Medium | A11y | hermione | 2 |
| 30 | Light mode accent fails WCAG contrast | 🟡 Medium | A11y | hermione | 2 |
| 31 | FTC disclosure not co-located with links | 🟡 Medium | Security | snape | 2 |
| 32 | Category filter URL param not validated | 🟡 Medium | Security | snape | 2 |
| 33 | CSP blocked by inline styles | 🟡 Medium | Security | snape | 3 |
| 34 | `og:type` always "website" on blog posts | 🟡 Medium | SEO | mcgonagall | 2 |
| 35 | No JSON-LD structured data | 🟡 Medium | SEO | mcgonagall | 2 |
| 36 | Category colors duplicated 4× | 🟡 Medium | Design | hermione | 2 |
| 37 | `readTime` computed 3× at runtime | 🟡 Medium | Performance | harry | 2 |
| 38 | No `compressHTML` in Astro config | 🟡 Medium | Performance | harry | 2 |
| 39 | No prefetch configuration | 🟡 Medium | Performance | harry | 2 |
| 40 | `button-pink` duplicate of `button-accent` | ⚪ Low | Design | hermione | 3 |
| 41 | `.text-primary` class conflicts with tokens | ⚪ Low | Design | hermione | 3 |
| 42 | Hardcoded colors in prose/utility classes | ⚪ Low | Design | hermione | 3 |
| 43 | AffiliateLink wrong surface color | ⚪ Low | Design | hermione | 3 |
| 44 | Eyebrow/label 3 near-duplicate implementations | ⚪ Low | Design | hermione | 3 |
| 45 | `@theme` tokens not used as Tailwind utilities | ⚪ Low | Design | hermione | 3 |
| 46 | Inline `font-family` instead of `font-serif` | ⚪ Low | Design | hermione | 3 |
| 47 | No `@layer` structure in global.css | ⚪ Low | Design | hermione | 3 |
| 48 | Content Layer API migration needed | ⚪ Low | Modernization | harry | 3 |
| 49 | Content schema missing fields | ⚪ Low | Modernization | harry | 3 |
| 50 | View Transitions partially implemented | ⚪ Low | Modernization | harry | 3 |
| 51 | `@astrojs/mdx` not installed | ⚪ Low | Modernization | harry | 3 |
| 52 | Inline styles vs Tailwind inconsistency | ⚪ Low | Modernization | harry | 3 |
| 53 | Placeholder Rick Astley video | ⚪ Low | Performance | harry | 1 |
| 54 | RSS feed missing author/full content | ⚪ Low | SEO | mcgonagall | 3 |
| 55 | `@astrojs/check` not in dev toolchain | ⚪ Low | Modernization | harry | 3 |
| 56 | Squad SDK in production dependencies | ⚪ Low | Security | snape | 1 |
| 57 | No `npm audit` baseline | ⚪ Low | Security | snape | 1 |
| 58 | Giscus re-injection on theme toggle | ⚪ Low | Performance | snape | 3 |

---

## Phase 1 — Launch Blockers & Critical Fixes

Items that **MUST** be fixed before going live. Grouped by category.

### Security

**[ISSUE-1] Kit Newsletter Form Placeholder URL**
- **Problem:** `NewsletterSignup.astro` POSTs to `https://app.kit.com/forms/YOUR_FORM_ID/subscriptions` — a literal placeholder that collects user emails and sends them nowhere (or to an uncontrolled endpoint).
- **Impact:** User PII (email) sent to unvalidated endpoint. GDPR Art. 5(1)(f) violation. Users believe they subscribed but didn't.
- **Fix:** Replace with real Kit form ID stored in environment variable. Add pre-deploy validation: `if (!import.meta.env.KIT_FORM_ID) throw new Error(...)`.
- **Owner:** snape
- **Effort:** S

**[ISSUE-2] AffiliateLink Unvalidated `href` (XSS Vector)**
- **Problem:** `AffiliateLink.astro` accepts arbitrary `href` string with no validation. `javascript:` protocol URLs are a valid XSS vector.
- **Impact:** Architecturally unsafe. If href values ever come from a CMS or API, this becomes exploitable immediately.
- **Fix:** Add server-side validation: `const safeHref = /^https?:\/\//.test(href) ? href : '#';`
- **Owner:** snape
- **Effort:** S

**[ISSUE-3] Giscus Loaded with Empty Config**
- **Problem:** `Giscus.astro` has `REPO_ID = ''` and `CATEGORY_ID = ''`. A third-party script with full DOM access loads on every blog post for zero functional benefit.
- **Impact:** Supply-chain attack surface with no utility. ~500KB wasted JS on every blog post page load.
- **Fix:** Gate the script injection: `if (!REPO_ID || !CATEGORY_ID) return;` — don't load until configured.
- **Owner:** snape
- **Effort:** S

**[ISSUE-4] All Affiliate Links Are `#` Placeholders**
- **Problem:** Every `<AffiliateLink>` on `resources.astro` has `href="#"`. The page has an affiliate disclosure banner implying active relationships that don't exist.
- **Impact:** FTC guidelines violation (disclosure implies active affiliates). Deceptive to readers.
- **Fix:** Either populate real links, mark page as "coming soon," or remove from navigation until ready.
- **Owner:** snape
- **Effort:** S

**[ISSUE-9] No Security Headers**
- **Problem:** No CSP, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, or Permissions-Policy anywhere.
- **Impact:** Clickjacking possible. Full referrer leakage to Google Fonts, YouTube, Giscus. No script injection protection.
- **Fix:** Add `<meta http-equiv="Content-Security-Policy">` in BaseLayout. Add `public/_headers` for CDN deployment. See CSP design in Snape's audit.
- **Owner:** snape
- **Effort:** M

**[ISSUE-14] Astro Generator Version Disclosure**
- **Problem:** `<meta name="generator" content={Astro.generator} />` exposes exact framework version.
- **Impact:** Reconnaissance gift to automated scanners that cross-reference CVEs.
- **Fix:** Remove the meta tag or suppress in production: `{import.meta.env.DEV && <meta ... />}`
- **Owner:** snape
- **Effort:** S

### HTML Validity

**[ISSUE-5] Duplicate `class` Attributes — Broken Layout**
- **Problem:** Two elements in `index.astro` and `blog/index.astro` have duplicate `class` attributes. Browsers silently discard the second — responsive grid classes and animations never apply.
- **Impact:** YouTube two-column layout broken on desktop. Blog page fade animation never fires.
- **Fix:** Merge both class strings into a single `class` attribute or use `class:list`.
- **Owner:** harry
- **Effort:** S

**[ISSUE-6] Nested `<main>` Landmark**
- **Problem:** `BaseLayout.astro` wraps content in `<main>`, then `index.astro` renders its own `<main>` inside — producing `<main><main>…</main></main>`.
- **Impact:** HTML spec violation. axe-core `landmark-no-duplicate-main` failure. −8 to −12 pts Accessibility.
- **Fix:** Remove `<main>` from page components; let BaseLayout own the landmark.
- **Owner:** neville
- **Effort:** S

### Critical Accessibility

**[ISSUE-7] Blog Card Images with Empty `alt`**
- **Problem:** `BlogCard.astro` uses `alt=""` on blog thumbnails that convey meaning (they illustrate post content).
- **Impact:** Screen reader users get no image information. −6 to −10 pts Accessibility.
- **Fix:** Pass post title or dedicated `imageAlt` frontmatter field as the `alt` value.
- **Owner:** neville
- **Effort:** S

### Broken Features & UX

**[ISSUE-8] Theme Init Script Below Content (FOUC)**
- **Problem:** Theme-setting `is:inline` script is at the bottom of `<body>`. Browser paints un-themed page first, then flashes to correct theme.
- **Impact:** Guaranteed Flash of Unstyled Content on every page load for every user.
- **Fix:** Move script to top of `<head>` as a synchronous blocking `is:inline` script.
- **Owner:** harry
- **Effort:** S

**[ISSUE-53] Placeholder Rick Astley Video in Production**
- **Problem:** Homepage embeds `videoId="dQw4w9WgXcQ"` (Rick Roll) — unprofessional and triggers the YouTube performance penalty.
- **Impact:** Ships broken section to users. 500KB wasted third-party JS for a joke.
- **Fix:** Replace with real video or conditionally hide the section when no featured video is set.
- **Owner:** harry
- **Effort:** S

### Type Safety & Build Reliability

**[ISSUE-20] `post: any` Type Cast**
- **Problem:** Blog slug route casts props to `{ post: any }`, defeating TypeScript inference.
- **Impact:** Typos on `post.data.*` won't be caught at build time.
- **Fix:** Use `InferGetStaticPropsType<typeof getStaticPaths>`.
- **Owner:** harry
- **Effort:** S

**[ISSUE-21] Silent Error Swallowing on `getCollection`**
- **Problem:** `.catch(() => [])` on all content collection calls — errors vanish silently.
- **Impact:** Schema mismatches or broken content files produce empty pages with no diagnostic.
- **Fix:** Remove `.catch()` in dev. In prod, use explicit try/catch with logging.
- **Owner:** harry
- **Effort:** S

**[ISSUE-22] `post.render()` Deprecated in Astro 5**
- **Problem:** Uses `await post.render()` instead of Astro 5's `render(post)`.
- **Impact:** Deprecated API; will break on Astro 6.
- **Fix:** `import { render } from 'astro:content'; const { Content } = await render(post);`
- **Owner:** harry
- **Effort:** S

### Dependency Hygiene

**[ISSUE-56] Squad SDK in Production Dependencies**
- **Problem:** `@bradygaster/squad-sdk` is in `dependencies` instead of `devDependencies`.
- **Impact:** Dev-only tooling SDK deployed to production, increasing attack surface.
- **Fix:** `npm install --save-dev @bradygaster/squad-sdk`
- **Owner:** snape
- **Effort:** S

**[ISSUE-57] No `npm audit` Baseline**
- **Problem:** No evidence of `npm audit` in CI or documented vulnerability baseline.
- **Impact:** Unknown vulnerability status.
- **Fix:** Run `npm audit`, add `npm audit --audit-level=high` to CI.
- **Owner:** snape
- **Effort:** S

---

## Phase 2 — Performance & Lighthouse Score Targets

Items to push Lighthouse scores above 90 in all categories.

### Performance

**[ISSUE-11] Render-Blocking Google Fonts → Self-Host**
- **Problem:** External Google Fonts stylesheet blocks rendering. Adds 400–1200ms to FCP on slow connections.
- **Impact:** −10 to −18 pts Performance (LCP, FCP, Speed Index).
- **Fix:** Install Fontsource packages (`@fontsource-variable/inter`, `@fontsource/playfair-display`), import in layout, remove external `<link>` tags.
- **Owner:** harry
- **Effort:** S

**[ISSUE-12] YouTube Iframe → Facade Pattern**
- **Problem:** Each YouTube embed loads ~500KB of third-party JS immediately. Homepage + YouTube page = up to 1.5MB wasted.
- **Impact:** −15 to −25 pts Performance on affected pages (TBT, LCP, INP).
- **Fix:** Replace with lite-youtube facade: render thumbnail + play button, load real iframe only on click.
- **Owner:** harry
- **Effort:** M

**[ISSUE-23] Raw `<img>` → Astro `<Image>` Component**
- **Problem:** `BlogCard.astro` uses plain `<img>` with no WebP/AVIF conversion, no srcset, no responsive sizing.
- **Impact:** −5 to −8 pts Performance. Oversized images on mobile.
- **Fix:** Replace with `<Image>` from `astro:assets`. Configure `image.domains` in config for remote sources.
- **Owner:** harry
- **Effort:** M

**[ISSUE-24] No Critical Asset Preload**
- **Problem:** No `<link rel="preload">` for LCP elements (hero image or critical font subset).
- **Impact:** −5 to −8 pts Performance (late LCP discovery).
- **Fix:** Add preload hints for critical woff2 font files and hero images.
- **Owner:** neville
- **Effort:** S

**[ISSUE-25] `filter:blur(40px)` Paint Storm**
- **Problem:** Decorative blurred divs trigger full repaint cycles during scroll on low-end GPUs.
- **Impact:** −4 to −6 pts Performance (INP, scroll jank).
- **Fix:** Add `will-change: transform` to promote to GPU layer, or use pre-blurred static assets.
- **Owner:** neville
- **Effort:** S

**[ISSUE-26] `backdrop-filter` on Nav Without `will-change`**
- **Problem:** Nav backdrop blur composites everything behind it without layer promotion.
- **Impact:** −3 to −5 pts Performance (scroll jank, INP).
- **Fix:** Add `will-change: transform` and `isolation: isolate` to `.nav-scrolled`.
- **Owner:** neville
- **Effort:** S

**[ISSUE-37] `readTime` Computed 3× at Runtime**
- **Problem:** Same string-split calculation repeated in 3 files for every post.
- **Impact:** DRY violation; blocks Content Layer migration (no `post.body` in new API).
- **Fix:** Extract to remark plugin or schema transform. Compute once at build time.
- **Owner:** harry
- **Effort:** S

**[ISSUE-38] No `compressHTML` in Config**
- **Problem:** HTML output not minified. Template-heavy pages have 10–20% compressible whitespace.
- **Impact:** +1–2 pts Performance.
- **Fix:** Add `compressHTML: true` to `astro.config.mjs`.
- **Owner:** harry
- **Effort:** S

**[ISSUE-39] No Prefetch Configuration**
- **Problem:** Internal link navigation doesn't benefit from hover/viewport prefetching.
- **Impact:** Significant perceived navigation improvement for content site.
- **Fix:** Add `prefetch: { prefetchAll: true, defaultStrategy: 'hover' }` to config.
- **Owner:** harry
- **Effort:** S

### Accessibility

**[ISSUE-16] Color Contrast `#484F58` Fails WCAG AA**
- **Problem:** Mid-grey text on dark background = 2.8:1 contrast ratio (needs 4.5:1).
- **Impact:** −5 to −8 pts Accessibility. Affects all tertiary text.
- **Fix:** Replace `#484F58` with `#8B949E` or lighter for sufficient contrast.
- **Owner:** neville
- **Effort:** S

**[ISSUE-27] Theme Toggle Missing `aria-pressed`**
- **Problem:** Screen readers cannot determine current theme state.
- **Impact:** −3 to −5 pts Accessibility. WCAG 4.1.2 violation.
- **Fix:** Add `aria-pressed` attribute, update on toggle. Update `aria-label` contextually.
- **Owner:** neville
- **Effort:** S

**[ISSUE-28] Mobile Menu Focus Management**
- **Problem:** Opening mobile menu doesn't trap focus. Keyboard users tab behind overlay.
- **Impact:** −3 to −5 pts Accessibility. WCAG 2.1.1, 2.4.3 violations.
- **Fix:** Move focus into menu on open. Trap focus. Return focus to toggle on close. Use `inert` on background.
- **Owner:** neville
- **Effort:** M

**[ISSUE-29] `prefers-reduced-motion` Not Respected**
- **Problem:** Smooth scroll, fade-up animations, button hover transforms all ignore motion preferences.
- **Impact:** −4 pts Accessibility. WCAG 2.3.3 failure. Physical discomfort for vestibular disorder users.
- **Fix:** Wrap all motion in `@media (prefers-reduced-motion: no-preference)`.
- **Owner:** hermione
- **Effort:** S

**[ISSUE-30] Light Mode Accent Fails WCAG Contrast**
- **Problem:** `#5E8C8A` on `#FFFFFF` = ~3.1:1 (needs 4.5:1). All accent-colored text invisible in light mode.
- **Impact:** WCAG AA failure for all interactive elements in light theme.
- **Fix:** Define `--color-accent: #2E6B69` in `[data-theme="light"]` (achieves ~5.2:1).
- **Owner:** hermione
- **Effort:** S

### SEO

**[ISSUE-34] `og:type` Always "website" on Blog Posts**
- **Problem:** Blog posts should use `og:type="article"` for rich social sharing previews.
- **Impact:** −3 pts SEO. Degraded social sharing on Facebook/LinkedIn.
- **Fix:** Pass `ogType` prop to BaseLayout. BlogLayout sends `"article"` + `article:published_time`.
- **Owner:** mcgonagall
- **Effort:** S

**[ISSUE-35] No JSON-LD Structured Data**
- **Problem:** No `application/ld+json` for Article, Organization, or BreadcrumbList schemas.
- **Impact:** Missing rich results in Google Search (dates, breadcrumbs, sitelinks).
- **Fix:** Add JSON-LD component to BlogLayout for Article schema. Add WebSite schema to BaseLayout.
- **Owner:** mcgonagall
- **Effort:** M

### Design System Consistency

**[ISSUE-17] Footer Background Doesn't Match Site**
- **Problem:** Footer uses `#0A0A0A` (hardcoded) vs site token `--color-bg: #0D1117`. Visibly different shade.
- **Impact:** Footer looks like a different product. Won't update with brand changes.
- **Fix:** Replace all hardcoded footer hex values with `var(--color-*)` tokens.
- **Owner:** hermione
- **Effort:** S

**[ISSUE-18] Stray Purple Hover on Featured Card**
- **Problem:** `rgba(137,87,229,0.5)` purple hover is not in the design system or brand palette.
- **Impact:** Brand-incorrect color on a high-traffic page element.
- **Fix:** Replace with `var(--color-accent)` or `color-mix(in srgb, var(--color-accent) 50%, transparent)`.
- **Owner:** hermione
- **Effort:** S

**[ISSUE-19] Border Colors: 6 Locations, 4 Different Values**
- **Problem:** Token is `#30363D`. Components use `#2E2E2E`, `#272727`, `#1E1E1E`, `#21262D`.
- **Impact:** Inconsistent visual rhythm. Cards look sharper/lighter randomly.
- **Fix:** Replace all with `var(--color-border)` or Tailwind `border-border`.
- **Owner:** hermione
- **Effort:** S

**[ISSUE-36] Category Colors Duplicated 4×**
- **Problem:** Same 5-color map copy-pasted in `BlogCard`, `BlogLayout`, `index.astro`, `blog/index.astro`.
- **Impact:** Adding a category requires editing 4 files. Drift is already visible.
- **Fix:** Create `src/lib/categories.ts` mapping names to CSS variable names. Delete JS color objects.
- **Owner:** hermione
- **Effort:** S

### Security (Phase 2)

**[ISSUE-10] Google Fonts GDPR Leakage**
- **Problem:** Every page sends visitor IP + referer to Google. German courts (2022) ruled this a GDPR violation without consent.
- **Impact:** Legal risk for EU visitors.
- **Fix:** Self-host fonts (same fix as ISSUE-11 above — single action resolves both).
- **Owner:** snape
- **Effort:** S (combined with ISSUE-11)

**[ISSUE-15] YouTube iframe Overpermissive `allow`**
- **Problem:** `clipboard-write`, `accelerometer`, `gyroscope` granted unnecessarily.
- **Impact:** Clipboard write creates phishing vector if embed is compromised.
- **Fix:** Minimal: `allow="autoplay; encrypted-media; picture-in-picture"`.
- **Owner:** snape
- **Effort:** S

---

## Phase 3 — Modernization & Technical Excellence

### Astro Modernization

**[ISSUE-48] Content Layer API Migration**
- **Problem:** Uses Astro 4 legacy `type: 'content'` API. Content Layer with `glob` loader is the documented path forward.
- **Impact:** Legacy API will be removed in Astro 6. Blocks advanced data source features.
- **Fix:** Migrate to `loader: glob(...)`. Update `post.slug` → `post.id` across all files.
- **Owner:** harry
- **Effort:** M

**[ISSUE-49] Content Schema Missing Fields**
- **Problem:** No `tags`, `updatedDate`, `ogImage` in schema. `image` is `z.string()` (no path validation).
- **Impact:** Missing SEO signals. No tag filtering. Broken image paths not caught at build.
- **Fix:** Add `image()` helper, `tags: z.array(z.string())`, `updatedDate`, `ogImage`.
- **Owner:** harry
- **Effort:** M

**[ISSUE-50] View Transitions Partially Implemented**
- **Problem:** Only titles transition. No image transitions. Scroll listener leaks across navigations.
- **Impact:** Suboptimal SPA-like navigation feel. Listener memory leak.
- **Fix:** Add `transition:name` on images. Add `astro:before-swap` cleanup. Add `transition:animate="slide"` for posts.
- **Owner:** harry
- **Effort:** M

**[ISSUE-51] `@astrojs/mdx` Not Installed**
- **Problem:** No MDX support. Can't embed interactive components in blog posts.
- **Impact:** Blocks CGM data visualizations, blood glucose charts, affiliate product cards in posts.
- **Fix:** `npx astro add mdx` — zero-config, backward compatible.
- **Owner:** harry
- **Effort:** S

**[ISSUE-55] `@astrojs/check` Not in Dev Toolchain**
- **Problem:** Type errors in `.astro` files not caught in CI.
- **Impact:** TypeScript inference failures (like `post: any`) slip through uncaught.
- **Fix:** `npx astro add check`, add `"check": "astro check"` script, call in CI.
- **Owner:** harry
- **Effort:** S

### Design System

**[ISSUE-45] `@theme` Tokens Not Used as Tailwind Utilities**
- **Problem:** Components use `bg-[#161B22]` instead of `bg-surface`, `text-[#E6EDF3]` instead of `text-text-primary`.
- **Impact:** Arbitrary values bypass token system. Won't update on palette changes.
- **Fix:** Audit and replace all `[#hex]` Tailwind classes with named utility equivalents.
- **Owner:** hermione
- **Effort:** M

**[ISSUE-46] Inline `font-family` Instead of `font-serif` Utility**
- **Problem:** 5 files hardcode `style="font-family:'Playfair Display',serif"`.
- **Impact:** Won't update if serif font changes.
- **Fix:** Replace with Tailwind `font-serif` class.
- **Owner:** hermione
- **Effort:** S

**[ISSUE-47] No `@layer` Structure in global.css**
- **Problem:** All styles in flat file with no cascade layer declarations.
- **Impact:** Specificity surprises. Hard-to-debug ordering issues.
- **Fix:** Organize into `@layer base`, `@layer components`, `@layer utilities`.
- **Owner:** hermione
- **Effort:** M

**[ISSUE-40] `button-pink` Duplicate**
- **Problem:** Nearly identical to `button-accent`. Name is wrong (it's teal, not pink).
- **Impact:** Confusion. Dual maintenance burden.
- **Fix:** Delete `button-pink`. Update `NewsletterSignup.astro` to use `button-accent px-6`.
- **Owner:** hermione
- **Effort:** S

**[ISSUE-44] Eyebrow/Label 3 Near-Duplicates**
- **Problem:** `.eyebrow`, `.section-label`, `.page-eyebrow` — all uppercase accent labels with different letter-spacing.
- **Impact:** No documented reason for differences. Developer confusion.
- **Fix:** Consolidate to 2 variants. Standardize letter-spacing to 0.12em.
- **Owner:** hermione
- **Effort:** S

### Developer Experience

**[ISSUE-52] Inline Styles vs Tailwind Inconsistency**
- **Problem:** Mix of static inline styles, Tailwind utilities, and invalid CSS (`space-y:1.25rem` in style attr).
- **Impact:** Invalid CSS silently fails. Defeats Tailwind purging. Blocks CSP.
- **Fix:** Audit all `style=""` attrs. Convert static ones to Tailwind. Keep style only for dynamic values.
- **Owner:** harry
- **Effort:** L

**[ISSUE-54] RSS Feed Missing Author/Full Content**
- **Problem:** Feed items lack `author`, `enclosure`, and full article content.
- **Impact:** Feed readers show only titles. Reduced engagement.
- **Fix:** Add `author` and `content` fields using `@astrojs/rss` content support.
- **Owner:** mcgonagall
- **Effort:** S

---

## Top Starred Astro Repo Comparison

| Pattern | AstroWind (8.1k⭐) | Astro Paper (9.7k⭐) | Fuwari (6.2k⭐) | TypeOneDen | Priority |
|---------|-------------------|---------------------|----------------|------------|----------|
| Self-hosted fonts | ✅ Fontsource | ✅ Local woff2 | ✅ Fontsource | ❌ Google CDN | 🔴 Phase 2 |
| `<Image>` component | ✅ Everywhere | ✅ Everywhere | ✅ Everywhere | ❌ Raw `<img>` | 🔴 Phase 2 |
| YouTube facade | ✅ lite-youtube | N/A | N/A | ❌ Eager iframe | 🔴 Phase 2 |
| Prefetch | ✅ `prefetchAll` | ✅ Enabled | ✅ Enabled | ❌ Not configured | 🟡 Phase 2 |
| MDX support | ✅ Installed | ✅ Installed | ✅ Installed | ❌ Not installed | 🟡 Phase 3 |
| Content Layer API | ✅ Migrated | ✅ Migrated | ✅ Migrated | ❌ Legacy API | 🟡 Phase 3 |
| CSP headers | ✅ Configured | ⚠️ Partial | ⚠️ Partial | ❌ None | 🔴 Phase 1 |
| JSON-LD structured data | ✅ Article schema | ✅ Article schema | ⚠️ Basic | ❌ None | 🟡 Phase 2 |
| Category/tag system | ✅ Full taxonomy | ✅ Tags + search | ✅ Categories | ⚠️ Categories only (no tags) | 🟡 Phase 3 |
| Read time in schema | ✅ Remark plugin | ✅ Remark plugin | ✅ Computed once | ❌ Runtime 3× | 🟡 Phase 2 |

---

## Estimated Impact Summary

After implementing Phase 1 + Phase 2:

| Category | Before | After | Change |
|----------|--------|-------|--------|
| Performance | 62–70 | 88–93 | +21–28 pts |
| Accessibility | 74–80 | 93–97 | +15–21 pts |
| SEO | 78–84 | 90–94 | +8–14 pts |
| Best Practices | 83–88 | 92–95 | +5–11 pts |

All four categories cross the **90+ threshold** required for production readiness.

---

## Quick Wins (< 1 hour each, high impact)

These deliver outsized value relative to effort:

1. **Move theme script to `<head>`** (ISSUE-8) — eliminates FOUC for every user. 15 minutes.
2. **Merge duplicate `class` attributes** (ISSUE-5) — fixes broken desktop layout. 10 minutes.
3. **Remove nested `<main>`** (ISSUE-6) — +8–12 pts Accessibility. 10 minutes.
4. **Add `compressHTML` + `prefetch` to config** (ISSUE-38, 39) — two lines in config. 5 minutes.
5. **Remove Astro generator meta tag** (ISSUE-14) — delete one line. 2 minutes.
6. **Guard Giscus with empty-config check** (ISSUE-3) — saves 500KB JS per blog post. 15 minutes.
7. **Add `prefers-reduced-motion` media query** (ISSUE-29) — wrap existing CSS. 30 minutes.

---

## Recommended Implementation Order

Respecting dependencies and maximizing early impact:

```
Phase 1 (Sprint 1 — Launch Blockers)
──────────────────────────────────────
 1. Fix duplicate class attributes (ISSUE-5) — unblocks layout
 2. Remove nested <main> from pages (ISSUE-6) — unblocks a11y
 3. Move theme script to <head> (ISSUE-8) — unblocks UX
 4. Fix post: any type cast (ISSUE-20) — unblocks type safety
 5. Fix post.render() → render(post) (ISSUE-22) — unblocks deprecation
 6. Remove .catch(() => []) (ISSUE-21) — unblocks error visibility
 7. Guard Giscus empty config (ISSUE-3) — unblocks security
 8. Validate AffiliateLink href (ISSUE-2) — unblocks security
 9. Fix Kit form placeholder (ISSUE-1) — unblocks newsletter
10. Handle affiliate link placeholders (ISSUE-4) — unblocks trust
11. Remove generator meta tag (ISSUE-14) — unblocks security
12. Add security headers meta tag (ISSUE-9) — unblocks CSP
13. Add blog card alt text (ISSUE-7) — unblocks a11y
14. Replace placeholder video (ISSUE-53) — unblocks professionalism
15. Move squad-sdk to devDeps (ISSUE-56) — unblocks deps
16. Run npm audit (ISSUE-57) — baseline

Phase 2 (Sprint 2 — Performance & Lighthouse 90+)
───────────────────────────────────────────────────
17. Self-host fonts via Fontsource (ISSUE-11 + ISSUE-10)
    ↳ removes Google Fonts GDPR risk simultaneously
18. YouTube facade component (ISSUE-12 + ISSUE-15)
    ↳ restrict iframe permissions at same time
19. Adopt <Image> component (ISSUE-23)
20. Add critical asset preload (ISSUE-24)
21. Add will-change to blur elements (ISSUE-25, 26)
22. Add compressHTML + prefetch config (ISSUE-38, 39)
23. Extract readTime to remark plugin (ISSUE-37)
24. Add prefers-reduced-motion (ISSUE-29)
25. Fix light mode accent contrast (ISSUE-30)
26. Fix color contrast #484F58 (ISSUE-16)
27. Add aria-pressed to theme toggle (ISSUE-27)
28. Fix mobile menu focus management (ISSUE-28)
29. Fix footer/border/purple design tokens (ISSUE-17, 18, 19)
30. Consolidate categoryColors (ISSUE-36)
31. Add og:type article (ISSUE-34)
32. Add JSON-LD structured data (ISSUE-35)
33. Validate category filter URL param (ISSUE-32)
34. Add FTC co-located disclosure (ISSUE-31)

Phase 3 (Sprint 3 — Modernization & Excellence)
─────────────────────────────────────────────────
35. Migrate to Content Layer API (ISSUE-48)
    ↳ depends on: readTime extraction (step 23)
36. Expand content schema (ISSUE-49)
    ↳ depends on: Content Layer migration (step 35)
37. Full View Transitions (ISSUE-50)
38. Install @astrojs/mdx (ISSUE-51)
39. Install @astrojs/check (ISSUE-55)
40. Replace [#hex] with named utilities (ISSUE-45)
41. Replace inline font-family (ISSUE-46)
42. Add @layer structure (ISSUE-47)
43. Consolidate eyebrow/button duplicates (ISSUE-40, 44)
44. Audit inline styles → Tailwind (ISSUE-52)
45. Enhance RSS feed (ISSUE-54)
46. Fix remaining design token deviations (ISSUE-41, 42, 43)
```

---

*Plan authored by Dumbledore. Implementation begins on approval. Each phase should be verified with a Lighthouse audit before proceeding to the next.*
