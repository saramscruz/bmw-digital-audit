# BMW Digital Intelligence Audit
## A Competitive Web Analytics Project — Full Specification
### Version 2.0 — Built on Real, Verifiable Data

---

**Author:** [Your Name]  
**Status:** Specification v2.0  
**Date:** June 2026  
**Intended audience:** Portfolio; Digital Analyst hiring managers in automotive digital platforms

---

## What This Project Is — And Is Not

This project is a **competitive digital intelligence audit** of BMW's publicly observable digital presence, benchmarked against verified industry data.

It is **not** an analysis of BMW's internal analytics. No one outside BMW has access to their GA4 or Adobe Analytics backend. Any project claiming otherwise is fabricating data.

What this project does instead is more honest and, arguably, more useful as a portfolio demonstration: it shows how a skilled analyst extracts signal from publicly available sources, constructs a rigorous measurement framework, and produces actionable insight — without needing privileged access. This is precisely the thinking required in a Digital Analyst role: knowing what the data means, where it comes from, and where its limits are.

---

## Data Sources — What Is Real and What It Tells You

Every data point in this project comes from a named, verifiable source. The table below is the foundation of the project.

| Source | What it provides | Reliability | Access |
|--------|-----------------|-------------|--------|
| SimilarWeb (free tier) | bmw.com traffic estimates: monthly visits, channel mix, bounce rate, device split, pages/visit | Estimated, ±20–30% vs real GA4; useful for directional benchmarking and competitor comparison | Free account at similarweb.com |
| Semrush (free tier) | bmwusa.com organic keywords, top landing pages, estimated traffic by page | Estimated; stronger for SEO than engagement | Free account at semrush.com |
| BMW Group Annual Report 2024 | Global deliveries by market, BEV share, revenue — official, audited | High | bmwgroup.com/en/report/2024 |
| BMW press statements | Digital strategy, online sales rollout, configurator mentions | Primary source; PR-framed | press.bmwgroup.com |
| Cox Automotive 2024 Car Buyer Journey Study | 14+ hours online research before dealer visit; 1.4 dealer visits avg. | Published industry research | Publicly cited |
| Ruler Analytics 2026 Conversion Benchmarks | Automotive direct traffic conversion: 9.8% | Published, multi-source benchmark | ruleranalytics.com |
| Demand Local / WordStream 2024 | Automotive website conversion: 2–5% average; top performers 8–16% | Published benchmarks | demandlocal.com |
| Google BigQuery GA4 public dataset | Real GA4 event schema; SQL technique demonstration only | Real schema, wrong domain — labelled explicitly throughout | Free via BigQuery sandbox |

**Transparency rule applied throughout:** every number in this project is labelled with its source and a confidence level: High / Estimated / Benchmark.

---

## Project Structure

Three sequential deliverables. Each stands alone; together they tell a complete story.

```
DELIVERABLE 1          DELIVERABLE 2              DELIVERABLE 3
──────────────         ──────────────────         ──────────────────────
Measurement            Competitive Signal          Insight Brief
Framework              Analysis                    + SQL Appendix
(What should           (What public data           (What it means;
 be measured)           actually shows)             how I'd dig deeper)
```

---

## Deliverable 1 — Measurement Framework for BMW's Digital Funnel

### Purpose

Define exactly what a Digital Analyst *would* measure on bmw.com if they had full GA4 access. This is solution design thinking that precedes any implementation. It demonstrates that you understand the business before you touch the data.

### The BMW Customer Journey (Publicly Observable)

The following stages are verifiable by visiting bmw.com directly. Each stage transition is a measurable event.

```
Stage 0 — Entry
  Traffic arrives via search, direct, paid, or referral.
  Observable signal: SimilarWeb channel split.
  Business question: Which channels bring high-intent visitors?

Stage 1 — Model Discovery
  User browses model range or lands on a model overview page.
  Key pages: /en/vehicles/series/ or individual model pages.
  Business question: Which models attract the most research interest?

Stage 2 — Model Detail Engagement
  User views a specific model's detail page, reads specs, watches media.
  Business question: Do visitors engage with the page or bounce immediately?

Stage 3 — Configurator Entry
  User clicks "Configure" and opens the configurator.
  This is the highest-intent action before a lead.
  Business question: What percentage of model-page visitors open the configurator?

Stage 4 — Configuration Progression
  User completes each step: engine, exterior, interior, options, packages.
  Business question: At which step does the largest drop-off occur?

Stage 5 — Configurator Completion
  User reaches the summary screen and saves or shares a configuration.
  Business question: What is the configurator completion rate?

Stage 6 — Lead Action
  User clicks "Request test drive", "Contact dealer", or "Order online".
  This is the primary conversion event.
  Business question: What percentage of completed configurations become leads?

Stage 7 — Lead Confirmation
  Confirmation page is reached after form submission.
  Business question: What is the end-to-end funnel conversion rate?
```

### KPI Framework

#### Tier 1 — Primary KPIs (what the business cares about)

| KPI | Formula | Why it matters |
|-----|---------|----------------|
| End-to-End Conversion Rate | Lead Confirmations / Total Sessions | The headline number for digital sales contribution |
| Configurator Entry Rate | Configurator Opens / Model Page Views | Measures whether the product page drives intent |
| Configurator Completion Rate | Summary Views / Configurator Opens | Measures configurator UX quality |
| Lead Generation Rate | Lead Actions / Summary Views | Measures whether intent converts to qualified contact |

#### Tier 2 — Diagnostic KPIs (where to look when Tier 1 drops)

| KPI | What it diagnoses |
|-----|------------------|
| Bounce Rate by Landing Page Type | Is entry traffic misaligned with content? |
| Device Conversion Gap | Is mobile checkout creating friction? |
| Channel-to-Lead Ratio | Which acquisition channels produce qualified visitors? |
| Return Visitor Rate to Configurator | Are users returning to complete a saved configuration? |
| Time-to-Configure | Is the configurator too long or too complex? |

#### Tier 3 — Segmentation Dimensions

Every KPI above should be breakable by: market/country, device category, acquisition channel, model series (1/3/5/X/i series), user type (new vs. returning), and BEV vs. ICE.

### Event Taxonomy

If this were a real implementation, the following GA4 custom events would be specified:

| Event | Trigger | Mandatory Parameters |
|-------|---------|---------------------|
| `model_page_view` | Model detail page load | `model_name`, `model_series`, `fuel_type`, `market` |
| `configurator_start` | Configurator opens | `model_name`, `entry_point` |
| `configurator_step_complete` | Step advanced | `step_number`, `step_name`, `selection_made` |
| `configurator_complete` | Summary reached | `model_name`, `total_price_eur`, `fuel_type` |
| `lead_cta_click` | Lead CTA clicked | `cta_type` (test_drive / dealer / order), `model_name` |
| `lead_form_submit` | Form submitted | `lead_type`, `model_name`, `market` |

This section is the most important in the document for a hiring manager. It shows you think in implementation terms, not just reporting terms.

---

## Deliverable 2 — Competitive Signal Analysis

### What this section does

Using only publicly available, named sources, this section builds an evidence-based picture of BMW's digital performance and identifies where gaps and opportunities are. Every claim is sourced. Confidence levels are stated.

---

### 2.1 Traffic Profile

**Source: SimilarWeb / Semrush free tier. Confidence: Estimated.**

Note on accuracy: SimilarWeb estimates are modelled, not measured. A peer-reviewed comparison found SimilarWeb overestimates bounce rate by approximately 6.8% on average relative to actual Google Analytics data. For a site with bmw.com's scale, directional trends and channel splits are more reliable than absolute numbers.

| Metric | Value | Source | Confidence |
|--------|-------|---------|------------|
| Monthly visits, bmwusa.com | ~6.6M (August 2024) | SimilarWeb, public competitor data | Estimated |
| Monthly visits, mercedes-benz.com | ~7.3M (August 2024) | SimilarWeb, public competitor data | Estimated |
| Traffic source, bmw.com — Direct | 46.42% | Semrush | Estimated |
| Traffic source, bmw.com — Organic (Google) | 33.39% | Semrush | Estimated |
| bmwusa.com bounce rate | 51.62% (Dec 2025) | Semrush competitor data | Estimated |
| bmwgroup.com bounce rate | 39.62% (Dec 2025) | Semrush competitor data | Estimated |

**What this tells us (with appropriate caution):**

Nearly half of bmw.com traffic arrives direct, meaning visitors already know the brand. This has a critical measurement implication: direct traffic inflates session-level conversion rates because these visitors are further along their purchase journey. A meaningful analysis must segment direct vs. search-acquired traffic separately, or conversion rates will be misleading.

The bmwusa.com bounce rate of ~51% is consistent with automotive industry norms for brand sites and does not alone indicate a problem. High-intent direct visitors who "bounce" may be navigating to a dealer or picking up the phone. Bounce rate is only diagnostic in context.

---

### 2.2 Industry Benchmark Context

**Source: Multiple published research reports. Confidence: High for benchmarks; not BMW-specific.**

| Metric | Benchmark | Source |
|--------|-----------|--------|
| Automotive website conversion rate (average) | 2–5% | Demand Local / WordStream 2024 |
| Automotive website conversion rate (top performers) | 8–16% | Demand Local 2026 |
| Automotive direct traffic conversion rate | 9.8% | Ruler Analytics 2026 |
| Organic search conversion rate, automotive | 1.57% | WordStream benchmarks |
| Mobile device share of automotive research | >70% | Google via Invoca |
| Mobile conversion rate vs. desktop | Lower — confirmed "mobile paradox" | Demand Local 2025 |
| Average online research time before dealer contact | 14+ hours | Cox Automotive 2024 Car Buyer Journey Study |
| Average dealer visits before purchase | 1.4 | BMW Group press statement / industry data |

**What this tells us:**

The 14-hour research window and 1.4 dealer visits are the two most important numbers in this table. They mean that by the time a user opens the BMW configurator, they have already done significant research — likely across multiple sessions, devices, and sources. The configurator is not the start of the journey; it is near the end. This fundamentally changes how conversion should be measured and attributed. A standard last-click model will overstate direct traffic and paid search, and understate organic and brand content that influenced earlier sessions.

---

### 2.3 BMW's Stated Digital Strategy vs. Observable Signals

**Source: BMW Group press releases; BMW Annual Report 2024. Confidence: High for stated intent; unverified for execution.**

BMW has publicly committed to a full-funnel digital sales model, with ambitions for customers to buy individually configured vehicles entirely online, delivered to their door. They have invested, by their own account, triple-digit millions annually in this direction.

BMW Group's 2024 results confirm that BEV sales grew 13.5% to 426,594 units, representing 17.4% of total deliveries — the highest-ever share. Electric vehicle buyers are disproportionately digital-native and research-intensive, which makes the configurator-to-lead journey even more critical for this growing segment.

**The gap worth naming honestly:** BMW's digital investment is large and publicly stated, but observable signals — traffic channel mix, estimated bounce rates, competitor comparisons — are not sufficient to confirm whether execution matches ambition. Naming this limit directly is the correct analytical framing, and it demonstrates the maturity that separates a good analyst from an overconfident one.

---

### 2.4 Competitor Comparison

**Source: SimilarWeb / Semrush public competitor data. Confidence: Estimated.**

| Brand | Est. monthly visits | Notes |
|-------|-------------------|-------|
| bmwusa.com | ~6.6M | US market |
| mercedes-benz.com | ~7.3M | Global |
| porsche.com | ~10.9M | High enthusiast traffic relative to sales volume |
| audiusa.com | ~2.7M | US market |
| mbusa.com | ~5.1M | US market |

At the US market level, mercedes-benz.com and bmwusa.com are closely matched in estimated traffic. Porsche's outsized traffic likely reflects enthusiast interest disproportionate to its sales volume. These are estimates and should be treated as order-of-magnitude comparisons.

---

## Deliverable 3 — Insight Brief + SQL Appendix

### 3.1 The Insight Brief

*Format: What We Know / What It Suggests / What We'd Test / What We'd Need*

---

**WHAT WE KNOW**

Using publicly available traffic intelligence and published industry benchmarks, we can build a directional picture of BMW's digital funnel context. BMW.com receives high-volume, brand-aware traffic — nearly half arriving via direct — consistent with a mature premium brand. The automotive industry benchmark for website-to-lead conversion sits between 2% and 5% for average performers, with top-quartile sites reaching 8–16%. BMW's stated strategy targets a fully online purchase journey, backed by publicly confirmed triple-digit million annual investment in digital sales and marketing.

All data used here is estimated or benchmarked. None represents BMW's internal analytics.

**WHAT IT SUGGESTS**

Three observations are worth exploring with real data.

First, the dominance of direct traffic (46%) means BMW.com functions primarily as a destination for decided visitors. This is a characteristic of premium brand sites, not a problem in itself — but it means that conversion rates calculated on total sessions will be misleading. A meaningful measure of configurator performance must segment by traffic source.

Second, the 14-hour online research window means that a single-session conversion metric misrepresents the funnel entirely. A user who opens the configurator three times across a week before submitting a test drive request is converting — but last-click attribution may credit none of those sessions. Multi-touch, session-level analysis is not optional here; it is definitional.

Third, the mobile research paradox is directly relevant to BMW's configurator. Over 70% of automotive research happens on mobile, but conversion is higher on desktop. The configurator is a complex, multi-step tool. If it is not fully optimised for mobile completion, BMW is losing a measurable percentage of high-intent users at the device transition point. This is the highest-probability area for a quick-win improvement.

**WHAT WE'D TEST**

With real GA4 access, three analyses would be prioritised immediately:

1. Configurator completion rate segmented by device — to quantify the mobile drop-off and identify which specific step has the largest mobile exit rate.
2. Session sequence analysis for converters — how many sessions did users who eventually submitted a lead complete before converting? What was the median time-to-convert?
3. Channel-to-configurator-start rate — which acquisition channels produce visitors who actually open the configurator, not just view a model page?

**WHAT WOULD CHANGE WITH REAL DATA**

With access to BMW's GA4 backend, the entire analysis shifts from directional to definitive. Benchmark comparisons become internal comparisons against BMW's own historical baseline. The device gap becomes quantified to a specific step number. Multi-session behaviour becomes a measured cohort, not an inference from industry research. Every recommendation becomes a testable hypothesis with pre-defined success metrics.

That is the work. This brief is the frame.

---

### 3.2 SQL Appendix — Technique Demonstration

**Explicit label: The following queries run on the Google BigQuery GA4 sample dataset (Google Merchandise Store). They demonstrate GA4 SQL technique and analytical reasoning. They produce no findings about BMW. This label appears here, in the README, and in every query file header.**

Dataset: `bigquery-public-data.ga4_obfuscated_sample_ecommerce`
Access: Free via BigQuery sandbox (no billing required for ≤10GB/month)

Every query is written to answer a business question, not to produce a number. The question is stated first.

---

**Query A — Multi-session path to conversion**

*Business question: Do converting users require more sessions than non-converting users, and how long does conversion take? This tests the multi-session hypothesis that underlies the entire measurement framework.*

```sql
WITH user_sessions AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value
     FROM UNNEST(event_params)
     WHERE key = 'ga_session_id')                            AS session_id,
    MIN(event_timestamp)                                      AS session_start_ts,
    MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END)  AS converted
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  GROUP BY user_pseudo_id, session_id
),
user_summary AS (
  SELECT
    user_pseudo_id,
    COUNT(DISTINCT session_id)                                AS total_sessions,
    MAX(converted)                                            AS ever_converted,
    TIMESTAMP_DIFF(
      TIMESTAMP_MICROS(MIN(CASE WHEN converted = 1 THEN session_start_ts END)),
      TIMESTAMP_MICROS(MIN(session_start_ts)),
      HOUR
    )                                                         AS hours_to_first_conversion
  FROM user_sessions
  GROUP BY user_pseudo_id
)
SELECT
  ever_converted,
  COUNT(*)                                                    AS users,
  ROUND(AVG(total_sessions), 1)                               AS avg_sessions,
  APPROX_QUANTILES(total_sessions, 100)[OFFSET(50)]           AS median_sessions,
  ROUND(AVG(hours_to_first_conversion), 1)                    AS avg_hours_to_convert
FROM user_summary
GROUP BY ever_converted
ORDER BY ever_converted DESC;
```

---

**Query B — Funnel drop-off with step-level granularity**

*Business question: At which specific stage of the purchase funnel does the largest volume of users exit? The column `step_retention_pct` shows what percentage of users who reached step N also completed step N+1. The lowest number in that column is where optimisation has the highest impact.*

```sql
WITH funnel_events AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value
     FROM UNNEST(event_params)
     WHERE key = 'ga_session_id')       AS session_id,
    event_name
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND event_name IN (
      'session_start', 'view_item_list', 'view_item',
      'add_to_cart', 'begin_checkout', 'add_payment_info', 'purchase'
    )
),
session_funnel AS (
  SELECT
    user_pseudo_id,
    session_id,
    MAX(CASE WHEN event_name = 'session_start'    THEN 1 ELSE 0 END) AS s0,
    MAX(CASE WHEN event_name = 'view_item_list'   THEN 1 ELSE 0 END) AS s1,
    MAX(CASE WHEN event_name = 'view_item'        THEN 1 ELSE 0 END) AS s2,
    MAX(CASE WHEN event_name = 'add_to_cart'      THEN 1 ELSE 0 END) AS s3,
    MAX(CASE WHEN event_name = 'begin_checkout'   THEN 1 ELSE 0 END) AS s4,
    MAX(CASE WHEN event_name = 'add_payment_info' THEN 1 ELSE 0 END) AS s5,
    MAX(CASE WHEN event_name = 'purchase'         THEN 1 ELSE 0 END) AS s6
  FROM funnel_events
  GROUP BY user_pseudo_id, session_id
)
SELECT 'S0 Session Start'   AS stage, COUNTIF(s0=1) AS sessions,
  100.0 AS pct_of_entry, NULL AS step_retention_pct FROM session_funnel
UNION ALL
SELECT 'S1 Browsed Catalogue', COUNTIF(s1=1),
  ROUND(COUNTIF(s1=1)*100.0/NULLIF(COUNTIF(s0=1),0),1),
  ROUND(COUNTIF(s1=1)*100.0/NULLIF(COUNTIF(s0=1),0),1) FROM session_funnel
UNION ALL
SELECT 'S2 Product View', COUNTIF(s2=1),
  ROUND(COUNTIF(s2=1)*100.0/NULLIF(COUNTIF(s0=1),0),1),
  ROUND(COUNTIF(s2=1)*100.0/NULLIF(COUNTIF(s1=1),0),1) FROM session_funnel
UNION ALL
SELECT 'S3 Add to Cart', COUNTIF(s3=1),
  ROUND(COUNTIF(s3=1)*100.0/NULLIF(COUNTIF(s0=1),0),1),
  ROUND(COUNTIF(s3=1)*100.0/NULLIF(COUNTIF(s2=1),0),1) FROM session_funnel
UNION ALL
SELECT 'S4 Begin Checkout', COUNTIF(s4=1),
  ROUND(COUNTIF(s4=1)*100.0/NULLIF(COUNTIF(s0=1),0),1),
  ROUND(COUNTIF(s4=1)*100.0/NULLIF(COUNTIF(s3=1),0),1) FROM session_funnel
UNION ALL
SELECT 'S5 Payment Info', COUNTIF(s5=1),
  ROUND(COUNTIF(s5=1)*100.0/NULLIF(COUNTIF(s0=1),0),1),
  ROUND(COUNTIF(s5=1)*100.0/NULLIF(COUNTIF(s4=1),0),1) FROM session_funnel
UNION ALL
SELECT 'S6 Purchase', COUNTIF(s6=1),
  ROUND(COUNTIF(s6=1)*100.0/NULLIF(COUNTIF(s0=1),0),1),
  ROUND(COUNTIF(s6=1)*100.0/NULLIF(COUNTIF(s5=1),0),1) FROM session_funnel
ORDER BY stage;
```

---

**Query C — Device × channel interaction on conversion**

*Business question: Is the mobile conversion problem uniform across all channels, or is it specific to certain acquisition sources? This matters because fixing a mobile problem in paid traffic has a different ROI than fixing it in organic.*

```sql
WITH session_data AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
    device.category                                                 AS device,
    traffic_source.medium                                           AS medium,
    MAX(CASE WHEN event_name = 'view_item'  THEN 1 ELSE 0 END)     AS viewed_product,
    MAX(CASE WHEN event_name = 'purchase'   THEN 1 ELSE 0 END)     AS purchased
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  GROUP BY 1, 2, 3, 4
)
SELECT
  device,
  COALESCE(medium, '(none)')                                       AS channel,
  COUNT(*)                                                          AS sessions,
  COUNTIF(purchased = 1)                                            AS purchases,
  ROUND(
    COUNTIF(purchased = 1) * 100.0
    / NULLIF(COUNTIF(viewed_product = 1), 0), 2
  )                                                                 AS cvr_from_product_view
FROM session_data
WHERE viewed_product = 1
GROUP BY 1, 2
HAVING COUNT(*) > 50  -- minimum volume for reliable rates
ORDER BY device, purchases DESC;
```

*The `HAVING COUNT(*) > 50` filter is not cosmetic. Conversion rates calculated on fewer than ~50 sessions have wide confidence intervals and should not inform decisions. Showing this filter in the query demonstrates statistical awareness.*

---

**Query D — Return visitor lift across the funnel**

*Business question: Do returning users convert at a higher rate, and at which funnel stage does the return visit provide the most lift? This identifies where re-engagement campaigns — email, retargeting — would have the highest expected return.*

```sql
WITH session_events AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
    MIN(CASE WHEN event_name = 'session_start' THEN event_timestamp END)            AS session_ts,
    MAX(CASE WHEN event_name = 'view_item'       THEN 1 ELSE 0 END)                 AS viewed_product,
    MAX(CASE WHEN event_name = 'begin_checkout'  THEN 1 ELSE 0 END)                 AS began_checkout,
    MAX(CASE WHEN event_name = 'purchase'        THEN 1 ELSE 0 END)                 AS purchased
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  GROUP BY 1, 2
),
ranked AS (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY user_pseudo_id ORDER BY session_ts) AS session_rank
  FROM session_events
)
SELECT
  CASE
    WHEN session_rank = 1         THEN '1st session'
    WHEN session_rank = 2         THEN '2nd session'
    WHEN session_rank BETWEEN 3 AND 5 THEN '3rd–5th session'
    ELSE '6th+ session'
  END                                                                AS visit_recency,
  COUNT(*)                                                           AS sessions,
  ROUND(COUNTIF(viewed_product = 1)  * 100.0 / COUNT(*), 1)         AS pct_viewed_product,
  ROUND(COUNTIF(began_checkout = 1)  * 100.0 / COUNT(*), 1)         AS pct_began_checkout,
  ROUND(COUNTIF(purchased = 1)       * 100.0 / COUNT(*), 2)         AS conversion_rate
FROM ranked
GROUP BY 1
ORDER BY MIN(session_rank);
```

---

## Dashboard Specification

**Tool:** Looker Studio (free; native BigQuery connector)
**Layout:** Single page, five panels
**Story:** *Where in the funnel are we losing users, and at which point in their multi-session journey does it happen?*

| Panel | Chart type | Source | Annotation |
|-------|-----------|--------|------------|
| Funnel Waterfall | Step funnel | Query B | Highlight the single largest drop; name the step |
| Device Conversion Gap | Grouped bar | Query C | Quantify the mobile gap; frame as completion problem, not demand problem |
| Return Visit Lift | Line chart | Query D | Show conversion rate by session number; where does the curve flatten? |
| Channel × Device Matrix | Heat map table | Query C | Identify the highest-cost, lowest-efficiency combination |
| Data Transparency Card | Plain text | — | "All data from Google GA4 sample dataset. Demonstrates methodology, not BMW findings." |

The transparency panel is not an apology. It is the signal that you know exactly what your data can and cannot claim.

---

## Reproducibility — What Actually Transfers to Other Brands

**Genuinely reusable without changes:**
- KPI framework (Tier 1/2/3 structure)
- Event taxonomy (standard GA4 — brand-agnostic)
- All four SQL queries
- Insight brief structure (Know / Suggests / Test / Need)
- Dashboard template (label changes only)

**Requires brand-specific work per new brand:**
- Funnel stage mapping from UI observation (~1 hour)
- SimilarWeb/Semrush data collection for that domain (~30 minutes)
- Brand-specific public statement research (~1 hour)

Honest time estimate per new brand after BMW pilot: **3–4 hours**.

---

## Repository Structure

```
bmw-digital-audit/
├── README.md                          # Project overview; data sources; how to run
├── data-sources.md                    # Every source cited with URL and access date
├── framework/
│   ├── kpi-framework.md               # Tier 1/2/3 KPIs (reusable)
│   ├── event-taxonomy.md              # GA4 event specification (reusable)
│   └── funnel-model-bmw.md            # BMW funnel stages (from UI observation)
├── analysis/
│   ├── competitive-signals.md         # SimilarWeb/Semrush findings with source notes
│   ├── benchmark-context.md           # Industry benchmarks with citations
│   └── insight-brief-bmw.md           # The memo
├── sql/
│   ├── A-multi-session-path.sql
│   ├── B-funnel-dropoff.sql
│   ├── C-device-channel-interaction.sql
│   └── D-return-visitor-lift.sql
├── dashboard/
│   ├── looker-studio-link.md          # Shareable view link
│   └── screenshot-bmw.png
└── outputs/
    └── query-results/
        ├── A-results.csv
        ├── B-results.csv
        ├── C-results.csv
        └── D-results.csv
```

---

## What This Project Demonstrates

| What the hiring manager sees | What they infer |
|------------------------------|----------------|
| Explicitly sourced, cited data | You will not invent numbers in a stakeholder presentation |
| Confidence levels on every claim | You know what your data can and cannot prove |
| Business questions before SQL | You think from the business back to the data |
| Statistical significance filter (Query C) | You understand that small-sample rates are noise, not signal |
| Multi-session analysis | You understand attribution in high-consideration purchase journeys |
| Transparency panel in the dashboard | You will tell a stakeholder when you don't know something |
| Reusable framework | You build systems, not one-off analyses |

---

*All SQL outputs are sourced from Google's publicly available GA4 sample dataset. All competitive intelligence is sourced from SimilarWeb, Semrush, and published industry reports, labelled as estimated. No proprietary BMW data was used or accessed. Version 2.0.*
