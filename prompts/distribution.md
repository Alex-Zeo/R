---
chart_family: distribution
difficulty: intermediate
packages: [ggrain, ggpubr, palmerpenguins]
dataset: palmerpenguins::penguins
sections: [3, 4, 10]
---

# Prompt

Raincloud plot of penguin body mass (g) by species with pairwise Wilcoxon significance
tests. Show raw data points, violin density, and boxplot in one layer. Use the
Okabe-Ito colorblind-safe palette. Remove the legend (species shown on x-axis).

# Expected outputs

- Fully self-contained R script
- `geom_rain()` with `rain.side = "l"`, violin, boxplot, and point layers
- `stat_compare_means()` with `method = "wilcox.test"` and `label = "p.signif"`
- Okabe-Ito or equivalent colorblind-safe fill/color palette
- `scale_fill_manual()` + `scale_color_manual()` with matched values
- Title: e.g. "Gentoo penguins are significantly heavier than other species"
- Axis labels: `y = "Body mass (g)"`, `x = NULL` (species on x-axis is sufficient)
- Legend removed (`theme(legend.position = "none")`)
- `ggsave()` with explicit dimensions and DPI

# Reference

See `examples/02_raincloud_distributions.R` and `plan.md` Section 10.2.
