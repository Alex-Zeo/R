# TASKS — r-high-fidelity-viz

Remaining modules required for MCP readiness, production readiness, and GitHub publication.
Each task is self-contained and can be worked independently.

---

## Track 1 · MCP Readiness

Tasks required for the skill to be consumed by Claude / any MCP-compatible host.

### T-01 · Create `skill.json` — MCP skill manifest

**File:** `skill.json`
**Why:** MCP hosts discover skills via a machine-readable manifest. Without it the skill
cannot be registered or invoked programmatically.
**Contents to include:**
- `name`, `version`, `description`, `author`
- `trigger_phrases` — keywords that should activate this skill
  (e.g. `["R chart", "ggplot", "visualization", "R plot", "data viz"]`)
- `capabilities` — list of what the skill produces
- `skill_file` — pointer to `plan.md`
- `schema_version` — MCP spec version targeted

```json
// Minimum viable shape:
{
  "schema_version": "1.0",
  "name": "r-high-fidelity-viz",
  "version": "1.0.0",
  "description": "...",
  "trigger_phrases": [...],
  "skill_file": "plan.md",
  "capabilities": ["chart_generation", "code_generation", "export_guidance"]
}
```

---

### T-02 · Create `prompts/` directory — curated example prompts

**Files:** `prompts/README.md` + one `.md` file per chart family
**Why:** MCP hosts and developers need canonical prompts to (a) test the skill during CI,
(b) populate skill-picker UIs, and (c) document what the skill can do at a glance.
**Prompt files to create:**

| File | Example prompt |
|---|---|
| `prompts/scatter.md` | "Plot highway MPG vs engine displacement, colored by vehicle class, with regression line and outlier labels" |
| `prompts/distribution.md` | "Raincloud plot of penguin body mass by species with pairwise Wilcoxon tests" |
| `prompts/timeseries.md` | "Line chart of life expectancy over time for Asian countries, highlight outliers" |
| `prompts/heatmap.md` | "Correlation heatmap of penguin morphological traits, mask non-significant cells" |
| `prompts/forest.md` | "Forest plot of OLS regression coefficients from mtcars model" |
| `prompts/multipanel.md` | "Three-panel composite figure: scatter, ridge density, and bar chart from penguins" |
| `prompts/survival.md` | "Kaplan-Meier survival curve with risk table and log-rank p-value" |
| `prompts/network.md` | "Network graph of co-authorship data using ggraph with Fruchterman-Reingold layout" |
| `prompts/map.md` | "Choropleth map of a variable by country using geom_sf and viridis fill" |

Each file follows this schema:
```markdown
---
chart_family: scatter
difficulty: intermediate
packages: [ggplot2, ggrepel, ggsci]
---
# Prompt
[The exact prompt text]

# Expected outputs
- Self-contained R script
- Uses colorblind-safe palette
- ggsave() with explicit dimensions
```

---

### T-03 · Create `tests/` directory — skill validation criteria

**Files:** `tests/README.md` + `tests/validation_rules.md` + `tests/checklist_auto.R`
**Why:** Without tests there is no way to verify that a generated script satisfies the
quality bar defined in Section 11 of `plan.md`. Automated rules enable CI gating.
**Contents:**

- `validation_rules.md` — prose description of each rule and how to check it
- `checklist_auto.R` — an R script that parses a generated `.R` file and checks:
  - `library()` calls present
  - `ggsave()` call present with `width`, `height`, `units`, `dpi` args
  - No `setwd()` calls (breaks reproducibility)
  - No `install.packages()` calls (should not auto-install)
  - At least one colorblind-safe palette function referenced
  - `labs(title = ...)` present
  - `labs(x = ..., y = ...)` present (axis labels)

---

### T-04 · Add Section 14 to `plan.md` — Data Ingestion Patterns

**File:** `plan.md`
**Why:** Real-world users never have data in a built-in dataset. The skill currently has
no guidance on loading CSV, Excel, database, or API data before plotting.
**Contents to add:**

- `readr::read_csv()` / `read_tsv()` with column type specification
- `readxl::read_excel()` with sheet and range selection
- `DBI` + `dplyr::tbl()` for database queries
- `httr2` + `jsonlite` for REST API data
- Tidy reshape patterns: `tidyr::pivot_longer()` / `pivot_wider()`
- Date parsing: `lubridate::ymd()`, `parse_date_time()`
- Factor handling: `forcats::fct_reorder()`, `fct_relevel()`, `fct_lump_n()`
- Missing value strategy before plotting

---

### T-05 · Add Section 15 to `plan.md` — Publication Tables

**File:** `plan.md`
**Why:** Papers and reports pair figures with tables. The skill covers plots but has no
table guidance, leaving users to figure out `gt`, `flextable`, or `kableExtra` alone.
**Contents to add:**

- Package decision guide: `gt` (HTML/PDF), `flextable` (Word), `kableExtra` (LaTeX/PDF)
- `gt` worked example: summary statistics table with spanners and footnotes
- `flextable` worked example: regression output table formatted for Word submission
- `gtsummary::tbl_summary()` for clinical/demographic summary tables
- `broom::tidy()` → `gt` pipeline for model output tables
- Column formatting: `fmt_number()`, `fmt_percent()`, `fmt_scientific()`
- Export: `gt::gtsave()` to PNG/PDF/RTF; `flextable::save_as_docx()`

---

### T-06 · Add Section 16 to `plan.md` — Advanced Chart Types

**File:** `plan.md`
**Why:** Sections 3 and 10 cover common chart families but are missing worked examples
for survival curves, network graphs, geographic maps, and alluvial diagrams — all
explicitly listed in the package stack but not demonstrated.
**Examples to add:**

| Chart | Package | Dataset |
|---|---|---|
| Kaplan-Meier survival curve | `survminer` | `survival::lung` |
| Network graph | `ggraph` + `tidygraph` | custom edge list |
| Choropleth map | `geom_sf` + `sf` | `rnaturalearth` world |
| Alluvial / Sankey | `ggalluvial` | `ggalluvial::majors` |
| Waffle chart | `waffle` | custom proportions |
| Ridgeline density | `ggridges` | `gapminder` |

---

## Track 2 · Production Readiness

Tasks required before the skill can be relied on in production contexts.

### T-07 · Rewrite `README.md` — full project documentation

**File:** `README.md`
**Why:** The current README is one line. Users, contributors, and MCP hosts need
full documentation to evaluate and use the skill.
**Sections to include:**

- What this skill does (1-paragraph summary)
- Quick-start: how to load the skill in Claude Code / MCP host
- Trigger keywords (mirror `skill.json`)
- Capability overview (link to plan.md sections)
- Screenshot gallery (6 example plots, one per chart family) — describe images even if not yet rendered
- Package prerequisites (`install.packages(...)` block for the full stack)
- Usage examples (3 prompt → script pairs)
- Output quality guarantees (the 26-point checklist summary)
- Development / contribution instructions (link to CONTRIBUTING.md)
- License badge + License section

---

### T-08 · Create `CHANGELOG.md`

**File:** `CHANGELOG.md`
**Why:** Semantic versioning and a changelog are required for production software.
They let consumers know what changed and when.
**Format:** Keep a Changelog (keepachangelog.com) style, starting at `v1.0.0`.
**Initial entry should document:**
- All 13 original sections of `plan.md`
- All improvements made in this session (Sections 4.3, 5.3–5.6, 8.2–8.3, 9.2, 10.6, expanded Section 11)

---

### T-09 · Create `LICENSE`

**File:** `LICENSE`
**Why:** Without a license, the repository is legally all-rights-reserved by default.
Open-source consumers cannot legally use or adapt the skill specification.
**Recommended:** MIT License (permissive, compatible with commercial use).
**Alternative:** Apache 2.0 (adds explicit patent grant).
**Action:** Choose license, add full license text, add SPDX identifier to README badge.

---

### T-10 · Create `.gitignore`

**File:** `.gitignore`
**Why:** Future contributors will run R locally and generate output files. Without a
`.gitignore`, generated plots, `.Rhistory`, `.RData`, and RStudio project files will
pollute the repository.
**Entries to include:**
```
# R artifacts
.Rhistory
.RData
.Rproj.user/
*.Rproj

# Generated figure outputs
*.png
*.tiff
*.tif
*.pdf
*.svg
*.eps

# OS
.DS_Store
Thumbs.db

# Editor
.vscode/
*.swp
```

---

### T-11 · Pin package versions in `plan.md` Section 2

**File:** `plan.md` — Section 2 (Standard Library Stack)
**Why:** R packages can introduce breaking changes. Pinning the minimum tested version
for each key package lets users reproduce results and diagnose API drift.
**Format:** Add version comment after each `library()` line, e.g.:
```r
library(ggplot2)   # >= 3.5.0  — linewidth arg (replaces size for lines)
library(patchwork) # >= 1.2.0  — plot_annotation tag_prefix support
library(ggtext)    # >= 0.1.2  — element_markdown(), geom_richtext()
library(ragg)      # >= 1.3.0  — AGG text rendering improvements
```
**Also add:** a `sessioninfo::session_info()` snippet at the end of Section 2 so
generated scripts can embed their R + package versions for reproducibility.

---

### T-12 · Expand Section 12 — Edge Cases & Troubleshooting

**File:** `plan.md` — Section 12
**Why:** Current section is 8 bullet points. Need deeper coverage of common failure
modes encountered in production use.
**New cases to add:**
- `geom_smooth()` fails with small n → use `method = "loess"` with `span` argument
- Log scale with zeros → `scale_x_log10()` + `oob = scales::squish_infinite`
- `patchwork` layout breaks when panels have different axis ranges → `plot_layout(axes = "collect")`
- `ggrepel` labels outside plot bounds → `xlim` / `ylim` in `geom_text_repel()`
- `cairo_pdf` not found on Windows → use `pdf()` with `useDingbats = FALSE`
- TIFF files too large → use `compression = "lzw"` and/or reduce DPI
- `ggsave()` cuts off legend → increase `plot.margin` or use `clip = "off"`
- `showtext` renders at wrong DPI → call `showtext_opts(dpi = 300)` before plotting
- Raster vs. vector confusion → decision table: when to use each format
- `coord_flip()` incompatibility with `facet_grid()` → use `scale_y_discrete()` + `aes` reorder instead

---

## Track 3 · GitHub Readiness

Tasks required to publish this as a well-maintained open-source GitHub repository.

### T-13 · Create `.github/ISSUE_TEMPLATE/bug_report.md`

**File:** `.github/ISSUE_TEMPLATE/bug_report.md`
**Why:** Structured issue templates prevent incomplete bug reports and reduce
maintainer back-and-forth.
**Fields to include:**
- R version (`R.version.string`)
- `sessioninfo::session_info()` output
- Which section of `plan.md` the bug is in
- Minimal reproducible example (the generated R script)
- Expected vs. actual output description
- Plot output (screenshot or file attachment)

---

### T-14 · Create `.github/ISSUE_TEMPLATE/feature_request.md`

**File:** `.github/ISSUE_TEMPLATE/feature_request.md`
**Why:** Provides a consistent structure for requesting new chart types, packages,
or worked examples.
**Fields to include:**
- Chart type / package to add
- Analytical goal it serves
- Reference (paper, blog post, or existing implementation)
- Which section of `plan.md` it belongs in
- Draft R code (optional)

---

### T-15 · Create `.github/PULL_REQUEST_TEMPLATE.md`

**File:** `.github/PULL_REQUEST_TEMPLATE.md`
**Why:** Ensures all PRs document what section was changed, why, and what quality
checks were performed before submitting.
**Checklist to include:**
- [ ] Section(s) of `plan.md` changed are identified in the PR title
- [ ] All new R code blocks are fully self-contained (library + data + plot + ggsave)
- [ ] All new code uses a colorblind-safe palette
- [ ] New examples pass the Section 11 quality checklist
- [ ] `CHANGELOG.md` updated with the change under `[Unreleased]`
- [ ] No new external dependencies added without updating Section 2

---

### T-16 · Create `CONTRIBUTING.md`

**File:** `CONTRIBUTING.md`
**Why:** Tells contributors exactly how to propose changes — what's in scope, code
conventions, how to test locally, and the review process.
**Sections to include:**
- What contributions are welcome (mirror CLAUDE.md in-scope list)
- What is out of scope (mirror CLAUDE.md out-of-scope list)
- How to run the validation script (`tests/checklist_auto.R`)
- Code conventions (snake_case, `%>%`, section dividers — mirror CLAUDE.md)
- Branch naming: `<github-username>/<short-description>`
- Commit message convention: `"Sec N: <description>"` e.g. `"Sec 10: Add survival curve example"`
- PR process: fork → branch → PR against `main`

---

### T-17 · Create `.github/workflows/validate.yml` — CI validation

**File:** `.github/workflows/validate.yml`
**Why:** Automated CI catches regressions before merge: malformed YAML front-matter,
broken code block fences, missing `ggsave()` calls, etc.
**Jobs to implement:**

```yaml
jobs:
  validate-skill-yaml:
    # Parse YAML front-matter from plan.md and assert required keys exist
    # (name, description, schema_version)

  lint-code-blocks:
    # Extract all ```r ... ``` blocks from plan.md
    # Check each for: library() calls, no setwd(), balanced braces

  validate-checklist-auto:
    # Run tests/checklist_auto.R against each worked example in Section 10
    # Fail if any example is missing ggsave() or axis labels

  check-links:
    # Validate all internal section cross-references are valid headings
```

**Trigger:** on push and PR to `main`.

---

### T-18 · Create `examples/` directory — standalone R scripts

**Files:** `examples/*.R` — one script per worked example
**Why:** Currently the worked examples live only inside Markdown fences in `plan.md`.
Extracting them as real `.R` files lets users:
- Clone and run them directly
- Use them as CI test fixtures in `validate.yml`
- Reference them in the README gallery

**Files to create** (extracted from plan.md Sections 10.1–10.6):

| File | Source |
|---|---|
| `examples/01_scatter_regression.R` | Section 10.1 |
| `examples/02_raincloud_distributions.R` | Section 10.2 |
| `examples/03_timeseries_highlight.R` | Section 10.3 |
| `examples/04_forest_plot.R` | Section 10.4 |
| `examples/05_multipanel_composite.R` | Section 10.5 |
| `examples/06_correlation_heatmap.R` | Section 10.6 |

Each file must begin with a standardized header:
```r
# ── Title ──────────────────────────────────────────────────────
# [Insight-driven title]
# Source: plan.md Section 10.X
# Packages: [list]
# Output: [filename.tiff], [W] × [H] mm, [DPI] DPI
# ───────────────────────────────────────────────────────────────
```

---

### T-19 · Set up GitHub repository and push

**Why:** The skill currently lives in a local proxy. To be publicly discoverable and
usable via MCP it must be published to GitHub.
**Steps:**
1. Create public GitHub repo `Alex-Zeo/r-high-fidelity-viz` (rename from `R`)
2. Update remote: `git remote set-url origin https://github.com/Alex-Zeo/r-high-fidelity-viz.git`
3. Push `main` branch: `git push -u origin main`
4. Add repository topics on GitHub: `r`, `ggplot2`, `visualization`, `mcp`, `ai-skill`, `tidyverse`
5. Enable GitHub Issues and Discussions
6. Create initial release `v1.0.0` with a tag pointing to the post-this-session commit

---

### T-20 · Publish to MCP skill registry (post-GitHub)

**Why:** After the repo is on GitHub, register it with whatever MCP skill index
is in use so it appears in skill-picker UIs.
**Steps (registry-dependent):**
- Submit `skill.json` URL to registry
- Verify trigger phrases don't conflict with existing skills
- Add registry badge to README

---

## Summary — Module Count by Track

| Track | Tasks | Effort |
|---|---|---|
| MCP Readiness | T-01 → T-06 | 6 tasks |
| Production Readiness | T-07 → T-12 | 6 tasks |
| GitHub Readiness | T-13 → T-20 | 8 tasks |
| **Total** | **20 tasks** | |

### Suggested implementation order

```
Phase 1 (Foundation):   T-09 (LICENSE), T-10 (.gitignore), T-08 (CHANGELOG)
Phase 2 (Docs):         T-07 (README), T-16 (CONTRIBUTING)
Phase 3 (MCP core):     T-01 (skill.json), T-02 (prompts/), T-11 (pin versions)
Phase 4 (Content):      T-04 (Sec 14 data ingestion), T-05 (Sec 15 tables),
                        T-06 (Sec 16 advanced charts), T-12 (Sec 12 edge cases)
Phase 5 (Examples):     T-18 (examples/ scripts), T-03 (tests/)
Phase 6 (GitHub):       T-13, T-14, T-15 (issue/PR templates), T-17 (CI workflow)
Phase 7 (Publish):      T-19 (GitHub push), T-20 (registry)
```
