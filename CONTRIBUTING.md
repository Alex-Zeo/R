# Contributing to r-high-fidelity-viz

Thank you for helping improve this skill. This document explains what contributions
are welcome, how to make them, and what quality bar your changes must meet.

---

## What Is In Scope

- Adding new geom/package entries to the library stack (Section 2)
- Expanding the plot selection tables (Section 3) with new chart types
- Adding new worked examples to Sections 10 or 16
- Updating the color system when new packages become available
- Correcting R syntax or outdated API usage in any code block
- Expanding or fixing the troubleshooting section (Section 12)
- Improving the data ingestion patterns (Section 14)
- Adding table examples in Section 15
- Fixing typos, unclear wording, or broken Markdown formatting

## What Is Out of Scope

- Converting this repository into an R package (no DESCRIPTION/NAMESPACE)
- Adding a build/test pipeline beyond the existing validation script
- Adding interactive widget generation — explicitly excluded in Section 13
- Changing the YAML front-matter `name` or `description` without strong justification
- Adding non-R visualization libraries (Python, JavaScript, etc.)

---

## Code Conventions

All R code blocks in `plan.md` must follow these conventions exactly.

### Naming

- Functions and variables: `snake_case` (e.g., `theme_pub`, `body_mass_g`)
- Package names: lowercase (e.g., `tidyverse`, `ggplot2`, `patchwork`)

### Style

- Pipe operator: `%>%` (magrittr/tidyverse style, not `|>`)
- Layer separator: one `+` per line, aligned
- Section dividers: `# ── Section Name ──────────────`
- All code blocks must be **fully self-contained**: `library()` calls, data prep,
  plot construction, and `ggsave()` in a single script

### Preferred Packages (by role)

| Role | Use | Avoid |
|---|---|---|
| Multi-panel layout | `patchwork` | `cowplot`, `gridExtra` |
| Non-overlapping labels | `ggrepel` | manual `geom_text` positioning |
| Sequential color | `viridis` | rainbow, jet |
| Discrete color | `ggsci` (NPG/AAAS) or Okabe-Ito | random `scale_color_manual` |
| Distribution + raw data | `ggrain` (raincloud) | bare boxplots |
| Raster export | `ragg::agg_png` | base `png()` device |

### Quality Bar for New Code Examples

Every new code block must pass the checklist in Section 11 of `plan.md`:

- [ ] Title describes the *insight*, not the chart type
- [ ] Axis labels include units in parentheses; sentence case
- [ ] Color palette is colorblind-safe
- [ ] Export uses explicit `width`, `height`, `units`, `dpi`, and correct format
- [ ] No 3D effects, no excessive gridlines, no chartjunk
- [ ] No `setwd()` calls
- [ ] No `install.packages()` calls

---

## How to Validate Your Changes

Run the automated validation script against any new or changed example script:

```r
source("tests/checklist_auto.R")
validate_script("examples/your_new_example.R")
```

The script checks for `library()` calls, `ggsave()` with all required arguments,
absence of `setwd()`, presence of axis labels and a colorblind-safe palette call.

---

## Branch Naming

```
<github-username>/<short-description>
```

Examples:
- `alice/add-waffle-chart-example`
- `bob/fix-ggcorrplot-api`
- `carol/sec12-log-scale-troubleshooting`

---

## Commit Message Convention

Format: `Sec N: <imperative description>`

Examples:
```
Sec 10: Add Kaplan-Meier survival curve worked example
Sec 12: Add geom_smooth small-n troubleshooting entry
Sec 2: Pin ggplot2 >= 3.5.0 for linewidth argument
Sec 3: Add treemap and waffle to composition chart table
```

---

## Pull Request Process

1. Fork the repository
2. Create a branch from `main` following the naming convention above
3. Make your changes in `plan.md` (and `examples/` if adding a script)
4. Run `tests/checklist_auto.R` on any new/changed R code
5. Update `CHANGELOG.md` under the `[Unreleased]` section
6. Open a PR against `main` and fill out the PR template

PRs that add new content without updating `CHANGELOG.md` will be asked to do so
before merge.

---

## Review Criteria

Reviewers will check:

1. **Correctness** — does the R code run without errors using the specified packages?
2. **Conventions** — does it follow the style guide above?
3. **Quality checklist** — does the example pass all 26 points?
4. **Scope** — is this change in scope per the list above?
5. **Changelog** — is `CHANGELOG.md` updated?
