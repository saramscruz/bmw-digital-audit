# GA4 Event Taxonomy — BMW Digital Funnel

**Scope:** Custom GA4 events that would be specified for a BMW.com implementation  
**Status:** Specification design — demonstrates implementation thinking, not a live implementation  
**Note:** These events are not currently observable from outside BMW. This section shows solution design thinking that precedes any analytics implementation.

---

## Why This Section Matters

An event taxonomy is the contract between the business and the data layer. Writing it before any implementation is the discipline that separates analysts who produce reliable data from those who produce data that raises more questions than it answers. A hiring manager reading this section should see someone who thinks in implementation terms, not just reporting terms.

---

## Standard GA4 Events (Auto-Collected)

These fire automatically with gtag.js and require no custom implementation. Listed here for completeness — they form the base of the funnel.

| Event | When it fires | Key parameters available |
|-------|--------------|--------------------------|
| `session_start` | First event of each session | `ga_session_id`, `ga_session_number` |
| `page_view` | Every page load | `page_location`, `page_title`, `page_referrer` |
| `user_engagement` | When page is in focus >1 second | `engagement_time_msec` |
| `first_visit` | First time user visits site | — |
| `scroll` | 90% scroll depth reached | `percent_scrolled` |
| `click` | Outbound link click | `link_url`, `link_text` |

---

## Enhanced Measurement Events (GA4 Toggle)

Enable in GA4 admin. No code required for basic versions; custom parameters require gtag customisation.

| Event | Trigger | BMW relevance |
|-------|---------|---------------|
| `video_start` | Video playback begins | Model reveal videos, configurator walkthroughs |
| `video_progress` | 10%, 25%, 50%, 75% played | Engagement depth with model content |
| `video_complete` | Video reaches 100% | Full feature demonstration watched |
| `file_download` | PDF/brochure download | Spec sheet, price list downloads |

---

## Custom Events — BMW Funnel-Specific

These require custom GTM/gtag implementation. Each event definition includes the trigger, mandatory parameters, optional parameters, and the business question it answers.

---

### `model_page_view`

| Field | Value |
|-------|-------|
| **Trigger** | Model detail page load (e.g., `/en/vehicles/bmw-3-series/sedan`) |
| **Business question** | Which models attract the most research interest, and from which channels? |

| Parameter | Type | Required | Values / Notes |
|-----------|------|----------|----------------|
| `model_name` | string | Yes | e.g., `3 Series Sedan`, `iX xDrive50` |
| `model_series` | string | Yes | `1`, `2`, `3`, `4`, `5`, `7`, `X1`…`X7`, `i3`, `i4`, `i5`, `i7`, `iX`, `M2`… |
| `fuel_type` | string | Yes | `BEV`, `PHEV`, `ICE`, `MHEV` |
| `market` | string | Yes | ISO 3166-1 alpha-2 country code, e.g., `US`, `DE`, `GB` |
| `body_type` | string | No | `Sedan`, `Estate`, `Coupe`, `SAV`, `Convertible` |
| `price_from_eur` | number | No | Entry price shown on the page |

---

### `configurator_start`

| Field | Value |
|-------|-------|
| **Trigger** | User clicks any "Configure" / "Build Your Own" CTA and the configurator iframe/page loads |
| **Business question** | What percentage of model-page visitors open the configurator? (Configurator Entry Rate — Tier 1 KPI) |

| Parameter | Type | Required | Values / Notes |
|-----------|------|----------|----------------|
| `model_name` | string | Yes | Same as `model_page_view` |
| `model_series` | string | Yes | Same as `model_page_view` |
| `fuel_type` | string | Yes | Same as `model_page_view` |
| `entry_point` | string | Yes | `model_page`, `homepage`, `search_result`, `direct_url` |
| `market` | string | Yes | ISO country code |

---

### `configurator_step_complete`

| Field | Value |
|-------|-------|
| **Trigger** | User advances from one configurator step to the next (step transition, not just view) |
| **Business question** | At which step does the largest drop-off occur? (feeds Exit Rate by Step — Tier 2 KPI) |

| Parameter | Type | Required | Values / Notes |
|-----------|------|----------|----------------|
| `step_number` | integer | Yes | 1–N; zero-indexed is acceptable but document clearly |
| `step_name` | string | Yes | `engine`, `exterior_colour`, `interior`, `wheels`, `options`, `packages`, `accessories` |
| `selection_made` | string | Yes | The option code or description chosen (e.g., `mineral_white_metallic`) |
| `model_name` | string | Yes | Same as prior events |
| `fuel_type` | string | Yes | Same as prior events |
| `cumulative_price_eur` | number | No | Running price total shown to user |
| `time_on_step_sec` | integer | No | Seconds spent on this step before advancing |

---

### `configurator_complete`

| Field | Value |
|-------|-------|
| **Trigger** | User reaches the configuration summary/review screen |
| **Business question** | What is the configurator completion rate? (Configurator Completion Rate — Tier 1 KPI) |

| Parameter | Type | Required | Values / Notes |
|-----------|------|----------|----------------|
| `model_name` | string | Yes | Final configured model |
| `model_series` | string | Yes | Final series |
| `fuel_type` | string | Yes | Final powertrain selection |
| `total_price_eur` | number | Yes | Full configured price as shown on summary |
| `total_steps_completed` | integer | Yes | Count of steps user completed |
| `session_number_in_journey` | integer | No | `ga_session_number` at time of completion |
| `market` | string | Yes | ISO country code |

---

### `lead_cta_click`

| Field | Value |
|-------|-------|
| **Trigger** | User clicks a lead-generating CTA: "Request test drive", "Contact dealer", "Order online", "Get a quote" |
| **Business question** | What percentage of completed configurations become leads? (Lead Generation Rate — Tier 1 KPI) |

| Parameter | Type | Required | Values / Notes |
|-----------|------|----------|----------------|
| `cta_type` | string | Yes | `test_drive`, `dealer_contact`, `order_online`, `get_quote`, `callback` |
| `model_name` | string | Yes | |
| `model_series` | string | Yes | |
| `fuel_type` | string | Yes | |
| `cta_location` | string | Yes | `configurator_summary`, `model_page`, `homepage`, `search_result` |
| `market` | string | Yes | |
| `total_price_eur` | number | No | If available from configurator context |

---

### `lead_form_submit`

| Field | Value |
|-------|-------|
| **Trigger** | User successfully submits the lead form (client-side confirmation) |
| **Business question** | What is the end-to-end funnel conversion rate? (E2E CVR — Tier 1 KPI) |

| Parameter | Type | Required | Values / Notes |
|-----------|------|----------|----------------|
| `lead_type` | string | Yes | Matches `cta_type` from `lead_cta_click` |
| `model_name` | string | Yes | |
| `market` | string | Yes | |
| `dealer_id` | string | No | Anonymised dealer code |
| `form_completion_time_sec` | integer | No | Time from form open to submit |
| `session_number_in_journey` | integer | No | Which session number in this user's history |

---

## Implementation Notes

**Parameter naming:** All parameters use snake_case, consistent with GA4 convention. Do not mix naming conventions within the same implementation.

**Session vs. user scope:** `model_page_view` and `configurator_start` are session-scoped events. Lead events should be user-scoped where possible to support lifetime value analysis.

**Cross-domain tracking:** If the configurator is hosted on a subdomain or third-party domain (common in automotive), cross-domain measurement must be configured explicitly in GA4 or session attribution will break.

**Sampling:** GA4 standard properties do not sample up to 10M events/day. BMW.com traffic likely exceeds this; GA4 360 or BigQuery export is required for unsampled analysis.

**Consent mode:** BMW operates in GDPR-regulated markets. Consent mode v2 must be implemented. Modelled conversions will supplement observed data for users who decline analytics cookies.

*See [kpi-framework.md](kpi-framework.md) for how these events feed the Tier 1/2/3 KPI structure.*
