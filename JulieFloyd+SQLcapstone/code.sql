/* Number of Distinct Campaigns Query */
SELECT COUNT (DISTINCT utm_campaign)
FROM page_visits;

/* Number of Distinct Sources Query */
SELECT COUNT (DISTINCT utm_source)
FROM page_visits;

/* How are the Campaigns and Sources Related Query */
SELECT DISTINCT utm_campaign,
	utm_source
FROM page_visits;

/* Pages on the CoolTShirts website Query */
SELECT DISTINCT page_name
FROM page_visits;

/* First Touch - Campaign Query */
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as 'first_touch_at'
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
        pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source,
       ft_attr.utm_campaign,
       COUNT(*)
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/* Last Touch - Campaign Query */
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as 'last_touch_at'
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
        pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/* Purchase Query */
SELECT COUNT (DISTINCT user_id)
FROM page_visits
WHERE page_name = '4 – purchase';

/* Last Touch = Purchase - Campaign Query */
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 – purchase'
    GROUP BY user_id),
lt_attr AS (
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
        pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/* Distinct User ID Query */
SELECT COUNT (DISTINCT user_id)
FROM page_visits;

/* User Journey by Campaign Query */
SELECT page_name,
    COUNT (page_name) as 'page visit count',
    utm_campaign,
    utm_source
FROM page_visits
GROUP BY utm_campaign,
    page_name;

/* User Journey by Page (Funnel) Query */
SELECT page_name,
    COUNT (DISTINCT user_id)
FROM page_visits
GROUP BY page_name;



