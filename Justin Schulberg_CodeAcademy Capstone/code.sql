Starting Code:

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp;


1. Get familiar with the company.

How many campaigns and sources does CoolTShirts use and how are they related? Be sure to explain the difference between utm_campaign and utm_source.

SELECT utm_campaign AS 'Campaigns', COUNT(utm_campaign) AS 'number of unique campaigns'
FROM page_visits
GROUP BY utm_campaign
ORDER BY 2 DESC;

This yielded 8 unique campaigns.

Campaigns	number of unique campaigns
getting-to-know-cool-tshirts	1349
ten-crazy-cool-tshirts-facts	1198
interview-with-cool-tshirts-founder	1178
weekly-newsletter	565
retargetting-ad	558
cool-tshirts-search	313
retargetting-campaign	300
paid-search	231


SELECT utm_source AS 'Sources', COUNT(utm_source) AS 'number of unique sources'
FROM page_visits
GROUP BY utm_source
ORDER BY 2 DESC;

This yielded 6 unique sources.

Sources	number of unique sources
nytimes	1349
buzzfeed	1198
medium	1178
email	865
facebook	558
google	544


What pages are on their website?

SELECT page_name AS 'Page Name'
FROM page_visits
GROUP BY 1;

Page Name
1 - landing_page
2 - shopping_cart
3 - checkout
4 - purchase


2. What is the user journey?

How many first touches is each campaign responsible for?

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    COUNT(*)
FROM first_touch AS 'ft'
JOIN page_visits AS 'pv'
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY 4
ORDER BY 5 DESC;

user_id	first_touch_at	utm_source	utm_campaign	COUNT(*)
99990	2018-01-13 23:30:09	medium	interview-with-cool-tshirts-founder	622
99933	2018-01-25 00:04:39	nytimes	getting-to-know-cool-tshirts	612
99765	2018-01-04 05:59:46	buzzfeed	ten-crazy-cool-tshirts-facts	576
99684	2018-01-13 13:20:49	google	cool-tshirts-search	169



How many last touches is each campaign responsible for?

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source AS 'Source',
    pv.utm_campaign AS 'Campaign',
    COUNT(*) AS 'Total'
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 4
ORDER BY 5 DESC;

user_id	last_touch_at	utm_source	utm_campaign	COUNT(*)
99933	2018-01-26 06:18:39	email	weekly-newsletter	447
99928	2018-01-24 05:26:09	facebook	retargetting-ad	443
99990	2018-01-16 11:35:09	email	retargetting-campaign	245
99589	2018-01-15 04:55:43	nytimes	getting-to-know-cool-tshirts	232
99765	2018-01-04 05:59:47	buzzfeed	ten-crazy-cool-tshirts-facts	190
99838	2018-01-02 07:40:34	medium	interview-with-cool-tshirts-founder	184
98840	2018-01-10 04:58:48	google	paid-search	178
99344	2018-01-18 21:36:32	google	cool-tshirts-search	60



How many visitors make a purchase?

SELECT page_name AS 'Page Name', COUNT(DISTINCT user_id) AS 'Visitors per Page'
FROM page_visits
WHERE page_name='4 - purchase';

Page Name	Visitors per Page
4 - purchase	361



How many last touches on the purchase page is each campaign responsible for?

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name='4 - purchase'
    GROUP BY user_id)
SELECT pv.utm_campaign,
    COUNT(*)
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC;

utm_campaign	COUNT(*)
weekly-newsletter	115
retargetting-ad	113
retargetting-campaign	54
paid-search	52
getting-to-know-cool-tshirts	9
ten-crazy-cool-tshirts-facts	9
interview-with-cool-tshirts-founder	7
cool-tshirts-search	2



What is the typical user journey?

3. Optimize the campaign budget

CoolTShirts can re-invest in 5 campaigns. Which should they pick and why?