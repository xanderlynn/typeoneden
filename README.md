# Type One Den

> A T1D lifestyle website and blog. Built with Astro + Tailwind CSS.

## Stack
- **Framework:** Astro 5
- **Styling:** Tailwind CSS v4
- **Hosting:** GitHub Pages
- **Multi-agent tooling:** Squad (`bradygaster/squad`) with Harry Potter themed agents

## Squad Agents
| Agent | Role |
|-------|------|
| Dumbledore | Project Lead |
| Hermione | Lead Designer |
| Harry | Frontend Engineer |
| Luna | Content Architect |
| Ron | Integration Engineer |
| Neville | QA / Tester |
| McGonagall | SEO & Legal |
| Snape | Security Reviewer |

## Local Development
```bash
npm install
npm run dev
```

## Deploy
Automatic via GitHub Actions on push to `main`. See `.github/workflows/deploy.yml`.

## Adding Content
Blog posts live in `src/content/blog/`. Create a new `.md` or `.mdx` file with the required frontmatter (see `src/content/config.ts` for schema).
