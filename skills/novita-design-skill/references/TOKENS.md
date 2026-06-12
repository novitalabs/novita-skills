# Novita Public Brand Tokens

Use this reference as a public brand-level guide. It intentionally avoids publishing a full internal design-token system, exhaustive component state tables, or implementation-only class names.

## Core Palette

Novita uses a mostly neutral interface with one vivid brand accent.

| Role | Value | Use |
| --- | --- | --- |
| Brand green | `#23D57C` | Primary CTA, active state, success signal, selected accent |
| Deep green | `#16B063` | Hover, deeper brand text, stronger active state |
| Soft green | `#CAF6E0` | Light highlight, selected surface, subtle brand tint |
| Pale green | `#EFFCF5` | Very soft background tint or focus support |
| Near-white canvas | `#FAFAFA` | Page and slide background |
| White | `#FFFFFF` | Cards, panels, clean sections |
| Near-black | `#0A0A0A` | Primary text |
| Dark gray | `#262626` | Strong UI text, dark panel |
| Mid gray | `#737373` | Supporting text |
| Light border | `#E5E5E5` | Borders and separators |

## Color Principles

- Use green as a precise signal, not an all-over theme.
- Keep most surfaces white, near-white, or light gray.
- Use neutral borders and quiet shadows before adding color.
- Use red, amber, and blue only for obvious semantic states: error, warning, and information.
- Do not use generic purple-blue AI gradients as the main brand expression.

## Typography Direction

Preferred direction:

- geometric sans for headings, body copy, and UI;
- Miletus Grotesk Trial when available;
- Inter, TT Interfaces, or system sans as public-safe fallback;
- mono only for small technical labels, code snippets, model/API tags, and metrics.

Type behavior:

- large headlines should feel tight and crisp;
- body copy should stay readable with normal tracking;
- avoid excessive bold weight;
- avoid long all-caps text blocks;
- use tabular or mono-like numbers for metrics when available.

## Spacing And Layout Feel

Use a measured, technical rhythm:

- generous page margins;
- compact UI groups;
- clear section separation;
- card padding that feels intentional, not oversized;
- aligned text, cards, charts, and diagrams on a visible grid.

For public design work, describe spacing as small, medium, large, and section-scale rather than exposing internal token scales.

## Radius And Depth

Novita should feel precise, not bubbly.

- Use small radii for controls and tags.
- Use moderate radii for cards and feature panels.
- Use subtle shadows only for lifted panels, dropdowns, and hero visuals.
- Prefer 1px borders and neutral separators for structure.
- Avoid heavy shadows, glass effects by default, and oversized rounded cards.

## UI State Direction

For public-facing concepts:

- primary actions use green and deepen on hover;
- secondary actions stay neutral;
- focus states should be visible and may use soft green support;
- errors use red plus text, not red alone;
- selected states use green border, soft green fill, or a clear check/label.

Keep state descriptions conceptual. Do not publish exhaustive internal component specs.

## Data Visual Direction

Use data visuals to communicate proof:

- green for Novita, positive deltas, active path, or the primary metric;
- gray for baselines and inactive references;
- blue for neutral informational comparison;
- amber/red for warnings, failures, or risk;
- direct labels and units over decorative chart furniture.

Avoid rainbow palettes and unlabeled decorative charts.
