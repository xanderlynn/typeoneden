import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const blog = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/blog' }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    pubDate: z.coerce.date(),
    updatedDate: z.coerce.date().optional(),
    category: z.enum(['Life with T1D', 'Tech & Gear', 'Nutrition', 'Advocacy', 'Mindset']),
    tags: z.array(z.string()).optional().default([]),
    image: z.string().optional(),
    author: z.string().default('xanderlynn'),
    draft: z.boolean().default(false),
  }),
});

export const collections = { blog };
