---
chart_family: correlation
difficulty: intermediate
packages: [ggcorrplot, palmerpenguins, ragg]
dataset: palmerpenguins::penguins
sections: [3, 4, 10]
---

# Prompt

Correlation heatmap of the four penguin morphological traits (bill length, bill depth,
flipper length, body mass). Show Pearson r values in cells. Blank out cells where
p ≥ 0.05. Use a diverging colorblind-safe palette centered at zero. Show only the
lower triangle to avoid redundancy.

# Expected outputs

- Fully self-contained R script
- `select()` the four numeric variables; `drop_na()`
- `cor()` for the correlation matrix; `cor_pmat()` for p-values
- `ggcorrplot()` with `type = "lower"`, `lab = TRUE`, `insig = "blank"`
- Diverging colorblind-safe palette: e.g. `c("#D55E00", "white", "#009E73")`
- Title describing insight: e.g. "Morphological traits are strongly intercorrelated"
- Subtitle: Pearson r, p threshold, sample size
- `ggsave()` via `ragg::agg_tiff` with `compression = "lzw"`, explicit dimensions

# Reference

See `examples/06_correlation_heatmap.R` and `plan.md` Section 10.6.
