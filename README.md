# r-high-fidelity-viz

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![MCP Skill](https://img.shields.io/badge/MCP-skill-blue)](skill.json)

An AI skill that generates **publication-quality R visualizations** using ggplot2 and the
tidyverse ecosystem. Load it as context whenever you want polished, reproducible R charts
ready for journals, slides, or dashboards.

---

## Quick Start

### In Claude Code

```bash
# Load the skill for an R visualization session
claude --skill ./plan.md "Plot highway MPG vs engine displacement colored by vehicle class"
```

### As MCP Context

Point your MCP host at `skill.json` in this repository. The host will automatically
activate the skill when the user's prompt matches any trigger phrase (see below).

### Manual use

Copy the contents of `plan.md` into your system prompt or context window before asking
for an R visualization.

---

## Trigger Keywords

This skill activates on prompts containing any of:

`R chart` · `ggplot` · `visualization` · `R plot` · `data viz` · `scatter plot` ·
`bar chart` · `boxplot` · `heatmap` · `forest plot` · `survival curve` ·
`time series` · `histogram` · `violin` · `raincloud` · `ggplot2`

---

## What This Skill Produces

Given a description of your data and analytical goal, the skill returns a **complete,
self-contained R script** that:

- Loads only the required libraries from the vetted package stack
- Prepares data using tidy patterns
- Builds a polished ggplot2 visualization
- Applies a colorblind-safe palette by default
- Exports at publication-grade resolution with `ggsave()`

Every generated script passes a 26-point quality checklist before delivery.

---

## Capability Overview

| Skill section | What it covers |
|---|---|
| [Plot Selection Guide](plan.md#3--plot-selection-guide) | Match your analytical goal to the right geom |
| [Color System](plan.md#4--color-system) | Colorblind-safe palettes, `scale_*` reference |
| [Theme & Typography](plan.md#5--theme--typography-system) | `theme_pub()`, pre-built themes, rich text |
| [Annotations](plan.md#6--annotation-best-practices) | Labels, reference lines, stat annotations |
| [Multi-Panel](plan.md#8--multi-panel-composition-patchwork) | `patchwork` layouts, legend collection |
| [Export](plan.md#9--export-settings) | Journal presets for Nature, Science, PLOS, JAMA |
| [Data Ingestion](plan.md#14--data-ingestion-patterns) | CSV, Excel, database, API, tidy reshape |
| [Tables](plan.md#15--publication-tables) | `gt`, `flextable`, `gtsummary` |
| [Advanced Charts](plan.md#16--advanced-chart-types) | Survival, network, map, alluvial, waffle |
| [Troubleshooting](plan.md#12--edge-cases--troubleshooting) | 18 common failure modes with fixes |

---

## Example Prompts & Outputs

### Scatter with regression

**Prompt:**
> "Plot highway MPG vs engine displacement, colored by vehicle class, with a regression
> line and outlier labels."

**Output:** `examples/01_scatter_regression.R` — uses `ggplot2`, `ggrepel`, `ggsci`;
exports 180 × 130 mm PNG at 300 DPI.

---

### Raincloud distributions

**Prompt:**
> "Raincloud plot of penguin body mass by species with pairwise Wilcoxon tests."

**Output:** `examples/02_raincloud_distributions.R` — uses `ggrain`, `ggpubr`;
Okabe-Ito colorblind-safe palette; exports 170 × 140 mm PNG.

---

### Multi-panel composite

**Prompt:**
> "Three-panel composite figure from palmerpenguins: scatter, ridge density, and bar chart."

**Output:** `examples/05_multipanel_composite.R` — uses `patchwork`, `ggridges`;
panel tags A/B/C; exports 220 × 180 mm PNG.

---

## Package Prerequisites

Install the full stack before running any generated script:

```r
install.packages(c(
  # Core
  "tidyverse", "scales",
  # Layout & labels
  "patchwork", "ggrepel", "ggtext",
  # Color
  "viridis", "RColorBrewer", "ggsci", "colorspace",
  # Themes
  "hrbrthemes", "ggpubr", "ggthemes",
  # Statistical viz
  "ggstatsplot", "ggcorrplot", "survminer", "broom", "ggeffects",
  # Extensions
  "ggridges", "ggbeeswarm", "ggrain", "gghighlight", "ggforce",
  "gganimate", "ggdist", "treemapify", "waffle", "ggalluvial",
  "ggraph", "tidygraph",
  # Data
  "palmerpenguins", "gapminder", "readxl", "DBI", "httr2", "jsonlite",
  "lubridate", "sf", "rnaturalearth", "rnaturalearthdata",
  # Tables
  "gt", "flextable", "gtsummary",
  # Export
  "ragg", "svglite", "sessioninfo"
))
```

---

## Standalone Examples

Ready-to-run R scripts are in the [`examples/`](examples/) directory:

| File | Chart type | Dataset |
|---|---|---|
| `01_scatter_regression.R` | Scatter + regression | `ggplot2::mpg` |
| `02_raincloud_distributions.R` | Raincloud + stats | `palmerpenguins` |
| `03_timeseries_highlight.R` | Time series + highlight | `gapminder` |
| `04_forest_plot.R` | Forest plot | `datasets::mtcars` |
| `05_multipanel_composite.R` | Multi-panel (patchwork) | `palmerpenguins` |
| `06_correlation_heatmap.R` | Correlation heatmap | `palmerpenguins` |

---

## Quality Guarantee

Every script generated by this skill is verified against the 26-point checklist in
[Section 11](plan.md#11--quality-checklist), covering:

- Insight-driven title + units in axis labels
- Colorblind-safe palette with greyscale pass
- Explicit export dimensions and DPI
- No chartjunk, no 3D effects
- Fully self-contained (no `setwd()`, no `install.packages()`)

---

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add new chart types, fix R syntax,
or expand the troubleshooting section.

All changes should target `plan.md` — there is no build step, test runner, or
compilation. Run `tests/checklist_auto.R` against any new code example before submitting.

---

## Limitations

- Does not generate interactive widgets (`plotly`, Shiny)
- Does not execute R code — produces complete scripts for the user to run
- Does not access user data directly — works with described data or built-in datasets

See [Section 13](plan.md#13--what-this-skill-cannot-do) for the full list.

---

## License

[MIT](LICENSE) © 2026 Alex-Zeo
