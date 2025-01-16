-- 1. wypisanie informacje o meczu („czerwone kartki”, bramki (punkty), wynik)
SELECT
    m.match_id,
    m.match_date,
    t1.team_name AS home_team,
    t2.team_name AS away_team,
    m.home_team_score,
    m.away_team_score,
    COUNT(CASE WHEN e.event_type = 'red_card' AND p.team_id = m.home_team_id THEN 1 END) AS home_team_red_cards,
    COUNT(CASE WHEN e.event_type = 'red_card' AND p.team_id = m.away_team_id THEN 1 END) AS away_team_red_cards,
    CASE
        WHEN m.home_team_score > m.away_team_score THEN t1.team_name
        WHEN m.home_team_score < m.away_team_score THEN t2.team_name
        ELSE 'Draw'
    END AS winner
FROM erd_03.matches m
LEFT JOIN erd_03.match_events e ON m.match_id = e.match_id
LEFT JOIN erd_03.players p ON e.player_id = p.player_id
LEFT JOIN erd_03.teams t1 ON m.home_team_id = t1.team_id
LEFT JOIN erd_03.teams t2 ON m.away_team_id = t2.team_id
GROUP BY m.match_id, t1.team_name, t2.team_name, m.home_team_score, m.away_team_score
;

-- 2. wypisanie informacji o piłkarzu (strzelone bramki, czy ma „czerwoną kartkę”)
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS player_name,
    t.team_name,
    COUNT(CASE WHEN e.event_type = 'goal' THEN 1 END) AS total_goals,
    CASE
        WHEN COUNT(CASE WHEN e.event_type = 'red_card' THEN 1 END) > 0 THEN 'Yes'
        ELSE 'No'
    END AS has_red_card
FROM erd_03.players p
JOIN erd_03.teams t ON p.team_id = t.team_id
LEFT JOIN erd_03.match_events e ON p.player_id = e.player_id
GROUP BY p.player_id, t.team_name;


-- 3.  wypisanie „tabeli drużyn”
SELECT
    t.team_name,
    SUM(CASE WHEN t.team_id = m.home_team_id AND m.home_team_score > m.away_team_score THEN 3
             WHEN t.team_id = m.away_team_id AND m.away_team_score > m.home_team_score THEN 3
             WHEN (t.team_id = m.home_team_id OR t.team_id = m.away_team_id) AND m.home_team_score = m.away_team_score THEN 1
             ELSE 0 END) AS points
FROM erd_03.teams t
LEFT JOIN erd_03.matches m ON t.team_id = m.home_team_id OR t.team_id = m.away_team_id
GROUP BY t.team_id
ORDER BY points DESC;
