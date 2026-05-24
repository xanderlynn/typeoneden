# Squad Decisions

## Active Decisions

### Session 2026-05-24: TypeOneDen Performance & Modernization

**DECISION:** Adopt comprehensive performance, security, accessibility, and modernization plan for TypeOneDen Astro site across three implementation phases.

**RATIONALE:**
- Current estimated Lighthouse scores: Performance 62–70, Accessibility 74–80, Best Practices 83–88, SEO 78–84
- 58 identified issues across performance, security, accessibility, design system, and modernization
- Three-phase implementation path targets all categories ≥90 after Phase 1+2
- Phase 1 (launch blockers) includes 8 critical issues that must be fixed before production
- Harry (Frontend), Hermione (Design), Neville (QA), Snape (Security) consensus on findings

**PHASE 1 (Launch Blockers — Sprint 1):**
- Fix HTML validity: duplicate class attributes, nested main landmark, missing alt text
- Move theme script to <head> to eliminate FOUC
- Remove giscus script load when unconfigured (saves 500KB per post)
- Validate AffiliateLink href to prevent XSS
- Replace Kit form placeholder with real environment-based config
- Remove Astro generator meta tag (version disclosure)
- Add security headers baseline
- Fix type safety: post: any cast, post.render() deprecation, error swallowing
- Move Squad SDK to devDependencies
- Replace Rick Astley placeholder video

**PHASE 2 (Performance & Lighthouse 90+):**
- Self-host fonts via Fontsource (eliminates Google Fonts GDPR exposure + render-blocking)
- YouTube facade component pattern (saves 500KB+ JS per embed)
- Astro `<Image>` component adoption for responsive images
- Add prefers-reduced-motion protection
- Fix color contrasts (WCAG AA)
- Consolidate category colors: single source of truth
- Add JSON-LD structured data
- Normalize design tokens (footer, borders, accent colors)

**PHASE 3 (Modernization & Excellence):**
- Content Layer API migration (Astro 4 → 5)
- Expand content schema (tags, updatedDate, image validation)
- Full View Transitions implementation
- @astrojs/mdx installation
- @astrojs/check in CI
- Design system refactoring (layer structure, token utilities)

**OWNER:** Dumbledore (project lead)  
**REVIEWERS:** Harry, Hermione, Neville, Snape  
**TARGET COMPLETION:** Phase 1 + Phase 2 before production launch  
**VERIFICATION:** Lighthouse audit ≥90 all categories after each phase

---

## Governance

- All meaningful changes require team consensus
- Document architectural decisions here
- Keep history focused on work, decisions focused on direction
