# Neville – History

## Learnings

### 2026-05-24 — Phase 2 Accessibility Fixes

**Task:** Three accessibility improvements for TypeOneDen's Nav and homepage.

**What I did:**

1. **`aria-pressed` on the theme toggle** — The button already had `id="theme-toggle"`. Added `aria-pressed="false"` as the static HTML initial state (dark = false, light = true — "pressed" means light mode is active). Updated `applyTheme()` in the script to call `themeBtn.setAttribute('aria-pressed', String(!isDark))` on every theme change. Added an `astro:page-load` listener so View Transitions don't silently reset the attribute after navigation. Also cast `themeBtn` as `HTMLButtonElement | null` for correct TypeScript inference.

2. **Mobile menu focus trap** — Added a `trapFocus(container)` function inside the `if (toggle instanceof HTMLButtonElement && menu instanceof HTMLElement)` block. The function queries all focusable descendants, wraps Tab and Shift+Tab at the boundaries, and returns a cleanup closure. Called `trapFocus(menu)` on `openMenu()` and stored the cleanup in `removeTrap`. `closeMenu()` now accepts a `returnFocus = false` parameter — passes `true` on explicit user actions (toggle click, Escape key) to return focus to the hamburger button. Added an `Escape` key listener on `document` that calls `closeMenu(true)` when the menu is open.

3. **Glow orb compositor-layer promotion** — In `src/pages/index.astro`, updated both decorative glow orb `<div>`s inside the hero section. The first orb had `transform:translateX(-50%)` — combined it with `translateZ(0)` to form `transform:translateX(-50%) translateZ(0)` so the existing positioning is preserved while also promoting to a compositor layer; added `will-change:transform`. The second orb had no transform — added `will-change:transform; transform:translateZ(0)`. This prevents the GPU from re-rasterizing the blurred gradient on every scroll tick.

**Build result:** `npx astro build` — ✅ 25 pages built, no errors, no warnings.
