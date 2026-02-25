# ── Title ──────────────────────────────────────────────────────────────────────
# Palmer Penguins: Morphology, Distribution & Sample Composition
# Source: plan.md Section 10.5
# Packages: tidyverse, patchwork, palmerpenguins, ggridges
# Output: composite_penguins.png, 220 × 180 mm, 300 DPI
# ───────────────────────────────────────────────────────────────────────────────

# ── Libraries ─────────────────────────────────────────────────
library(tidyverse)
library(patchwork)
library(palmerpenguins)
library(ggridges)

# ── Data preparation ──────────────────────────────────────────
d <- penguins %>% filter(!is.na(sex))

okabe <- c("Adelie" = "#E69F00", "Chinstrap" = "#56B4E9", "Gentoo" = "#009E73")

# ── Panel A: scatter ──────────────────────────────────────────
p1 <- ggplot(d, aes(flipper_length_mm, body_mass_g, color = species)) +
  geom_point(alpha = 0.5, size = 1.8) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 0.7) +
  scale_color_manual(values = okabe, name = "Species") +
  labs(x = "Flipper length (mm)", y = "Body mass (g)") +
  theme_minimal(base_size = 10) +
  theme(panel.grid.minor = element_blank())

# ── Panel B: ridge density ────────────────────────────────────
p2 <- ggplot(d, aes(x = body_mass_g, y = species, fill = species)) +
  geom_density_ridges(alpha = 0.6, scale = 1.2) +
  scale_fill_manual(values = okabe) +
  labs(x = "Body mass (g)", y = NULL) +
  theme_minimal(base_size = 10) +
  theme(panel.grid.minor = element_blank(), legend.position = "none")

# ── Panel C: bar chart ────────────────────────────────────────
p3 <- d %>%
  count(species, sex) %>%
  ggplot(aes(x = species, y = n, fill = sex)) +
  geom_col(position = "dodge", width = 0.7) +
  scale_fill_manual(values = c("female" = "#CC79A7", "male" = "#0072B2"),
                    name   = "Sex") +
  labs(x = NULL, y = "Count") +
  theme_minimal(base_size = 10) +
  theme(panel.grid.minor = element_blank())

# ── Compose ───────────────────────────────────────────────────
composite <- (p1 | p2) / p3 +
  plot_layout(guides = "collect", heights = c(2, 1)) +
  plot_annotation(
    title      = "Palmer Penguins: Morphology, Distribution & Sample Composition",
    tag_levels = "A",
    theme = theme(plot.title = element_text(face = "bold", size = 14))
  ) &
  theme(legend.position = "bottom", panel.grid.minor = element_blank())

# ── Export ────────────────────────────────────────────────────
ggsave("composite_penguins.png", composite,
       width = 220, height = 180, units = "mm", dpi = 300)

# ── Reproducibility ───────────────────────────────────────────
sessioninfo::session_info()
