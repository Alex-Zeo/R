# Changelog

All notable changes to **r-high-fidelity-viz** are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versions follow [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

### Added
- `skill.json` MCP manifest with trigger phrases, capabilities, and schema version
- `prompts/` directory with 9 curated example prompts (one per chart family)
- `tests/` directory with validation rules and `checklist_auto.R`
- `examples/` directory with 6 standalone, directly-runnable R scripts
- `.github/` directory: issue templates, PR template, CI validation workflow
- `CONTRIBUTING.md` — contribution guidelines and code conventions
- `CHANGELOG.md` — this file
- `LICENSE` — MIT License
- `.gitignore` — R artifacts, generated figures, OS/editor files
- `plan.md` Section 14: Data Ingestion Patterns
- `plan.md` Section 15: Publication Tables (`gt`, `flextable`, `gtsummary`)
- `plan.md` Section 16: Advanced Chart Types (survival, network, map, alluvial, waffle, ridgeline)
- `plan.md` Section 2: package version pins and `sessioninfo` reproducibility snippet
- `plan.md` Section 12: expanded troubleshooting (10 new failure modes)

---

## [1.0.0] — 2026-02-25

Initial release of the **r-high-fidelity-viz** skill specification.

### Added

**Core skill document (`plan.md`):**

- **Section 1 · Core Philosophy** — four guiding principles: Grammar of Graphics first,
  minimal but precise, accessible by default, fully reproducible
- **Section 2 · Standard Library Stack** — 28 vetted R packages organized by role,
  with `library()` calls and comments covering core, layout, labels, color,
  themes, statistical visualization, extensions, and export
- **Section 3 · Plot Selection Guide** — tables mapping analytical goals to geoms/functions
  across 7 chart families: comparison, distribution, correlation, composition,
  geospatial, time series, and statistical
- **Section 4 · Color System** — colorblind-safe palette principles; Okabe-Ito
  palette; `scale_*` quick-reference block for viridis, RColorBrewer, ggsci, and
  custom palettes
- **Section 5 · Theme & Typography System** — custom `theme_pub()` function,
  pre-built theme comparison table, typography rules, `ggtext` rich-text patterns
- **Section 6 · Annotation Best Practices** — `ggrepel` patterns, reference lines,
  region highlights, statistical annotations
- **Section 7 · Scale & Axis Formatting** — `scales::` formatting, log/date axes,
  `coord_cartesian()` vs `ylim()`, discrete axis reordering
- **Section 8 · Multi-Panel Composition** — `patchwork` operators,
  `plot_annotation()`, legend collection, insets; small-multiples decision tree;
  multi-figure consistency guide
- **Section 9 · Export Settings** — `ggsave()` recipes for PNG/TIFF/PDF/SVG;
  size guidelines table; journal-specific presets for Nature, Science, Cell,
  PLOS, Lancet, JAMA, NEJM with `save_journal_fig()` helper
- **Section 10 · Complete Worked Examples** — 5 fully self-contained, copy-pasteable
  R scripts:
  - 10.1 Publication scatter with regression + annotation (mpg dataset)
  - 10.2 Raincloud plot with pairwise Wilcoxon tests (palmerpenguins)
  - 10.3 Faceted time series with highlight (gapminder)
  - 10.4 Forest plot of OLS regression coefficients (mtcars)
  - 10.5 Multi-panel composite figure (palmerpenguins, patchwork, ggridges)
  - 10.6 Annotated correlation heatmap (palmerpenguins, ggcorrplot)
- **Section 11 · Quality Checklist** — 26-point checklist across 4 categories:
  Content & Insight, Color & Accessibility, Typography & Layout, Export & Reproducibility
- **Section 12 · Edge Cases & Troubleshooting** — solutions for overplotting,
  long labels, too many categories, date axis crowding, legend overlap, font issues,
  missing values, and `ylim()` vs `coord_cartesian()` pitfall
- **Section 13 · What This Skill Cannot Do** — explicit capability limitations

**Repository:**
- `README.md` — one-line project description
- `CLAUDE.md` — AI assistant guide covering repo structure, development workflow,
  code conventions, and skill usage instructions

[Unreleased]: https://github.com/Alex-Zeo/r-high-fidelity-viz/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/Alex-Zeo/r-high-fidelity-viz/releases/tag/v1.0.0
