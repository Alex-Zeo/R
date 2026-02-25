# Validation Rules

Rules checked by `checklist_auto.R`. Each rule maps to one or more items in the
26-point quality checklist in `plan.md` Section 11.

---

## Automated rules (checked by `checklist_auto.R`)

### R-01 · `library()` calls present
The script must contain at least one `library(...)` call.
Rationale: all scripts must be fully self-contained.
Check: `grepl("library\\(", content)`

### R-02 · `ggsave()` call present
The script must contain a `ggsave(` call.
Rationale: every script must include export.
Check: `grepl("ggsave\\(", content)`

### R-03 · `width` argument in `ggsave()`
The `ggsave()` call must include a `width` argument.
Rationale: explicit dimensions are required.
Check: `grepl("width\\s*=", content)`

### R-04 · `height` argument in `ggsave()`
The `ggsave()` call must include a `height` argument.
Check: `grepl("height\\s*=", content)`

### R-05 · `units` argument in `ggsave()`
The `ggsave()` call must include a `units` argument.
Check: `grepl("units\\s*=", content)`

### R-06 · `dpi` argument in `ggsave()`
The `ggsave()` call must include a `dpi` argument.
Check: `grepl("dpi\\s*=", content)`

### R-07 · No `setwd()` calls
The script must not call `setwd()`.
Rationale: breaks reproducibility across machines.
Check: `!grepl("setwd\\(", content)`

### R-08 · No `install.packages()` calls
The script must not call `install.packages()`.
Rationale: scripts should not auto-modify the user's library.
Check: `!grepl("install\\.packages\\(", content)`

### R-09 · Colorblind-safe palette referenced
The script must reference at least one colorblind-safe palette function or constant.
Accepted patterns: `viridis`, `scale_fill_viridis`, `scale_color_viridis`,
`scale_color_npg`, `scale_fill_npg`, `scale_color_aaas`, `scale_fill_aaas`,
`scale_color_manual.*#E69F00|#56B4E9|#009E73|#0072B2|#D55E00|#CC79A7|#F0E442`,
`okabe`, `scale_fill_brewer`, `colorblind`.
Check: regex union across the above patterns.

### R-10 · `labs(title` present
The script must set a plot title via `labs(title`.
Rationale: every plot must have an insight-driven title.
Check: `grepl("labs\\(.*title\\s*=|labs\\(\\s*\\n.*title\\s*=", content)`

### R-11 · `labs(x` or `labs(y` axis labels present
The script must set at least one axis label.
Check: `grepl("labs\\(.*[xy]\\s*=", content)`

### R-12 · `sessioninfo::session_info()` call present (recommended)
The script should include a session info call for reproducibility.
This is a warning (not an error) if absent.
Check: `grepl("session_info|sessionInfo", content)`

---

## Human-review rules (not automated)

These items require visual inspection of the rendered plot:

- Title describes the *insight*, not the chart type (e.g. "Gentoo are heavier", not "Boxplot")
- Subtitle provides methodological context (sample size, test used, data source)
- Caption cites the data source
- Statistical annotations state test name, effect size, and p-value
- Greyscale test: desaturate and confirm groups remain distinguishable
- Redundant encoding: shape or linetype pairs with color for key groups
- Legend is non-redundant (removed when axis labels are sufficient)
- Text is readable at final output size (≥ 6 pt at target DPI)
- `plot.title.position = "plot"` set
- Margins appropriate for target (journal vs. slide)
- Facet labels informative
- Long axis labels handled
- Grid lines minimal (major only; minor removed)
- No chartjunk (no 3D, no decorative elements)
