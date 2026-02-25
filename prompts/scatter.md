---
chart_family: scatter
difficulty: intermediate
packages: [ggplot2, ggrepel, ggsci]
dataset: ggplot2::mpg
sections: [3, 6, 10]
---

# Prompt

Plot highway MPG vs engine displacement, colored by vehicle class, with a regression
line and confidence band. Label outliers (highway > 40 mpg or displacement > 6.5 L)
with manufacturer and model name. Use a colorblind-safe qualitative palette.

# Expected outputs

- Fully self-contained R script
- `geom_point()` with `alpha` to reduce overplotting
- `geom_smooth(method = "lm")` with confidence band
- `geom_text_repel()` for non-overlapping outlier labels
- `scale_color_npg()` or equivalent colorblind-safe qualitative palette
- Insight-driven title (e.g. "Fuel efficiency declines with engine size")
- Axis labels with units: "Engine displacement (L)", "Highway fuel economy (mpg)"
- `ggsave()` with explicit `width`, `height`, `units = "mm"`, `dpi`

# Reference

See `examples/01_scatter_regression.R` and `plan.md` Section 10.1.
