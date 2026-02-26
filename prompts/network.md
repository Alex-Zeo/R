---
chart_family: network
difficulty: advanced
packages: [ggraph, tidygraph, graphlayouts]
dataset: custom edge list
sections: [3, 16]
---

# Prompt

Force-directed network graph visualizing co-occurrence or collaboration relationships
between nodes. Use stress majorization layout for deterministic, high-quality positioning.
Node size proportional to degree centrality. Edge width proportional to weight. Color
nodes by group/community membership. Use a colorblind-safe qualitative palette.

# Network implementation rules

1. **Layout** — default to `layout = "stress"` (stress majorization from graphlayouts).
   It is deterministic, faster than KK, and higher quality than FR for most graphs.
   Use `"fr"` only for quick exploration; avoid `"kk"` for >500 nodes.
2. **Edge rendering** — use `geom_edge_link0()` (the `0` variant) for production.
   It uses native grid grobs without interpolating ~100 points per edge, giving smaller
   file sizes and faster rendering. Only use `geom_edge_link()` when you need gradient
   coloring along the edge path.
3. **Edge alpha** — set `0.1-0.3` for dense networks (>50 edges); `0.3-0.5` for sparse.
   Lower alpha reveals structural density without obscuring nodes.
4. **Node shape** — use `shape = 21` (filled circle with border) to separate `fill`
   (community/group) from `colour` (border). Stroke = 0.3-0.5.
5. **Node sizing** — map to `centrality_degree()`, `centrality_pagerank()`, or
   `centrality_betweenness()` inline via tidygraph. Always constrain with
   `scale_size(range = c(min, max))`.
6. **Label filtering** — never label all nodes. Filter to top-N by centrality using
   the `filter` aesthetic: `aes(label = name, filter = rank(desc(degree)) <= 15)`.
   Always set `repel = TRUE` and `max.overlaps = 20`.
7. **Large networks (>100 nodes)** — use backbone extraction (`layout_as_backbone()`),
   k-core filtering, or Louvain community detection + faceting to avoid hairball layouts.
8. **`coord_fixed()`** — always include to preserve distance relationships from the
   layout algorithm.
9. **Legend** — suppress edge width/alpha legends (rarely informative). Use
   `override.aes` in `guides()` to make legend symbols visible at adequate size.

# Expected outputs

- Fully self-contained R script
- `tidygraph::tbl_graph()` or `as_tbl_graph()` for graph construction
- `tidygraph::mutate()` with inline `centrality_degree()` or `centrality_pagerank()`
- `ggraph(layout = "stress")` — deterministic stress majorization
- `geom_edge_link0()` with `edge_alpha = 0.2-0.3`, `edge_colour` from brand tokens
- `geom_node_point()` with `shape = 21`, `aes(size = degree, fill = group)`
- `geom_node_text()` with `repel = TRUE`, `filter` aesthetic for top-N labels
- `scale_fill_manual()` with colorblind-safe palette (Okabe-Ito or brand tokens)
- `scale_size_continuous(range = c(2, 10))` for node size
- `scale_edge_linewidth_continuous(guide = "none")` for edges
- `coord_fixed()` to preserve layout geometry
- Insight-driven title
- `ggsave()` with explicit dimensions and DPI

# Reference

See `plan.md` Section 16.2.
