---
name: novita-design-skill
version: 1.0.0
description: Public-safe Novita AI brand design skill for creating or reviewing Novita-style visual work. Use whenever the user asks for Novita-branded slides/PPT, landing pages, websites, UI concepts, marketing graphics, brand direction, or frontend styling inspired by Novita AI. This public guide gives brand-level direction and intentionally avoids internal product routes, private IA, sidebar structures, implementation-only app details, and complete internal design-system specifications.
---

# Novita Design Skill

Use this skill to create public-facing Novita AI design work that feels clean, technical, fast, and trustworthy. It applies to artifacts such as landing pages, presentation decks, product one-pagers, web sections, UI concepts, diagrams, thumbnails, social visuals, and frontend implementations.

This is a public-safe brand design skill. Do not expose or preserve internal product structure, private route names, authenticated-console information architecture, sidebar menus, domain JSON, internal component paths, exact internal layouts, or complete component specifications. Translate source material into reusable brand principles and generic design patterns.

## Core Workflow

1. Identify the artifact type: slide deck, landing page, website section, dashboard mockup, graphic, report, design critique, or code implementation.
2. Read the relevant references:
   - `references/BRAND.md` for Novita visual identity, voice, composition, and public-safe constraints.
   - `references/LOGO.md` when the output includes the Novita name, logo, wordmark, partner strip, title slide, website header, footer, or brand lockup.
   - `references/TOKENS.md` when selecting public brand colors, typography direction, spacing feel, radius feel, or visual hierarchy.
   - `references/PATTERNS.md` when designing PPT layouts, landing pages, content sections, data visuals, diagrams, or AI/developer-tool themed graphics.
3. Apply the Novita visual language:
   - neutral light canvas, restrained green accent, crisp typography, quiet surfaces, precise spacing, and useful motion.
   - green communicates action, readiness, success, or active state; it is not decorative wallpaper.
   - use technical clarity over playful illustration or generic AI neon.
4. Create the requested output in the user's format. For code, use the repo's existing stack and components. For design specs, provide structured choices and brand-level layout guidance rather than private implementation specs.
5. Run the pre-delivery checklist before finalizing.

## Design North Star

Novita AI should look like serious infrastructure for people building with AI. The design should feel:

- Clean: few colors, strong alignment, generous whitespace.
- Technical: grid-aware composition, monospace accents, data-friendly details.
- Trustworthy: readable contrast, precise labels, restrained elevation.
- Fast: direct calls to action, low visual friction, lightweight motion.
- Modern: current SaaS polish without generic purple-blue AI gradients.

Avoid making Novita look like a consumer entertainment app, crypto product, gaming UI, or corporate consulting template.

## Public-Safe Rules

- Do not copy internal app structure into public artifacts.
- Do not mention private routes, sidebar zones, authenticated-product modules, implementation-only file paths, domain names from internal JSON, or hidden navigation.
- Do not preserve console IA or authenticated product structure.
- When source material contains product-specific details, abstract them into general patterns such as "catalog view", "usage summary", "settings concept", "developer workflow", or "technical proof section".
- If the output is public-facing, prioritize brand expression, value communication, and reusable design language over product architecture.

## Visual Language

Use a mostly achromatic interface with one living accent:

- Primary accent: Novita green `#23D57C`
- Hover/deeper green: `#16B063`
- Soft green surfaces: `#CAF6E0`, `#EFFCF5`
- Page canvas: `#FAFAFA`
- Main text: near-black `#0A0A0A`
- Cards and panels: white or subtle gray with fine borders

Use the green accent sparingly. A single green CTA, active tab, focused input, selected state, or success marker is often enough.

## Typography Guidance

Prefer Miletus Grotesk Trial when available. Use Inter, TT Interfaces, or a neutral geometric sans fallback when it is not. Use a mono face only for labels, code-adjacent text, metrics, IDs, or small infrastructure tags.

Headlines should be tight and crisp. Body copy should remain highly readable with normal tracking. Avoid heavy all-caps blocks, decorative type, or excessive boldness.

## Artifact-Specific Guidance

### PPT / Slide Decks

Use Novita's restraint to make slides feel executive and technical:

- one sharp idea per slide;
- large title, short subtitle, compact evidence;
- plenty of whitespace;
- green only for emphasis or the key number;
- diagrams use thin borders, neutral fills, and small green active nodes;
- data slides use aligned numeric columns and restrained status color.

Avoid dense walls of text, mixed icon styles, decorative gradients, and oversized green backgrounds.

### Landing Pages

Build around a direct value proposition, proof, and action:

- hero with headline, concise supporting copy, primary CTA, and product-relevant visual;
- feature sections that explain capability through use cases, not abstract buzzwords;
- trust/proof section with metrics, logos, benchmarks, or integration cues when available;
- final CTA with a clear next step.

Prefer light surfaces, clean cards, realistic product visuals, model/API/developer metaphors, and technical proof points.

### UI Concepts / Web Apps

Keep interfaces dense enough for professional users but not crowded:

- clear hierarchy, compact controls, visible states, and predictable navigation;
- cards use fine borders and subtle shadows;
- forms use visible labels, focus rings, and inline feedback;
- data tables include empty, loading, error, and overflow states;
- icon-only controls need labels or tooltips.

Keep these as public-facing concept patterns. Do not reconstruct internal app screens, route structure, sidebar structure, exact component APIs, or private flows.

### Marketing Graphics

Use literal AI infrastructure cues: model cards, inference traces, API calls, latency/throughput charts, GPU-like compute grids, pipeline flows, or multimodal generation panels. Keep them abstract enough to avoid exposing product internals.

## Code Implementation Guidance

When implementing frontend code:

- Use existing project components and styling conventions first.
- Prefer semantic tokens over hardcoded colors.
- Use accessible focus states and 44px touch targets for mobile.
- Do not hand-draw common icons when an icon library is available.
- Do not use emoji as UI icons.
- Avoid layout shifts from hover states; prefer color, border, shadow, or opacity changes.
- Test responsive layouts at mobile, tablet, and desktop widths when feasible.

## Pre-Delivery Checklist

- The output feels clean, technical, trustworthy, and fast.
- No internal product route/sidebar/domain structure leaked into the artifact.
- Green is used as a precise accent, not a decorative wash.
- Type hierarchy is clear and readable.
- Logo usage follows `references/LOGO.md`; do not redraw or approximate the Novita logo.
- Surfaces use neutral backgrounds, fine borders, and restrained depth.
- Calls to action are obvious and not competing with too many secondary accents.
- Mobile or slide readability is preserved; no cramped text.
- Icons, charts, and diagrams use a consistent visual language.
- Accessibility basics are covered: contrast, labels, focus, alt text where relevant.
