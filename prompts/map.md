---
chart_family: geospatial
difficulty: advanced
packages: [sf, rnaturalearth, rnaturalearthdata, tidyverse]
dataset: rnaturalearth world boundaries
sections: [3, 16]
---

# Prompt

Choropleth map showing a variable (e.g. GDP per capita or life expectancy) by country
worldwide. Use natural earth world boundaries. Fill countries with a viridis sequential
palette. Countries with missing data shown in light grey. Add a clean minimal theme
with no axis labels.

# Expected outputs

- Fully self-contained R script
- `rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")` for boundaries
- Join a data frame of country-level values on ISO3 code or country name
- `geom_sf(aes(fill = variable), color = "white", linewidth = 0.1)`
- `scale_fill_viridis_c(option = "plasma", na.value = "grey85", name = "Variable")`
- `coord_sf(expand = FALSE)` for tight bounding box
- `theme_void()` or minimal theme with `panel.background = element_rect(fill = "aliceblue")`
- Insight-driven title
- Caption citing data source and year
- `ggsave()` at wide dimensions (e.g. 240 × 150 mm, 300 DPI)

# Reference

See `plan.md` Section 16 and `examples/09_choropleth_map.R` (if present).
