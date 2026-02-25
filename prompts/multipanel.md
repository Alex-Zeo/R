---
chart_family: multipanel
difficulty: advanced
packages: [patchwork, ggridges, palmerpenguins]
dataset: palmerpenguins::penguins
sections: [8, 10]
---

# Prompt

Three-panel composite figure from palmerpenguins:
- Panel A: scatter of flipper length vs body mass, colored by species, with linear fits
- Panel B: ridgeline density of body mass by species
- Panel C: bar chart of species × sex counts

Collect the legend at the bottom. Label panels A, B, C. Consistent color mapping
across all three panels using the Okabe-Ito palette.

# Expected outputs

- Fully self-contained R script
- Three separate ggplot objects (`p1`, `p2`, `p3`)
- Identical `scale_color_manual()` / `scale_fill_manual()` across all panels
- `(p1 | p2) / p3` patchwork layout
- `plot_layout(guides = "collect", heights = c(2, 1))`
- `plot_annotation(tag_levels = "A")`
- `& theme(legend.position = "bottom")` applied globally
- `ggsave()` at 220 × 180 mm, 300 DPI

# Reference

See `examples/05_multipanel_composite.R` and `plan.md` Sections 8 and 10.5.
