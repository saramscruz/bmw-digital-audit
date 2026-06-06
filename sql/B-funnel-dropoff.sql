-- =============================================================================
-- ACTUAL RESULTS — bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Run date: June 2026  |  Date range: 20201101–20210131
-- =============================================================================
--
--  stage                  | sessions | pct_of_entry | step_retention_pct
--  -----------------------+----------+--------------+--------------------
--  S0 Session Start        |  82,332  |    100.0     |       NULL
--  S1 Browsed Catalogue    |  44,510  |     54.1     |       54.1
--  S2 Product View         |  37,167  |     45.1     |       83.5
--  S3 Add to Cart          |   7,326  |      8.9     |       19.7   ← largest drop
--  S4 Begin Checkout       |   4,690  |      5.7     |       64.0
--  S5 Payment Info         |   2,186  |      2.7     |       46.6
--  S6 Purchase             |   1,153  |      1.4     |       52.7
--
-- KEY FINDING:
--   The largest single drop-off is at S2→S3 (Product View → Add to Cart)
--   with only 19.7% retention — meaning 80.3% of sessions that viewed a
--   product did not add it to cart. Overall end-to-end conversion is 1.4%.
--   Every other step retains at least 46% of the prior stage.
--
-- BMW IMPLICATION:
--   The S2→S3 equivalent for BMW is the Model Page → Configurator Start
--   transition (Configurator Entry Rate, Tier 1 KPI). An 80% drop-off at
--   this step would mean the product page is not successfully directing
--   intent toward configuration — a content or CTA placement problem,
--   not a late-funnel UX problem. This is where A/B testing should begin.
-- =============================================================================

-- =============================================================================
-- Query B: Funnel drop-off with step-level granularity
-- =============================================================================
-- DATASET: bigquery-public-data.ga4_obfuscated_sample_ecommerce (Google Merchandise Store)
-- PURPOSE: SQL technique demonstration. Produces NO findings about BMW.
-- ACCESS:  Free via BigQuery sandbox — no billing required for ≤10 GB/month
-- =============================================================================
--
-- BUSINESS QUESTION (BMW context):
--   At which specific stage of the purchase funnel does the largest volume
--   of users exit?
--
--   The column `step_retention_pct` shows what percentage of users who
--   reached step N also completed step N+1. The LOWEST number in that
--   column is where optimisation has the highest expected impact per
--   unit of engineering investment.
--
-- BMW ANALOGY:
--   Replace the event_name values with BMW's GA4 event taxonomy:
--     'session_start'    → 'session_start'           (unchanged)
--     'view_item_list'   → 'model_page_view'          (custom event)
--     'view_item'        → 'configurator_start'       (custom event)
--     'add_to_cart'      → 'configurator_step_complete' WHERE step_number = 3
--     'begin_checkout'   → 'configurator_complete'    (custom event)
--     'add_payment_info' → 'lead_cta_click'           (custom event)
--     'purchase'         → 'lead_form_submit'         (custom event)
--
-- OUTPUT COLUMNS:
--   stage               — human-readable stage label
--   sessions            — count of sessions reaching this stage
--   pct_of_entry        — sessions at this stage as % of total session_starts
--   step_retention_pct  — sessions at this stage as % of sessions at prior stage
--                         (NULL for Stage 0 — no prior stage)
-- =============================================================================

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

SELECT 'S0 Session Start'     AS stage,
       COUNTIF(s0=1)          AS sessions,
       100.0                  AS pct_of_entry,
       NULL                   AS step_retention_pct
FROM session_funnel

UNION ALL
SELECT 'S1 Browsed Catalogue', COUNTIF(s1=1),
  ROUND(COUNTIF(s1=1) * 100.0 / NULLIF(COUNTIF(s0=1), 0), 1),
  ROUND(COUNTIF(s1=1) * 100.0 / NULLIF(COUNTIF(s0=1), 0), 1)
FROM session_funnel

UNION ALL
SELECT 'S2 Product View', COUNTIF(s2=1),
  ROUND(COUNTIF(s2=1) * 100.0 / NULLIF(COUNTIF(s0=1), 0), 1),
  ROUND(COUNTIF(s2=1) * 100.0 / NULLIF(COUNTIF(s1=1), 0), 1)
FROM session_funnel

UNION ALL
SELECT 'S3 Add to Cart', COUNTIF(s3=1),
  ROUND(COUNTIF(s3=1) * 100.0 / NULLIF(COUNTIF(s0=1), 0), 1),
  ROUND(COUNTIF(s3=1) * 100.0 / NULLIF(COUNTIF(s2=1), 0), 1)
FROM session_funnel

UNION ALL
SELECT 'S4 Begin Checkout', COUNTIF(s4=1),
  ROUND(COUNTIF(s4=1) * 100.0 / NULLIF(COUNTIF(s0=1), 0), 1),
  ROUND(COUNTIF(s4=1) * 100.0 / NULLIF(COUNTIF(s3=1), 0), 1)
FROM session_funnel

UNION ALL
SELECT 'S5 Payment Info', COUNTIF(s5=1),
  ROUND(COUNTIF(s5=1) * 100.0 / NULLIF(COUNTIF(s0=1), 0), 1),
  ROUND(COUNTIF(s5=1) * 100.0 / NULLIF(COUNTIF(s4=1), 0), 1)
FROM session_funnel

UNION ALL
SELECT 'S6 Purchase', COUNTIF(s6=1),
  ROUND(COUNTIF(s6=1) * 100.0 / NULLIF(COUNTIF(s0=1), 0), 1),
  ROUND(COUNTIF(s6=1) * 100.0 / NULLIF(COUNTIF(s5=1), 0), 1)
FROM session_funnel

ORDER BY stage;

-- =============================================================================
-- INTERPRETATION GUIDE (for sample dataset output):
--
--   The row where step_retention_pct is lowest is the primary drop-off point.
--   This is where UX investment has the highest expected return.
--
--   Common patterns in e-commerce (analogous to automotive configurator):
--   - S1→S2 (Catalogue → Product View): if low, the catalogue page is not
--     surfacing compelling products — a content/merchandising problem
--   - S3→S4 (Cart → Checkout): if low, checkout friction or unexpected costs
--     are causing abandonment — a UX/pricing transparency problem
--   - S5→S6 (Payment → Purchase): if low, trust signals or payment options
--     are insufficient — a conversion optimisation problem
--
-- BMW APPLICATION:
--   In a BMW implementation, the step with the lowest retention_pct across
--   configurator_step_complete events (step 1 through N) identifies the
--   specific configuration question causing abandonment.
--
--   If the options/packages step has the lowest retention (plausible — it
--   presents the most choices and the largest price jumps), the optimisation
--   hypothesis is: simplify the options presentation or introduce progressive
--   disclosure (show fewer options first, allow expansion).
--
--   This query, run on BMW data segmented by device.category, is the
--   direct test of the mobile paradox hypothesis from the insight brief.
-- =============================================================================
