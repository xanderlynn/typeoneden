# Harry – History

## Learnings

### 2026-05-24 — Phase 2 Performance Improvements

**Task:** Three frontend performance improvements for TypeOneDen.

**What I did:**

1. **Self-hosted fonts with Fontsource** — Installed `@fontsource-variable/inter` and `@fontsource-variable/playfair-display`. Added imports at the top of `BaseLayout.astro` frontmatter and removed the three Google Fonts `<link>` tags from `<head>`. Updated `@theme` font-family variables in `global.css` to use `'Inter Variable'` and `'Playfair Display Variable'` (the names Fontsource variable fonts expose). Eliminates a render-blocking external CDN request and GDPR IP-leak concern.

2. **YouTube lite facade** — Replaced the eager `<iframe>` in `YouTubeEmbed.astro` with a click-to-play thumbnail facade. The facade shows the YouTube `hqdefault.jpg` thumbnail with an SVG play button overlay. On click (or Enter/Space for keyboard), a `youtube-nocookie.com` iframe with `autoplay=1` is injected in place. Saves ~1.5 MB on pages with embedded videos. Also added `will-change: transform` to `.nav-scrolled` in `global.css` to prevent paint storms from the backdrop-filter blur.

3. **BlogCard `<Image>` component** — Added `import { Image } from 'astro:assets'` to `BlogCard.astro` frontmatter and replaced the raw `<img>` tag with Astro's `<Image>` component using `format="webp"`. The build succeeded without errors because the blog images in this project are external URLs or public paths that Astro accepts at build time in static mode. No revert was needed.

**Build result:** `npx astro build` — ✅ 25 pages built, no errors, no warnings.
