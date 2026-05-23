#!/usr/bin/env pwsh
# Type One Den — GitHub Setup Script
# Run this after gh auth login is complete

$REPO = "typeoneden"
$OWNER = "xanderlynn"
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")

Write-Host "`n== Step 1: Create GitHub repo ==" -ForegroundColor Cyan
gh repo create $REPO --public --description "T1D lifestyle website and blog — typeoneden.com" --source=. --remote=origin --push
if ($LASTEXITCODE -ne 0) { Write-Host "Repo may already exist, continuing..." -ForegroundColor Yellow }

Write-Host "`n== Step 2: Create GitHub Labels ==" -ForegroundColor Cyan
$labels = @(
  @{ name="dumbledore"; color="7B2D8B"; desc="Project Lead - architecture & scope" },
  @{ name="hermione";   color="F472B6"; desc="Lead Designer - Tailwind & visual system" },
  @{ name="harry";      color="EF4444"; desc="Frontend Engineer - Astro pages & deploy" },
  @{ name="luna";       color="A78BFA"; desc="Content Architect - copy & blog posts" },
  @{ name="ron";        color="F97316"; desc="Integration Engineer - YouTube, Kit, Giscus" },
  @{ name="neville";    color="22C55E"; desc="QA / Tester - accessibility & Lighthouse" },
  @{ name="mcgonagall"; color="3B82F6"; desc="SEO & Legal - meta, sitemap, legal pages" },
  @{ name="snape";      color="1F2937"; desc="Security Reviewer - CSP, audits, compliance" },
  @{ name="design";     color="FDE68A"; desc="Design tasks" },
  @{ name="frontend";   color="FCA5A5"; desc="Frontend tasks" },
  @{ name="content";    color="C4B5FD"; desc="Content tasks" },
  @{ name="integration";color="FED7AA"; desc="Integration tasks" },
  @{ name="testing";    color="BBF7D0"; desc="Testing & QA tasks" },
  @{ name="seo";        color="BFDBFE"; desc="SEO & legal tasks" },
  @{ name="security";   color="6B7280"; desc="Security tasks" },
  @{ name="phase-1";    color="F9FAFB"; desc="Phase 1 launch work" },
  @{ name="phase-2";    color="E5E7EB"; desc="Phase 2 shop & scale" }
)
foreach ($l in $labels) {
  gh label create $l.name --color $l.color --description $l.desc --force 2>$null
  Write-Host "  Label: $($l.name)" -ForegroundColor Gray
}

Write-Host "`n== Step 3: Create GitHub Milestones ==" -ForegroundColor Cyan
gh api repos/$OWNER/$REPO/milestones -f title="Phase 1 - Launch" -f description="Core site live on typeoneden.com" -f state="open" 2>$null
gh api repos/$OWNER/$REPO/milestones -f title="Phase 2 - Shop" -f description="Shopify + Printful merch store" -f state="open" 2>$null
gh api repos/$OWNER/$REPO/milestones -f title="Phase 3 - Scale" -f description="Cloudflare CDN + Sanity CMS" -f state="open" 2>$null
Write-Host "  Milestones created" -ForegroundColor Gray

Write-Host "`n== Step 4: Create GitHub Issues (Phase 1 tasks) ==" -ForegroundColor Cyan

$issues = @(
  # HERMIONE - Design
  @{
    title="[design] Finalize Tailwind design token file and global CSS"
    body="**Agent: @hermione (Lead Designer)**`n`nReview and finalize `src/styles/global.css`. Ensure all color tokens, typography scale, and spacing are locked in before other agents build on top of them.`n`n**Acceptance criteria:**`n- [ ] Color tokens defined in @theme{}`n- [ ] Playfair Display + Inter loaded correctly`n- [ ] Scrollbar, selection, and link styles applied`n- [ ] No visual regressions on Home page"
    labels=@("design","hermione","phase-1")
  },
  @{
    title="[design] Design blog card component visual polish"
    body="**Agent: @hermione (Lead Designer)**`n`nReview BlogCard.astro for visual consistency with the dark + pink design system.`n`n**Acceptance criteria:**`n- [ ] Hover lift effect is smooth`n- [ ] Category pill uses correct pink`n- [ ] 2-line title clamp works correctly`n- [ ] Looks great at all breakpoints (mobile/tablet/desktop)"
    labels=@("design","hermione","phase-1")
  },
  @{
    title="[design] Mobile navigation hamburger menu"
    body="**Agent: @hermione (Lead Designer)**`n`nEnsure the Nav.astro hamburger menu on mobile is polished and accessible.`n`n**Acceptance criteria:**`n- [ ] Opens/closes smoothly`n- [ ] Links are tap-friendly (min 44px touch target)`n- [ ] Closes when a link is tapped`n- [ ] Focus trap when open (accessibility)"
    labels=@("design","hermione","phase-1")
  },

  # HARRY - Frontend
  @{
    title="[frontend] Configure GitHub Pages with custom domain typeoneden.com"
    body="**Agent: @harry (Frontend Engineer)**`n`nSet up GitHub Pages to serve from typeoneden.com once domain is purchased.`n`n**Steps:**`n- [ ] Add CNAME file to public/ with content: typeoneden.com`n- [ ] Confirm astro.config.mjs site URL is correct`n- [ ] Document DNS settings needed (A records: 185.199.108-111.153.153, CNAME: xanderlynn.github.io)`n- [ ] Test build produces correct base URLs"
    labels=@("frontend","harry","phase-1")
  },
  @{
    title="[frontend] Verify GitHub Actions deploy workflow end-to-end"
    body="**Agent: @harry (Frontend Engineer)**`n`nOnce repo is pushed to GitHub, verify the Actions workflow builds and deploys correctly.`n`n**Acceptance criteria:**`n- [ ] Push to main triggers build`n- [ ] Build completes without errors`n- [ ] Site is accessible at xanderlynn.github.io/typeoneden (before custom domain)`n- [ ] All pages load correctly"
    labels=@("frontend","harry","phase-1")
  },
  @{
    title="[frontend] Implement blog category filter (client-side)"
    body="**Agent: @harry (Frontend Engineer)**`n`nThe blog listing page has category filter tabs. Implement client-side filtering using vanilla JS (no framework).`n`n**Categories:** All / Life with T1D / Tech & Gear / Nutrition / Advocacy / Mindset`n`n**Acceptance criteria:**`n- [ ] Clicking a category shows only matching posts`n- [ ] 'All' shows everything`n- [ ] Active tab is visually distinct (pink underline)`n- [ ] Works without JavaScript (show all by default)"
    labels=@("frontend","harry","phase-1")
  },
  @{
    title="[frontend] Add Open Graph image generation for blog posts"
    body="**Agent: @harry (Frontend Engineer)**`n`nGenerate social share images for blog posts so links look good on Twitter/Instagram.`n`n**Options:** Satori (static OG images at build time) or a simple default OG image`n`n**Acceptance criteria:**`n- [ ] Each blog post has a valid og:image tag`n- [ ] Default fallback image exists at /og-default.png`n- [ ] Image dimensions are 1200x630"
    labels=@("frontend","harry","phase-1")
  },

  # LUNA - Content
  @{
    title="[content] Write all placeholder page copy (About, Start Here, Newsletter)"
    body="**Agent: @luna (Content Architect)**`n`nThe About, Start Here, and Newsletter pages contain placeholder text. Replace with compelling, personal copy that fits the Type One Den brand voice.`n`n**Brand voice:** Honest, bold, warm, never clinical. Written by a woman living with T1D.`n`n**Acceptance criteria:**`n- [ ] About page tells a real, relatable T1D story`n- [ ] Start Here page organizes content for 4 reader types`n- [ ] Newsletter page clearly communicates value of subscribing`n- [ ] All copy passes spell check"
    labels=@("content","luna","phase-1")
  },
  @{
    title="[content] Write 3 additional launch blog posts"
    body="**Agent: @luna (Content Architect)**`n`nWe launch with 2 sample posts. Add 3 more for a fuller blog at launch.`n`n**Suggested topics:**`n1. 'My Favorite T1D Instagram Accounts to Follow' (Advocacy)`n2. 'Low-Carb Snacks That Actually Work for T1D' (Nutrition)`n3. 'What I Wish I Knew When I Was First Diagnosed' (Life with T1D)`n`n**Acceptance criteria:**`n- [ ] Each post is 600-900 words`n- [ ] Correct frontmatter (category, pubDate, description)`n- [ ] Affiliate disclosure line where relevant`n- [ ] SEO-friendly headings (H2, H3 structure)"
    labels=@("content","luna","phase-1")
  },
  @{
    title="[content] Populate Resources page with real affiliate programs"
    body="**Agent: @luna (Content Architect)**`n`nThe Resources page has placeholder `href='#'` links. Research and add real affiliate program URLs.`n`n**Programs to research:**`n- Dexcom affiliate program`n- Omnipod / Insulet`n- Myabetic bags`n- Dia-Be-Tees clothing`n- Amazon Associates (for books, supplies)`n- Levels Health`n`n**Acceptance criteria:**`n- [ ] Each affiliate link goes to the correct program signup or product page`n- [ ] Affiliate disclosure is prominent at page top`n- [ ] Personal recommendation note added for each product`n- [ ] No broken links"
    labels=@("content","luna","phase-1")
  },

  # RON - Integrations
  @{
    title="[integration] Wire up Kit (ConvertKit) newsletter form"
    body="**Agent: @ron (Integration Engineer)**`n`nReplace the placeholder Kit form action URL in NewsletterSignup.astro with the real form ID once account is created.`n`n**Steps:**`n- [ ] Create free Kit account at kit.com`n- [ ] Create a new form in Kit dashboard`n- [ ] Copy the form embed code or action URL`n- [ ] Update NewsletterSignup.astro with real form ID`n- [ ] Test subscription end-to-end`n`n**Note:** Document the form ID in .env.example for future reference"
    labels=@("integration","ron","phase-1")
  },
  @{
    title="[integration] Wire up Giscus comments on blog posts"
    body="**Agent: @ron (Integration Engineer)**`n`nReplace the Giscus placeholder in blog/[slug].astro with the real Giscus widget.`n`n**Steps:**`n- [ ] Enable GitHub Discussions on the repo`n- [ ] Go to giscus.app and generate embed config`n- [ ] Choose 'pathname' as discussion mapping`n- [ ] Use dark theme: 'dark_protanopia' or custom`n- [ ] Replace placeholder div with <script> tag`n`n**Acceptance criteria:**`n- [ ] Comments load on all blog posts`n- [ ] Dark theme matches site design`n- [ ] Sign-in prompt is clear"
    labels=@("integration","ron","phase-1")
  },
  @{
    title="[integration] Connect YouTube Data API for latest videos"
    body="**Agent: @ron (Integration Engineer)**`n`nReplace placeholder YouTube video IDs with real API-driven content.`n`n**Steps:**`n- [ ] Create Google Cloud project + enable YouTube Data API v3`n- [ ] Store API key in .env as PUBLIC_YOUTUBE_API_KEY`n- [ ] Update YouTubeEmbed to optionally accept channelId`n- [ ] Fetch latest 3 videos from channel at build time`n- [ ] Add build-time fetch to youtube.astro and index.astro`n`n**Acceptance criteria:**`n- [ ] Latest videos appear automatically on each deploy`n- [ ] Graceful fallback if API key missing`n- [ ] API key is not committed to repo (.env.example only)"
    labels=@("integration","ron","phase-1")
  },

  # NEVILLE - Testing
  @{
    title="[testing] Lighthouse audit - all pages must score 90+"
    body="**Agent: @neville (QA / Tester)**`n`nRun Lighthouse CI on all pages and ensure scores meet the bar.`n`n**Minimum scores:**`n- Performance: 90`n- Accessibility: 95`n- Best Practices: 90`n- SEO: 95`n`n**Pages to test:** /, /blog, /blog/[slug], /about, /resources, /youtube, /start, /newsletter, /contact`n`n**Acceptance criteria:**`n- [ ] All pages meet minimum scores`n- [ ] Any failures have a linked issue for follow-up`n- [ ] Results documented in .github/lighthouse-results.md"
    labels=@("testing","neville","phase-1")
  },
  @{
    title="[testing] Accessibility audit with axe-core"
    body="**Agent: @neville (QA / Tester)**`n`nRun axe accessibility scan on all pages.`n`n**Steps:**`n- [ ] Install axe-core or use axe DevTools browser extension`n- [ ] Test all pages for WCAG 2.1 AA compliance`n- [ ] Focus on: color contrast (pink on dark must pass), keyboard navigation, skip-to-content link, alt text on all images, form labels`n`n**Acceptance criteria:**`n- [ ] Zero critical or serious violations`n- [ ] Skip-to-main-content link present on all pages`n- [ ] All images have descriptive alt text"
    labels=@("testing","neville","phase-1")
  },
  @{
    title="[testing] Validate all internal and external links"
    body="**Agent: @neville (QA / Tester)**`n`nCheck for broken links across the site.`n`n**Steps:**`n- [ ] Run build and scan dist/ for broken href values`n- [ ] Check all nav links resolve correctly`n- [ ] Check all footer links (Privacy, Disclosure, Terms)`n- [ ] Verify affiliate links in /resources use nofollow`n`n**Acceptance criteria:**`n- [ ] Zero 404 errors on internal links`n- [ ] All external links have rel=noopener noreferrer"
    labels=@("testing","neville","phase-1")
  },

  # MCGONAGALL - SEO & Legal
  @{
    title="[seo] Generate sitemap.xml and robots.txt"
    body="**Agent: @mcgonagall (SEO & Legal)**`n`nEnsure sitemap and robots are correctly configured.`n`n**Steps:**`n- [ ] Install @astrojs/sitemap integration`n- [ ] Add to astro.config.mjs`n- [ ] Verify sitemap includes all public pages`n- [ ] Exclude /shop from sitemap until launched`n- [ ] Create robots.txt in public/ allowing all crawlers`n`n**Acceptance criteria:**`n- [ ] /sitemap-index.xml accessible after build`n- [ ] All 9 public launch pages included`n- [ ] /shop excluded"
    labels=@("seo","mcgonagall","phase-1")
  },
  @{
    title="[seo] Add JSON-LD structured data to blog posts"
    body="**Agent: @mcgonagall (SEO & Legal)**`n`nAdd Article schema markup to blog post pages for Google rich results.`n`n**Schema type:** BlogPosting`n**Fields:** headline, description, datePublished, author (Person), publisher (Organization), image`n`n**Acceptance criteria:**`n- [ ] Each blog post has valid JSON-LD in <head>`n- [ ] Passes Google Rich Results Test`n- [ ] Author and publisher correctly populated"
    labels=@("seo","mcgonagall","phase-1")
  },
  @{
    title="[seo] Review and finalize all legal pages"
    body="**Agent: @mcgonagall (SEO & Legal)**`n`nReview Privacy Policy, Affiliate Disclosure, and Terms of Use for completeness and legal soundness.`n`n**Checklist:**`n- [ ] Privacy Policy covers: Kit email collection, YouTube embeds, Giscus (GitHub account data), affiliate link tracking, cookies`n- [ ] Disclosure clearly states which links are affiliate links (FTC requirement)`n- [ ] Terms include medical disclaimer: 'This site is for informational purposes only and is NOT medical advice'`n- [ ] All three pages linked in footer`n- [ ] Effective date added to each policy"
    labels=@("seo","mcgonagall","phase-1")
  },

  # SNAPE - Security
  @{
    title="[security] Implement Content Security Policy for GitHub Pages"
    body="**Agent: @snape (Security Reviewer)**`n`nGitHub Pages doesn't support custom HTTP headers via _headers file. Document and implement CSP via <meta http-equiv> in BaseLayout.astro instead.`n`n**Required allowances:**`n- YouTube nocookie embeds`n- Giscus (giscus.app)`n- Kit/ConvertKit forms (app.kit.com)`n- Google Fonts`n`n**Acceptance criteria:**`n- [ ] CSP meta tag in BaseLayout.astro head`n- [ ] No console errors from CSP violations on any page`n- [ ] Document any intentional unsafe-inline uses"
    labels=@("security","snape","phase-1")
  },
  @{
    title="[security] Audit npm dependencies for vulnerabilities"
    body="**Agent: @snape (Security Reviewer)**`n`nRun security audit and resolve any issues.`n`n**Steps:**`n- [ ] Run npm audit`n- [ ] Fix any high or critical vulnerabilities`n- [ ] Document any accepted low/moderate risks`n- [ ] Set up dependabot alerts in GitHub (add .github/dependabot.yml)`n`n**Acceptance criteria:**`n- [ ] npm audit shows 0 high/critical vulnerabilities`n- [ ] dependabot.yml configured for weekly npm updates"
    labels=@("security","snape","phase-1")
  },

  # DUMBLEDORE - Lead
  @{
    title="[architecture] Purchase domain typeoneden.com and configure DNS"
    body="**Owner: xanderlynn (human action required)**`n`nThis is a manual task — cannot be automated.`n`n**Steps:**`n1. Purchase typeoneden.com at Cloudflare Registrar (recommended) or Namecheap`n2. Add CNAME record: @ → xanderlynn.github.io`n3. Add A records pointing to GitHub Pages IPs:`n   - 185.199.108.153`n   - 185.199.109.153`n   - 185.199.110.153`n   - 185.199.111.153`n4. In GitHub repo Settings → Pages → set custom domain: typeoneden.com`n5. Enable 'Enforce HTTPS'`n`n**Acceptance criteria:**`n- [ ] typeoneden.com loads the site`n- [ ] HTTPS is enforced`n- [ ] www.typeoneden.com redirects to typeoneden.com"
    labels=@("dumbledore","phase-1")
  },
  @{
    title="[architecture] Initialize Squad and run squad init"
    body="**Owner: xanderlynn + @dumbledore**`n`nInitialize Squad in the repo so agents can be activated.`n`n**Steps:**`n1. Ensure npm install -g @bradygaster/squad-cli is done (already completed)`n2. Ensure gh auth login is done`n3. Run: squad init`n4. Run: squad build (to generate .squad/ from squad.config.ts)`n5. Commit the .squad/ directory`n6. Start watch mode: squad triage --execute --interval 5`n`n**Acceptance criteria:**`n- [ ] .squad/team.md exists and lists all 8 HP agents`n- [ ] squad status shows team active`n- [ ] Issues are being auto-triaged by Ralph"
    labels=@("dumbledore","phase-1")
  },
  @{
    title="[architecture] Phase 1 launch sign-off checklist"
    body="**Agent: @dumbledore (Project Lead)**`n`nFinal sign-off before going live. All items must be checked.`n`n**Pre-launch checklist:**`n- [ ] All Phase 1 issues closed`n- [ ] Lighthouse scores 90+ on all pages`n- [ ] Zero axe accessibility violations`n- [ ] typeoneden.com custom domain resolving`n- [ ] HTTPS enforced`n- [ ] Kit newsletter form accepting signups`n- [ ] Giscus comments loading on blog posts`n- [ ] Sitemap submitted to Google Search Console`n- [ ] Privacy, Disclosure, Terms pages published`n- [ ] Affiliate links all functional with nofollow`n- [ ] README updated with live site URL"
    labels=@("dumbledore","phase-1")
  }
)

Write-Host "  Creating $($issues.Count) issues..." -ForegroundColor Gray
$issueNum = 0
foreach ($issue in $issues) {
  $issueNum++
  $labelStr = $issue.labels -join ","
  $result = gh issue create `
    --title $issue.title `
    --body $issue.body `
    --label $labelStr `
    2>&1
  if ($LASTEXITCODE -eq 0) {
    Write-Host "  [$issueNum/$($issues.Count)] Created: $($issue.title.Substring(0, [Math]::Min(60, $issue.title.Length)))..." -ForegroundColor Green
  } else {
    Write-Host "  [$issueNum/$($issues.Count)] FAILED: $($issue.title)" -ForegroundColor Red
    Write-Host "  Error: $result" -ForegroundColor Red
  }
  Start-Sleep -Milliseconds 500
}

Write-Host "`n== Step 5: Initialize Squad ==" -ForegroundColor Cyan
squad init 2>&1
Write-Host "  Running squad build to generate .squad/ from squad.config.ts..." -ForegroundColor Gray
squad build 2>&1

Write-Host "`n== Setup Complete! ==" -ForegroundColor Green
Write-Host "Repo:   https://github.com/$OWNER/$REPO" -ForegroundColor Cyan
Write-Host "Issues: https://github.com/$OWNER/$REPO/issues" -ForegroundColor Cyan
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Purchase typeoneden.com domain" -ForegroundColor White
Write-Host "  2. Configure GitHub Pages custom domain" -ForegroundColor White
Write-Host "  3. Enable GitHub Discussions (for Giscus)" -ForegroundColor White
Write-Host "  4. Create Kit account and update NewsletterSignup.astro form ID" -ForegroundColor White
Write-Host "  5. Start Squad watch: squad triage --execute --interval 5" -ForegroundColor White
