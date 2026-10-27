-- 03_review_window.sql
-- The reviews the analysis reads into Python: the 2018+ window with the columns needed
-- for ratings, review text, and the skin profile fields.
-- Keep the date in sync with 02_product_stats.sql.

SELECT product_id, author_id, submission_time, review_title, review_text,
       rating, skin_type, skin_tone
FROM reviews_clean
WHERE submission_time >= '2018-01-01'
