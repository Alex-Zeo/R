# CLAUDE.md — AI Assistant Guide for r-high-fidelity-viz

## What This Repository Is

This is a **Claude AI skill specification repository** named `r-high-fidelity-viz`. It does not contain runnable application code or a traditional software project. Instead, it holds a structured prompt/specification document (`plan.md`) that teaches AI agents how to generate publication-quality R visualizations using ggplot2 and the tidyverse ecosystem.

The skill is intended to be loaded as context when a user asks for R charts, plots, statistical figures, or data visualizations.

---

## Repository Structure

```
/
├── README.md     # One-line project description
├── plan.md       # Primary artifact: the full skill specification (611 lines)
└── CLAUDE.md     # This file
```

There are no source directories, build systems, test suites, package manifests, or CI/CD pipelines. The entire value of this repository is in `plan.md`.

---

## The Core Artifact: `plan.md`

`plan.md` starts with a YAML front-matter header followed by 13 numbered sections of Markdown:

| Section | Content |
|---|---|
| 1 · Core Philosophy | Four guiding principles (Grammar of Graphics, minimal/precise, accessible, reproducible) |
| 2 · Standard Library Stack | 28 vetted R packages organized by role, with `library()` calls and comments |
| 3 · Plot Selection Guide | Tables matching analytical goals to geoms/functions across 7 chart families |
| 4 · Color System | Colorblind-safe palette principles and a `scale_*` quick-reference block |
| 5 · Theme & Typography System | Custom `theme_pub()` function, pre-built theme table, typography rules |
| 6 · Annotation Best Practices | Copy-paste `ggrepel`, reference lines, region highlights, stat annotations |
| 7 · Scale & Axis Formatting | `scales::` formatting, log/date axes, `coord_cartesian()` vs `ylim()` |
| 8 · Multi-Panel Composition | `patchwork` operators, `plot_annotation()`, legend collection, insets |
| 9 · Export Settings | `ggsave()` recipes for PNG/TIFF/PDF/SVG, size guidelines table |
| 10 · Complete Worked Examples | 5 fully self-contained, copy-pasteable R scripts |
| 11 · Quality Checklist | 14-point checklist every generated plot must pass |
| 12 · Edge Cases & Troubleshooting | Solutions for overplotting, long labels, crowded axes, font issues |
| 13 · What This Skill Cannot Do | Explicit capability limitations (no Shiny, no code execution, no data access) |

---

## Development Workflow

### Making Changes

1. Edit `plan.md` directly — it is both the documentation and the skill.
2. There is no build step, compilation, or test runner.
3. Commit with a clear message describing the section(s) changed.
4. Push to the feature branch (see branch conventions below).

### What Changes Are In-Scope

- Adding new geom/package entries to the library stack (Section 2)
- Expanding the plot selection tables (Section 3) with new chart types
- Adding new worked examples to Section 10
- Updating the color system when new packages become available
- Correcting R syntax or outdated API usage in code blocks
- Expanding the troubleshooting section (Section 12)

### What Changes Are Out-of-Scope

- Converting this repository into an R package (no DESCRIPTION/NAMESPACE)
- Adding a build/test pipeline (not applicable)
- Adding interactive widget generation — explicitly excluded in Section 13
- Changing the YAML front-matter `name` or `description` without a strong reason

---

## Code Conventions (for R code blocks in `plan.md`)

All R code in this repository follows these conventions:

### Naming
- Functions and variables: `snake_case` (e.g., `theme_pub`, `body_mass_g`)
- Package names: lowercase (e.g., `tidyverse`, `ggplot2`, `patchwork`)

### Style
- Pipe operator: `%>%` (magrittr/tidyverse style)
- Layer separator: one `+` per line, aligned
- Section dividers in code comments: `# ── Section Name ──────────────`
- All code blocks must be **fully self-contained**: include `library()` calls, data preparation, plot construction, and `ggsave()` in a single script

### Quality Bar for Code Examples
Every code block must satisfy the quality checklist in Section 11:
- Title describes the insight, not the chart type
- Axis labels include units in parentheses
- Color palette is colorblind-safe
- Export uses explicit `width`, `height`, `units`, and `dpi`
- No 3D effects, excessive gridlines, or chartjunk

### Preferred Packages (by role)

| Role | Preferred | Avoid |
|---|---|---|
| Multi-panel layout | `patchwork` | `cowplot`, `gridExtra` |
| Non-overlapping labels | `ggrepel` | manual `geom_text` positioning |
| Sequential color | `viridis` | rainbow, jet |
| Discrete/qualitative color | `ggsci` (NPG/AAAS) or Okabe-Ito | random `scale_color_manual` |
| Distribution + raw data | `ggrain` (raincloud) | bare boxplots |
| Raster export | `ragg::agg_png` | base `png()` device |

---

## Key Technical Details

### R Ecosystem Targeted
- **Core**: tidyverse (ggplot2, dplyr, tidyr, readr, stringr, forcats, purrr, tibble)
- **Layout**: patchwork
- **Color**: viridis, RColorBrewer, ggsci, colorspace
- **Themes**: hrbrthemes, ggpubr, ggthemes
- **Stats**: ggstatsplot, ggcorrplot, survminer, broom, ggeffects
- **Extensions**: ggridges, ggbeeswarm, ggrain, gghighlight, ggforce, gganimate, ggdist, treemapify, waffle, ggalluvial, ggraph
- **Export**: ragg, svglite

### Example Datasets Used
- `palmerpenguins::penguins`
- `gapminder::gapminder`
- `ggplot2::mpg`
- `datasets::mtcars`

### Export Defaults
- Publication figures: 170–180 mm wide, 600 DPI, TIFF or PNG via `ragg`
- Slides: 13.33 × 7.5 in, 150–300 DPI
- Vector: PDF via `cairo_pdf` or SVG via `svglite`

---

## Git Conventions

- **Branch pattern**: `claude/<description>-<session-id>`
- **Commits**: Descriptive messages referencing the section of `plan.md` changed
- **Remote**: `origin` at `http://local_proxy@127.0.0.1:50394/git/Alex-Zeo/R`
- **Push**: Always use `git push -u origin <branch-name>`

---

## How to Use This Skill as an AI Agent

When a user asks for an R visualization:

1. Identify the **analytical goal** using the plot selection tables in Section 3.
2. Load only the **minimum required libraries** from the stack in Section 2.
3. Write a **fully self-contained script** with data prep, plot layers, and `ggsave()`.
4. Apply a **colorblind-safe palette** (viridis, Okabe-Ito, or ggsci) by default.
5. Set the **title** to describe the insight, not the chart type.
6. Use **explicit export dimensions** appropriate to the target (journal / slide / web).
7. Run through the **quality checklist** (Section 11) before delivering.
8. Note any **limitations** from Section 13 if the user asks for something out of scope.

---

## Limitations of This Skill

- Does not generate interactive widgets (no `plotly`, no Shiny)
- Does not execute R code — produces complete scripts for the user to run
- Does not access user data directly — works with described data or built-in datasets
- Cannot guarantee exact rendering across different fonts, devices, or R versions
