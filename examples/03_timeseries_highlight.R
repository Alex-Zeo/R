# ── Title ──────────────────────────────────────────────────────────────────────
# Life expectancy trajectories in Asia, 1952–2007
# Source: plan.md Section 10.3
# Packages: tidyverse, gghighlight, gapminder
# Output: asia_lifeexp_highlight.png, 200 × 120 mm, 300 DPI
# ───────────────────────────────────────────────────────────────────────────────

# ── Libraries ─────────────────────────────────────────────────
library(tidyverse)
library(gghighlight)
library(gapminder)

# ── Data preparation ──────────────────────────────────────────
df <- gapminder %>%
  filter(continent == "Asia")

# ── Plot ──────────────────────────────────────────────────────
p <- ggplot(df, aes(x = year, y = lifeExp, group = country, color = country)) +
  geom_line(linewidth = 0.6) +
  gghighlight(
    max(lifeExp) > 78 | min(lifeExp) < 35,
    use_direct_label  = TRUE,
    label_key         = country,
    unhighlighted_params = list(linewidth = 0.3, alpha = 0.4)
  ) +
  scale_x_continuous(breaks = seq(1952, 2007, 10)) +
  scale_y_continuous(limits = c(25, 85)) +
  labs(
    title    = "Life expectancy trajectories in Asia, 1952–2007",
    subtitle = "Highlighted: countries reaching >78 yr or dropping below 35 yr",
    x        = "Year",
    y        = "Life expectancy (years)",
    caption  = "Source: Gapminder Foundation"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title           = element_text(face = "bold"),
    plot.title.position  = "plot",
    panel.grid.minor     = element_blank(),
    legend.position      = "none"
  )

# ── Export ────────────────────────────────────────────────────
ggsave("asia_lifeexp_highlight.png", p,
       width = 200, height = 120, units = "mm", dpi = 300)

# ── Reproducibility ───────────────────────────────────────────
sessioninfo::session_info()
