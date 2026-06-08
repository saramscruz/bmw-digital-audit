# Insight Brief — BMW Digital Funnel

**Data:** Google Merchandise Store GA4 sample dataset — not BMW. Patterns are directionally valid; specific rates do not transfer. One transparency statement, stated once.

---

## What We Know

Four queries run against Google's public GA4 dataset (354,857 sessions, 270,154 users, Nov 2020–Jan 2021) produced findings directly relevant to how BMW should think about its digital funnel.

**Conversion takes multiple sessions and days.** Of 270,154 users, 4,419 converted. Those who converted took a median of 3 sessions and an average of 129 hours — just over five days — from first visit to purchase. Non-converters averaged 1.3 sessions and did not return. The conversion window is a multi-day journey, not a single-visit decision.

**The funnel breaks at one step.** Product view to add-to-cart retained only 19.7% of sessions. Every other transition retained at least 61%. End-to-end conversion across 354,857 sessions was 1.4%. One step is responsible for the majority of funnel loss; everything downstream is secondary.

**The mobile gap is channel-specific, not universal.** Mobile CPC converts at 4.28% against desktop CPC at 5.06% — a meaningful gap on paid traffic. Mobile referral, however, outperforms desktop referral outright: 7.53% vs 7.01%. The problem is not mobile devices. It is the mobile experience for paid acquisition traffic specifically.

**Return visits compound without plateauing.** Conversion grows from 0.78% on the first session to 2.01% on the second, 3.99% on sessions three through five, and 4.94% on session six or more — a 6.3× lift across the journey. The rate does not flatten; every return visit adds measurable conversion probability.

These patterns align with what BMW's own public data shows. Buyers average 14+ hours of online research before contacting a dealer and now make just 1.4 dealer visits before purchase — meaning the digital funnel does the work that showrooms used to do. BMW's fastest-growing segment sharpens this further: 426,594 BEV deliveries in 2024, up 13.5% year-on-year, with electric buyers facing technology decisions — range, charging infrastructure, software — that extend the research window beyond the automotive average. BMW is investing triple-digit millions annually to capture that journey digitally.

---

## What It Suggests

**Re-engagement windows are too short.** If the typical converter takes 129 hours from first visit to purchase, a standard 24-hour retargeting window discards the majority of eventual buyers before they convert. The data supports a 5–7 day sequence. This is a campaign settings change, not a creative problem, and it costs nothing to test.

**One transition needs fixing before anything else.** An 80.3% drop-off at the product-to-cart step is not a marginal inefficiency — four in five people who viewed a product did not take the next step. For BMW, the equivalent transition is model page to configurator start. If that step has comparable retention, optimising it produces more incremental leads than any combination of downstream improvements.

**Target mobile paid traffic, not mobile broadly.** Mobile referral already outperforms desktop. The gap is concentrated on CPC: 0.78 percentage points. Treating "mobile" as a single problem produces fixes in the wrong places. The paid mobile landing experience — not the configurator, not the model page — is where the gap lives.

**The iX3 Gap — BMW's highest-demand model has the weakest conversion path.** BMW's most searched model in Portugal right now is the iX3 (+1,050% web search, BREAKOUT on YouTube, June 2026). Yet the iX3 configurator has no Reserve CTA — the highest-intent digital conversion action available on the i4 is absent entirely. The only conversion paths are Pedido de Proposta and Test Drive, both dealer-mediated. The iX3 also has 14 configuration steps versus the i4's 12, a higher entry price (€64,500 vs €57,950), and an €8,400 decision at Step 1 between two variants. Combined with the Query D finding — conversion rate grows 6.3× from first to sixth session — the absence of a save or reserve mechanism means BMW cannot capture return visitor behaviour for its highest-demand product. This is the highest-priority gap identified in this audit. It requires no SQL to confirm and no GA4 access to fix.

---

## What We'd Test

Three analyses, in priority order:

1. **Configurator entry rate by device and channel.** If mobile CPC visitors open the configurator at a lower rate than desktop CPC visitors, the paid landing page is the problem — not the configurator itself. This separates a media problem from a product problem.

2. **BEV vs ICE mobile completion rate.** BEV buyers navigate more complex decisions. If mobile completion for i4 and iX is lower than for 3 Series or X5, the fix is BEV-configurator-specific — not a sitewide mobile redesign. Knowing this before scoping engineering work changes the cost estimate by an order of magnitude.

3. **Session count for configurator abandoners.** How many sessions does a user who starts but does not complete a configuration take before converting or going cold? The answer sets the re-engagement window precisely, replacing the assumption with a measurement.

---

## Three Testable Product Hypotheses

These are product decisions, not analytics requests. Each one is
actionable without GA4 access, testable within a single sprint,
and falsifiable with a pre-defined success metric.

---

**Hypothesis 1 — Reducing the lead form from 7 to 4 mandatory fields will increase form completion rate**

The "Pedido de Proposta" form on bmw.pt currently requires 7 mandatory fields before submission: Series, Model, Particular/Empresa selector, Nome, Apelido, Telefone, and Concessionário. Industry research consistently shows form conversion drops with each field beyond 3–4.

Proposed change: make Concessionário optional (dealer selection can happen post-submission) and remove the Particular/Empresa selector from the mandatory path (default to Particular, offer toggle).

Success metric: lead form submissions per configurator completion, segmented by device. The mobile CPC gap found in this analysis (4.28% vs desktop 5.06%) predicts that mobile users are disproportionately affected by form length — the success metric should be measured on mobile CPC traffic specifically.

Test mechanism: A/B test on form field count. Control: 7 fields. Variant: 4 fields.
Cost: one sprint. No configurator changes required.

---

**Hypothesis 2 — Adding a "Save configuration" entry point at Step 6 of the iX3 configurator will increase return visit rate**

The data shows conversion grows 6.3x from first to sixth session. The mechanism that enables return visits — saving a configuration — is currently gated behind a BMW ID login wall and only available at the final summary screen (Step 14 on the iX3). Most users who will eventually convert never reach Step 14 on their first visit.

Proposed change: surface a lightweight "Save and continue later" prompt at Step 6 (after the core product decisions — engine, version, paint, wheels, interior, trim — are made but before the upsell layers). Require only an email address, not a full BMW ID registration. Send a single re-engagement email at 48 hours and 5 days if the configuration is not completed.

Success metric: return visit rate for users who save at Step 6 vs users who reach Step 6 without saving. Secondary metric: lead submission rate for return visitors who used the save feature vs those who returned via direct/organic.

Test mechanism: Add save prompt at Step 6 for 50% of iX3 configurator sessions. Measure over 30 days — long enough to capture the 129-hour average conversion window.
Cost: one sprint for the prompt UI; email automation via existing CRM.

---

**Hypothesis 3 — A dedicated mobile landing page for iX3 paid search traffic will close the CPC conversion gap**

The device/channel analysis shows mobile CPC converts at 4.28% vs desktop CPC at 5.06% — a gap that does not exist on referral traffic (mobile referral outperforms desktop at 7.53% vs 7.01%). The funnel observation confirmed the iX3 configurator itself is functionally identical on mobile and desktop. The friction is therefore upstream — in the paid search landing experience before the configurator is reached.

Proposed change: create a dedicated mobile landing page for iX3 paid search campaigns. The page should load the iX3 configurator directly at Step 1 (bypassing the model range and model detail pages), display the two variant options (iX3 40 from €64,500 / iX3 50 xDrive from €72,900) with range and price as the primary decision frame, and surface the "Pedido de Proposta" CTA without requiring configurator completion.

Success metric: CPC conversion rate on mobile, measured as lead submissions per paid mobile session. Baseline: 4.28%. Target: parity with desktop CPC (5.06%) within 60 days.

Test mechanism: Run iX3 paid mobile traffic 50/50 between existing landing page and new dedicated page. Measure for 30 days minimum.
Cost: one sprint for the landing page. No changes to the configurator or existing campaigns required.

---

## What Changes With Real Data

The numbers above demonstrate method, not finding. With BMW's GA4 export, each inference becomes a measurement: the exact configurator step where mobile exits, the actual session count for BEV converters, the paid mobile gap in basis points, the true re-engagement window for configurator abandoners.

BMW is already collecting the data to answer every question in this brief. Running these queries takes hours.
