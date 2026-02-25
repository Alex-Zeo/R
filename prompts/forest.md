---
chart_family: statistical
difficulty: intermediate
packages: [tidyverse, broom]
dataset: datasets::mtcars
sections: [3, 10]
---

# Prompt

Forest plot of OLS regression coefficients predicting MPG in the mtcars dataset.
Model predictors: weight, horsepower, quarter-mile time, transmission type.
Show point estimates with 95% confidence intervals. Add a vertical reference line
at zero. Order terms by effect size. Label axes clearly.

# Expected outputs

- Fully self-contained R script
- `lm()` model; `broom::tidy(conf.int = TRUE)`
- Filter out intercept term
- `fct_reorder(term, estimate)` to sort by effect size
- `geom_vline(xintercept = 0, linetype = "dashed")` reference line
- `geom_pointrange(aes(xmin = conf.low, xmax = conf.high))`
- Colorblind-safe single color for point/range (e.g. `"#0072B2"`)
- Title: e.g. "Predictors of fuel efficiency in mtcars"
- Axis labels: `x = "Estimated change in MPG"`, `y = NULL`
- `ggsave()` with explicit dimensions

# Reference

See `examples/04_forest_plot.R` and `plan.md` Section 10.4.
