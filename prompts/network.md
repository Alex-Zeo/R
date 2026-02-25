---
chart_family: network
difficulty: advanced
packages: [ggraph, tidygraph]
dataset: custom edge list
sections: [3, 16]
---

# Prompt

Network graph visualizing co-authorship or directed relationships between nodes.
Use Fruchterman-Reingold layout. Node size proportional to degree centrality.
Edge width proportional to weight. Color nodes by group/community membership.
Use a colorblind-safe qualitative palette.

# Expected outputs

- Fully self-contained R script
- A `tibble` edge list with columns `from`, `to`, `weight`; node attributes with `group`
- `tidygraph::as_tbl_graph()` to build the graph object
- `tidygraph::mutate(degree = centrality_degree())` for node sizing
- `ggraph(layout = "fr")` with Fruchterman-Reingold layout
- `geom_edge_link(aes(width = weight), alpha = 0.4)` for edges
- `geom_node_point(aes(size = degree, color = group))`
- `geom_node_text(aes(label = name), repel = TRUE, size = 3)`
- `scale_color_manual()` with Okabe-Ito or `ggsci` colorblind-safe palette
- `scale_edge_width_continuous(range = c(0.3, 2))`
- Insight-driven title
- `ggsave()` with explicit dimensions

# Reference

See `plan.md` Section 16 and `examples/08_network_graph.R` (if present).
