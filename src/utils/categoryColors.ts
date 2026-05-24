/**
 * Canonical category color map.
 * - Use `getCategoryColor()` for contexts where CSS variables are unavailable
 *   (e.g., SVG/OG image generation).
 * - Use `getCategoryVar()` in Astro component inline styles to leverage
 *   the design tokens already defined in global.css.
 */
export const CATEGORY_COLORS: Record<string, string> = {
  'Life with T1D': '#E8956B',
  'Tech & Gear':   '#58A6FF',
  'Nutrition':     '#3FB950',
  'Advocacy':      '#9B8DB3',
  'Mindset':       '#F0883E',
};

export function getCategoryColor(category: string): string {
  return CATEGORY_COLORS[category] ?? '#C8A87A';
}

export function getCategoryVar(category: string): string {
  const varMap: Record<string, string> = {
    'Life with T1D': 'var(--cat-life)',
    'Tech & Gear':   'var(--cat-tech)',
    'Nutrition':     'var(--cat-nutrition)',
    'Advocacy':      'var(--cat-advocacy)',
    'Mindset':       'var(--cat-mindset)',
  };
  return varMap[category] ?? 'var(--cat-life)';
}
