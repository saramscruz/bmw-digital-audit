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

## What Changes With Real Data

The numbers above demonstrate method, not finding. With BMW's GA4 export, each inference becomes a measurement: the exact configurator step where mobile exits, the actual session count for BEV converters, the paid mobile gap in basis points, the true re-engagement window for configurator abandoners.

BMW is already collecting the data to answer every question in this brief. Running these queries takes hours.
