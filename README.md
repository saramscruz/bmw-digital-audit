# BMW Digital Intelligence Audit

**Author:** Saram Cruz  
**Version:** 2.0  
**Date:** June 2026  
**Status:** Complete  
**Audience:** Portfolio — Digital Analyst hiring managers in automotive digital platforms

---

## What This Project Is

A **competitive digital intelligence audit** of BMW's publicly observable digital presence, benchmarked against verified industry data.

It is **not** an analysis of BMW's internal analytics. No one outside BMW has access to their GA4 or Adobe Analytics backend. What this project does instead is more honest and more useful as a portfolio demonstration: it shows how a skilled analyst extracts signal from publicly available sources, constructs a rigorous measurement framework, and produces actionable insight — without privileged access. This is precisely the thinking required in a Digital Analyst role: knowing what the data means, where it comes from, and where its limits are.

---

## Quick Start — Running the SQL

1. Open [BigQuery Sandbox](https://console.cloud.google.com/bigquery) — free; no billing required for ≤10 GB/month
2. Paste any query from the `sql/` directory directly into the editor
3. All queries target `bigquery-public-data.ga4_obfuscated_sample_ecommerce`
4. Run; export results as CSV to `outputs/query-results/`

> **Label:** All SQL output is from Google's GA4 sample dataset (Google Merchandise Store). It demonstrates analytical technique. It produces no findings about BMW.

---

## Data Sources Summary

| Source | What it provides | Confidence |
|--------|-----------------|------------|
| SimilarWeb (free tier) | bmw.com traffic estimates, channel mix, bounce rate, device split | Estimated |
| Semrush (free tier) | Organic keywords, landing pages, competitor traffic comparison | Estimated |
| BMW Group Annual Report 2024 | Global deliveries, BEV share, revenue | High |
| BMW press statements | Digital strategy, online sales rollout, configurator investment | High (stated intent) |
| Cox Automotive 2024 Car Buyer Journey Study | 14+ hours research before dealer; 1.4 avg dealer visits | High |
| Ruler Analytics 2026 | Automotive direct traffic conversion: 9.8% | Benchmark |
| Demand Local / WordStream 2024 | Automotive CVR: 2–5% avg, 8–16% top performers | Benchmark |
| Google BigQuery GA4 public dataset | Real GA4 schema — SQL technique demonstration only | Real schema, wrong domain |

Full citations with URLs: [data-sources.md](data-sources.md)

---

## Project Structure

```
bmw-digital-audit/
├── README.md                              # This file
├── data-sources.md                        # Every source cited with URL and access notes
├── framework/
│   ├── kpi-framework.md                   # Tier 1/2/3 KPIs — reusable across brands
│   ├── event-taxonomy.md                  # GA4 event specification
│   └── funnel-model-bmw.md               # BMW funnel stages from UI observation
├── analysis/
│   ├── competitive-signals.md             # SimilarWeb/Semrush findings with source notes
│   ├── benchmark-context.md               # Industry benchmarks with citations
│   └── insight-brief-bmw.md              # The strategic memo
├── sql/
│   ├── A-multi-session-path.sql           # Do converters take more sessions?
│   ├── B-funnel-dropoff.sql               # Where does the funnel break?
│   ├── C-device-channel-interaction.sql   # Is mobile underperformance uniform?
│   └── D-return-visitor-lift.sql         # When does return visit lift kick in?
├── dashboard/
│   └── looker-studio-link.md              # Dashboard spec and shareable link
└── outputs/
    └── query-results/                     # CSV exports from BigQuery (add manually)
```

---

## Three Deliverables

| Deliverable | Files | What it demonstrates |
|-------------|-------|---------------------|
| 1 — Measurement Framework | `framework/` | Designing measurement systems before touching data |
| 2 — Competitive Signal Analysis | `analysis/competitive-signals.md`, `analysis/benchmark-context.md` | Extracting signal from public sources with calibrated confidence |
| 3 — Insight Brief + SQL | `analysis/insight-brief-bmw.md`, `sql/` | Translating analysis into business language, backed by technical depth |

---

## What This Project Demonstrates

| What the hiring manager sees | What they infer |
|------------------------------|----------------|
| Explicitly sourced, cited data | Will not invent numbers in a stakeholder presentation |
| Confidence levels on every claim | Understands what data can and cannot prove |
| Business questions stated before SQL | Thinks from the business back to the data |
| Statistical significance filter in Query C | Understands that small-sample rates are noise, not signal |
| Multi-session analysis design | Understands attribution in high-consideration purchase journeys |
| Transparency panel in dashboard | Will tell a stakeholder when something is unknown |
| Reusable framework structure | Builds systems, not one-off analyses |

---

## Reproducibility

**Reusable without changes across brands:**
- KPI framework (Tier 1/2/3 structure)
- Event taxonomy (standard GA4 — brand-agnostic)
- All four SQL queries
- Insight brief structure (Know / Suggests / Test / Need)
- Dashboard template (label changes only)

**Requires brand-specific work per new brand:**
- Funnel stage mapping from UI observation (~1 hour)
- SimilarWeb/Semrush data collection for that domain (~30 minutes)
- Brand-specific public statement research (~1 hour)

Estimated time per new brand after BMW pilot: **3–4 hours**.

---

*All SQL outputs are sourced from Google's publicly available GA4 sample dataset. All competitive intelligence is sourced from SimilarWeb, Semrush, and published industry reports, labelled as estimated. No proprietary BMW data was used or accessed. Version 2.0.*
