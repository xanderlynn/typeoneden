/**
 * Generates per-post OG images as SVG at build time.
 * Served at /og/{slug}.svg — referenced in BlogLayout as og:image.
 *
 * Note: SVG OG images work on Discord, LinkedIn, and Slack.
 * For Twitter/Facebook PNG support, swap the body below for a
 * canvas/satori render pipeline when needed.
 */
import type { APIRoute } from 'astro';
import { getCollection } from 'astro:content';

export async function getStaticPaths() {
  const posts = await getCollection('blog');
  return posts
    .filter((p) => !p.data.draft)
    .map((post) => ({ params: { slug: post.slug }, props: { post } }));
}

const CAT_COLORS: Record<string, string> = {
  'Life with T1D': '#5E8C8A',
  'Tech & Gear':   '#58A6FF',
  'Nutrition':     '#3FB950',
  'Advocacy':      '#9B8DB3',
  'Mindset':       '#F0883E',
};

/** Wrap text into lines no longer than `maxChars` characters. */
function wrapText(text: string, maxChars: number): string[] {
  const words = text.split(' ');
  const lines: string[] = [];
  let current = '';
  for (const word of words) {
    if ((current + ' ' + word).trim().length > maxChars) {
      lines.push(current.trim());
      current = word;
    } else {
      current = (current + ' ' + word).trim();
    }
  }
  if (current) lines.push(current.trim());
  return lines;
}

export const GET: APIRoute = ({ props }) => {
  const { post } = props as { post: any };
  const title    = post.data.title as string;
  const category = post.data.category as string;
  const color    = CAT_COLORS[category] ?? '#5E8C8A';

  const titleLines = wrapText(title, 36);
  const lineHeight = 68;
  const startY     = 260 - (titleLines.length - 1) * (lineHeight / 2);

  const titleSvg = titleLines
    .map(
      (line, i) =>
        `<text x="80" y="${startY + i * lineHeight}" font-family="Georgia, serif" font-size="54" font-weight="700" fill="#E6EDF3">${line.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')}</text>`,
    )
    .join('\n    ');

  const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="630" viewBox="0 0 1200 630">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%"   stop-color="#0D1117"/>
      <stop offset="100%" stop-color="#161B22"/>
    </linearGradient>
    <linearGradient id="glow" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="${color}" stop-opacity="0.25"/>
      <stop offset="100%" stop-color="${color}" stop-opacity="0"/>
    </linearGradient>
  </defs>

  <!-- Background -->
  <rect width="1200" height="630" fill="url(#bg)"/>

  <!-- Subtle glow blob top-right -->
  <ellipse cx="1050" cy="120" rx="320" ry="240" fill="url(#glow)"/>

  <!-- Left accent bar -->
  <rect x="0" y="0" width="8" height="630" fill="${color}"/>

  <!-- Category pill -->
  <rect x="80" y="80" width="${category.length * 11 + 40}" height="44" rx="22" fill="${color}22" stroke="${color}55" stroke-width="1.5"/>
  <text x="${80 + (category.length * 11 + 40) / 2}" y="108" text-anchor="middle" font-family="Arial, sans-serif" font-size="18" font-weight="600" fill="${color}" letter-spacing="2" text-transform="uppercase">${category.toUpperCase()}</text>

  <!-- Title -->
  ${titleSvg}

  <!-- Bottom bar -->
  <rect x="0" y="570" width="1200" height="60" fill="#0D1117CC"/>
  <text x="80" y="608" font-family="Arial, sans-serif" font-size="24" font-weight="700" fill="#5E8C8A">TypeOneDen</text>
  <text x="1120" y="608" text-anchor="end" font-family="Arial, sans-serif" font-size="18" fill="#484F58">typeoneden.com</text>
</svg>`;

  return new Response(svg, {
    headers: { 'Content-Type': 'image/svg+xml; charset=utf-8' },
  });
};
