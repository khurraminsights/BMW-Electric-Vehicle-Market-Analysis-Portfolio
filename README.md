# BMW Electric Vehicle Market Analysis
### SQL Server Portfolio Case Study | 2022–2023

<div align="center">
    
<img width="2154" height="730" alt="BMW Electric Vehicle Market Analysis Dashboard" src="https://github.com/user-attachments/assets/8f636d7a-fabf-4782-b020-03cdfcf9827d" />

**EV Sales · Regional Markets · Model Performance · Customer Satisfaction · Competitive Benchmarking**

![SQL Server](https://img.shields.io/badge/SQL_Server-T--SQL-CC2927?style=for-the-badge)
![T-SQL](https://img.shields.io/badge/T--SQL-Analysis-087CBB?style=for-the-badge)
![Scope](https://img.shields.io/badge/Analysis-12_Business_Questions-00B4D8?style=for-the-badge)
![Data](https://img.shields.io/badge/Data-Sample_Case_Study-364152?style=for-the-badge)

*An independent analysis of BMW electric-vehicle sales, model attributes, regional demand and selected competitor records using Microsoft SQL Server.*

[Overview](#executive-summary) · [Data Model](#dataset--database-structure) · [Questions](#12-business-questions) · [SQL](#sql-implementation-highlights) · [Findings](#findings-supported-by-the-source-data) · [Limitations](#data-quality--analytical-limitations)

</div>

> **Independence and data disclaimer:** This is an educational portfolio case study, not an official BMW analysis. The uploaded SQL script supplies small demonstration datasets; these are not verified BMW financials, global market shares or actual customer survey results. All findings below refer only to the sample records and stated SQL logic.

---

## Executive Summary

Electric vehicle strategy involves more than comparing unit sales. Companies need to understand **where demand appears strongest, which models appeal to buyers, how product attributes relate to satisfaction, and where competitors outperform them**.

In this project, I designed a SQL Server case study around **four tables** and **12 business questions** spanning four workstreams:

| Workstream | Questions | Analytical focus |
|---|---:|---|
| **Sales performance** | 3 | Year, region and model comparisons |
| **Customer preferences** | 2 | Satisfaction, price, driving range and battery capacity |
| **Competitive benchmarking** | 2 | BMW versus selected competitor models and markets |
| **Growth opportunities** | 5 | Regional interest and potential product-market fit |

**My role:** Data Analyst · **Primary tool:** Microsoft SQL Server (T-SQL) · **Period represented:** 2022–2023

**What this work demonstrates:** relational data exploration, aggregate queries, joins, grouped comparisons, conditional scoring, analytical questioning and assessment of data quality.

**What it does not demonstrate:** verified EV market share, revenue forecasts, causal customer preferences, or production-ready commercial recommendations.

---

## Business Context & Objectives

The central business question is:

> **How can BMW identify opportunities to improve EV performance across markets by examining sales patterns, vehicle characteristics, customer interest and competitor activity?**

I break that question into four practical objectives:

1. **Understand BMW EV performance:** compare sales across 2022 and 2023, regions and vehicle models.
2. **Evaluate the product offering:** examine sample satisfaction ratings alongside model price, battery capacity and range.
3. **Benchmark the competition:** compare BMW's sample EV sales with selected Tesla, Audi and Mercedes entries.
4. **Explore growth opportunities:** investigate regional customer-interest records and identify missing data needed for stronger demand analysis.

---

## Dataset & Database Structure

The SQL file creates the `BMW_EV_Market_Analysis` database with these four tables:

| Table | Main fields | Purpose |
|---|---|---|
| `BMW_Sales` | `SaleID`, `Year`, `Region`, `Vehicle_Type`, `Model`, `Sales` | BMW electric and non-electric unit sales by market |
| `BMW_EVs` | `EV_ID`, `Model`, `Customer_Satisfaction`, `Price`, `Range_KM`, `Battery_Capacity_KWh`, `Sales` | EV model characteristics, sample ratings and sales values |
| `Competitor_EVs` | `Competitor_ID`, `Competitor`, `Model`, `Year`, `Region`, `Sales` | Selected competing EV models and regional sales |
| `Potential_Customers` | `CustomerID`, `Region`, `Age`, `Interest` | Illustrative regional customer interest |

### Conceptual analytical flow

```text
                   BMW EV MARKET ANALYSIS
                             |
         +-------------------+-------------------+
         |                   |                   |
      BMW_Sales           BMW_EVs          Competitor_EVs
         |                   |                   |
   Year / Region       Price / Range       Brand / Region
   Model / Units      Battery / Rating      Year / Units
         |                   |                   |
         +-------------------+-------------------+
                             |
                     T-SQL ANALYSIS
                             |
           +-----------------+-----------------+
           |                 |                 |
        EV Sales        Model & Customer   Competitor
       Performance         Attributes      Benchmarking
                                               |
                             Potential_Customers
                             (regional interest)
                                               |
                                        Growth hypotheses
```

**Modeling caution:** Some tables share `Region` or `Model` values, but the script does not declare formal foreign keys between them. Joining records only by region may multiply rows and inflate sums; joining only by model can also create many-to-many matches.

---

## 12 Business Questions

### 01. Sales Performance — 3 questions

**Q1. How did BMW EV sales change year by year?**  
Filter `Vehicle_Type = 'Electric'` and aggregate `Sales` by `Year`. This distinguishes EV performance from non-electric BMW records.

**Q2. Which regions contributed most to BMW EV sales?**  
Aggregate electric vehicle units by `Region` and rank the regions. This identifies market concentration *within the example dataset*.

**Q3. Which BMW EV models performed best by region?**  
Group by `Region` and `Model` to distinguish market-level model performance rather than assuming one model leads everywhere.

### 02. Customer Preferences — 2 questions

**Q4. How do satisfaction, price, range and battery capacity differ by BMW EV model?**  
Compare the recorded sample attributes using grouped averages. These figures describe model records, **not a statistically representative consumer study**.

**Q5. How do pricing, satisfaction and recorded sales compare across models?**  
Compare model-level price, average satisfaction and sales. These descriptive relationships cannot, by themselves, establish that pricing *caused* a change in demand.

### 03. Competitor Benchmarking — 2 questions

**Q6. How do BMW EV unit sales compare with Tesla, Audi and Mercedes in selected regions?**  
Summarize each brand's sample sales separately, then compare markets on a like-for-like year and regional basis wherever the data permits.

**Q7. Where do sampled competitor sales exceed BMW's, and what might explain the gap?**  
Compare units in overlapping market periods. Investigate possible explanations, but do **not** call BMW-sales-to-competitor-sales ratios “market share”: true market share requires a relevant total-market denominator.

### 04. Growth Opportunities — 5 questions

**Q8. Which regions show the strongest customer interest in EVs?**  
Count potential-customer records and evaluate the available `Interest` values. The sample currently stores `'Electric Vehicles'`, not actual `High`/`Medium`/`Low` scores, so interest *intensity* cannot be ranked reliably.

**Q9. Does regional interest align with BMW EV sales?**  
Compare separately aggregated customers and BMW EV units at region level. Regional counts alone are too small for a defensible correlation claim.

**Q10. Which features are most important to potential customers in each region?**  
The script categorizes model range and battery capacity. However, it does **not** include customers' stated feature preferences, so this is a model-feature scoring exercise, not proof of what buyers value.

**Q11. How does customer interest relate to preferred features?**  
The source attempts to compare interest labels with range and battery scores. Its data does not support meaningful interest-level segmentation; richer survey attributes would be needed.

**Q12. How could product attributes be aligned with different regional markets?**  
Use regional model performance and actual customer research to form testable product-positioning hypotheses. Treat all resulting recommendations as exploratory.

---

## SQL Implementation Highlights

The following examples use table and column names from the uploaded script. They illustrate **safer analysis patterns**; execution and totals should still be checked in SQL Server after cleaning the duplicate sample records.

### A. Annual BMW EV Sales

```sql
SELECT
    [Year],
    SUM(Sales) AS EV_Units
FROM dbo.BMW_Sales
WHERE Vehicle_Type = 'Electric'
GROUP BY [Year]
ORDER BY [Year];
```

**Business use:** Compare EV unit volume between 2022 and 2023.

### B. EV Sales by Region and Model

```sql
SELECT
    Region,
    Model,
    SUM(Sales) AS EV_Units
FROM dbo.BMW_Sales
WHERE Vehicle_Type = 'Electric'
GROUP BY Region, Model
ORDER BY Region, EV_Units DESC;
```

**Business use:** Identify which EV models drive units in each represented region.

### C. BMW EV Model Attributes

```sql
SELECT
    Model,
    AVG(Customer_Satisfaction) AS Avg_Satisfaction,
    AVG(Price) AS Avg_Price_USD,
    AVG(CAST(Range_KM AS DECIMAL(10,2))) AS Avg_Range_KM,
    AVG(Battery_Capacity_KWh) AS Avg_Battery_KWh
FROM dbo.BMW_EVs
GROUP BY Model
ORDER BY Avg_Satisfaction DESC;
```

**Business use:** Compare observed model specifications and recorded ratings. The result is descriptive, not causal.

### D. Competitor Comparison Without Inflating Sales

```sql
WITH BMW AS (
    SELECT
        [Year],
        Region,
        SUM(Sales) AS BMW_Units
    FROM dbo.BMW_Sales
    WHERE Vehicle_Type = 'Electric'
    GROUP BY [Year], Region
),
Competitors AS (
    SELECT
        [Year],
        Region,
        Competitor,
        SUM(Sales) AS Competitor_Units
    FROM dbo.Competitor_EVs
    WHERE Competitor IN ('Tesla', 'Audi', 'Mercedes')
    GROUP BY [Year], Region, Competitor
)
SELECT
    c.[Year],
    c.Region,
    c.Competitor,
    b.BMW_Units,
    c.Competitor_Units,
    b.BMW_Units - c.Competitor_Units AS Unit_Difference
FROM Competitors AS c
INNER JOIN BMW AS b
    ON c.[Year] = b.[Year]
   AND c.Region = b.Region
ORDER BY c.[Year], c.Region, c.Competitor;
```

**Why it matters:** Aggregating each side *before* joining prevents region-level row multiplication. Comparing by both year and region avoids mismatched periods. This still represents only the competitor entries included in the script.

### E. Count Potential Customers by Region

```sql
SELECT
    Region,
    COUNT(*) AS Sample_Potential_Customers
FROM dbo.Potential_Customers
GROUP BY Region
ORDER BY Sample_Potential_Customers DESC;
```

**Business use:** Explore the distribution of the small sample. Do not interpret these counts as real market demand or verified customer-interest scores.

---

## Findings Supported by the Source Data

The following observations come from the **literal demonstration records in the SQL file**, not independently verified market data.

- **Coverage:** The sample contains entries for **2022 and 2023** across **North America, Europe and Asia**.
- **BMW EV models:** The records reference **i4, iX3, iX, i7, i3 and iX1**, with price, satisfaction, range and battery attributes in the `BMW_EVs` table.
- **Competitor scope:** The competitor table contains examples from **Tesla, Audi, Mercedes, Nissan and Hyundai**; several benchmarking queries focus on the first three.
- **Driving range:** The example model records include ranges from **350 km to 630 km**. These are dataset values, not verified current manufacturer specifications.
- **Customer interest:** The sample `Interest` field is consistently populated with **`Electric Vehicles`**, which prevents meaningful High/Medium/Low interest scoring.

### Why this README does not announce a top market or overall EV market share

The SQL script repeats several insert records and includes analytical JOIN issues. Running it unchanged can inflate totals or fail before the queries execute. Claims such as **€2.8 billion revenue, 12.6% market share, Germany as the top market, or measured year-on-year growth** are not established by this source.

The appropriate next step is to validate and deduplicate records, rerun the queries, and publish the actual outputs.

---

## Data Quality & Analytical Limitations

Reviewing the SQL file is part of the analytical work. Important issues include:

| Issue found | Why it matters | Recommended fix |
|---|---|---|
| Decorative separator lines such as `=====` are not SQL comments | May produce syntax errors | Replace with `--` comments |
| Trailing comma in `Potential_Customers` table definition | Prevents successful table creation | Remove the comma |
| Repeated INSERT values across the first and second sample batches | Inflates sales, ratings and customer counts | Keep one intended seed dataset |
| Region-only JOINs between customer and sales records | Can multiply rows | Aggregate each table separately before joining |
| `JOIN BMW_EVs bm ON bm.model = bm.model` | Always true for non-null model names; effectively creates a broad cross-join | Join on appropriate model and grain |
| Interest scoring expects `High`, `Medium`, `Low`, while inserted values say `Electric Vehicles` | Scores become zero or misleading | Add a valid interest-level column or revise the metric |
| BMW “market share” computed against competitor sales | Not a true market-share denominator | Obtain complete market sales by region and year |
| Model features used as proxies for stated customer preferences | Does not measure actual preference | Collect surveys or explicit feature-priority data |

### Validation checklist

- [ ] Run the database creation script successfully.
- [ ] Remove duplicate seed records.
- [ ] Verify row counts and primary key uniqueness.
- [ ] Verify consistent regions, model names and years.
- [ ] Rebuild JOINs at the correct data grain.
- [ ] Execute all 12 business-question queries.
- [ ] Reconcile sales totals across annual, regional and model breakdowns.
- [ ] Save query outputs or screenshots to support key findings.
- [ ] Replace illustrative banner metrics with verified figures, if any.
- [ ] Document dataset provenance and assumptions.

---

## Business Recommendations — Hypotheses to Test

The sample raises useful questions but is not sufficient to justify real-world investment decisions. These are **testable analytical directions**:

| Decision area | Possible next action | Evidence needed |
|---|---|---|
| Regional expansion | Prioritize further investigation of markets with strong normalized demand | Complete regional industry sales and demand data |
| Model positioning | Evaluate whether price, range or battery size influence buyer choice | Customer research and controlled comparisons |
| Competitor response | Examine BMW's relative pricing and specifications against competing models | Comparable model-year product and sales data |
| Customer satisfaction | Identify recurring product issues and positive attributes | Representative review and survey samples |
| Charging considerations | Test whether infrastructure affects EV adoption | Regional charger coverage and purchasing data |
| Performance monitoring | Build a consistent regional/model KPI reporting layer | Validated and regularly updated data |

---

## Skills Demonstrated

| Technical | Analytical |
|---|---|
| SQL Server database creation | Business-question framing |
| `CREATE TABLE`, `INSERT` and `SELECT` | EV unit-sales analysis |
| `SUM`, `AVG`, `COUNT` and `CASE` | Regional and model comparisons |
| `GROUP BY`, `ORDER BY`, `HAVING` | Competitive benchmarking |
| JOINs and CTE-based rewrites | Data quality and metric definition |
| Data-grain and duplicate analysis | Translating observations into testable recommendations |

---

## Further Development

**Phase 1 — SQL reliability:** clean the initial script, create reproducible seed data, add constraints and test the 12 queries.

**Phase 2 — Verified results:** export actual result tables, calculate year-on-year comparisons from deduplicated records and provide a methodology for each metric.

**Phase 3 — Visualization:** if a Power BI report is developed, add screenshots and disclose exactly which dataset and measures were used. The supplied SQL file by itself does not establish a completed Power BI dashboard.

**Phase 4 — Deeper research:** add real market denominators, verified competitor data, customer survey evidence and charging infrastructure information before making external market claims.

---

## Repository Guide

**Core analysis:** `BMW_EV_Market_Analysis.sql` — the uploaded SQL script containing schema definitions, sample records and business-question queries.

**Presentation:** This `README.md` — project context, query examples, data-quality findings and recommendations.

For GitHub, I recommend placing the actual script in the root of the repository and adding real SQL-result screenshots only after verification.

---

<div align="center">

## About the Analyst

**Khurram Naveed**  
Data Analyst | SQL Server | Business Intelligence

[![GitHub](https://img.shields.io/badge/GitHub-khurraminsights-181717?style=for-the-badge&logo=github)](https://github.com/khurraminsights)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/khurram-naveed-0083851aa/)

**From raw sample records to defensible analytical decisions.**

</div>


