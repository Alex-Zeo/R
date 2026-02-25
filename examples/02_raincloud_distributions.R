# ── Title ──────────────────────────────────────────────────────────────────────
# Gentoo penguins are significantly heavier than other species
# Source: plan.md Section 10.2
# Packages: tidyverse, ggrain, ggpubr, palmerpenguins
# Output: raincloud_penguins.png, 170 × 140 mm, 300 DPI
# ───────────────────────────────────────────────────────────────────────────────

# ── Libraries ─────────────────────────────────────────────────
library(tidyverse)
library(ggrain)
library(ggpubr)
library(palmerpenguins)

# ── Data preparation ──────────────────────────────────────────
df <- penguins %>%
  filter(!is.na(body_mass_g), !is.na(species))

# ── Plot ──────────────────────────────────────────────────────
p <- ggplot(df, aes(x = species, y = body_mass_g,
                    fill = species, color = species)) +
  geom_rain(
    alpha     = 0.4,
    rain.side = "l",
    boxplot.args = list(color = "grey30", outlier.shape = NA),
    violin.args  = list(color = NA, alpha = 0.3)
  ) +
  stat_compare_means(
    comparisons = list(c("Adelie", "Chinstrap"),
                       c("Chinstrap", "Gentoo"),
                       c("Adelie", "Gentoo")),
    method       = "wilcox.test",
    label        = "p.signif",
    step.increase = 0.08
  ) +
  scale_fill_manual(values  = c("#FF6B35", "#004E89", "#2A9D8F")) +
  scale_color_manual(values = c("#FF6B35", "#004E89", "#2A9D8F")) +
  labs(
    title    = "Gentoo penguins are significantly heavier than other species",
    subtitle = "Body mass distributions with pairwise Wilcoxon tests",
    x        = NULL,
    y        = "Body mass (g)",
    caption  = paste0(
      "Data: palmerpenguins | ",
      "*** p < 0.001, ** p < 0.01, * p < 0.05, ns = not significant"
    )
  ) +
  theme_pubr(base_size = 12) +
  theme(legend.position = "none")

# ── Export ────────────────────────────────────────────────────
ggsave("raincloud_penguins.png", p,
       width = 170, height = 140, units = "mm", dpi = 300)

# ── Reproducibility ───────────────────────────────────────────
sessioninfo::session_info()
