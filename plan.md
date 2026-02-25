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

### 5.3 Typography Rules

- **Title**: 14–18 pt, bold. Describe the finding, not the chart type.
  - Good: *"Fuel efficiency drops sharply above 4L engine displacement"*
  - Bad: *"Scatter plot of MPG vs Displacement"*
- **Subtitle**: 10–12 pt, regular, grey. Provide methodological context.
- **Caption**: 8–10 pt, right-aligned. Data source and notes.
- **Axis labels**: Sentence case, include units: `"Body mass (g)"`, `"Price (USD, thousands)"`.
- **Legend**: Bottom or right. Title in bold. Remove if redundant with axis.
- **Rotate long x-labels** at 45° with `hjust = 1`, or use `coord_flip()`.

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

---

## 11 · Quality Checklist

Before delivering any plot, verify:

- [ ] **Title** describes the *insight*, not the chart type
- [ ] **Axis labels** include units in parentheses
- [ ] **Legend** is non-redundant and clearly labeled; removed if unnecessary
- [ ] **Color palette** is colorblind-safe (check with `colorspace::demoplot()`)
- [ ] **Text** is readable at final output size (≥8 pt at print dimensions)
- [ ] **Grid lines** are minimal — only major grid on the mapped axis
- [ ] **No chartjunk** — no 3D effects, no unnecessary borders, no heavy grid
- [ ] **Data-ink ratio** is high — every visual element encodes data or aids comparison
- [ ] **Caption** cites data source
- [ ] **Export** uses `ggsave()` with explicit dimensions, DPI ≥ 300, and correct format
- [ ] **Aspect ratio** is appropriate (scatter ≈ 1:1, time series ≈ 16:9)
- [ ] **Discrete axes** are ordered meaningfully (not alphabetically unless that is meaningful)
- [ ] **Statistical annotations** include test name, effect size, and p-value where relevant
- [ ] **Code** is self-contained, reproducible, and commented

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
