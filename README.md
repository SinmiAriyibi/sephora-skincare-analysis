# Skincare Product Performance and Customer Satisfaction

When a product shows 5.0 stars, how much should a shopper (or a merchandiser) trust it? This project uses 791,714 Sephora skincare reviews to find where star ratings mislead, what unhappy customers complain about, and which products deserve more visibility.

**Portfolio page:** https://sinmiariyibi.my.canva.site
**Interactive dashboard:** https://public.tableau.com/app/profile/sinmi.ariyibi/viz/SkincareProductPerformanceandCustomerSatisfaction/Dashboard1

## Questions

1. How reliable are product ratings when review volumes differ?
2. Do free-product reviews inflate ratings?
3. Does a higher price mean better ratings?
4. What are customers actually dissatisfied with?
5. Which strong products are being overlooked?

## What I found

| Finding | Number |
|---|---|
| Products with a perfect 5.0 average | 61, and all of them have 17 reviews or fewer (median 3) |
| Reviews that say the product was free | 15.6% (a floor, since it only counts what reviewers wrote down) |
| Rating gap, free-product reviews vs other reviews of the same product | +0.22 stars (brand-clustered 95% CI 0.179 to 0.263) |
| Priciest quartile vs cheapest, same product type | +0.15 stars (95% CI 0.078 to 0.218) |
| Top complaint themes in 1-2 star reviews | No results 22.1%, skin reaction 21.6% |
| Value for money, likelihood in 1-2 star reviews vs 4-5 star reviews | 20.2x |
| Hidden gems (top-quartile adjusted rating, slow review pace) | 98 found, 87 testable, 76 still top quartile without free-product reviews |

Everything here is correlational. Ratings differences are measured inside the same comparison group, with standard errors clustered by brand.

## How it works

1. **Load and profile** the raw Kaggle files.
2. **SQL layer (SQLite).** `sql/01_clean_tables.sql` removes exact duplicate reviews and keeps skincare products. `02_product_stats.sql` and `03_review_window.sql` build the 2018+ review window.
3. **Collapse shared reviews.** Sephora shows the same reviews on every size and edition of a product, and the scrape saved each copy. Products that share almost all their reviews are linked into one family and each shared review is counted once.
4. **One row per product family**, with ratings adjusted toward the category average (empirical Bayes shrinkage) so a product with a handful of reviews can't top the rankings.
5. **Price, satisfaction and review activity** compared within product-type groups.
6. **Regression** on product families with category fixed effects.
7. **Complaint themes** from keywords in 1-2 star reviews, compared with a category-balanced sample of 4-5 star reviews (the lift). Negation is handled inside a short window.
8. **Free-product reviews** flagged with a strict text pattern (influencer boxes, "in exchange for my honest review", and similar), then compared against other reviews of the same product.
9. **Exports** for the Tableau dashboard.

### Data funnel

| Step | Count |
|---|---|
| Raw reviews | 1,094,411 |
| After removing exact duplicates (SQL) | 1,094,182 |
| Reviews from 2018 onward | 900,965 |
| After collapsing reviews shared across listings | 791,714 |
| Products in raw product table | 8,494 |
| Skincare products | 2,420 |
| Product families (sizes and editions merged) | 2,265 |
| Families in the price/rating analysis set | 1,256 |

The window starts in 2018 because `is_recommended` was only collected from then.

## Limitations

- One retailer, reviews from 2018 onward, so this may not reflect the wider market.
- Reviews are self-reported. Free-product reviews were flagged with a text pattern and will miss some.
- Complaint themes come from keyword matching, so some reviews are missed or mislabeled.
- Product-level analysis. No customer demographics, sales or inventory data.

## Run it

Data: Kaggle, [Sephora Products and Skincare Reviews](https://www.kaggle.com/datasets/nadyinky/sephora-products-and-skincare-reviews) (`product_info.csv` and the `reviews_*.csv` files). The raw files are not in this repo.

```bash
pip install -r requirements.txt
# put product_info.csv and reviews_*.csv next to the notebook (or change DATA_DIR)
jupyter notebook sephora_skincare_analysis.ipynb   # run top to bottom
```

## Repo

```
sephora_skincare_analysis.ipynb
sql/            01_clean_tables.sql, 02_product_stats.sql, 03_review_window.sql
requirements.txt
.gitignore
```

Tools: Python (pandas, numpy, scipy, statsmodels, matplotlib), SQL (SQLite), Tableau Public.
