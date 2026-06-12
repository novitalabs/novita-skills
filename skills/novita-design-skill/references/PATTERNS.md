# Novita Public Design Patterns

Use this reference for public-facing Novita-style slides, landing pages, diagrams, marketing visuals, and UI concepts. It intentionally avoids internal information architecture, private routes, sidebar layouts, and exact component implementations.

## Pattern Selection

| Goal | Recommended Direction |
| --- | --- |
| Landing page | Hero + proof visual + capability sections + CTA |
| Pitch deck | Title + problem + solution + proof + workflow + next step |
| Product overview | Value prop + capability cards + technical diagram + metrics |
| Technical explainer | Diagram-first layout + concise callouts + code/data strip |
| Comparison story | Clear claim + comparison matrix + proof + CTA |
| Developer concept | API/code panel + model cards + latency/scale proof |
| Social or hero graphic | Large claim + technical visual + single brand cue |

## Landing Page Guidance

Recommended public structure:

1. Hero with a concrete value proposition.
2. Product-relevant visual: interface concept, API snippet, model card, media preview, or workflow diagram.
3. Capability sections that explain outcomes, not just features.
4. Proof section: metrics, benchmarks, customer quote, integration cue, or trust marker.
5. Final CTA with one clear next step.

Hero guidance:

- headline states a concrete capability;
- subtitle explains who it helps and what improves;
- primary CTA uses green;
- secondary CTA stays neutral;
- visual should feel technical and real, not decorative.

Feature sections:

- use 3 to 6 capability cards or rows;
- each card has one clear outcome;
- use thin icons or simple diagrams;
- keep copy short and specific.

## PPT / Slide Patterns

### Title Slide

Use:

- near-white background;
- small official logo from `assets/logo/`;
- oversized title;
- short subtitle;
- optional mono label for date, audience, or context;
- one quiet green accent.

Avoid:

- full-screen gradients;
- logo as oversized decoration;
- dense subtitles.

### Problem / Opportunity Slide

Use:

- one direct problem statement;
- 3 evidence points or pain cards;
- neutral surfaces;
- amber/red only when showing risk.

### Solution Slide

Use a simple public-safe flow:

Input -> API / Model -> Inference -> Output

Use green for the active solution node and keep other nodes neutral.

### Technical Diagram Slide

Use:

- simple nodes;
- thin neutral connectors;
- green active path;
- small labels close to nodes;
- concise takeaway sentence.

Do not expose internal architecture unless the user provides public-safe details.

### Metrics Slide

Use:

- one large hero metric;
- 2 to 4 supporting metrics;
- units and short explanations;
- green delta only when it represents positive proof.

## Public UI Concept Patterns

These are public-facing concept patterns, not internal screen specs.

### Model / Capability Card

Use for AI model catalogs, API showcases, or capability grids.

Elements:

- name;
- short type label;
- one-sentence description;
- 2 to 3 proof metrics or tags;
- action or status.

Style:

- white card;
- subtle border;
- modest radius;
- compact tags;
- green only for selected, available, or primary action.

### API Snippet Panel

Use for developer credibility.

Elements:

- generic endpoint or pseudocode;
- short request/response example;
- copy affordance if interactive;
- latency or success indicator when relevant.

Do not publish private endpoints, internal route names, or implementation-only paths.

### Data Proof Block

Use:

- small chart or metric row;
- clear unit labels;
- direct annotation;
- neutral baseline and green primary series.

Avoid unlabeled decorative charts.

## Marketing Graphic Patterns

### Technical Hero Visual

Composition:

- large claim on one side or top;
- public-safe technical visual as the main object;
- logo or wordmark used quietly;
- green CTA or small accent;
- mostly white or near-white background.

Visual motifs:

- model cards;
- code panels;
- generated-media previews;
- inference traces;
- compute tiles;
- latency or throughput mini-chart;
- pipeline arrows.

### Bento Capability Grid

Use:

- one large anchor card;
- 3 to 5 smaller supporting cards;
- neutral card fills;
- one or two soft green highlights;
- varied content types rather than random colors.

### Diagram-First Explainer

Use when explaining infrastructure or workflow:

- diagram first;
- labels close to nodes;
- one clear active path;
- short supporting copy;
- no private topology.

## Icon And Chart Style

Icons:

- use one clean outline set;
- keep strokes light and consistent;
- use green for active or success only;
- avoid emoji and mixed icon styles.

Charts:

- choose simple line, bar, matrix, or metric tiles before complex visuals;
- label axes and units;
- avoid rainbow palettes;
- make slide charts readable at small sizes.

## Copy Style

Use exact brand spelling: `Novita AI`.

Prefer:

- concrete verbs;
- measurable outcomes;
- short labels;
- technical proof;
- sentence case for body copy.

Avoid:

- vague AI hype;
- unsupported benchmark claims;
- casual filler;
- inconsistent capitalization.
