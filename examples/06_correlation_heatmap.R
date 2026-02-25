# ── Title ──────────────────────────────────────────────────────────────────────
# Morphological traits are strongly intercorrelated in Palmer Penguins
# Source: plan.md Section 10.6
# Packages: tidyverse, ggcorrplot, palmerpenguins, ragg
# Output: heatmap_correlation.tiff, 120 × 110 mm, 300 DPI
# ───────────────────────────────────────────────────────────────────────────────

# ── Libraries ─────────────────────────────────────────────────
library(tidyverse)
library(ggcorrplot)
library(palmerpenguins)
library(ragg)

# ── Data preparation ──────────────────────────────────────────
numeric_vars <- penguins %>%
  select(bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
  rename(
    "Bill length\n(mm)"    = bill_length_mm,
    "Bill depth\n(mm)"     = bill_depth_mm,
    "Flipper length\n(mm)" = flipper_length_mm,
    "Body mass\n(g)"       = body_mass_g
  ) %>%
  drop_na()

cor_matrix <- cor(numeric_vars, method = "pearson")
p_matrix   <- cor_pmat(numeric_vars)

# ── Plot ──────────────────────────────────────────────────────
p <- ggcorrplot(
  cor_matrix,
  method        = "square",
  type          = "lower",
  lab           = TRUE,
  lab_size      = 3.5,
  p.mat         = p_matrix,
  sig.level     = 0.05,
  insig         = "blank",
  colors        = c("#D55E00", "white", "#009E73"),
  outline.color = "white",
  tl.cex        = 9,
  tl.col        = "grey20"
) +
  labs(
    title    = "Morphological traits are strongly intercorrelated in Palmer Penguins",
    subtitle = "Pearson r | Blank cells: p ≥ 0.05 | n = 333 complete observations",
    caption  = "Data: palmerpenguins | Colorblind-safe diverging palette"
  ) +
  theme(
    plot.title      = element_text(face = "bold", size = 12),
    plot.subtitle   = element_text(color = "grey40", size = 9),
    plot.caption    = element_text(color = "grey50", size = 8, hjust = 1),
    legend.position = "right",
    legend.title    = element_text(size = 8),
    plot.margin     = margin(10, 10, 10, 10, "pt")
  )

# ── Export ────────────────────────────────────────────────────
ggsave("heatmap_correlation.tiff", p,
       device      = ragg::agg_tiff,
       width       = 120,
       height      = 110,
       units       = "mm",
       dpi         = 300,
       compression = "lzw")

# ── Reproducibility ───────────────────────────────────────────
sessioninfo::session_info()
