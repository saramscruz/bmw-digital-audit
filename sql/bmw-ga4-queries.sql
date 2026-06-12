-- ============================================================
-- BMW GA4 QUERIES: Requires BMW GA4 BigQuery export
-- These queries are written but cannot be executed without
-- access to BMW's GA4 BigQuery export.
-- Schema follows standard GA4 event structure.
-- Event names marked [VERIFY] must be confirmed against
-- BMW's actual GA4 implementation before running.
-- ============================================================


-- ============================================================
-- QUERY 1: iX3 vs i4 configurator entry rate
-- ============================================================
-- Reveals whether iX3 BREAKOUT search demand is entering the
-- configurator or dissipating on the model page. A high
-- view_item rate paired with a low configurator_start rate
-- on iX3 vs i4 indicates the model page is not converting
-- intent -- the gap is pre-configurator, not in the tool itself.
-- ============================================================

WITH session_attrs AS (
  SELECT
    (
      SELECT value.int_value
      FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    )                          AS session_id,
    device.category            AS device_category,
    traffic_source.medium      AS medium
  FROM `YOUR_PROJECT.YOUR_DATASET.events_*`  -- replace with BMW export path
  WHERE event_name = 'session_start'
),

model_views AS (
  SELECT
    (
      SELECT value.int_value
      FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    )                          AS session_id,
    (
      SELECT value.string_value
      FROM UNNEST(event_params)
      WHERE key = 'model_name'  -- [VERIFY] parameter name in BMW implementation
    )                          AS model_name
  FROM `YOUR_PROJECT.YOUR_DATASET.events_*`
  WHERE event_name = 'view_item'
    AND (
      SELECT value.string_value
      FROM UNNEST(event_params)
      WHERE key = 'model_name'
    ) IN ('iX3', 'i4')
),

configurator_entries AS (
  SELECT
    (
      SELECT value.int_value
      FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    )                          AS session_id,
    (
      SELECT value.string_value
      FROM UNNEST(event_params)
      WHERE key = 'model_name'  -- [VERIFY]
    )                          AS model_name
  FROM `YOUR_PROJECT.YOUR_DATASET.events_*`
  WHERE event_name = 'configurator_start'  -- [VERIFY] event name
),

session_level AS (
  SELECT
    mv.session_id,
    mv.model_name,
    sa.device_category,
    sa.medium,
    MAX(CASE WHEN ce.session_id IS NOT NULL THEN 1 ELSE 0 END) AS entered_configurator
  FROM model_views mv
  LEFT JOIN session_attrs sa USING (session_id)
  LEFT JOIN configurator_entries ce
    ON mv.session_id = ce.session_id AND mv.model_name = ce.model_name
  GROUP BY mv.session_id, mv.model_name, sa.device_category, sa.medium
)

SELECT
  model_name,
  device_category,
  medium,
  COUNT(*)                                                  AS model_page_sessions,
  SUM(entered_configurator)                                 AS configurator_starts,
  ROUND(100.0 * SUM(entered_configurator) / COUNT(*), 2)   AS configurator_entry_rate_pct
FROM session_level
GROUP BY model_name, device_category, medium
ORDER BY model_name, device_category, medium;


-- ============================================================
-- QUERY 2: Configurator abandonment by step and device
-- ============================================================
-- Step counts observed 12 June 2026: iX3 = 14 steps, i4 = 12 steps.
-- The step where mobile drop-off rate exceeds desktop drop-off rate
-- by the largest margin is the fix point -- not the overall mobile
-- completion rate. A uniform mobile deficit suggests UX friction;
-- a spike at a specific step suggests a content or input problem
-- (e.g. a finance calculator, image carousel, or form field that
-- degrades on small viewports).
-- ============================================================

WITH configurator_steps AS (
  SELECT
    (
      SELECT value.int_value
      FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    )                                                       AS session_id,
    device.category                                         AS device_category,
    REGEXP_EXTRACT(
      (
        SELECT value.string_value
        FROM UNNEST(event_params)
        WHERE key = 'page_location'
      ),
      r'configure\.bmw\.pt[^?#]*?[/=](\d+)'               -- [VERIFY] URL step pattern
    )                                                       AS step_number
  FROM `YOUR_PROJECT.YOUR_DATASET.events_*`
  WHERE event_name = 'page_view'
    AND (
      SELECT value.string_value
      FROM UNNEST(event_params)
      WHERE key = 'page_location'
    ) LIKE '%configure.bmw.pt%'
),

step_sessions AS (
  SELECT
    CAST(step_number AS INT64)  AS step_number,
    device_category,
    COUNT(DISTINCT session_id)  AS sessions_reached
  FROM configurator_steps
  WHERE step_number IS NOT NULL
  GROUP BY step_number, device_category
),

with_next AS (
  SELECT
    step_number,
    device_category,
    sessions_reached,
    LEAD(sessions_reached) OVER (
      PARTITION BY device_category ORDER BY step_number
    )                           AS sessions_next_step
  FROM step_sessions
)

SELECT
  step_number,
  device_category,
  sessions_reached,
  sessions_next_step,
  ROUND(
    100.0 * (sessions_reached - COALESCE(sessions_next_step, 0)) / sessions_reached,
    2
  )                             AS drop_off_rate_pct
FROM with_next
ORDER BY step_number, device_category;


-- ============================================================
-- QUERY 3: Session count at purchase-intent event
-- ============================================================
-- This is the automotive-specific replacement for the Google
-- Merchandise Store proxy in proxy-analysis.sql Query 2.
-- Where the proxy showed visit band for e-commerce purchase,
-- this shows the actual session count at the moment a BMW
-- user signals purchase intent (dealer contact or checkout).
-- The resulting distribution defines the minimum re-engagement
-- window: if 60%+ of intent events occur on session 3+, a
-- 24-hour retargeting window misses the majority of convertible
-- users regardless of bid strategy.
-- ============================================================

WITH intent_events AS (
  SELECT
    user_pseudo_id,
    (
      SELECT value.int_value
      FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    )                          AS session_id,
    (
      SELECT value.int_value
      FROM UNNEST(event_params)
      WHERE key = 'ga_session_number'  -- session count at time of event
    )                          AS session_number_at_intent,
    event_name
  FROM `YOUR_PROJECT.YOUR_DATASET.events_*`
  WHERE event_name IN ('dealer_contact_submit', 'begin_checkout')
  -- [VERIFY] dealer_contact_submit event name against BMW implementation
),

deduped AS (
  SELECT
    user_pseudo_id,
    MIN(session_number_at_intent) AS first_intent_session
  FROM intent_events
  GROUP BY user_pseudo_id
)

SELECT
  CASE
    WHEN first_intent_session = 1 THEN '1 - First visit'
    WHEN first_intent_session = 2 THEN '2 - Second visit'
    WHEN first_intent_session BETWEEN 3 AND 5 THEN '3 - 3rd to 5th visit'
    ELSE '4 - 6th visit or more'
  END                          AS session_band_at_intent,
  COUNT(*)                     AS users,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_intent_users
FROM deduped
GROUP BY session_band_at_intent
ORDER BY session_band_at_intent;


-- ============================================================
-- QUERY 4: CPC mobile vs desktop conversion rate
-- ============================================================
-- Proxy baseline from bigquery-public-data GA4 sample
-- (proxy-analysis.sql Query 3):
--   Desktop CPC: 1.09%   Mobile CPC: 0.97%
-- This query produces the BMW-specific equivalent against the
-- actual GA4 export. A gap larger than the proxy baseline
-- indicates BMW's paid mobile landing experience underperforms
-- relative to a general e-commerce benchmark -- the problem
-- is the post-click page, not paid media targeting. A gap
-- smaller than baseline suggests BMW's mobile paid experience
-- is competitive and effort should shift to bid strategy.
-- ============================================================

WITH session_attrs AS (
  SELECT
    (
      SELECT value.int_value
      FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    )                          AS session_id,
    device.category            AS device_category
  FROM `YOUR_PROJECT.YOUR_DATASET.events_*`
  WHERE event_name = 'session_start'
    AND traffic_source.medium = 'cpc'
),

conversions AS (
  SELECT
    (
      SELECT value.int_value
      FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    )                          AS session_id,
    1                          AS converted
  FROM `YOUR_PROJECT.YOUR_DATASET.events_*`
  WHERE event_name IN ('purchase', 'dealer_contact_submit')
  -- [VERIFY] dealer_contact_submit; add any additional lead events
),

session_level AS (
  SELECT
    sa.session_id,
    sa.device_category,
    MAX(COALESCE(c.converted, 0)) AS converted
  FROM session_attrs sa
  LEFT JOIN conversions c USING (session_id)
  GROUP BY sa.session_id, sa.device_category
)

SELECT
  device_category,
  COUNT(*)                                           AS cpc_sessions,
  SUM(converted)                                     AS conversions,
  ROUND(100.0 * SUM(converted) / COUNT(*), 2)        AS conversion_rate_pct
FROM session_level
GROUP BY device_category
ORDER BY device_category;
