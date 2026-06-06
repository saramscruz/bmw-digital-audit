# BMW Digital Funnel Model

**Source:** Direct UI observation of bmw.com (accessible to anyone)  
**Method:** Navigating the site and mapping each stage transition as a measurable event  
**Confidence:** High for stage structure; specific page paths subject to site changes  
**Date observed:** June 2026

---

## Overview

The BMW digital funnel has eight stages, from traffic entry to lead confirmation. Each stage transition is a discrete, measurable moment. The model below documents what is observable from the public website, the business question each stage answers, and the GA4 event that would capture the transition.

This mapping is the prerequisite to any analytics implementation. You cannot instrument what you haven't mapped.

---

## Funnel Stage Map

```
[Traffic Sources]
    Organic Search  →
    Direct          →     Stage 0: Entry
    Paid Search     →         │
    Paid Social     →         ▼
    Referral        →     Stage 1: Model Discovery
                              │
                              ▼
                          Stage 2: Model Detail Engagement
                              │
                              ▼
                          Stage 3: Configurator Entry         ← highest-intent action before lead
                              │
                              ▼
                          Stage 4: Configuration Progression
                              │  (multiple steps: engine → colour → interior → wheels → options)
                              ▼
                          Stage 5: Configurator Completion
                              │
                              ▼
                          Stage 6: Lead Action               ← primary conversion event
                              │
                              ▼
                          Stage 7: Lead Confirmation
```

---

## Stage Definitions

### Stage 0 — Entry

**What it is:** Traffic arrives on any bmw.com page via any acquisition channel.

**Observable signals from public data:**
- Channel split: 46.42% direct, 33.39% organic search (Semrush, Estimated)
- ~6.6M monthly visits to bmwusa.com (SimilarWeb, August 2024, Estimated)

**Business question:** Which channels bring high-intent visitors?

**Why it matters for measurement:** Nearly half of traffic arrives direct — visitors who already know the brand. Direct traffic converts at ~9.8% (Ruler Analytics 2026, Benchmark). Organic converts at ~1.57% (WordStream, Benchmark). Averaging these produces a misleading overall CVR. Channel segmentation is not optional.

**GA4 measurement:** `session_start` (auto-collected) + traffic source attribution from `session_traffic_source_detail`

---

### Stage 1 — Model Discovery

**What it is:** User browses the model range, either via the main navigation (`/en/vehicles/`) or a model overview page (e.g., the 3 Series overview).

**Observable page patterns:**
- `/en/vehicles/bmwseries/` — Series overview pages listing all variants
- `/en/vehicles/` — Full model range index

**Business question:** Which models attract the most research interest? Is there a mismatch between traffic distribution and sales volume?

**Why it matters:** A model receiving high traffic but low configurator entries may have a content problem (wrong audience arriving) or a UX problem (page doesn't direct intent to the configurator).

**GA4 measurement:** `page_view` with page path matching `/vehicles/` + custom `model_page_view` event on series overview pages

---

### Stage 2 — Model Detail Engagement

**What it is:** User views a specific model's detail page, reads specifications, watches embedded media, scrolls through feature sections.

**Observable page patterns:**
- Individual model pages: e.g., `/en/vehicles/bmw-3-series/sedan/`
- Key content sections: Overview, Design, Technology, Sustainability tabs

**Business question:** Do visitors engage with the model page or bounce immediately?

**Benchmark context:** Automotive site bounce rate average ~51% (Semrush, bmwusa.com, Estimated). Not all bounces are negative — a direct visitor who confirms a model then calls a dealer is technically a bounce.

**GA4 measurement:** `model_page_view` (custom event) + `scroll` (Enhanced Measurement) + `video_start` / `video_progress`

---

### Stage 3 — Configurator Entry

**What it is:** User clicks "Configure" or "Build Your BMW" CTA and the configurator loads. This is the single highest-intent action before a lead submission.

**Observable on bmw.com:** "Configure" CTAs appear on every model overview page and detail page. In some markets, the configurator is hosted at `configure.bmw.[country]` — cross-domain tracking is required.

**Business question:** What percentage of model-page visitors open the configurator?

**This is Configurator Entry Rate (Tier 1 KPI):** `configurator_start` events ÷ `model_page_view` events.

**Industry context:** No published benchmark exists for this specific ratio. Internal historical baseline is the correct comparator.

**GA4 measurement:** `configurator_start` (custom event)

---

### Stage 4 — Configuration Progression

**What it is:** User works through each configurator step. Based on UI observation, the BMW configurator steps follow this sequence:

| Step # | Step name | What user selects |
|--------|-----------|------------------|
| 1 | Engine / Powertrain | ICE variant, PHEV, or BEV; power output |
| 2 | Exterior | Paint colour, metallic/solid finish |
| 3 | Interior | Upholstery material, colour, dashboard trim |
| 4 | Wheels | Alloy wheel design, size |
| 5 | Options & Packages | Technology packages, driver assistance, M Sport |
| 6 | Accessories | Floor mats, charging cables, etc. |

**Business question:** At which step does the largest drop-off occur?

**Why it matters:** Each step exit represents lost intent. The step with the highest exit rate is the highest-ROI optimisation target. Common patterns: complex options steps (Step 5) and price-shock moments (after package selection).

**GA4 measurement:** `configurator_step_complete` (custom event, fires on each step advance)

---

### Stage 5 — Configurator Completion

**What it is:** User reaches the configuration summary screen showing their full build with total price, spec summary, and lead CTAs.

**Business question:** What is the configurator completion rate?

**This is Configurator Completion Rate (Tier 1 KPI):** summary page views ÷ `configurator_start` events.

**Multi-session consideration:** Users frequently save a configuration and return in a later session to review or modify it. The completion event should be attributed to the session in which the summary is first reached, not the final session before a lead.

**GA4 measurement:** `configurator_complete` (custom event)

---

### Stage 6 — Lead Action

**What it is:** User clicks a lead-generating CTA from the configurator summary or a model page. Three primary CTA types are observable on bmw.com:

1. **Request Test Drive** — opens dealer contact form pre-populated with model
2. **Contact Dealer** — dealer locator + enquiry form
3. **Order Online** — direct purchase flow (available in select markets)

**Business question:** What percentage of completed configurations become leads?

**This is Lead Generation Rate (Tier 1 KPI):** `lead_cta_click` events ÷ `configurator_complete` events.

**Segmentation imperative:** These three CTA types represent very different lead quality. "Order Online" is a committed buyer; "Request Test Drive" is high intent but further from transaction; "Contact Dealer" has the widest quality variance. Averaging them produces a misleading lead rate.

**GA4 measurement:** `lead_cta_click` (custom event)

---

### Stage 7 — Lead Confirmation

**What it is:** User successfully completes the form and reaches the confirmation page or receives a confirmation message. This is the terminal conversion event.

**Business question:** What is the end-to-end funnel conversion rate?

**This is E2E CVR (Tier 1 KPI):** `lead_form_submit` events ÷ total sessions.

**Benchmark context:**
- Automotive average CVR: 2–5% (Demand Local / WordStream 2024, Benchmark)
- Top-quartile automotive sites: 8–16% (Demand Local 2026, Benchmark)
- Direct traffic CVR: 9.8% (Ruler Analytics 2026, Benchmark)

These benchmarks apply to total sessions. BMW's 46% direct traffic share means its reported CVR will naturally be higher than a brand with lower direct share, all else equal.

**GA4 measurement:** `lead_form_submit` (custom event)

---

## Multi-Session Reality

The funnel diagram above implies a linear single-session journey. The reality is multi-session and multi-device:

- Cox Automotive 2024: average buyer spends 14+ hours online before dealer contact
- Average dealer visits before purchase: 1.4
- Implication: a user who completes Stage 5 in session 1, abandons, and returns in session 3 to submit a lead should be counted as **one funnel entrant**, not three separate partial funnels

**Measurement consequence:** Session-level funnel analysis (standard in GA4 Exploration) will overcount funnel drop-off. User-level analysis (requiring BigQuery export or custom GA4 audience definitions) is required for accurate drop-off attribution. Query A in the SQL appendix demonstrates this technique on the GA4 sample dataset.

---

*See [kpi-framework.md](kpi-framework.md) for the KPI definitions fed by this funnel.*  
*See [event-taxonomy.md](event-taxonomy.md) for the GA4 event specification at each stage.*  
*See [sql/A-multi-session-path.sql](../sql/A-multi-session-path.sql) for the technique to measure multi-session journey length.*
