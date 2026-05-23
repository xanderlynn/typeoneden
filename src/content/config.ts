import { defineCollection, z } from 'astro:content';

const blog = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    pubDate: z.coerce.date(),
    category: z.enum(['Life with T1D', 'Tech & Gear', 'Nutrition', 'Advocacy', 'Mindset']),
    image: z.string().optional(),
    author: z.string().default('xanderlynn'),
    draft: z.boolean().default(false),
  }),
});

export const collections = { blog };
