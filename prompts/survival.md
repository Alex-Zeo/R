---
chart_family: survival
difficulty: advanced
packages: [survminer, survival]
dataset: survival::lung
sections: [3, 16]
---

# Prompt

Kaplan-Meier survival curve for the lung cancer dataset, stratified by sex. Include
a number-at-risk table below the plot. Show confidence intervals, censoring marks,
median survival annotation, and log-rank p-value. Use a colorblind-safe palette.
Export at journal quality.

# Survival curve implementation rules

1. **Risk table** — always include `risk.table = TRUE` below the curve, aligned with
   the time axis. Use `risk.table.height = 0.25` for 2 strata, `0.30` for 3+.
   Use `tables.theme = theme_cleantable()` for clean appearance.
2. **Confidence intervals** — use semi-transparent ribbons with `conf.int.alpha = 0.15`
   for 2-3 groups. Omit CIs or use `conf.int.style = "step"` for 4+ overlapping groups.
3. **Censoring marks** — use `censor.shape = "|"` at `censor.size = 2-3`. Avoid large
   `"+"` marks that obscure curves. Omit when n is very large and risk table is present.
4. **Median survival** — always add `surv.median.line = "hv"` for horizontal line at
   y = 0.5 with vertical drop to the time axis.
5. **Max groups** — 3-4 per panel. Use faceting (`ggsurvplot_facet()`) for 5+.
6. **Y-axis** — always 0 to 1 (or 0-100%). Never truncate a survival curve y-axis.
7. **Time axis** — start at 0 with `break.time.by` at clinically meaningful intervals.
   Label clearly: "Time (months)", "Time (days)", etc.
8. **P-value** — show with `pval = TRUE, pval.method = TRUE` to state the test used.
   Report exact value, not `p < 0.05`. Place away from curves.
9. **Color** — colorblind-safe palette. Supplement with `linetype = "strata"` for
   greyscale printing. Maximum ~4 colors per panel.
10. **survminer returns a list** — use `print(p)` inside `ggsave()` for export.

# Expected outputs

- Fully self-contained R script
- `survival::Surv()` and `survival::survfit()` for the KM estimator
- `survminer::ggsurvplot()` with:
  - `risk.table = TRUE` with appropriate height
  - `pval = TRUE, pval.method = TRUE`
  - `conf.int = TRUE, conf.int.alpha = 0.15`
  - `censor.shape = "|", censor.size = 2`
  - `surv.median.line = "hv"`
  - `break.time.by` at meaningful intervals
  - `linetype = "strata"` for greyscale fallback
  - Colorblind-safe palette (Okabe-Ito or brand tokens)
  - `ggtheme` using project theme or `theme_minimal()`
- Axis labels: `x = "Time (days)"`, `y = "Survival probability"`
- Insight-driven title
- Export via `ggsave(plot = print(p), ...)` with explicit dimensions

# Reference

See `plan.md` Section 16.1.
