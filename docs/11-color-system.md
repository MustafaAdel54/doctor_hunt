# 11 — Colour System (Doctor Hunt)

Source: the Figma colour file supplied by the product owner.
Final file: `tools/app_colors.dart` → copy to `lib/generated/app_colors.dart`.

---

## 1. The Problem With the Raw File

The extracted file has **~60 colour constants**. The style generator produces
`weights × sizes × colours` getters, so feeding it 60 colours gives:

```
5 weights × 15 sizes × 60 colours = 22,500 getters
```

That is unusable — a multi-megabyte Dart file, unusable autocomplete, and a slow
analyzer. The generator is designed around **19** semantic colours (1,425 getters).

Worse, many of the 60 are **near-duplicates that no one can tell apart**. Measured
RGB distance (anything under ~40 is visually indistinguishable in body text):

| Pair | Distance | Verdict |
|---|---|---|
| `textRich #222222` vs `almostBlack #212121` | **2** | identical |
| `textSecondary #677294` vs `textSlate #64748B` | **10** | identical |
| `grey300 #C4C4C4` vs `grey350 #CBCBCB` | **12** | identical |
| `textNavy #17202A` vs `textDarkest #0F172A` | **12** | identical |
| `textNavy` vs `almostBlack` | 13 | indistinguishable |
| `almostBlack` vs `textGreenDark #161D19` | 14 | indistinguishable |
| `textRich` vs `textGreenDark` | 16 | indistinguishable |

There are **14 near-black text colours** in the file. A design system needs about
three.

### Contrast audit of the text colours (vs white, WCAG AA needs 4.5:1)

| Token | Hex | Ratio | Body text? |
|---|---|---|---|
| `textBody` | `#475569` | 7.58 | ✅ |
| `textMid` | `#556386` | 5.97 | ✅ |
| `textSecondary` | `#677294` | 4.76 | ✅ (just passes) |
| `textSlate` | `#64748B` | 4.76 | ✅ |
| `textNavy` | `#17202A` | 16.45 | ✅ |
| **`grey500`** | `#7B8490` | **3.79** | ❌ fails AA |
| **`iconMuted`** | `#94A3B8` | **2.56** | ❌ icons/placeholder only |
| **`grey300/350`** | `#C4C4C4` | **1.74** | ❌ decorative only |

`grey500` is the trap: it looks like a text colour and it is **not accessible**.
It is excluded from the semantic palette.

---

## 2. The Solution — Two Tiers

### Tier 1: `FigmaRaw` — every literal, kept verbatim
All ~60 values survive as named constants for reference and rare one-offs.
**Never used directly in widgets** (that would break dark mode).

### Tier 2: `AppPalette` — 19 semantic tokens the generator consumes
Plus 4 surfaces and 4 shadow tints that aren't text colours and so aren't in the
generator's list.

**Nothing was thrown away** — the raw tier keeps everything. The semantic tier is
what the app actually uses.

---

## 3. The Mapping (light)

| Semantic token | Figma source | Hex | Note |
|---|---|---|---|
| `primary` | `green500` | `#0EBE7F` | core brand |
| `primaryLight` | derived | `#E7F9F2` | solid tint (see §5) |
| `primaryDark` | `green900` | `#006C49` | |
| `secondary` | **added** | `#2E6FF2` | blue accent, not in Figma |
| `secondaryLight` | **added** | `#E8F0FE` | |
| `secondaryDark` | **added** | `#1B4DB3` | |
| `textMain` | `navy` | `#17202A` | 16.45:1 |
| `textSub` | `periwinkle` | `#677294` | 4.76:1, most-used |
| `textPlaceholder` | `slate400` | `#94A3B8` | |
| `textBorders` | `grey200` | `#EDEDED` | |
| `danger` | `red` | `#FA002F` | |
| `dangerLight` | derived | `#FFE8EC` | |
| `success` | `green500` | `#0EBE7F` | = brand green |
| `successLight` | `surfaceMint` | `#ECFDF5` | |
| `warning` | **changed** | `#F59E0B` | amber, replaces Figma rose |
| `warningLight` | **changed** | `#FEF3C7` | |
| `white` / `black` | literal | | absolute |
| `boxShadow` | `shadowMd` | `#14000000` | |
| `scaffold` / `surface` | `white` | `#FFFFFF` | |
| `surfaceAlt` | `grey100` | `#F9F8F8` | |
| `surfaceBrand` | `surfaceGreen` | `#F3FBF4` | |

### Two deliberate deviations from Figma (approved)

**1. `secondary` is a new blue `#2E6FF2`.** Doctor Hunt is monochrome-green, so the
design has no second accent. Without one, `secondary` would have duplicated `textSub`
and the admin dashboard, charts, and specialization chips would have had nothing to
work with. Blue pairs cleanly with the brand green and is a conventional, trustworthy
pairing in medical UI. Dark variant `#7FA0FF` (6.79:1).

**2. `warning` is amber `#F59E0B`, not Figma's rose `#F43F5E`.** `warning` marks
**pending** appointments, and a red pending badge reads as a failed booking. Amber is
the standard "waiting" signal. Dark variant `#FBBF24` (10.21:1).

Figma's rose is preserved as `FigmaRaw.rose` if it's ever needed.

**3. `success` and `primary` are the same green** — intentional and kept. A confirmed
booking in brand green is exactly right.

### ⚠️ Amber is a FILL colour, not a text colour

`#F59E0B` on white is only **2.15:1** — nowhere near readable as body text. It is
meant for the chip/badge **background**, with a dark label on top:

```dart
Container(
  color: context.palette.warning,                       // amber fill
  child: Text('Pending', style: context.medium12TextMain), // dark label, 7.66:1
)
```
`AppPalette.onWarning` is a derived getter (`textMain`), not a generator token or
constructor field. It exists for exactly this purpose.
The generated `context.*Warning` text getters still exist, but only use them on a
dark or neutral surface — never amber text on white.

### Status colour separation (RGB distance, >60 = clearly distinct)

| Pair | Distance |
|---|---|
| pending (amber) vs confirmed (green) | 260 ✅ |
| pending vs cancelled (red) | 162 ✅ |
| confirmed vs cancelled | 313 ✅ |
| confirmed vs completed (grey) | 119 ✅ |
| cancelled vs completed | 212 ✅ |

All four appointment statuses are unambiguous at a glance — which was the whole point
of moving off rose.

---

## 4. Dark Palette — Derivation Rules

Figma has light only, so dark is derived. Rules applied:

1. **Brand colours lighten, they don't invert.** `#0EBE7F` → `#2FD79B`: raise
   lightness, drop saturation slightly so it doesn't vibrate on a dark surface.
2. **`*Light` tints flip meaning.** In light mode they're pale tints; in dark mode
   they become **dark, low-chroma versions of the same hue** (`#E7F9F2` → `#143026`).
   They keep serving as chip/badge backgrounds.
3. **`*Dark` variants get lighter.** In dark mode the "stronger" variant must be more
   visible, not less: `#006C49` → `#5FE8B8`.
4. **Surfaces carry a green tint**, not neutral grey (`#151E1A`, `#0B1310`), so the
   brand still reads in dark mode.
5. **`white` and `black` stay absolute** — they mean literal white and black.
6. **Shadows get stronger**, since shadows are weaker on dark backgrounds.

### Dark contrast audit (vs `surface #151E1A`)

| Token | Hex | Ratio | Verdict |
|---|---|---|---|
| `textMain` | `#E8EDEB` | 14.40 | ✅ AAA |
| `textSub` | `#9AA6B2` | 6.87 | ✅ AA |
| `primary` | `#2FD79B` | 9.18 | ✅ AAA |
| `success` | `#3FD98D` | 9.35 | ✅ AAA |
| `secondary` | `#7FA0FF` | 6.79 | ✅ AA |
| `warning` | `#FBBF24` | 10.21 | ✅ AAA |
| `danger` | `#FF5A75` | 5.66 | ✅ AA |
| `textPlaceholder` | `#6B7785` | 3.73 | placeholder only — by design |

**Every functional colour passes WCAG AA.**

> These are a solid, accessible starting point — not a designer's dark theme.
> Review them on a real screen and adjust; the structure won't change.

---

## 5. Opacity-Based Tints → Solid Colours

The Figma file defines tints as **transparent overlays**:
```dart
static const Color primarySurface = Color(0x140EBE7F);  // green @ 8%
```
These were converted to **solid** colours in the palette. Why:

- A translucent colour composited over a **dark** background gives a completely
  different result than over white — so the same token can't serve both themes.
- Transparency stacks unpredictably when a tinted chip sits on a tinted card.
- Solid colours render marginally faster (no blending).

The translucent values remain available in `FigmaRaw` for genuine glass/overlay
effects, where transparency is the actual intent.

---

## 6. Shadows

Figma's shadow presets became **theme-aware helpers**:

```dart
Container(
  decoration: BoxDecoration(
    color: context.palette.surface,
    borderRadius: BorderRadius.circular(AppRadius.md),
    boxShadow: AppShadows.card(context),   // adapts to light/dark
  ),
)
```

Available: `card`, `cardLarge`, `searchBar`, `navBar`, `elevated`, `ctaButton`.

> Dark-mode shadows are ~2.5× stronger, because a subtle shadow is invisible on a
> dark surface. This is why they can't be `static const` lists.

---

## 7. Usage

```dart
// text — theme-aware automatically
Text(t.auth.login, style: context.bold20TextMain)
Text(doctor.bio,   style: context.regular14TextSub)
Text(fee,          style: context.semiBold16Primary)

// non-text colour
Container(color: context.palette.surfaceBrand)
Icon(Icons.star, color: context.palette.warning)

// shadows
boxShadow: AppShadows.ctaButton(context)

// ❌ never — breaks dark mode
Container(color: AppColors.primary)
Container(color: FigmaRaw.green500)
```

---

## 8. Status → Colour Mapping (final)

| Status | Token | Light | Dark |
|---|---|---|---|
| pending | `warning` | `#F59E0B` | `#FBBF24` |
| confirmed | `success` / `primary` | `#0EBE7F` | `#3FD98D` |
| cancelled | `danger` | `#FA002F` | `#FF5A75` |
| completed | `textSub` | `#677294` | `#9AA6B2` |

---

## 9. Remaining Item

**Review the dark palette on a real device before locking it.** It is derived and
contrast-audited, not designer-authored. The token structure won't change — only the
hex values might shift slightly.
