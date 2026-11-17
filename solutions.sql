-- 1. Выведите сколько пользователей добавили книгу 'Coraline', сколько пользователей прослушало больше 10%. 

SELECT COUNT(DISTINCT ac.user_id) AS added_users_count,
    COUNT(DISTINCT CASE WHEN ac.progress > 0.1 * b.duration THEN ac.user_id END) AS listened_over_10_pct_count
FROM audio_cards ac
JOIN audiobooks b ON ac.audiobook_uuid = b.uuid
WHERE b.title = 'Coraline';

-- 2. По каждой операционной системе и названию книги выведите количество пользователей, сумму прослушивания в часах, не учитывая тестовые прослушивания. 

SELECT l.os_name, b.title,
	COUNT(DISTINCT l.user_id) AS users_count,
	ROUND(SUM(EXTRACT(EPOCH FROM (l.finished_at - l.started_at))/3600), 1) AS listened_hours
FROM listenings l
JOIN audiobooks b
ON l.audiobook_uuid = b.uuid 
WHERE l.is_test = 0
GROUP BY l.os_name, b.title
ORDER BY b.title;

-- 3. Найдите книгу, которую слушает больше всего людей. 

SELECT b.title,
	COUNT(DISTINCT l.user_id) AS max_users_count
FROM audiobooks b 
JOIN listenings l
ON l.audiobook_uuid = b.uuid 
GROUP BY b.title
ORDER BY max_users_count DESC
LIMIT 1;

-- 4. Найдите книгу, которую чаще всего дослушивают до конца.

SELECT b.title, 
    COUNT(DISTINCT c.user_id) AS finished_users_count
FROM audiobooks b
JOIN audio_cards c ON b.uuid = c.audiobook_uuid
WHERE c.state = 'finished'
GROUP BY b.uuid, b.title
ORDER BY finished_users_count DESC
LIMIT 1;

