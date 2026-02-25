---
name: r-high-fidelity-viz
description: >
  Generate publication-quality R visualizations using ggplot2 and the tidyverse ecosystem.
  Use when the user asks for charts, plots, statistical figures, data visualizations, or
  exploratory graphics in R. Covers all major chart types, statistical plots, and
  multi-panel compositions with polished typography, color, and export settings.
---

# High-Fidelity R Visualization Skill

Generate publication-quality, reproducible R visualizations using ggplot2 and the
broader tidyverse/extension ecosystem. Every plot must be complete, polished, and
ready for journals, slides, or dashboards with zero additional tweaking.

---

## 1 · Core Philosophy

- **Grammar of Graphics first.** Build every plot as data → aesthetic mapping → geometry → scale → facet → coordinate → theme layers.
- **Minimal but precise.** Never add chartjunk. Every ink mark should encode data or aid comparison (Tufte, Cleveland).
- **Accessible by default.** Use colorblind-safe palettes, sufficient contrast, and clear labeling.
- **Reproducible.** Every code block must be fully self-contained: library loads, data prep, plot, and export in one script.

---

## 2 · Standard Library Stack

Always load the minimal set needed. Prefer these vetted packages:

```r
# ── Core ──────────────────────────────────────────
library(tidyverse)        # ggplot2, dplyr, tidyr, readr, stringr, forcats, purrr, tibble
library(scales)           # Formatting axes (comma, percent, dollar, scientific)

# ── Layout & Composition ─────────────────────────
library(patchwork)        # Multi-panel composition  (preferred over cowplot/gridExtra)

# ── Labels & Annotations ─────────────────────────
library(ggrepel)          # Non-overlapping text/label geoms
library(ggtext)           # Rich-text (Markdown/HTML) in titles, labels, annotations

# ── Color ─────────────────────────────────────────
library(viridis)          # Perceptually uniform, colorblind-safe sequential palettes
library(RColorBrewer)     # Diverging & qualitative palettes
library(ggsci)            # Journal-inspired palettes (NPG, AAAS, Lancet, NEJM, JAMA)
library(colorspace)       # HCL-based palette construction & assessment

# ── Themes & Typography ──────────────────────────
library(hrbrthemes)       # Opinionated publication themes (theme_ipsum, theme_modern_rc)
library(ggpubr)           # Publication-ready helpers + stat comparisons (theme_pubr)
library(ggthemes)         # Extra themes (theme_tufte, theme_economist, theme_few, etc.)

# ── Statistical Visualization ────────────────────
library(ggstatsplot)      # Stats-embedded plots (violin, scatter, bar, coef, etc.)
library(ggcorrplot)       # Correlation matrices
library(survminer)        # Kaplan-Meier & Cox diagnostics
library(broom)            # Tidy model output for forest/coefficient plots
library(ggeffects)        # Marginal effects / predicted values plots

# ── Specialty Geoms & Extensions ─────────────────
library(ggridges)         # Ridgeline / joy plots
library(ggbeeswarm)       # Beeswarm (no overplotting) strip plots
library(ggrain)           # Raincloud plots
library(gghighlight)      # Highlight subsets
library(ggforce)          # Sina plots, ellipses, facet_zoom, mark geoms
library(gganimate)        # Animation (gif / video)
library(ggdist)           # Distributional geoms (stat_halfeye, stat_dotsinterval)
library(treemapify)       # Treemap geoms for ggplot2
library(waffle)           # Waffle/isotype charts
library(ggalluvial)       # Alluvial / Sankey diagrams
library(ggraph)           # Network & tree layouts (with tidygraph)

# ── Fonts ────────────────────────────────────────
library(systemfonts)      # Font discovery & registration (used by ragg)
library(showtext)         # Google Fonts & custom font embedding in any device
library(sysfonts)         # Font loading helper (bundled with showtext)

# ── Export ────────────────────────────────────────
library(ragg)             # High-quality AGG raster device (PNG, TIFF)
library(svglite)          # Lightweight SVG output
```

Only load what the specific plot requires. Comment out unused libraries.

---

## 3 · Plot Selection Guide

Match the user's analytical goal to the best geometry. Always think:
**What relationship am I showing?**

### 3.1 Distribution (single variable)
| Goal | Geom / Function | Notes |
|---|---|---|
| Shape of distribution | `geom_histogram`, `geom_density` | Set meaningful `binwidth`; overlay `geom_rug` for small n |
| Compare distributions | `geom_density` + `fill` + `alpha`, `ggridges::geom_density_ridges` | Ridgelines excel for >3 groups |
| Distribution + raw data | `ggdist::stat_halfeye`, `ggrain::geom_rain` | Raincloud = box + violin + jitter |
| Counts of categories | `geom_bar(stat="count")` | Reorder with `forcats::fct_infreq` |

### 3.2 Relationship (two variables)
| Goal | Geom / Function | Notes |
|---|---|---|
| Correlation / trend | `geom_point` + `geom_smooth` | Default loess; add `method="lm"` for linear |
| Labeled scatter | `geom_point` + `ggrepel::geom_text_repel` | Label outliers or key points only |
| 2D density / overplotting | `geom_hex`, `geom_bin2d`, `stat_density_2d` | Use when n > ~1000 |
| Bubble chart | `geom_point(aes(size=...))` | Add `scale_size_area()` for truthful area |
| Slope / paired change | `geom_segment` or `newggslopegraph` | Great for before/after |

### 3.3 Comparison (groups)
| Goal | Geom / Function | Notes |
|---|---|---|
| Central tendency + spread | `geom_boxplot`, `geom_violin` | Prefer violin + jitter or beeswarm |
| Mean ± CI | `stat_summary(fun.data=mean_cl_normal)` | Or `ggstatsplot::ggbetweenstats` |
| Statistical tests overlaid | `ggstatsplot::ggbetweenstats` / `ggwithinstats` | Embeds p-values, effect sizes |
| Bar + error bars | `geom_col` + `geom_errorbar` | Avoid dynamite plots when possible |

### 3.4 Time Series & Change
| Goal | Geom / Function | Notes |
|---|---|---|
| Trend over time | `geom_line` | Group correctly; consider `geom_ribbon` for CI |
| Highlighted subset | `geom_line` + `gghighlight::gghighlight()` | Grays out non-highlighted |
| Area / stacked | `geom_area(position="stack")` | Use proportional (`position="fill"`) for shares |
| Animated change | `gganimate::transition_time()` | Export with `anim_save()` |

### 3.5 Composition & Part-to-Whole
| Goal | Geom / Function | Notes |
|---|---|---|
| Proportions | `geom_col(position="fill")` + `coord_flip()` | Stacked bars > pie charts |
| Waffle / isotype | `waffle::waffle()` | Good for counts out of 100 |
| Treemap | `treemapify::geom_treemap()` | Hierarchical proportions |
| Alluvial / flow | `ggalluvial::geom_alluvium` | Categorical flows across stages |

### 3.6 Statistical & Model Visualization
| Goal | Geom / Function | Notes |
|---|---|---|
| Regression coefficients | `ggstatsplot::ggcoefstats`, `broom::tidy` + `geom_pointrange` | Forest / dot-whisker plots |
| Marginal effects | `ggeffects::ggpredict` + `plot()` | Or manual with `geom_ribbon` |
| Correlation matrix | `ggcorrplot::ggcorrplot(method="circle")` | Reorder with `hclust` |
| Survival curves | `survminer::ggsurvplot` | Includes risk table + p-value |
| Diagnostics (residuals) | `ggfortify::autoplot(lm_model)` | Or build manually with `broom::augment` |
| PCA / ordination | `ggfortify::autoplot(prcomp(...))` | Color by group, add ellipses |
| Meta-analysis forest | `metafor` + `forest()` or custom `geom_pointrange` | |

### 3.7 Spatial & Network
| Goal | Geom / Function | Notes |
|---|---|---|
| Choropleth map | `geom_sf` + `sf` package | Use `viridis` or `distiller` scales |
| Network graph | `ggraph::ggraph` + `tidygraph` | Choose layout: `"fr"`, `"kk"`, `"tree"` |

---

## 4 · Color System

### 4.1 Principles
1. **Colorblind-safe by default.** Start with `viridis`, `cividis`, or Okabe-Ito.
2. **Sequential** for ordered/continuous data → `scale_*_viridis_c()`.
3. **Diverging** for deviation from center → `scale_*_distiller(palette="RdBu")` or `colorspace::scale_*_continuous_diverging("Blue-Red 3")`.
4. **Qualitative** for unordered categories → `ggsci::scale_*_npg()`, `scale_*_brewer(palette="Set2")`, or Okabe-Ito.
5. Never use rainbow. Never rely on color alone — pair with shape or linetype.

### 4.2 Quick Reference

```r
# ── Continuous / sequential ───────────────
+ scale_fill_viridis_c(option = "D")           # viridis (default)
+ scale_color_viridis_c(option = "C")          # inferno
+ scale_fill_distiller(palette = "YlGnBu", direction = 1)

# ── Diverging ─────────────────────────────
+ scale_fill_distiller(palette = "RdBu", direction = 1)
+ scale_fill_gradient2(low = "#2166AC", mid = "white", high = "#B2182B", midpoint = 0)

# ── Discrete / qualitative ────────────────
+ scale_color_brewer(palette = "Set2")
+ ggsci::scale_color_npg()                      # Nature Publishing Group
+ ggsci::scale_color_aaas()                     # Science / AAAS
+ ggsci::scale_color_lancet()                   # Lancet journals
+ ggsci::scale_fill_jama()                      # JAMA
+ scale_color_manual(values = c(                # Okabe-Ito (manual)
    "#E69F00", "#56B4E9", "#009E73",
    "#F0E442", "#0072B2", "#D55E00",
    "#CC79A7", "#000000"))

# ── Colorblind simulation check ───────────
colorspace::swatchplot(colorspace::desaturate(my_palette))
```

### 4.3 Redundant Encoding (Shape & Linetype)

Never rely on color alone — always double-encode with shape or linetype.
This ensures figures remain interpretable when printed in greyscale or
viewed by readers with color vision deficiency.

```r
# ── Color + Shape (scatter plots) ─────────────────────────────
ggplot(d, aes(x, y, color = group, shape = group)) +
  geom_point(size = 2.5) +
  scale_color_manual(values = okabe_ito) +
  scale_shape_manual(values = c(16, 17, 15, 18, 8))
  # 16 = filled circle, 17 = filled triangle, 15 = filled square,
  # 18 = filled diamond, 8 = asterisk

# ── Color + Linetype (line plots) ─────────────────────────────
ggplot(d, aes(x, y, color = group, linetype = group)) +
  geom_line(linewidth = 0.9) +
  scale_color_manual(values = okabe_ito) +
  scale_linetype_manual(values = c("solid", "dashed", "dotdash", "twodash", "longdash"))

# ── Color + Fill pattern (bars — requires ggpattern) ──────────
# install.packages("ggpattern")
library(ggpattern)
ggplot(d, aes(x, y, fill = group, pattern = group)) +
  geom_col_pattern(pattern_density = 0.35, pattern_colour = "grey30") +
  scale_fill_manual(values = okabe_ito) +
  scale_pattern_manual(values = c("none", "stripe", "crosshatch", "dot"))

# ── Greyscale test: convert palette and re-check ──────────────
grey_palette <- colorspace::desaturate(okabe_ito)
# Visually verify bars/lines remain distinguishable after desaturation
```

**Shape selection guide:**

| Shape code | Name | Use when |
|---|---|---|
| 16 | Filled circle | Primary group (most legible) |
| 17 | Filled triangle up | Second group |
| 15 | Filled square | Third group |
| 18 | Filled diamond | Fourth group |
| 8 | Asterisk | Outliers or "other" |
| 1 | Open circle | Overlapping data (alpha less effective) |
| 2 | Open triangle | High-density scatter with open shapes |

**Rule:** When a figure appears in a journal that may be printed in black and white,
always test the greyscale version before submitting.

---

## 5 · Theme & Typography System

### 5.1 Base Theme Construction

Start from a clean foundation, then customize:

```r
theme_pub <- function(base_size = 12, base_family = "Helvetica") {
  theme_minimal(base_size = base_size, base_family = base_family) %+replace%
    theme(
      # ── Text hierarchy ────────────────────
      plot.title          = element_text(size = rel(1.3), face = "bold", hjust = 0,
                                         margin = margin(b = 8)),
      plot.subtitle       = element_text(size = rel(1.0), color = "grey40", hjust = 0,
                                         margin = margin(b = 12)),
      plot.caption        = element_text(size = rel(0.75), color = "grey50", hjust = 1,
                                         margin = margin(t = 10)),
      # ── Axes ──────────────────────────────
      axis.title          = element_text(size = rel(0.9), face = "bold"),
      axis.text           = element_text(size = rel(0.8), color = "grey30"),
      axis.ticks          = element_line(color = "grey70", linewidth = 0.3),
      axis.line           = element_line(color = "grey40", linewidth = 0.4),
      # ── Grid ──────────────────────────────
      panel.grid.major    = element_line(color = "grey92", linewidth = 0.3),
      panel.grid.minor    = element_blank(),
      panel.background    = element_rect(fill = "white", color = NA),
      plot.background     = element_rect(fill = "white", color = NA),
      # ── Legend ────────────────────────────
      legend.title        = element_text(size = rel(0.85), face = "bold"),
      legend.text         = element_text(size = rel(0.8)),
      legend.position     = "bottom",
      legend.key          = element_rect(fill = "white", color = NA),
      legend.background   = element_rect(fill = "white", color = NA),
      # ── Strip (facets) ───────────────────
      strip.text          = element_text(size = rel(0.9), face = "bold", color = "grey20"),
      strip.background    = element_rect(fill = "grey95", color = NA),
      # ── Margins ──────────────────────────
      plot.margin         = margin(15, 15, 15, 15)
    )
}
```

### 5.2 Pre-Built Theme Recommendations

| Context | Theme | Package |
|---|---|---|
| General publication | `theme_pubr()` | ggpubr |
| Clean typographic | `theme_ipsum()` | hrbrthemes |
| Tufte-style minimal | `theme_tufte()` | ggthemes |
| Dark slides/presentations | `theme_modern_rc()` | hrbrthemes |
| FiveThirtyEight style | `theme_fivethirtyeight()` | ggthemes |
| Economist style | `theme_economist()` | ggthemes |
| Custom (above) | `theme_pub()` | (this skill) |

### 5.3 Font Management

Fonts are the #1 source of cross-platform rendering failures. Follow this strategy:

```r
# ── Strategy A: Use ragg (recommended) ───────────────────────
# ragg uses systemfonts to find installed fonts automatically.
# If the font is installed on the OS, ragg will find it.
ggsave("plot.png", p, device = ragg::agg_png,
       width = 180, height = 120, units = "mm", dpi = 300)

# ── Strategy B: Google Fonts via showtext ────────────────────
# Use when you need a specific font not installed on the system.
library(showtext)
font_add_google("Source Sans Pro", "source-sans")
font_add_google("Fira Code", "fira-code")        # monospace for annotations
showtext_auto()  # Enable showtext rendering for all devices

# Then use the family name in your theme:
theme_pub(base_family = "source-sans")

# ── Strategy C: Local font files ─────────────────────────────
# Register a .ttf / .otf file directly:
sysfonts::font_add("custom-font",
  regular    = "path/to/Font-Regular.ttf",
  bold       = "path/to/Font-Bold.ttf",
  italic     = "path/to/Font-Italic.ttf",
  bolditalic = "path/to/Font-BoldItalic.ttf"
)
showtext_auto()
```

**Font fallback priority** (choose the first available):

| Context | First choice | Fallback 1 | Fallback 2 |
|---|---|---|---|
| General publication | Source Sans Pro | Helvetica Neue | Arial |
| Slides / posters | Lato, Inter | Helvetica | sans |
| Monospace (code/annotations) | Fira Code | JetBrains Mono | Courier New |
| Serif (some journals) | Source Serif Pro | Palatino | Times New Roman |

**Cross-platform notes:**
- **macOS**: Helvetica Neue is always available. Use it as a safe default.
- **Linux**: Install `fonts-liberation` or `fonts-open-sans` for reliable sans-serif.
- **Windows**: Arial and Calibri are always available. Avoid assuming Helvetica exists.
- **Docker/CI**: Include `font_add_google()` in scripts to self-provision fonts.
- **PDF output**: Use `cairo_pdf` device — it embeds fonts automatically. Or call `extrafont::embed_fonts()` after saving.

### 5.4 Typography Rules

- **Title**: 14–18 pt, bold. Describe the finding, not the chart type.
  - Good: *"Fuel efficiency drops sharply above 4L engine displacement"*
  - Bad: *"Scatter plot of MPG vs Displacement"*
- **Subtitle**: 10–12 pt, regular, grey. Provide methodological context.
- **Caption**: 8–10 pt, right-aligned. Data source and notes.
- **Axis labels**: Sentence case, include units: `"Body mass (g)"`, `"Price (USD, thousands)"`.
- **Legend**: Bottom or right. Title in bold. Remove if redundant with axis.
- **Rotate long x-labels** at 45° with `hjust = 1`, or use `coord_flip()`.

### 5.5 Rich Text with ggtext

`ggtext` enables Markdown/HTML in any text element, eliminating the need for
separate legends when color is used in the title or labels.

```r
library(ggtext)

# ── Color-coded title (replaces legend) ──────────────────────
p + labs(
    title = "**<span style='color:#E69F00'>Adelie</span>** penguins are lighter than
             **<span style='color:#009E73'>Gentoo</span>**"
  ) +
  theme(plot.title = element_markdown(size = 14))

# ── Rich subtitle with italic and bold ───────────────────────
p + labs(
    subtitle = "Data: *palmerpenguins* | Method: **Wilcoxon rank-sum test**"
  ) +
  theme(plot.subtitle = element_markdown())

# ── Markdown in axis labels ──────────────────────────────────
p + labs(
    y = "Concentration (μg·L<sup>−1</sup>)"
  ) +
  theme(axis.title.y = element_markdown())

# ── Rich-text annotations inside the plot ────────────────────
p + geom_richtext(
    aes(x = 3, y = 40, label = "**R² = 0.87**<br><i>p</i> < 0.001"),
    fill = "white", label.color = NA, size = 3.5
  )

# ── Apply element_markdown to multiple elements at once ──────
p + theme(
    plot.title    = element_markdown(size = 14, face = "bold"),
    plot.subtitle = element_markdown(size = 10, color = "grey40"),
    axis.title.x  = element_markdown(),
    axis.title.y  = element_markdown()
  )
```

**When to use ggtext:**
- Title contains color references matching data groups → color-code the words
- Axis labels need superscript/subscript (units, chemical formulas)
- You want to eliminate a legend by embedding color meaning in the title
- Statistical results need mixed bold/italic formatting

### 5.4 Font Management

Fonts are the #1 source of "looks different on my machine" failures. Follow this strategy:

```r
# ── Strategy A: Use ragg (recommended for PNG/TIFF) ─────────
# ragg uses systemfonts for discovery — most system fonts just work.
library(ragg)
library(systemfonts)

# Check available fonts:
system_fonts() %>% filter(grepl("Helvetica|Arial|Roboto", family))

# Register a font variant explicitly:
systemfonts::register_font(
  name   = "Roboto Condensed",
  plain  = "/path/to/RobotoCondensed-Regular.ttf",
  bold   = "/path/to/RobotoCondensed-Bold.ttf",
  italic = "/path/to/RobotoCondensed-Italic.ttf"
)

# ── Strategy B: Use showtext (Google Fonts, any device) ─────
library(showtext)
library(sysfonts)

# Add a Google Font:
sysfonts::font_add_google("Source Sans Pro", "source-sans")
sysfonts::font_add_google("Fira Sans", "fira")

# Enable showtext rendering (call BEFORE plotting):
showtext_auto()

# Then use in theme:
theme_pub(base_family = "source-sans")

# ── Strategy C: Safe cross-platform fallback stack ──────────
# If you cannot guarantee font availability, use this order:
safe_family <- if (nrow(systemfonts::system_fonts() %>%
    filter(family == "Helvetica Neue")) > 0) {
  "Helvetica Neue"
} else if (nrow(systemfonts::system_fonts() %>%
    filter(family == "Arial")) > 0) {
  "Arial"
} else {
  "sans"
}
```

**Rules:**
- For **raster output** (PNG, TIFF): Use `ragg` device — it handles system fonts natively.
- For **PDF**: Use `cairo_pdf` or embed fonts with `extrafont::embed_fonts()`.
- For **SVG**: Use `svglite` — it references fonts by name; ensure viewer has the font.
- **Never hard-code a font path.** Use `systemfonts` discovery or `showtext` registration.
- **Test font rendering** by exporting a small test plot before generating final figures.

### 5.5 Rich Text with `ggtext`

`ggtext` enables Markdown and HTML in plot text, eliminating the need for separate legends when color alone distinguishes groups:

```r
library(ggtext)

# ── Color-coded title (replaces legend) ─────────────────────
labs(
  title = "**<span style='color:#E69F00'>Adelie</span>** penguins are lighter than
           **<span style='color:#009E73'>Gentoo</span>**"
) +
theme(plot.title = ggtext::element_markdown(size = 14))

# ── Styled axis labels ─────────────────────────────────────
scale_x_discrete(
  labels = c(
    "control" = "**Control**<br><span style='font-size:8pt;color:grey50'>n = 45</span>",
    "treatment" = "**Treatment**<br><span style='font-size:8pt;color:grey50'>n = 52</span>"
  )
) +
theme(axis.text.x = ggtext::element_markdown(halign = 0.5))

# ── Rich-text annotations in the plot area ──────────────────
+ ggtext::geom_richtext(
    aes(x = 3, y = 40, label = "R<sup>2</sup> = 0.87<br><i>p</i> < 0.001"),
    fill = "white", label.color = NA, size = 3.5
  )

# ── Multi-line subtitle with mixed formatting ───────────────
labs(subtitle = "Data: *palmerpenguins* | Method: Wilcoxon rank-sum test") +
theme(plot.subtitle = ggtext::element_markdown(color = "grey40"))
```

**When to use `ggtext`:**
- Title encodes group colors → use `element_markdown()` and drop the legend
- Axis labels need sub-annotations (sample sizes, units) → `element_markdown()`
- Annotations need superscripts, subscripts, or italic stat notation → `geom_richtext()`
- Caption needs italic dataset names or links → `element_markdown()`

### 5.6 White Space & Micro-Layout Control

White space is active design. Precise margin and spacing control prevents cramped
or unbalanced figures, especially critical at small journal column widths.

```r
# ── Plot margins (t, r, b, l — like CSS) ────────────────────
theme(plot.margin = margin(t = 10, r = 15, b = 10, l = 10, unit = "pt"))

# ── Panel spacing in facets ──────────────────────────────────
theme(
  panel.spacing     = unit(8, "pt"),   # uniform horizontal + vertical
  panel.spacing.x   = unit(10, "pt"),  # override horizontal only
  panel.spacing.y   = unit(6,  "pt")   # override vertical only
)

# ── Title/subtitle/caption spacing ──────────────────────────
theme(
  plot.title.position  = "plot",        # align title to full plot, not panel
  plot.caption.position = "plot",
  plot.title    = element_text(margin = margin(b = 6, unit = "pt")),
  plot.subtitle = element_text(margin = margin(b = 12, unit = "pt")),
  plot.caption  = element_text(margin = margin(t = 8,  unit = "pt"))
)

# ── Axis label spacing ───────────────────────────────────────
theme(
  axis.title.x = element_text(margin = margin(t = 8, unit = "pt")),
  axis.title.y = element_text(margin = margin(r = 8, unit = "pt")),
  axis.text.x  = element_text(margin = margin(t = 4, unit = "pt")),
  axis.text.y  = element_text(margin = margin(r = 4, unit = "pt"))
)

# ── Legend spacing ──────────────────────────────────────────
theme(
  legend.margin       = margin(0, 0, 0, 0),
  legend.box.spacing  = unit(6, "pt"),
  legend.key.size     = unit(10, "pt"),
  legend.key.spacing  = unit(4, "pt"),
  legend.spacing.x    = unit(4, "pt"),
  legend.spacing.y    = unit(2, "pt")
)

# ── Strip label spacing (facets) ────────────────────────────
theme(
  strip.text = element_text(margin = margin(t = 4, b = 4, l = 6, r = 6, unit = "pt"))
)

# ── Override theme_pub() for a compact journal panel ────────
theme_pub_compact <- function(...) {
  theme_pub(...) %+replace%
    theme(
      plot.margin         = margin(5, 8, 5, 8, unit = "pt"),
      panel.spacing       = unit(4, "pt"),
      legend.key.size     = unit(8, "pt"),
      legend.margin       = margin(0, 0, 0, 0),
      axis.title.x        = element_text(margin = margin(t = 5, unit = "pt")),
      axis.title.y        = element_text(margin = margin(r = 5, unit = "pt"))
    )
}
```

**Spacing rules of thumb:**
- Journal figure (85 mm): use `plot.margin = margin(4, 6, 4, 6, "pt")` — every mm counts.
- Slide figure (13 in): use `plot.margin = margin(10, 15, 10, 15, "pt")` for breathing room.
- Multi-panel with `patchwork`: set `panel.spacing` in the `&` theme block, not per-panel.
- Always set `plot.title.position = "plot"` to align title flush with the full figure width.

---

## 6 · Annotation Best Practices

Annotations transform plots from exploratory to explanatory.

```r
# ── Direct labeling (replaces legends) ─────────────────────
+ ggrepel::geom_text_repel(
    data = subset(df, is_outlier),
    aes(label = name),
    size = 3, color = "grey30",
    box.padding = 0.5, max.overlaps = 15,
    segment.color = "grey60", segment.size = 0.3
  )

# ── Reference lines ────────────────────────────────────────
+ geom_hline(yintercept = mean_val, linetype = "dashed", color = "grey50", linewidth = 0.5)
+ annotate("text", x = x_pos, y = mean_val, label = paste("Mean =", round(mean_val, 1)),
           hjust = 0, vjust = -0.5, size = 3.2, color = "grey40")

# ── Highlight a region ─────────────────────────────────────
+ annotate("rect", xmin = as.Date("2020-03-01"), xmax = as.Date("2020-06-01"),
           ymin = -Inf, ymax = Inf, alpha = 0.15, fill = "#D55E00")
+ annotate("text", x = as.Date("2020-04-15"), y = Inf, label = "COVID-19\nlockdown",
           vjust = 1.5, size = 3, fontface = "italic", color = "#D55E00")

# ── Statistical annotations (p-values, brackets) ──────────
+ ggpubr::stat_compare_means(method = "wilcox.test",
    comparisons = list(c("A", "B"), c("B", "C")),
    label = "p.signif")

# ── Rich-text annotation box (ggtext) ─────────────────────
+ ggtext::geom_richtext(
    aes(x = x_pos, y = y_pos,
        label = "**r** = 0.92<br><i>p</i> < 0.001<br>*n* = 342"),
    fill = "grey98", label.color = "grey80",
    label.padding = unit(c(4, 6, 4, 6), "pt"),
    size = 3.2, hjust = 0
  )
```

---

## 7 · Scale & Axis Formatting

```r
# ── Comma-separated thousands ──────────────────────────────
+ scale_y_continuous(labels = scales::comma)

# ── Dollar formatting ──────────────────────────────────────
+ scale_y_continuous(labels = scales::dollar)

# ── Percent ────────────────────────────────────────────────
+ scale_y_continuous(labels = scales::percent_format(accuracy = 1))

# ── Log scale with clean breaks ────────────────────────────
+ scale_x_log10(labels = scales::comma, breaks = scales::log_breaks(n = 6))

# ── Date axis ──────────────────────────────────────────────
+ scale_x_date(date_labels = "%b %Y", date_breaks = "3 months")

# ── Zoom without removing data (preserves smoothers) ──────
+ coord_cartesian(ylim = c(0, 50))   # NOT ylim(0, 50)

# ── Reverse axis ──────────────────────────────────────────
+ scale_y_reverse()

# ── Reorder discrete axis by value ─────────────────────────
aes(x = reorder(category, value), y = value)
# or with forcats:
aes(x = fct_reorder(category, value), y = value)
```

---

## 8 · Multi-Panel Composition (patchwork)

```r
library(patchwork)

# ── Basic combination ──────────────────────────────────────
(p1 | p2) / p3                    # p1 and p2 side by side, p3 below

# ── With annotation and tag ────────────────────────────────
(p1 | p2) / p3 +
  plot_annotation(
    title    = "Main title for composite figure",
    subtitle = "Supporting context",
    caption  = "Source: Dataset Name",
    tag_levels = "A"               # Auto-labels: A, B, C
  ) &
  theme_pub()                      # Apply theme to ALL panels

# ── Control relative sizes ─────────────────────────────────
(p1 | p2) + plot_layout(widths = c(2, 1))

# ── Collect legends across panels ──────────────────────────
(p1 + p2 + p3) + plot_layout(guides = "collect") & theme(legend.position = "bottom")

# ── Inset plot ─────────────────────────────────────────────
p1 + inset_element(p_small, left = 0.6, bottom = 0.6, right = 1, top = 1)
```

### 8.2 Small Multiples Decision Tree

Use this guide to choose between faceting strategies:

```
Is the number of groups ≤ 6?
├── Yes → facet_wrap() with free scales if ranges differ
└── No  → Is there a meaningful 2-variable crossing?
           ├── Yes → facet_grid(rows ~ cols)
           └── No  → Consider lumping small groups with fct_lump_n(),
                      then facet_wrap(), or use a single plot with gghighlight()
```

```r
# ── facet_wrap: 1D wrapping ──────────────────────────────────
+ facet_wrap(~ continent, ncol = 3, scales = "free_y")
# "free_y" when y-ranges differ greatly; "fixed" for direct comparison

# ── facet_grid: 2D crossing ─────────────────────────────────
+ facet_grid(sex ~ species, scales = "free", space = "free_x")
# space = "free_x" adjusts panel widths to data range

# ── Labeller: add variable name to strip ────────────────────
+ facet_wrap(~ species, labeller = label_both)
# → "species: Adelie", "species: Chinstrap", …

# ── Custom strip labels ──────────────────────────────────────
continent_labels <- c(
  Africa = "Africa (n = 624)", Europe = "Europe (n = 360)",
  Americas = "Americas (n = 300)"
)
+ facet_wrap(~ continent, labeller = labeller(continent = continent_labels))
```

### 8.3 Multi-Figure Consistency

When producing a series of figures for a paper or report, enforce shared
visual language across all panels:

```r
# ── Define shared elements once ──────────────────────────────
shared_theme <- theme_pub(base_size = 10) +
  theme(
    legend.position  = "none",
    panel.grid.minor = element_blank(),
    plot.margin      = margin(5, 8, 5, 8, "pt")
  )

shared_colors <- c(
  "Adelie"    = "#E69F00",
  "Chinstrap" = "#56B4E9",
  "Gentoo"    = "#009E73"
)

shared_color_scale <- scale_color_manual(values = shared_colors)
shared_fill_scale  <- scale_fill_manual(values = shared_colors)

# ── Apply to each figure ─────────────────────────────────────
p1 <- ggplot(d, aes(flipper_length_mm, body_mass_g, color = species)) +
  geom_point(alpha = 0.6, size = 1.8) +
  shared_color_scale + shared_theme

p2 <- ggplot(d, aes(species, bill_length_mm, fill = species)) +
  geom_violin(alpha = 0.5) +
  shared_fill_scale + shared_theme

p3 <- ggplot(d, aes(bill_depth_mm, bill_length_mm, color = species)) +
  geom_point(alpha = 0.5, size = 1.5) +
  shared_color_scale + shared_theme

# ── Combine with a shared legend ─────────────────────────────
# Re-add legend to ONE plot so patchwork can collect it:
p1_legend <- p1 + theme(legend.position = "right") +
  scale_color_manual(values = shared_colors, name = "Species")

(p1_legend | p2 | p3) +
  plot_layout(guides = "collect") +
  plot_annotation(tag_levels = "A") &
  theme(legend.position = "bottom")
```

**Consistency checklist for figure series:**
- Same `base_size` across all panels
- Identical color mapping for the same variable in every panel
- Consistent axis label capitalization and units
- Same export DPI, format, and column width
- Panel tags (A, B, C …) in the same position and font size
- Shared x-axis range when comparing distributions of the same variable

---

## 9 · Export Settings

Always export at publication-grade resolution and correct dimensions.

```r
# ── High-resolution PNG (for web, slides, Word) ───────────
ggsave("figure_01.png", plot = p, device = ragg::agg_png,
       width = 180, height = 120, units = "mm", dpi = 300)

# ── TIFF (common journal requirement) ─────────────────────
ggsave("figure_01.tiff", plot = p, device = ragg::agg_tiff,
       width = 180, height = 120, units = "mm", dpi = 600,
       compression = "lzw")

# ── PDF (vector, scalable, best for print) ────────────────
ggsave("figure_01.pdf", plot = p, device = cairo_pdf,
       width = 7, height = 4.7)    # inches for PDF

# ── SVG (web, editable in Illustrator/Inkscape) ───────────
ggsave("figure_01.svg", plot = p, device = svglite::svglite,
       width = 7, height = 4.7)

# ── CMYK PDF (some print journals) ────────────────────────
pdf("figure_01_cmyk.pdf", width = 7, height = 4.7, colormodel = "cmyk")
print(p)
dev.off()
```

### 9.1 Size Guidelines

| Target | Width | Height | DPI |
|---|---|---|---|
| Single column (journal) | 85–90 mm | 60–120 mm | 600 |
| Double column (journal) | 170–180 mm | 100–160 mm | 600 |
| Slide (16:9) | 13.33 in | 7.5 in | 150–300 |
| Poster panel | 8–12 in | 6–9 in | 300 |
| Web / README | 800–1200 px wide | — | 150 |

### 9.2 Journal-Specific Presets

Use these presets to match exact submission requirements:

```r
# ── Journal figure-size presets ──────────────────────────────
journal_presets <- list(
  nature = list(
    single = list(w = 89,  h = 89,  units = "mm", dpi = 600, format = "tiff"),
    double = list(w = 183, h = 120, units = "mm", dpi = 600, format = "tiff"),
    full   = list(w = 183, h = 247, units = "mm", dpi = 600, format = "tiff"),
    font_min = 5, font_max = 7, family = "Helvetica"
  ),
  science = list(
    single = list(w = 55,  h = 55,  units = "mm", dpi = 600, format = "pdf"),
    medium = list(w = 115, h = 115, units = "mm", dpi = 600, format = "pdf"),
    double = list(w = 174, h = 120, units = "mm", dpi = 600, format = "pdf"),
    font_min = 6, font_max = 8, family = "Helvetica"
  ),
  cell = list(
    single = list(w = 85,  h = 85,  units = "mm", dpi = 600, format = "pdf"),
    medium = list(w = 114, h = 114, units = "mm", dpi = 600, format = "pdf"),
    double = list(w = 174, h = 120, units = "mm", dpi = 600, format = "pdf"),
    font_min = 5, font_max = 7, family = "Helvetica"
  ),
  plos = list(
    single = list(w = 83,  h = 83,  units = "mm", dpi = 300, format = "tiff"),
    medium = list(w = 132, h = 132, units = "mm", dpi = 300, format = "tiff"),
    double = list(w = 173, h = 120, units = "mm", dpi = 300, format = "tiff"),
    font_min = 8, font_max = 12, family = "Arial"
  ),
  lancet = list(
    single = list(w = 89,  h = 89,  units = "mm", dpi = 300, format = "tiff"),
    double = list(w = 180, h = 120, units = "mm", dpi = 300, format = "tiff"),
    font_min = 6, font_max = 9, family = "Arial"
  ),
  jama = list(
    single = list(w = 86,  h = 86,  units = "mm", dpi = 300, format = "tiff"),
    double = list(w = 178, h = 120, units = "mm", dpi = 300, format = "tiff"),
    font_min = 8, font_max = 10, family = "Arial"
  ),
  nejm = list(
    single = list(w = 86,  h = 86,  units = "mm", dpi = 600, format = "tiff"),
    double = list(w = 178, h = 120, units = "mm", dpi = 600, format = "tiff"),
    font_min = 6, font_max = 8, family = "Arial"
  )
)

# ── Helper: save with journal preset ─────────────────────────
save_journal_fig <- function(plot, filename, journal = "nature",
                             size = "single", ...) {
  preset <- journal_presets[[journal]][[size]]
  device <- switch(preset$format,
    tiff = ragg::agg_tiff,
    png  = ragg::agg_png,
    pdf  = cairo_pdf,
    svg  = svglite::svglite
  )
  extra_args <- list(...)
  if (preset$format == "tiff") extra_args$compression <- "lzw"

  do.call(ggsave, c(list(
    filename = paste0(filename, ".", preset$format),
    plot     = plot,
    device   = device,
    width    = preset$w,
    height   = preset$h,
    units    = preset$units,
    dpi      = preset$dpi
  ), extra_args))
}

# Usage:
# save_journal_fig(p, "figure_01", journal = "nature", size = "double")
# save_journal_fig(p, "figure_02", journal = "plos",   size = "single")
```

**Quick reference — journal requirements at a glance:**

| Journal | Single col | Double col | Min DPI | Format | Font |
|---|---|---|---|---|---|
| Nature | 89 mm | 183 mm | 600 | TIFF/PDF | Helvetica, 5–7 pt |
| Science | 55 mm | 174 mm | 600 | PDF/EPS | Helvetica, 6–8 pt |
| Cell | 85 mm | 174 mm | 600 | PDF | Helvetica, 5–7 pt |
| PLOS | 83 mm | 173 mm | 300 | TIFF | Arial, 8–12 pt |
| Lancet | 89 mm | 180 mm | 300 | TIFF | Arial, 6–9 pt |
| JAMA | 86 mm | 178 mm | 300 | TIFF | Arial, 8–10 pt |
| NEJM | 86 mm | 178 mm | 600 | TIFF | Arial, 6–8 pt |

---

## 10 · Complete Worked Examples

### 10.1 Publication Scatter with Regression + Annotation

```r
library(tidyverse)
library(ggrepel)
library(ggsci)

data(mpg, package = "ggplot2")

p <- mpg %>%
  mutate(label = ifelse(hwy > 40 | displ > 6.5, paste(manufacturer, model), NA_character_)) %>%
  ggplot(aes(x = displ, y = hwy, color = class)) +
  geom_point(alpha = 0.7, size = 2.5) +
  geom_smooth(method = "lm", se = TRUE, color = "grey30", linewidth = 0.8,
              linetype = "dashed", fill = "grey85") +
  geom_text_repel(aes(label = label), size = 2.8, color = "grey25",
                  max.overlaps = 20, box.padding = 0.4,
                  segment.color = "grey60") +
  scale_color_npg() +
  scale_x_continuous(breaks = seq(1, 7, 1)) +
  labs(
    title    = "Fuel efficiency declines with engine size across vehicle classes",
    subtitle = "Highway MPG vs engine displacement (litres), EPA data 1999–2008",
    x        = "Engine displacement (L)",
    y        = "Highway fuel economy (mpg)",
    color    = "Vehicle class",
    caption  = "Source: ggplot2::mpg | Outliers labeled"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(color = "grey40"),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )

ggsave("scatter_regression.png", p, width = 180, height = 130, units = "mm", dpi = 300)
```

### 10.2 Raincloud Plot with Statistical Comparisons

```r
library(tidyverse)
library(ggrain)
library(ggpubr)
library(palmerpenguins)

p <- penguins %>%
  filter(!is.na(body_mass_g), !is.na(species)) %>%
  ggplot(aes(x = species, y = body_mass_g, fill = species, color = species)) +
  geom_rain(alpha = 0.4, rain.side = "l",
            boxplot.args = list(color = "grey30", outlier.shape = NA),
            violin.args  = list(color = NA, alpha = 0.3)) +
  stat_compare_means(comparisons = list(c("Adelie","Chinstrap"),
                                         c("Chinstrap","Gentoo"),
                                         c("Adelie","Gentoo")),
                     method = "wilcox.test", label = "p.signif",
                     step.increase = 0.08) +
  scale_fill_manual(values = c("#FF6B35", "#004E89", "#2A9D8F")) +
  scale_color_manual(values = c("#FF6B35", "#004E89", "#2A9D8F")) +
  labs(
    title    = "Gentoo penguins are significantly heavier than other species",
    subtitle = "Body mass distributions with pairwise Wilcoxon tests",
    x = NULL, y = "Body mass (g)",
    caption  = "Data: palmerpenguins | *** p < 0.001, ** p < 0.01, * p < 0.05, ns = not significant"
  ) +
  theme_pubr(base_size = 12) +
  theme(legend.position = "none")

ggsave("raincloud_penguins.png", p, width = 170, height = 140, units = "mm", dpi = 300)
```

### 10.3 Faceted Time Series with Highlight

```r
library(tidyverse)
library(gghighlight)
library(gapminder)

p <- gapminder %>%
  filter(continent == "Asia") %>%
  ggplot(aes(x = year, y = lifeExp, group = country, color = country)) +
  geom_line(linewidth = 0.6) +
  gghighlight(max(lifeExp) > 78 | min(lifeExp) < 35,
              use_direct_label = TRUE, label_key = country,
              unhighlighted_params = list(linewidth = 0.3, alpha = 0.4)) +
  scale_x_continuous(breaks = seq(1952, 2007, 10)) +
  scale_y_continuous(limits = c(25, 85)) +
  labs(
    title    = "Life expectancy trajectories in Asia, 1952–2007",
    subtitle = "Highlighted: countries reaching >78 yr or dropping below 35 yr",
    x = "Year", y = "Life expectancy (years)",
    caption  = "Source: Gapminder Foundation"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title      = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    legend.position  = "none"
  )

ggsave("asia_lifeexp_highlight.png", p, width = 200, height = 120, units = "mm", dpi = 300)
```

### 10.4 Forest Plot (Regression Coefficients)

```r
library(tidyverse)
library(broom)

mod <- lm(mpg ~ wt + hp + qsec + factor(am), data = mtcars)
td  <- tidy(mod, conf.int = TRUE) %>%
  filter(term != "(Intercept)") %>%
  mutate(term = recode(term,
    "wt" = "Weight (1000 lbs)", "hp" = "Horsepower",
    "qsec" = "¼-mile time (s)", "factor(am)1" = "Manual transmission"))

p <- ggplot(td, aes(x = estimate, y = fct_reorder(term, estimate))) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "grey60") +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high),
                  color = "#0072B2", size = 0.6, linewidth = 0.8) +
  labs(
    title    = "Predictors of fuel efficiency in mtcars",
    subtitle = "OLS coefficients with 95% confidence intervals",
    x = "Estimated change in MPG", y = NULL,
    caption  = "Reference: automatic transmission; data: mtcars"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank()
  )

ggsave("forest_plot_mtcars.png", p, width = 170, height = 100, units = "mm", dpi = 300)
```

### 10.5 Multi-Panel Composite Figure

```r
library(tidyverse)
library(patchwork)
library(palmerpenguins)
library(ggridges)

d <- penguins %>% filter(!is.na(sex))

p1 <- ggplot(d, aes(flipper_length_mm, body_mass_g, color = species)) +
  geom_point(alpha = 0.5, size = 1.8) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 0.7) +
  scale_color_manual(values = c("#E69F00","#56B4E9","#009E73")) +
  labs(x = "Flipper length (mm)", y = "Body mass (g)") +
  theme_minimal(base_size = 10)

p2 <- ggplot(d, aes(x = body_mass_g, y = species, fill = species)) +
  geom_density_ridges(alpha = 0.6, scale = 1.2) +
  scale_fill_manual(values = c("#E69F00","#56B4E9","#009E73")) +
  labs(x = "Body mass (g)", y = NULL) +
  theme_minimal(base_size = 10)

p3 <- d %>% count(species, sex) %>%
  ggplot(aes(x = species, y = n, fill = sex)) +
  geom_col(position = "dodge", width = 0.7) +
  scale_fill_manual(values = c("#CC79A7","#0072B2")) +
  labs(x = NULL, y = "Count", fill = "Sex") +
  theme_minimal(base_size = 10)

composite <- (p1 | p2) / p3 +
  plot_layout(guides = "collect", heights = c(2, 1)) +
  plot_annotation(
    title      = "Palmer Penguins: Morphology, Distribution & Sample Composition",
    tag_levels = "A",
    theme = theme(
      plot.title = element_text(face = "bold", size = 14)
    )
  ) &
  theme(legend.position = "bottom", panel.grid.minor = element_blank())

ggsave("composite_penguins.png", composite, width = 220, height = 180, units = "mm", dpi = 300)
```

### 10.6 Annotated Correlation Heatmap

```r
# ── Fully self-contained correlation heatmap ─────────────────
library(tidyverse)
library(ggcorrplot)
library(palmerpenguins)
library(ragg)

# ── Data preparation ─────────────────────────────────────────
numeric_vars <- penguins %>%
  select(bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
  rename(
    "Bill length\n(mm)"   = bill_length_mm,
    "Bill depth\n(mm)"    = bill_depth_mm,
    "Flipper length\n(mm)"= flipper_length_mm,
    "Body mass\n(g)"      = body_mass_g
  ) %>%
  drop_na()

cor_matrix <- cor(numeric_vars, method = "pearson")
p_matrix   <- cor_pmat(numeric_vars)          # p-values for significance marks

# ── Plot ─────────────────────────────────────────────────────
p <- ggcorrplot(
  cor_matrix,
  method   = "square",          # "square" | "circle"
  type     = "lower",           # show lower triangle only
  lab      = TRUE,              # print correlation coefficients
  lab_size = 3.5,
  p.mat    = p_matrix,          # cross out non-significant cells
  sig.level = 0.05,
  insig    = "blank",           # blank non-significant cells
  colors   = c("#D55E00", "white", "#009E73"),  # diverging, colorblind-safe
  outline.color = "white",
  tl.cex   = 9,
  tl.col   = "grey20"
) +
labs(
  title   = "Morphological traits are strongly intercorrelated in Palmer Penguins",
  subtitle = "Pearson r | Blank cells: p ≥ 0.05 | n = 333 complete observations",
  caption = "Data: palmerpenguins | Colorblind-safe diverging palette"
) +
theme(
  plot.title      = element_text(face = "bold", size = 12),
  plot.subtitle   = element_text(color = "grey40", size = 9),
  plot.caption    = element_text(color = "grey50", size = 8, hjust = 1),
  legend.position = "right",
  legend.title    = element_text(size = 8),
  plot.margin     = margin(10, 10, 10, 10, "pt")
)

ggsave("heatmap_correlation.tiff", p,
       device = ragg::agg_tiff,
       width = 120, height = 110, units = "mm",
       dpi = 300, compression = "lzw")
```

**Heatmap design notes:**
- Always use a **diverging** palette centered at 0, not a sequential one.
- Show **only one triangle** (`type = "lower"` or `"upper"`) to avoid redundancy.
- **Blank or cross out** cells where correlation is not statistically significant.
- **Reorder rows/columns** by hierarchical clustering when the matrix is large:
  `ggcorrplot(..., hc.order = TRUE, hc.method = "ward.D2")`.
- For raw count or frequency heatmaps (not correlation), use `geom_tile()` with
  `scale_fill_viridis_c()` and `geom_text(aes(label = n))` for cell labels.

---

## 11 · Quality Checklist

Before delivering any plot, verify every item below:

**Content & Insight**
- [ ] **Title** describes the *insight*, not the chart type
- [ ] **Subtitle** provides methodological context (data source, sample size, test used)
- [ ] **Caption** cites the data source and any important caveats
- [ ] **Axis labels** include units in parentheses; sentence case
- [ ] **Statistical annotations** state the test name, effect size, and p-value

**Color & Accessibility**
- [ ] **Color palette** is colorblind-safe (viridis, Okabe-Ito, or ggsci)
- [ ] **Greyscale test** passed — desaturate the palette and confirm groups remain distinguishable
- [ ] **Redundant encoding** used — shape or linetype pairs with color for key groups
- [ ] **Legend** is non-redundant; removed if axis or direct labels convey the same info
- [ ] **ggtext** used when color is referenced in the title (drop the legend, encode in text)

**Typography & Layout**
- [ ] **Text** is readable at final output size (≥ 6 pt for Nature/Science; ≥ 8 pt for PLOS/clinical)
- [ ] **`plot.title.position = "plot"`** set so the title aligns to the full figure width
- [ ] **Margins** are explicit and appropriate for the target (journal panel vs. slide)
- [ ] **Facet labels** are informative (use `labeller = label_both` or custom labels)
- [ ] **Long axis labels** handled with `coord_flip()`, `str_wrap()`, or 45° rotation

**Grid, Ink & Chartjunk**
- [ ] **Grid lines** are minimal — major only on the primary axis; minor grid removed
- [ ] **No chartjunk** — no 3D effects, no heavy borders, no decorative elements
- [ ] **Data-ink ratio** is high — every visual element encodes data or aids comparison
- [ ] **Discrete axes** are ordered meaningfully (by value, not alphabetically)
- [ ] **Aspect ratio** is appropriate (scatter ≈ 1:1, time series ≈ 16:9 or wider)

**Export & Reproducibility**
- [ ] **Export** uses `ggsave()` with explicit `width`, `height`, `units`, `dpi`, and correct format
- [ ] **DPI** meets journal requirements (≥ 600 for Nature/Science; ≥ 300 for PLOS/clinical)
- [ ] **Format** matches journal requirement (TIFF/LZW for most; PDF/cairo for vector)
- [ ] **Font** is the journal-required family (Helvetica for Nature/Cell; Arial for PLOS/JAMA)
- [ ] **Code** is fully self-contained: `library()` calls, data prep, plot, and `ggsave()` in one script
- [ ] **Code** is commented at each major section with `# ── Section ──────────────`

---

## 12 · Edge Cases & Troubleshooting

- **Overplotting**: Use `alpha`, `geom_hex`, `geom_bin2d`, `ggbeeswarm`, or jitter.
- **Long labels**: `coord_flip()`, `str_wrap(label, width = 20)`, or angled text.
- **Too many categories (>8)**: Use faceting, highlight, or lumped categories (`fct_lump_n`).
- **Date axis crowding**: Widen figure or increase `date_breaks` interval.
- **Legend overlaps plot**: Move to `"bottom"`, or use direct labeling with `ggrepel`.
- **Font issues in PDF**: Use `cairo_pdf` device or embed fonts with `extrafont`.
- **Missing values warning**: Pre-filter or annotate; don't silently drop.
- **`ylim()` vs `coord_cartesian()`**: Use `coord_cartesian()` to zoom without removing data points — critical for smoothers and boxplots.

---

## 13 · What This Skill Cannot Do

- Generate interactive HTML widgets (use `plotly::ggplotly()` or Shiny separately).
- Run R code — it produces complete, copy-pasteable R scripts.
- Access the user's data directly — it works with described data or built-in datasets.
- Guarantee exact rendering — font availability and device differences may require local adjustment.
