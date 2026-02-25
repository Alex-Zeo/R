# Example Prompts

Each file contains a curated prompt for a specific chart family, plus the metadata
needed for skill validation and MCP skill-picker UIs.

| File | Chart family | Key packages |
|---|---|---|
| `scatter.md` | Scatter + regression | ggplot2, ggrepel, ggsci |
| `distribution.md` | Raincloud distributions | ggrain, ggpubr |
| `timeseries.md` | Time series + highlight | gghighlight, gapminder |
| `heatmap.md` | Correlation heatmap | ggcorrplot |
| `forest.md` | Forest plot | broom, ggplot2 |
| `multipanel.md` | Multi-panel composite | patchwork, ggridges |
| `survival.md` | Kaplan-Meier curve | survminer |
| `network.md` | Network graph | ggraph, tidygraph |
| `map.md` | Choropleth map | geom_sf, sf |

## Schema

Each prompt file uses this front-matter:

```yaml
---
chart_family: <family>
difficulty: beginner | intermediate | advanced
packages: [pkg1, pkg2, ...]
dataset: <dataset name>
sections: [<plan.md section numbers>]
---
```
