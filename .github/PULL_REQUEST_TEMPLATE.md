## Summary

What does this PR change and why?

**Section(s) of plan.md changed:**

---

## Type of change

- [ ] Bug fix (incorrect R syntax, outdated API)
- [ ] New worked example (Section 10 or 16)
- [ ] New chart type / package (Section 2 or 3)
- [ ] New troubleshooting entry (Section 12)
- [ ] New data ingestion pattern (Section 14)
- [ ] New table example (Section 15)
- [ ] Documentation / README / CONTRIBUTING
- [ ] Repository tooling (CI, tests, templates)

---

## Quality checklist

For any new or changed R code blocks:

- [ ] Code is **fully self-contained**: `library()`, data prep, plot, `ggsave()` in one script
- [ ] `ggsave()` includes explicit `width`, `height`, `units`, and `dpi`
- [ ] **Colorblind-safe palette** used (viridis, Okabe-Ito, or ggsci)
- [ ] **Title** describes the insight, not the chart type
- [ ] **Axis labels** include units in parentheses; sentence case
- [ ] No `setwd()` calls
- [ ] No `install.packages()` calls
- [ ] Passed `tests/checklist_auto.R` (paste output below)

**checklist_auto.R output:**
```
paste output here
```

---

## Changelog

- [ ] `CHANGELOG.md` updated under `[Unreleased]`

---

## Related issues

Closes #
