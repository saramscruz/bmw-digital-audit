-- ============================================================
-- PROXY ANALYSIS: Google Merchandise Store GA4 Public Sample
-- Dataset: bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Purpose: Establish funnel shape for high-consideration funnels
-- NOT BMW data. Conversion rates not transferable to automotive.
-- Session count and drop-off structure are directionally valid.
-- ============================================================


-- ============================================================
-- QUERY 1: Funnel drop-off by event sequence
-- ============================================================
-- Maps to BMW digital journey stages:
--   session_start   -> any site visit
--   page_view       -> landing / browsing
--   view_item       -> model detail page (e.g. /3-series)
--   add_to_cart     -> build & price / configurator start
--   begin_checkout  -> request a quote / reserve
--   add_payment_info-> finance application / deposit entry
--   purchase        -> confirmed order / conversion
-- The absolute conversion rates are e-commerce artefacts and
-- should not be cited for BMW. The staged drop-off shape -- and
-- where the steepest fall occurs -- is the transferable signal.
-- ============================================================

WITH session_events AS (
  SELECT
    event_name,
    (
      SELECT value.int_value
      FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    ) AS session_id
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
),

stage_sessions AS (
  SELECT
    'session_start'    AS stage, 1 AS stage_order, COUNT(DISTINCT session_id) AS sessions FROM session_events WHERE event_name = 'session_start'
  UNION ALL
  SELECT 'page_view',            2,                COUNT(DISTINCT session_id) FROM session_events WHERE event_name = 'page_view'
  UNION ALL
  SELECT 'view_item',            3,                COUNT(DISTINCT session_id) FROM session_events WHERE event_name = 'view_item'
  UNION ALL
  SELECT 'add_to_cart',          4,                COUNT(DISTINCT session_id) FROM session_events WHERE event_name = 'add_to_cart'
  UNION ALL
  SELECT 'begin_checkout',       5,                COUNT(DISTINCT session_id) FROM session_events WHERE event_name = 'begin_checkout'
  UNION ALL
  SELECT 'add_payment_info',     6,                COUNT(DISTINCT session_id) FROM session_events WHERE event_name = 'add_payment_info'
  UNION ALL
  SELECT 'purchase',             7,                COUNT(DISTINCT session_id) FROM session_events WHERE event_name = 'purchase'
),

baseline AS (
  SELECT sessions AS total_sessions
  FROM stage_sessions
  WHERE stage = 'session_start'
)

SELECT
  s.stage_order,
  s.stage,
  s.sessions,
  ROUND(100.0 * s.sessions / b.total_sessions, 2) AS pct_of_session_start
FROM stage_sessions s
CROSS JOIN baseline b
ORDER BY s.stage_order;
