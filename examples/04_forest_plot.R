# ── Title ──────────────────────────────────────────────────────────────────────
# Predictors of fuel efficiency in mtcars
# Source: plan.md Section 10.4
# Packages: tidyverse, broom
# Output: forest_plot_mtcars.png, 170 × 100 mm, 300 DPI
# ───────────────────────────────────────────────────────────────────────────────

# ── Libraries ─────────────────────────────────────────────────
library(tidyverse)
library(broom)

# ── Data preparation ──────────────────────────────────────────
mod <- lm(mpg ~ wt + hp + qsec + factor(am), data = mtcars)

td <- tidy(mod, conf.int = TRUE) %>%
  filter(term != "(Intercept)") %>%
  mutate(
    term = recode(term,
      "wt"          = "Weight (1000 lbs)",
      "hp"          = "Horsepower",
      "qsec"        = "¼-mile time (s)",
      "factor(am)1" = "Manual transmission"
    ),
    significant = p.value < 0.05
  )

# ── Plot ──────────────────────────────────────────────────────
p <- ggplot(td, aes(x = estimate, y = fct_reorder(term, estimate))) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "grey60") +
  geom_pointrange(
    aes(xmin = conf.low, xmax = conf.high),
    color    = "#0072B2",
    size     = 0.6,
    linewidth = 0.8
  ) +
  labs(
    title    = "Predictors of fuel efficiency in mtcars",
    subtitle = "OLS coefficients with 95% confidence intervals",
    x        = "Estimated change in MPG",
    y        = NULL,
    caption  = "Reference: automatic transmission; data: mtcars"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title           = element_text(face = "bold"),
    plot.title.position  = "plot",
    panel.grid.major.y   = element_blank(),
    panel.grid.minor     = element_blank()
  )

# ── Export ────────────────────────────────────────────────────
ggsave("forest_plot_mtcars.png", p,
       width = 170, height = 100, units = "mm", dpi = 300)

# ── Reproducibility ───────────────────────────────────────────
sessioninfo::session_info()
