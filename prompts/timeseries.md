---
chart_family: timeseries
difficulty: intermediate
packages: [tidyverse, gghighlight, gapminder]
dataset: gapminder::gapminder
sections: [3, 6, 10]
---

# Prompt

Line chart of life expectancy over time (1952–2007) for all Asian countries.
Highlight countries that reached above 78 years or dropped below 35 years at any point.
Use direct labels instead of a legend. Unhighlighted countries shown in grey.

# Expected outputs

- Fully self-contained R script
- Filter to `continent == "Asia"`
- `geom_line()` with `group = country`
- `gghighlight()` with condition on max/min life expectancy
- `use_direct_label = TRUE`, `label_key = country`
- `unhighlighted_params = list(linewidth = 0.3, alpha = 0.4)` to grey-out background
- Insight-driven title: e.g. "Life expectancy trajectories in Asia, 1952–2007"
- Axis labels: `x = "Year"`, `y = "Life expectancy (years)"`
- Legend suppressed (`legend.position = "none"`)
- `ggsave()` with explicit dimensions (wider than tall, e.g. 200 × 120 mm)

# Reference

See `examples/03_timeseries_highlight.R` and `plan.md` Section 10.3.
