---
chart_family: timeseries
difficulty: intermediate
packages: [tidyverse, gghighlight, ggrepel]
dataset: custom or gapminder::gapminder
sections: [3, 6, 10]
---

# Prompt

Multi-line time series chart showing trends over time for multiple groups. Use direct
end-of-line labels instead of a legend. Include event annotations for key milestones.
Add linetype differentiation for greyscale/colorblind accessibility. Use a wider-than-tall
aspect ratio and a colorblind-safe palette.

# Time series implementation rules

1. **Direct labels over legends** — always use `geom_text_repel()` or `geom_label_repel()`
   at the last point per group instead of a legend. Set `nudge_x` to push labels right,
   `direction = "y"` to prevent vertical overlap, `hjust = 0` for left-alignment. Then
   suppress the legend with `guides(colour = "none")`.
2. **Linetype for accessibility** — always add `aes(linetype = group)` alongside colour.
   This provides a greyscale fallback and helps colorblind readers distinguish lines. Use
   `scale_linetype_manual()` with standard types: solid, dashed, dotted, dotdash, longdash,
   twodash. Suppress the linetype legend when direct labels are present.
3. **Aspect ratio** — use wider-than-tall dimensions (2:1 to 3:1). Time flows horizontally;
   a wider canvas reveals temporal patterns better. Typical: 220-240 mm wide, 120-150 mm tall.
4. **Event annotations** — mark important events with `geom_vline(linetype = "dashed")` +
   `annotate("text", ...)` positioned slightly left of the line with `hjust = 1`. Keep
   annotations behind data layers (plot them first).
5. **Date axis** — use `scale_x_date(date_breaks = ..., date_labels = ...)` with meaningful
   intervals. For long series use `"%Y"`, for months use `"%b %Y"`. Always start from the
   data range; add `expand = expansion(mult = c(0.02, 0.10-0.15))` for right-side label space.
6. **Y-axis** — include 0 when it's a meaningful baseline (counts, percentages). Use
   `scales::percent_format()` for proportions, `scales::comma_format()` for large numbers.
   Never truncate in misleading ways.
7. **Max groups** — 6-8 lines per panel. Use `gghighlight()` for >8 to grey out background
   lines and highlight a subset. For 10+, consider faceting by group.
8. **Point markers** — add small `geom_point()` at each observation (size = 1.5-2.0,
   alpha = 0.5-0.7) to show data density and distinguish observation frequency from
   interpolated trends.
9. **gghighlight pattern** — when highlighting a subset, use
   `gghighlight(condition, use_direct_label = TRUE, label_key = group)` with
   `unhighlighted_params = list(linewidth = 0.3, alpha = 0.3-0.4)` to grey out context.
10. **Theme** — use `theme_ai_ts()` (adds vertical gridlines for time-axis readability)
    or add `panel.grid.major.x = element_line()` manually.

# Expected outputs

- Fully self-contained R script
- `geom_line()` with `aes(colour = group, linetype = group)` for dual encoding
- `geom_point()` with small markers at each observation
- `geom_text_repel()` for direct end-of-line labels (not a legend)
- `scale_colour_manual()` with colorblind-safe palette (Okabe-Ito or brand tokens)
- `scale_linetype_manual()` for greyscale fallback
- Event annotations with `geom_vline()` + `annotate()`
- `scale_x_date()` with meaningful breaks and right-side expansion
- Insight-driven title
- Wider-than-tall dimensions (e.g. 240 x 140 mm)
- `ggsave()` with explicit dimensions and DPI

# Reference

See `examples/03_timeseries_highlight.R` and `plan.md` Section 10.3.
