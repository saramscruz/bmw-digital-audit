# BMW Digital Funnel Model

**Source:** Direct UI observation of bmw.pt (Portugal market) — market-level implementation of BMW Group digital platform. URL structure and form domains are market-specific. Core funnel architecture consistent with bmw.com global.  
**Method:** Navigating the site and mapping each stage transition, CTA, URL, and form field as observed  
**Market:** Portugal (pt-PT)  
**Device:** Desktop (see Mobile Observation section at end)  
**Date observed:** June 2026

---

## Overview

The BMW Portugal digital funnel has six stages, from homepage entry to lead submission. Each stage transition is a discrete, measurable event. The model below documents exactly what is observable from the public website: URLs, CTAs, step sequences, mandatory form fields, and the friction points that emerge from the structure.

This mapping is the prerequisite to any analytics implementation. You cannot instrument what you haven't mapped.

---

## Funnel Stage Map

```
[Traffic Sources]
    Organic Search  →
    Direct          →     Stage 0: Entry (bmw.pt/pt/index.html)
    Paid Search     →         │
    Paid Social     →         ▼
    Referral        →     Stage 1: Model Range (bmw.pt/pt/all-models.html)
                              │  inline panel opens on model click
                              ▼
                          Stage 2: Configurator — 12 steps
                              │  (configure.bmw.pt — cross-domain)
                              ▼
                          Stage 3: Configurator Summary (step 12)
                              │
                    ┌─────────┼─────────┐
                    ▼         ▼         ▼
                Stage 4a   Stage 4b  Stage 4c
                Proposta   Reserve   Test Drive
                (7 fields) (BMW ID)  (same as Reserve)
```

---

## Stage Definitions

### Stage 0 — Entry

**URL:** `bmw.pt/pt/index.html`

**Primary CTA:** "Modelos & Configurador" button

**What it is:** Traffic arrives on the BMW Portugal homepage. The primary navigation action offered to users is the "Modelos & Configurador" button, directing toward the model range.

**Measurement note:** Standard `session_start` with traffic source attribution. Channel segmentation is required — direct traffic and paid traffic convert at materially different rates and must not be averaged.

---

### Stage 1 — Model Range

**URL:** `bmw.pt/pt/all-models.html`

**Interaction:** Clicking a model box (e.g. "i4 Models") opens an inline panel on the same page — no page navigation occurs.

**CTAs available in inline panel:**
- "Configuração e preço" — enters the configurator
- "Pedido de proposta" — skips to the lead form directly

**Observation:** The inline panel pattern means a model selection does not generate a page_view event in standard GA4. This transition requires a custom event (`model_panel_open`) or it is invisible to analytics. Users who click "Pedido de proposta" directly from this panel skip the configurator entirely — their lead-form data carries no configuration signal.

---

### Stage 2 — Configurator (12 steps)

**URL structure:** `configure.bmw.pt/pt_PT/configure/[model-code]/[options]`

**Cross-domain note:** The configurator runs on a subdomain (`configure.bmw.pt`) separate from the main site (`bmw.pt`). Without explicit cross-domain tracking configuration in GA4, each subdomain crossing creates a new session and breaks funnel attribution.

The configurator has 12 discrete steps:

| Step | Name | Content | Feature |
|------|------|---------|---------|
| 1 | Motorizações | Engine type: Elétrico / Gasolina / Gasóleo | — |
| 2 | Versão | Version selection — **base price first appears here** (from €57,950) | — |
| 3 | Pinturas | Paint: BMW Individual / Metallic / Uni | Compare |
| 4 | Jantes | Wheels | Compare |
| 5 | Estofo | Interior upholstery | Compare |
| 6 | Frisos | Trim | Compare |
| 7 | Packs | Packages | Ver detalhes |
| 8 | Opcionais | Options | Ver detalhes |
| 9 | Carregamento | Charging | Ver detalhes |
| 10 | Acessórios | Accessories | Ver detalhes |
| 11 | Services | Services | Ver detalhes |
| 12 | Concluído | Summary — "A sua configuração está pronta!" | — |

**Structural observations:**

- **Price first appears at Step 2.** Until this point the user has committed only to a drivetrain type. The base price (€57,950 observed for i4) is revealed on version selection. This is the primary likely drop-off point in the funnel — users for whom price is misaligned with expectation exit here, before touching any configuration choices. Step 2 exit rate is the single highest-priority drop-off metric to instrument.

- **Steps 1–6 are core product decisions.** These define the vehicle: powertrain, version, paint, wheels, interior, trim. Drop-off in this range indicates product configuration friction.

- **Steps 7–11 are upsell layers.** Packs, Options, Charging, Accessories, Services. These add to price progressively. Each "Ver detalhes" expansion is a micro-engagement signal worth capturing. Cumulative price delta from Step 2 to Step 11 may be a secondary drop-off driver.

---

### Stage 3 — Configurator Summary

**URL:** Same as configurator (step 12 — `configure.bmw.pt/pt_PT/configure/...`)

**Content:** 360-degree vehicle view, final price, available vehicles in stock

**CTAs available:**
- Pedido de proposta (request proposal)
- Reservar (reserve — highest-intent action)
- Test drive
- Guardar configuração (save configuration)
- Partilhar link (share link)

**Observation:** Five distinct actions are presented at this stage, representing a wide range of intent levels — from sharing a link to placing a reservation. Each CTA must be tracked as a separate event. Aggregating them into a single "lead CTA click" metric masks the true distribution of intent.

---

### Stage 4a — Lead: Pedido de Proposta

**URL:** `bmw.pt/faas/form/pt-pt/bmw/rfo/pedido-de-proposta.html`

**Mandatory fields (7):**
1. Série (Series)
2. Modelo (Model)
3. Particular / Empresa selector
4. Nome (First name)
5. Apelido (Last name)
6. Telefone (Phone)
7. Concessionário BMW preferência (Preferred dealer)

**Friction assessment:** 7 mandatory fields. The threshold at which form conversion typically drops is 3–4 fields (Baymard Institute benchmark). This form is above that threshold. The Particular/Empresa selector adds a classification step that requires the user to self-identify, which introduces additional cognitive friction for undecided buyers.

---

### Stage 4b — Lead: Reservar (highest-intent action)

**URL:** `configure.bmw.pt` checkout flow

**Steps:**
1. Dealer selection
2. Personal data + BMW ID creation or login
3. Payment data
4. Reservation overview

**Friction assessment:** The BMW ID account requirement at Step 2 is a login wall imposed on the highest-intent action in the funnel. A user ready to place a reservation must either retrieve existing credentials or create an account before proceeding. This is a known conversion friction point. The proportion of reservation attempts that abandon at Step 2 is a critical measurement gap — it is not visible without server-side or enhanced ecommerce tracking on the `configure.bmw.pt` domain.

---

### Stage 4c — Lead: Test Drive

**URL:** `bmw.pt/forms/tda/tda.html`

**Friction assessment:** The test drive form requires the same data as the Reserve flow. Equal friction is applied to a low-commitment action (test drive) and a high-commitment action (reservation). This suppresses test drive conversion — users willing to book a test drive but not ready to reserve are deterred by the same level of data entry required for a purchase reservation. Test drive volume is the primary re-engagement mechanism for undecided buyers; suppressing it has downstream pipeline consequences.

---

### Stage 5 — Save Configuration

**URL:** `customer.bmwgroup.com/oneid/#/login`

**Mechanism:** Saving a configuration requires a BMW ID account login or creation.

**Observation:** The save/re-engagement mechanism — the path most likely to recover multi-session buyers — is gated behind account creation. This has two consequences: (1) users who do not create an account cannot save their configuration and are less likely to return to a specific build, and (2) returning users who did create an account are not trackable in standard GA4 without a CRM integration, making return-visit attribution invisible. The Query D data showing saved-configuration paths as highest-value journeys makes this gate a measurable revenue constraint, not just a UX issue.

---

## Funnel Friction Summary

| Stage | Friction point | Impact |
|-------|---------------|--------|
| Stage 1 | Inline panel — no page_view event | Model selection invisible to GA4 without custom event |
| Stage 2, Step 2 | Price reveal at €57,950 | Primary likely drop-off point in configurator |
| Stage 2 → Stage 3 | Cross-domain to configure.bmw.pt | Breaks session attribution without explicit cross-domain config |
| Stage 4a | 7 mandatory fields | Above conversion-drop threshold of 3–4 fields |
| Stage 4b | BMW ID login wall | Friction on highest-intent action |
| Stage 4c | Same data requirements as Stage 4b | Suppresses low-commitment conversions (test drive) |
| Stage 5 | BMW ID required to save | Gates primary re-engagement mechanism |

---

## Mobile Observation

**Tested:** June 2026  
**Flow and information:** Identical to desktop  

**Key structural difference:** The 12-step configurator navigation changes from a horizontal upper menu (desktop) to a vertical scroll interface (mobile). All CTAs, steps, mandatory fields, and URLs are identical across devices.

**No mobile-specific friction was identified in the configurator navigation structure.**

The device-level performance gap observed in Query C (CPC: 4.28% mobile vs 5.06% desktop CTR) is therefore unlikely to originate from the configurator itself. The more likely origin is paid traffic landing pages reached *before* the configurator — specifically how ad landing pages render and load on mobile, and whether the CTA path from paid landing page to `all-models.html` to `configure.bmw.pt` is optimised for mobile sessions.

---

*See [kpi-framework.md](kpi-framework.md) for the KPI definitions fed by this funnel.*  
*See [event-taxonomy.md](event-taxonomy.md) for the GA4 event specification at each stage.*  
*See [sql/A-multi-session-path.sql](../sql/A-multi-session-path.sql) for the technique to measure multi-session journey length.*
