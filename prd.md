# BMW Digital Intelligence Audit
## Project Requirements Document
### Version 3.0 — As Built

---

**Author:** Sara Cruz
**Status:** Executed v3.0
**Date:** June 2026
**Repository:** https://github.com/saramscruz/bmw-digital-audit
**Intended audience:** Portfolio; Digital Analyst hiring managers in automotive digital platforms

---

## Version History

| Version | Status | What changed |
|---------|--------|-------------|
| v1.0 | Specification | Initial framework — data problem hidden, SQL tutorial-level |
| v2.0 | Specification | Rebuilt on honest foundations — data problem named, SQL strengthened |
| v3.0 | **Executed** | Project built, SQL run, results saved, dashboard live, repo published |

---

## What This Project Is — And Is Not

This project is a **competitive digital intelligence audit** of BMW's publicly observable digital presence, benchmarked against verified industry data and demonstrated with executed SQL analysis.

It is **not** an analysis of BMW's internal analytics. No one outside BMW has access to their GA4 or Adobe Analytics backend. Any project claiming otherwise is fabricating data.

What this project does instead is more honest and more useful as a portfolio demonstration: it shows how a skilled analyst extracts signal from publicly available sources, constructs a rigorous measurement framework, executes real SQL queries, and produces actionable insight — without needing privileged access.

---

## What Was Actually Built

### Repository structure — as committed

```
bmw-digital-audit/
├── README.md
├── PRD.md
├── data-sources.md
├── framework/
│   ├── kpi-framework.md
│   ├── event-taxonomy.md
│   └── funnel-model-bmw.md
├── analysis/
│   ├── competitive-signals.md        ← includes BEV growth argument
│   ├── benchmark-context.md
│   └── insight-brief-bmw.md          ← rewritten with real query results
├── sql/
│   ├── A-multi-session-path.sql      ← executed; results saved
│   ├── B-funnel-dropoff.sql          ← executed; results saved
│   ├── C-device-channel-interaction.sql  ← executed; results saved
│   └── D-return-visitor-lift.sql     ← executed; results saved
├── dashboard/
│   ├── looker-studio-link.md         ← live dashboard link
│   └── screenshot-bmw.png
└── outputs/
    └── query-results/
        ├── A-results.csv             ← real data
        ├── B-results.csv             ← real data
        ├── C-results.csv             ← real data
        └── D-results.csv             ← real data
```

**Commit:** f2d62c6 — 15 files, 1,524 insertions
**Published:** github.com/saramscruz/bmw-digital-audit

---

## Data Sources

Every data point in this project comes from a named, verifiable source.

| Source | What it provides | Reliability | Access |
|--------|-----------------|-------------|--------|
| Google BigQuery GA4 public dataset | Executed SQL analysis — 354,857 sessions, Nov 2020–Jan 2021 | Real data, wrong domain. Methodology demonstration only. | Free via BigQuery sandbox |
| BMW Group Annual Report 2024 | BEV deliveries (426,594, +13.5% YoY), total deliveries, digital strategy commitments | High — audited | bmwgroup.com/en/report/2024 |
| BMW press statements | Digital sales strategy, triple-digit million annual investment, online purchase rollout | Primary source; PR-framed | press.bmwgroup.com |
| Cox Automotive 2024 Car Buyer Journey Study | 14+ hours online research before dealer contact; 1.4 dealer visits avg. | Published industry research | Publicly cited |
| Ruler Analytics 2026 | Automotive direct traffic conversion: 9.8% | Published benchmark | ruleranalytics.com |
| Demand Local / WordStream 2024 | Automotive website CVR: 2–5% avg; top performers 8–16% | Published benchmarks | demandlocal.com |
| SimilarWeb / Semrush free tier | bmw.com channel split (46.42% direct, 33.39% organic); bmwusa.com bounce rate 51.62% | Estimated ±20–30% | similarweb.com; semrush.com |

**Transparency rule:** every number is labelled with its source and confidence level throughout all project files.

---

## Deliverable 1 — Measurement Framework

### Purpose
Define what a Digital Analyst would measure on bmw.com with full GA4 access. Solution design thinking before any data is touched.

### BMW Customer Journey (Publicly Observable)

```
Stage 0 — Entry
  Channels: direct (46.42%), organic search (33.39%), paid, referral
  Business question: Which channels bring high-intent visitors?

Stage 1 — Model Discovery
  Pages: /en/vehicles/series/ and model overview pages
  Business question: Which models attract the most research interest?

Stage 2 — Model Detail Engagement
  Specs, media, pricing on individual model pages
  Business question: Do visitors engage or bounce immediately?

Stage 3 — Configurator Entry
  User clicks "Configure" — highest-intent pre-lead action
  Business question: What % of model-page visitors open the configurator?

Stage 4 — Configuration Progression
  Steps: engine → exterior → interior → options → packages
  Business question: At which step does the largest drop-off occur?

Stage 5 — Configurator Completion
  User reaches summary screen
  Business question: What is the configurator completion rate?

Stage 6 — Lead Action
  CTAs: "Request test drive" / "Contact dealer" / "Order online"
  Business question: What % of completed configurations become leads?

Stage 7 — Lead Confirmation
  Confirmation page reached
  Business question: What is the end-to-end conversion rate?
```

### KPI Framework

#### Tier 1 — Primary KPIs

| KPI | Formula | Why it matters |
|-----|---------|----------------|
| End-to-End Conversion Rate | Lead Confirmations / Total Sessions | Headline digital sales contribution |
| Configurator Entry Rate | Configurator Opens / Model Page Views | Does the product page drive intent? |
| Configurator Completion Rate | Summary Views / Configurator Opens | Measures configurator UX quality |
| Lead Generation Rate | Lead Actions / Summary Views | Does intent convert to qualified contact? |

#### Tier 2 — Diagnostic KPIs

| KPI | What it diagnoses |
|-----|------------------|
| Bounce Rate by Landing Page | Is entry traffic misaligned with content? |
| Device Conversion Gap | Is mobile creating friction? |
| Channel-to-Lead Ratio | Which channels produce qualified visitors? |
| Return Visitor Rate to Configurator | Are users returning to complete saved configurations? |
| Time-to-Configure | Is the configurator too long or complex? |

#### Tier 3 — Segmentation Dimensions

Every KPI breakable by: market/country, device category, acquisition channel, model series, user type (new vs. returning), BEV vs. ICE.

### Event Taxonomy

| Event | Trigger | Mandatory Parameters |
|-------|---------|---------------------|
| `model_page_view` | Model detail page load | `model_name`, `model_series`, `fuel_type`, `market` |
| `configurator_start` | Configurator opens | `model_name`, `entry_point` |
| `configurator_step_complete` | Step advanced | `step_number`, `step_name`, `selection_made` |
| `configurator_complete` | Summary reached | `model_name`, `total_price_eur`, `fuel_type` |
| `lead_cta_click` | Lead CTA clicked | `cta_type`, `model_name` |
| `lead_form_submit` | Form submitted | `lead_type`, `model_name`, `market` |

---

## Deliverable 2 — Competitive Signal Analysis

### Traffic Profile (bmw.com)

| Metric | Value | Source | Confidence |
|--------|-------|---------|------------|
| Direct traffic share | 46.42% | Semrush | Estimated |
| Organic search share | 33.39% | Semrush | Estimated |
| bmwusa.com monthly visits | ~6.6M (Aug 2024) | SimilarWeb | Estimated |
| mercedes-benz.com monthly visits | ~7.3M (Aug 2024) | SimilarWeb | Estimated |
| bmwusa.com bounce rate | 51.62% (Dec 2025) | Semrush | Estimated |

### BMW Strategic Context

| Fact | Value | Source | Confidence |
|------|-------|---------|------------|
| Total 2024 deliveries | 2,450,804 (−4% YoY) | BMW Annual Report 2024 | High |
| BEV deliveries 2024 | 426,594 (+13.5% YoY) | BMW Annual Report 2024 | High |
| BEV share of total | 17.4% — highest ever | BMW Annual Report 2024 | High |
| Digital investment | Triple-digit millions annually | BMW press statement | High |
| Online research before dealer | 97% of buyers | BMW press statement | High |
| Avg. dealer visits before purchase | 1.4 | BMW / industry data | High |
| Online research time | 14+ hours | Cox Automotive 2024 | High |

### The BEV Growth Argument

BMW's fastest-growing segment — BEV, up 13.5% in 2024 — is also its most research-intensive. EV buyers face decisions ICE buyers do not: range, charging infrastructure, home installation, software packages. This extends the research window beyond the automotive average and increases configurator usage. The mobile paradox therefore carries greater commercial weight for BMW than for most peers. Every percentage point of mobile drop-off in the configurator represents lost leads in the highest-growth segment. This is not a UX problem. It is a revenue risk with a measurable trajectory.

---

## Deliverable 3 — SQL Analysis

### Dataset

**Source:** `bigquery-public-data.ga4_obfuscated_sample_ecommerce`
**Date range:** 20201101–20210131
**Total sessions:** 354,857
**Total users:** 270,154
**Tool:** Google BigQuery (free sandbox tier)

**Proxy note:** This is Google Merchandise Store data — a shop selling branded merchandise. It is not BMW data. Patterns are directionally valid for high-consideration purchase funnels. Specific rates are not transferable to BMW and are not claimed to be.

### Query A — Multi-Session Path to Conversion

**Business question:** Do converting users require more sessions, and how long does conversion take?

**Results:**

| ever_converted | users | avg_sessions | median_sessions | avg_hours_to_convert |
|---------------|-------|-------------|----------------|---------------------|
| 1 (converted) | 4,419 | 3.6 | 3 | 129.2 |
| 0 (did not convert) | 265,735 | 1.3 | 1 | null |

**Finding:** Converters took a median of 3 sessions and an average of 129 hours (5.4 days) from first visit to purchase. Non-converters averaged 1.3 sessions and did not return. Last-click attribution misattributes the majority of these conversions.

**BMW implication:** If a Google Merchandise Store customer takes 3 sessions and 5 days to buy a €30 t-shirt, a BMW configurator user making a €60,000 decision almost certainly takes more. Standard 24-hour retargeting windows discard most eventual converters before they purchase.

---

### Query B — Funnel Drop-Off

**Business question:** At which stage does the largest volume of users exit?

**Results:**

| Stage | Sessions | % of entry | Step retention |
|-------|----------|------------|----------------|
| S0 Session Start | 354,857 | 100.0% | — |
| S2 Product View | 77,020 | 21.7% | — |
| S3 Add to Cart | 15,188 | 4.3% | 19.7% |
| S4 Begin Checkout | 11,106 | 3.1% | 73.1% |
| S5 Payment Info | 6,815 | 1.9% | 61.4% |
| S6 Purchase | 4,848 | 1.4% | 71.1% |

Note: S1 (Browsed Catalogue) showed only 59 sessions — a dataset anomaly, not a real finding. Excluded from analysis.

**Finding:** The largest drop-off is S2→S3: only 19.7% of product viewers add to cart. Every other transition retains at least 61%. One step accounts for the majority of funnel loss; everything downstream is secondary.

**BMW implication:** The equivalent transition is model page to configurator entry. If BMW's configurator entry rate mirrors this pattern, optimising that single step produces more incremental leads than any combination of downstream improvements.

---

### Query C — Device × Channel Interaction

**Business question:** Is the mobile conversion gap uniform, or channel-specific?

**Key results:**

| Device | Channel | CVR from product view |
|--------|---------|----------------------|
| desktop | referral | 7.01% |
| desktop | organic | 4.86% |
| desktop | cpc | 5.06% |
| mobile | referral | 7.53% |
| mobile | organic | 5.44% |
| mobile | cpc | 4.28% |

Note: "data deleted" rows excluded — GA4 privacy artefact, not a real channel.

**Finding:** The mobile gap is channel-specific, not universal. Mobile referral outperforms desktop referral (7.53% vs 7.01%). The gap is concentrated on CPC: mobile 4.28% vs desktop 5.06%. Treating "mobile" as a single problem produces fixes in the wrong places.

**BMW implication:** The paid mobile landing experience — not the configurator, not the model page broadly — is where the gap lives. A targeted paid mobile landing page test is the highest-ROI starting point.

---

### Query D — Return Visitor Lift

**Business question:** Do returning users convert at a higher rate, and does the lift continue with each visit?

**Results:**

| Visit recency | Sessions | % viewed product | % began checkout | Conversion rate |
|--------------|----------|-----------------|-----------------|----------------|
| 1st session | 270,154 | 20.5% | 2.4% | 0.78% |
| 2nd session | 47,364 | 19.7% | 3.6% | 2.01% |
| 3rd–5th session | 33,017 | 28.1% | 6.5% | 3.99% |
| 6th+ session | 9,594 | 31.3% | 7.6% | 4.94% |

**Finding:** Conversion rate grows monotonically with session number, from 0.78% on the first visit to 4.94% on the sixth or more — a 6.3x lift. The rate does not plateau; every return visit adds measurable conversion probability.

**BMW implication:** Re-engagement campaigns targeting configurator abandoners should use a 5–7 day window, not the standard 24 hours. Users who have visited 3+ times without converting are not lost — they are close. This is a campaign settings change, not a creative problem, and it costs nothing to test.

---

## Deliverable 4 — Dashboard

**Tool:** Looker Studio (Data Studio)
**Connection:** Live BigQuery custom SQL queries — not static CSV data
**Status:** Built and published

### Panels

| Panel | Chart type | Data | Key annotation |
|-------|-----------|------|----------------|
| Return visitor lift | Line chart | Query D | 0.78% → 4.94% across session recency — 6.3x lift |
| Funnel drop-off | Bar chart | Query B | Largest drop at S2→S3: 19.7% retention |
| Device × channel matrix | Grouped bar | Query C | Mobile CPC gap (4.28% vs 5.06%); mobile referral outperforms desktop |
| Transparency statement | Text | — | Data is Google Merchandise Store; methodology demonstration only |

**Design decisions:**
- Single page, single story
- BMW blue (#1C69D4) as accent colour throughout
- Every panel has a one-sentence annotation stating the business implication
- Query A finding embedded in line chart annotation rather than as a separate panel
- Transparency statement prominent — not hidden in small print

---

## Insight Brief — Key Findings

*Full brief in analysis/insight-brief-bmw.md. Summary of positions taken:*

**Position 1:** One funnel step (product view → next action) accounts for the majority of conversion loss. Optimising it produces more incremental leads than any combination of downstream improvements.

**Position 2:** The mobile problem is not mobile — it is paid mobile. Mobile referral already outperforms desktop. Fix CPC landing pages, not the entire mobile experience.

**Position 3:** Re-engagement windows are too short. Converters take 129 hours and 3 sessions. A 24-hour retargeting window discards most eventual buyers before they convert. Switch to 5–7 days.

**Position 4:** BMW's BEV growth (426,594 units, +13.5% YoY) makes the configurator's mobile performance a revenue risk, not just a UX issue. BEV buyers are the most research-intensive segment and the fastest-growing one.

---

## What Changes With Real BMW Data

With access to BMW's GA4 backend, every inference in this project becomes a measurement:

| This project infers | Real access would measure |
|--------------------|--------------------------|
| Configurator entry rate mirrors product-to-cart drop-off | Exact configurator entry rate by model, device, channel |
| Multi-session journey is longer for BMW than merchandise store | Actual median sessions and hours-to-lead for BMW configurator users |
| Mobile CPC gap exists in configurator flow | Specific configurator step where mobile exits on paid traffic |
| BEV configurator has higher mobile friction | Completion rate segmented by BEV vs ICE model series |
| 5–7 day re-engagement window is optimal | Actual conversion window measured from configurator start to lead submission |

BMW is already collecting this data. Running these queries takes hours.

---

## Reproducibility — What Transfers to Other Brands

**Reusable without changes:**
- KPI framework (Tier 1/2/3)
- Event taxonomy (standard GA4)
- All four SQL queries and their results
- Insight brief structure (Know / Suggests / Test / Need)
- Dashboard template (label and colour changes only)

**Requires brand-specific research per new brand:**
- Funnel stage mapping from UI observation (~1 hour)
- SimilarWeb/Semrush data pull (~30 minutes)
- Annual report and press statement research (~1 hour)

**Honest time estimate per new brand:** 3–4 hours.

**Remaining BMW-specific work not yet completed:**
- BMW.com funnel observation — real page paths, step names, CTA labels
- SimilarWeb live data pull for bmw.com — current traffic and device split
- BMW Annual Report deep-dive — additional digital figures beyond BEV data

---

## Project Status

| Component | Status |
|-----------|--------|
| Repository structure | ✅ Complete — 15 files committed |
| Measurement framework | ✅ Complete |
| Event taxonomy | ✅ Complete |
| Competitive signals analysis | ✅ Complete (SimilarWeb estimates + BMW Annual Report) |
| Benchmark context | ✅ Complete |
| SQL queries (all 4) | ✅ Executed on BigQuery |
| Query results (all 4 CSVs) | ✅ Saved in outputs/ |
| Insight brief | ✅ Complete — written with real query results |
| Looker Studio dashboard | ✅ Live — 3 charts + transparency panel |
| GitHub repository | ✅ Public — github.com/saramscruz/bmw-digital-audit |
| BMW.com funnel observation | ⏳ Pending |
| SimilarWeb live data pull | ⏳ Pending |
| Annual report deep-dive | ⏳ Pending |
| LinkedIn post | ⏳ Pending |

---

*Version 3.0 — As built. All SQL outputs sourced from Google's publicly available GA4 sample dataset. All competitive intelligence sourced from SimilarWeb, Semrush, and published industry reports, labelled as estimated. No proprietary BMW data was used or accessed.*
