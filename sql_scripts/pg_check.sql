----list all mv's in a specific schema---
SELECT schemaname, matviewname
FROM pg_matviews
WHERE schemaname = 'cht';



---