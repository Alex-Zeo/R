---
chart_family: survival
difficulty: advanced
packages: [survminer, survival]
dataset: survival::lung
sections: [3, 16]
---

# Prompt

Kaplan-Meier survival curve for the lung cancer dataset, stratified by sex.
Include a risk table below the plot. Show the log-rank p-value. Use a
colorblind-safe palette. Export at journal quality.

# Expected outputs

- Fully self-contained R script
- `survival::Surv()` and `survival::survfit()` for the KM estimator
- `survminer::ggsurvplot()` with:
  - `risk.table = TRUE`
  - `pval = TRUE` (log-rank p-value)
  - `conf.int = TRUE`
  - `palette = c("#E69F00", "#56B4E9")` (colorblind-safe)
  - `ggtheme = theme_minimal()`
- Axis labels: `x = "Time (days)"`, `y = "Survival probability"`
- Legend labels: `c("Male", "Female")`
- Insight-driven title: e.g. "Women show higher survival probability in lung cancer"
- Export via `ggsave()` or `survminer::surv_plot()` at explicit dimensions

# Reference

See `plan.md` Section 16 and `examples/07_survival_curve.R` (if present).
