# KPI Framework — BMW Digital Funnel

**Scope:** What a Digital Analyst would measure on bmw.com with full GA4 access  
**Status:** Specification — reusable across automotive brands with minor adaptation  
**Confidence:** Framework design (High); actual BMW values (not available without internal access)

---

## Design Principle

KPIs are organised in three tiers. Tier 1 tells you whether digital performance is healthy. Tier 2 tells you where to look when it isn't. Tier 3 defines the dimensions by which every KPI should be breakable. This structure prevents the common failure mode of reporting too many metrics with no clear hierarchy.

---

## Tier 1 — Primary KPIs

*What the business cares about. These appear in executive dashboards and QBRs.*

| KPI | Formula | Target direction | Why it matters |
|-----|---------|-----------------|----------------|
| End-to-End Conversion Rate | Lead Confirmations ÷ Total Sessions | Higher | The headline number for digital sales contribution; contextualises all other metrics |
| Configurator Entry Rate | Configurator Opens ÷ Model Page Views | Higher | Measures whether product pages drive purchase intent; low rate suggests content or UX misalignment |
| Configurator Completion Rate | Summary Page Views ÷ Configurator Opens | Higher | Measures configurator UX quality; low rate indicates friction in the configuration journey |
| Lead Generation Rate | Lead Actions ÷ Summary Page Views | Higher | Measures whether high intent converts to qualified dealer or online contact |

**Benchmark context (not BMW-specific):**
- Industry average automotive website CVR: 2–5% (Demand Local / WordStream 2024)
- Top-performing automotive sites: 8–16% (Demand Local 2026)
- Direct traffic CVR, automotive: 9.8% (Ruler Analytics 2026)

---

## Tier 2 — Diagnostic KPIs

*Where to look when Tier 1 drops. These do not appear on executive dashboards but are essential for root cause analysis.*

| KPI | Formula | What it diagnoses | When to prioritise |
|-----|---------|------------------|-------------------|
| Bounce Rate by Landing Page Type | Single-page sessions ÷ Total sessions, by page template | Entry traffic misaligned with content | When entry CVR drops without a change in paid spend |
| Device Conversion Gap | Desktop CVR ÷ Mobile CVR | Mobile checkout friction; configurator usability on small screens | Always — the automotive mobile paradox is well-documented |
| Channel-to-Lead Ratio | Leads ÷ Sessions by traffic source | Which acquisition channels produce qualified visitors | When cost-per-lead rises without a traffic drop |
| Return Visitor Rate to Configurator | Return sessions with configurator event ÷ All configurator sessions | Whether users are returning to complete saved configurations | When configurator completion rate is low |
| Time-to-Configure | Median minutes from configurator open to summary page | Whether the configurator is too long or too complex | When configurator completion rate is low |
| Page Depth by Channel | Avg pages per session by traffic source | Content engagement quality; whether organic visitors explore or bounce | When organic traffic rises but CVR falls |
| Exit Rate by Configurator Step | Step N exits ÷ Step N entries | Which specific step is highest friction | When configurator completion rate drops |

---

## Tier 3 — Segmentation Dimensions

*Every Tier 1 and Tier 2 KPI should be breakable by all dimensions below. A flat average hides the insight.*

| Dimension | Values | Why segment |
|-----------|--------|------------|
| Market / Country | DE, US, UK, CN, etc. | Digital maturity and configurator availability differ by market |
| Device Category | Desktop, Mobile, Tablet | The mobile paradox is strongest on mobile; desktop completes at higher rates |
| Acquisition Channel | Organic Search, Direct, Paid Search, Paid Social, Referral, Display | Channel intent varies dramatically; direct traffic is already pre-sold |
| Model Series | 1, 2, 3, 4, 5, 7, X, i, M | Price point and BEV status affect research depth and conversion speed |
| User Type | New vs. Returning | Returning visitors have higher intent; Cox Automotive data shows 14+ hours of research |
| Powertrain | BEV vs. PHEV vs. ICE | BEV buyers are more digital-native and research-intensive |
| Session Number | 1st, 2nd, 3rd–5th, 6th+ | Conversion lift accelerates with return visits (see Query D) |
| Time Period | Day of week, hour of day, week | Automotive research peaks on weekends; paid peaks on weekdays |

---

## KPI Relationships

```
Total Sessions
    │
    ├── Bounce Rate (Tier 2) → signals entry quality
    │
    └── Model Page Views
            │
            ├── Channel-to-Lead Ratio (Tier 2) → signals acquisition quality
            │
            └── Configurator Opens  ←── Configurator Entry Rate (Tier 1)
                    │
                    ├── Time-to-Configure (Tier 2) → signals complexity
                    ├── Exit Rate by Step (Tier 2) → signals friction point
                    │
                    └── Summary Page Views  ←── Configurator Completion Rate (Tier 1)
                                │
                                └── Lead Actions  ←── Lead Generation Rate (Tier 1)
                                        │
                                        └── Lead Confirmations  ←── E2E CVR (Tier 1)
```

---

## Reusability Notes

This framework maps to BMW's specific funnel architecture (configurator → lead). The Tier 1 KPI formulas adapt to any automotive brand by substituting equivalent funnel events. The Tier 3 dimensions are universal.

For a brand without a configurator (e.g., a used-car marketplace), replace configurator steps with search → listing → VDP → contact form.

*See [event-taxonomy.md](event-taxonomy.md) for the GA4 implementation that feeds these KPIs.*  
*See [funnel-model-bmw.md](funnel-model-bmw.md) for the BMW-specific funnel stage mapping.*
