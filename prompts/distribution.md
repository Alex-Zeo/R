---
chart_family: distribution
difficulty: intermediate
packages: [ggdist, ggplot2, palmerpenguins]
dataset: palmerpenguins::penguins
sections: [3, 4, 10]
---

# Prompt

Raincloud plot of penguin body mass (g) by species. Show a half-density slab (cloud),
boxplot (lightning), and deterministic dot strip (rain) using ggdist. Use horizontal
orientation with `coord_flip()`. Apply the Okabe-Ito colorblind-safe palette. Remove the
legend (species shown on axis).

# Raincloud implementation rules

1. **Three distinct layers** — half-density slab, boxplot, raw dots. Never combine into
   fewer layers (a violin alone or boxplot alone is not a raincloud).
2. **Prefer `ggdist::stat_dots()` over `geom_jitter()`** — deterministic dot stacking
   avoids jitter artefacts where identical data looks different across renders. If jitter
   is required, always set `seed` for reproducibility.
3. **Density bandwidth** — set `adjust = 0.5` for medium n (20-200) to reveal bimodality.
   Increase to `1.0-1.5` for small n (< 20). Always use `trim = TRUE` to prevent density
   mass beyond data bounds.
4. **Boxplot sizing** — width = 0.10 to 0.15 (roughly 1/4 to 1/6 of violin width).
   Always set `outlier.shape = NA` since raw data already shows outliers.
5. **Layer spacing** — nudge the boxplot ~0.15 from center; position density slab with
   `justification = -0.2`; position dots with `justification = 1.1` on the opposite side.
6. **Orientation** — horizontal (`coord_flip()` or swapped aesthetics) is preferred:
   category labels read naturally, density extends rightward, better for many groups.
7. **Large n handling** — when n > 200-300 per group, replace raw dots with
   `stat_dots(quantiles = 100)` (quantile dotplot) or drop the rain layer entirely.
8. **Small n handling** — when n < 15, increase density bandwidth (`adjust = 1.0-1.5`)
   and consider whether density estimation is warranted at all; a dot strip alone may
   be more honest.
9. **Alpha by component** — density: 0.5-0.7, boxplot: 0.5, dots: 0.4-0.6 (scale
   inversely with n).

# Expected outputs

- Fully self-contained R script
- `ggdist::stat_halfeye()` for half-density slab with `adjust`, `trim = TRUE`, `.width = 0`
- `geom_boxplot()` with `outlier.shape = NA`, nudged position, narrow width
- `ggdist::stat_dots()` for deterministic dot layout (not `geom_jitter`)
- `coord_flip()` for horizontal orientation
- Okabe-Ito or equivalent colorblind-safe fill palette
- Title: insight-driven (e.g. "Gentoo penguins are significantly heavier than other species")
- Axis labels: `y = "Body mass (g)"`, `x = NULL`
- Legend removed (`theme(legend.position = "none")`)
- `ggsave()` with explicit dimensions and DPI

# Reference

See `examples/02_raincloud_distributions.R` and `plan.md` Section 10.2.
