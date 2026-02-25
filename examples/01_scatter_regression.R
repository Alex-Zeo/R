# ── Title ──────────────────────────────────────────────────────────────────────
# Fuel efficiency declines with engine size across vehicle classes
# Source: plan.md Section 10.1
# Packages: ggplot2 (tidyverse), ggrepel, ggsci
# Output: scatter_regression.png, 180 × 130 mm, 300 DPI
# ───────────────────────────────────────────────────────────────────────────────

# ── Libraries ─────────────────────────────────────────────────
library(tidyverse)
library(ggrepel)
library(ggsci)

# ── Data preparation ──────────────────────────────────────────
data(mpg, package = "ggplot2")

df <- mpg %>%
  mutate(label = ifelse(hwy > 40 | displ > 6.5,
                        paste(manufacturer, model),
                        NA_character_))

# ── Plot ──────────────────────────────────────────────────────
p <- ggplot(df, aes(x = displ, y = hwy, color = class)) +
  geom_point(alpha = 0.7, size = 2.5) +
  geom_smooth(method = "lm", se = TRUE, color = "grey30", linewidth = 0.8,
              linetype = "dashed", fill = "grey85") +
  geom_text_repel(aes(label = label), size = 2.8, color = "grey25",
                  max.overlaps = 20, box.padding = 0.4,
                  segment.color = "grey60", na.rm = TRUE) +
  scale_color_npg() +
  scale_x_continuous(breaks = seq(1, 7, 1)) +
  labs(
    title    = "Fuel efficiency declines with engine size across vehicle classes",
    subtitle = "Highway MPG vs engine displacement (litres), EPA data 1999–2008",
    x        = "Engine displacement (L)",
    y        = "Highway fuel economy (mpg)",
    color    = "Vehicle class",
    caption  = "Source: ggplot2::mpg | Outliers labeled"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title           = element_text(face = "bold", size = 14),
    plot.subtitle        = element_text(color = "grey40"),
    plot.title.position  = "plot",
    legend.position      = "bottom",
    panel.grid.minor     = element_blank()
  )

# ── Export ────────────────────────────────────────────────────
ggsave("scatter_regression.png", p,
       width = 180, height = 130, units = "mm", dpi = 300)

# ── Reproducibility ───────────────────────────────────────────
sessioninfo::session_info()
