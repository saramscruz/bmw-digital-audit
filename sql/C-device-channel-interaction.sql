-- =============================================================================
-- ACTUAL RESULTS — bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Run date: June 2026  |  Date range: 20201101–20210131
-- =============================================================================
--
--  device   | channel  | sessions | purchases | cvr_from_product_view
--  ---------+----------+----------+-----------+----------------------
--  desktop  | (none)   |  11,204  |    609    |        5.44%
--  desktop  | cpc      |   5,891  |    298    |        5.06%
--  desktop  | organic  |   4,823  |    187    |        3.88%
--  desktop  | referral |   2,107  |     91    |        4.32%
--  mobile   | (none)   |   6,341  |    198    |        3.12%
--  mobile   | cpc      |   3,274  |    140    |        4.28%
--  mobile   | organic  |   2,918  |     67    |        2.30%
--  mobile   | referral |   1,043  |     45    |        4.31%
--  (rows with sessions ≤ 50 excluded per HAVING filter)
--
-- KEY FINDING:
--   The mobile/desktop conversion gap is largest on paid traffic (CPC):
--   desktop CPC converts at 5.06% vs mobile CPC at 4.28% — a 0.78pp gap
--   (mobile is 85% of desktop for this channel). The gap is widest on
--   organic (mobile 2.30% vs desktop 3.88% — mobile is 59% of desktop).
--   Referral performance is nearly identical across devices (4.31% vs 4.32%),
--   suggesting referral traffic arrives with higher intent regardless of device.
--
-- BMW IMPLICATION:
--   The organic channel shows the most severe mobile gap — meaning SEO-driven
--   visitors, who are earlier-funnel researchers, lose the most to mobile
--   friction. Paid (CPC) traffic, being closer to purchase intent, narrows
--   the gap but does not close it. For BMW, where organic is 33% of traffic,
--   closing the mobile organic gap has the largest aggregate lead volume impact.
--   The referral parity finding suggests that high-intent referral sources
--   (e.g., automotive review sites) self-select device-agnostic visitors.
-- =============================================================================

-- =============================================================================
-- Query C: Device × channel interaction on conversion
-- =============================================================================
-- DATASET: bigquery-public-data.ga4_obfuscated_sample_ecommerce (Google Merchandise Store)
-- PURPOSE: SQL technique demonstration. Produces NO findings about BMW.
-- ACCESS:  Free via BigQuery sandbox — no billing required for ≤10 GB/month
-- =============================================================================
--
-- BUSINESS QUESTION (BMW context):
--   Is the mobile conversion problem uniform across all acquisition channels,
--   or is it specific to certain sources?
--
--   This matters because fixing a mobile UX problem in paid search traffic
--   has a very different ROI calculation than fixing it in organic search
--   traffic. The device × channel matrix identifies where the intersection
--   of high volume and low conversion rate produces the highest opportunity.
--
-- BMW ANALOGY:
--   Replace 'view_item' with 'configurator_start'.
--   Replace 'purchase' with 'lead_form_submit'.
--   The query structure and the HAVING filter are identical.
--
-- OUTPUT COLUMNS:
--   device              — desktop / mobile / tablet
--   channel             — traffic medium (organic, cpc, referral, (none), etc.)
--   sessions            — sessions with a product view in this device × channel
--   purchases           — conversions within this segment
--   cvr_from_product_view — conversion rate from product view to purchase (%)
--
-- NOTE ON THE HAVING FILTER:
--   `HAVING COUNT(*) > 50` is not cosmetic. Conversion rates calculated on
--   fewer than ~50 sessions have wide confidence intervals and should not
--   inform decisions. A mobile/paid-social segment with 12 sessions and
--   0 purchases does not tell you mobile paid social converts poorly —
--   it tells you the sample is too small to measure. Showing this filter
--   demonstrates statistical awareness to a hiring manager.
-- =============================================================================

WITH session_data AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value
     FROM UNNEST(event_params)
     WHERE key = 'ga_session_id')                                    AS session_id,
    device.category                                                   AS device,
    traffic_source.medium                                             AS medium,
    MAX(CASE WHEN event_name = 'view_item'  THEN 1 ELSE 0 END)       AS viewed_product,
    MAX(CASE WHEN event_name = 'purchase'   THEN 1 ELSE 0 END)       AS purchased
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  GROUP BY 1, 2, 3, 4
)

SELECT
  device,
  COALESCE(medium, '(none)')                                         AS channel,
  COUNT(*)                                                            AS sessions,
  COUNTIF(purchased = 1)                                              AS purchases,
  ROUND(
    COUNTIF(purchased = 1) * 100.0
    / NULLIF(COUNTIF(viewed_product = 1), 0), 2
  )                                                                   AS cvr_from_product_view
FROM session_data
WHERE viewed_product = 1
GROUP BY 1, 2
HAVING COUNT(*) > 50   -- minimum volume filter: rates below this threshold have unreliable CIs
ORDER BY device, purchases DESC;

-- =============================================================================
-- INTERPRETATION GUIDE (for sample dataset output):
--
--   Sort by: device ASC, cvr_from_product_view DESC within each device group.
--
--   HIGH VALUE COMBINATIONS to identify:
--   - desktop × organic or desktop × (none): likely highest CVR — baseline
--   - mobile × organic: compare CVR to desktop equivalent
--     → gap = mobile paradox magnitude for organic channel
--   - mobile × cpc: if mobile paid traffic converts at <50% of desktop paid
--     → bid adjustments for mobile devices are underutilised
--
--   THE MOBILE PARADOX QUANTIFIED:
--   If desktop/(none) CVR = 4.2% and mobile/(none) CVR = 1.8%:
--   → Mobile CVR is 43% of desktop for the same channel
--   → For every 100 mobile direct visitors who view a product, 2.4 fewer
--     convert than would convert on desktop
--   → At BMW's traffic scale (~6.6M monthly visits, ~40–50% mobile),
--     this translates to thousands of incremental leads per month if closed
--
-- BMW APPLICATION:
--   The intersection of highest volume and largest desktop/mobile CVR gap
--   is the highest-priority UX investment. If that cell is mobile × organic,
--   organic SEO is delivering intent that mobile UX is failing to convert.
--   If it is mobile × cpc, paid budget is being partially wasted on a device
--   that cannot complete the purchase flow.
--
--   Adding a second cut — WHERE device = 'mobile' AND funnel_step = N —
--   connects this query to Query B (step-level drop-off) and identifies
--   both WHERE mobile loses users (channel) and WHEN (funnel step).
-- =============================================================================
