-- 02_product_stats.sql
-- Review stats per listing for the analysis window, joined to the skincare products.
-- The window starts on 2018-01-01 because is_recommended was only collected from 2018.
-- Keep this date in sync with 03_review_window.sql.

DROP TABLE IF EXISTS product_stats;
CREATE TABLE product_stats AS
SELECT product_id,
       COUNT(*) AS n_reviews,
       AVG(rating) AS avg_rating,
       AVG(rating <= 2) AS low_rating_share,
       AVG(rating = 5) AS five_star_share,
       AVG(is_recommended) AS recommend_rate
FROM reviews_clean
WHERE submission_time >= '2018-01-01'
GROUP BY product_id;

DROP TABLE IF EXISTS product_analysis;
CREATE TABLE product_analysis AS
SELECT p.*, s.n_reviews, s.avg_rating, s.low_rating_share,
       s.five_star_share, s.recommend_rate
FROM products_skincare p
LEFT JOIN product_stats s USING (product_id);
