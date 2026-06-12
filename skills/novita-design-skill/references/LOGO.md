# Novita Logo Usage

Use this reference whenever a design includes the Novita name, logo, wordmark, partner logos, title slide branding, website header, footer, cover graphic, or social preview.

## Source Of Truth

Do not redraw, approximate, or invent the Novita logo. Use an official or verified vector asset whenever the logo itself is required.

Bundled official assets:

- `assets/logo/novita-logo.svg` — default horizontal black logo for light backgrounds.
- `assets/logo/novita-logo-small.svg` — symbol-only mark for favicons, avatars, compact UI, or small slide marks.
- `assets/logo/novita-logo-white.svg` — horizontal white logo for dark backgrounds.

These bundled SVGs were downloaded from the public Novita AI website on 2026-06-12. Prefer them before remote fetching.

Original public sources:

- Official Novita AI site: `https://novita.ai/`
- `https://novita.ai/logo/logo.svg`
- `https://novita.ai/logo/logo_small.svg`
- `https://novita.ai/logo/white-logo.svg`
- Verified provider icon package: `@lobehub/icons`, which documents Novita variants such as `Novita`, `Novita.Color`, `Novita.Text`, `Novita.Combine`, and `Novita.Avatar`.

If no bundled, official, or verified asset is available in the working project, use the text lockup `Novita AI` in the correct typography and color rather than drawing a fake symbol.

## Brand Name

Use `Novita AI`.

Avoid:

- `NOVITA`
- `novita`
- `Novita.AI`
- `Novita ai`
- `NovitaAI`

Use sentence case in body copy. Use the exact brand spelling in titles, captions, headers, and alt text.

## Logo Variants

Use the smallest sufficient brand mark:

| Context | Preferred Variant |
| --- | --- |
| Website header | horizontal lockup or `Novita AI` text lockup |
| Website footer | horizontal lockup or text lockup |
| PPT title slide | horizontal lockup, small and quiet |
| PPT section divider | wordmark or text lockup |
| Favicon/avatar/small badge | symbol/avatar variant |
| Partner strip | monochrome or neutral lockup |
| Dark surface | light or mono-light variant |
| Light surface | color or mono-dark variant |

Use `novita-logo.svg` on light surfaces, `novita-logo-white.svg` on dark surfaces, and `novita-logo-small.svg` only when the full wordmark would become unreadable.

Do not mix multiple logo variants in the same view unless the layout has a clear hierarchy, such as full lockup in the header and small avatar in a product mockup.

## Placement

Use the logo as an orientation marker, not decoration.

Good placements:

- top-left in website headers;
- bottom-left or top-left on PPT title slides;
- footer brand area;
- partner/integration strips;
- small app/avatar mark in mock UI chrome;
- closing slide next to URL or contact.

Avoid:

- oversized centered logo as a hero replacement;
- repeated logo pattern backgrounds;
- watermarking every card;
- rotating, skewing, stretching, outlining, or adding effects;
- placing the logo on noisy images or low-contrast surfaces.

## Clear Space And Size

Keep clear space around the logo at least equal to the symbol height or the cap height of the wordmark when possible. In tight UI, keep at least 8px clear space.

Suggested sizes:

- Website header: 28-36px visual height for the full lockup.
- Website footer: 24-32px visual height.
- PPT title slide: 24-40px visual height depending on canvas.
- PPT footer mark: 14-20px visual height.
- Avatar/symbol: 24, 32, 40, or 56px.

Never scale the logo so small that the wordmark becomes unreadable. Use a symbol/avatar variant instead.

## Color Use

On light backgrounds:

- use full-color or dark mono logo;
- keep surrounding UI neutral;
- do not recolor the logo with arbitrary palette colors.

On dark backgrounds:

- use light mono or approved color variant;
- avoid brand-green backgrounds behind the full lockup unless contrast has been checked.

Do not apply gradients, shadows, strokes, glass effects, or masking to the logo.

## Web Implementation

For React projects that can add dependencies, prefer the verified icon package when appropriate:

```tsx
import { Novita } from '@lobehub/icons';

export function BrandMark() {
  return <Novita.Combine size={36} type="color" />;
}
```

If the project already has an official local SVG asset, prefer that local asset. Otherwise copy from `assets/logo/`. Preserve its viewBox and aspect ratio.

For accessibility:

- use `alt="Novita AI"` for image logos;
- use `aria-label="Novita AI"` for linked SVG logos;
- avoid empty alt text unless the logo is purely decorative and the brand name appears immediately next to it.

## PPT / Static Design

For slides, use the logo quietly:

- title slide: small top-left or bottom-left lockup;
- section divider: wordmark plus section label;
- closing slide: lockup plus URL/contact;
- partner slide: same optical size as other partner logos.

If the official logo asset is unavailable, typeset `Novita AI` as a text lockup in the primary sans font. Do not create a custom symbol.

## Quality Checklist

- The logo comes from an official or verified vector source.
- The brand name is spelled `Novita AI`.
- The logo is not stretched, recolored, redrawn, or decorated.
- The logo has enough clear space and contrast.
- The selected variant matches the background and size.
- The logo supports orientation or trust; it is not used as filler.
