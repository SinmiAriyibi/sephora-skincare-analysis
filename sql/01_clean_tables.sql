-- 01_clean_tables.sql
-- The two clean tables the analysis starts from.
-- Needs the raw tables reviews_raw and products_raw (loaded by the notebook).

-- Reviews: drop exact duplicates and keep only the columns the analysis uses.
DROP TABLE IF EXISTS reviews_clean;
CREATE TABLE reviews_clean AS
SELECT DISTINCT
    author_id, product_id, rating, is_recommended,
    helpfulness, total_feedback_count,
    total_pos_feedback_count, total_neg_feedback_count,
    submission_time, review_title, review_text,
    skin_type, skin_tone
FROM reviews_raw;

-- Products: skincare only (the review file covers skincare products only).
DROP TABLE IF EXISTS products_skincare;
CREATE TABLE products_skincare AS
SELECT product_id, product_name, brand_name, loves_count, price_usd,
       limited_edition, "new" AS is_new, online_only, out_of_stock,
       sephora_exclusive, secondary_category, tertiary_category
FROM products_raw
WHERE primary_category = 'Skincare';
