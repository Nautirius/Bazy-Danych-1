CREATE SCHEMA IF NOT EXISTS erd_03;

CREATE TABLE IF NOT EXISTS erd_03.teams (
    team_id SERIAL PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS erd_03.players (
    player_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    team_id INT NOT NULL,
    FOREIGN KEY (team_id) REFERENCES erd_03.teams(team_id)
);

CREATE TABLE IF NOT EXISTS erd_03.matches (
    match_id SERIAL PRIMARY KEY,
    home_team_id INT NOT NULL,
    away_team_id INT NOT NULL,
    home_team_score INT DEFAULT 0,
    away_team_score INT DEFAULT 0,
    match_date DATE NOT NULL,
    FOREIGN KEY (home_team_id) REFERENCES erd_03.teams(team_id),
    FOREIGN KEY (away_team_id) REFERENCES erd_03.teams(team_id)
);

CREATE TABLE IF NOT EXISTS erd_03.match_events (
    event_id SERIAL PRIMARY KEY,
    match_id INT NOT NULL,
    player_id INT NOT NULL,
    event_type VARCHAR(50) CHECK (event_type IN ('goal', 'red_card')),
    event_time INT NOT NULL,
    FOREIGN KEY (match_id) REFERENCES erd_03.matches(match_id),
    FOREIGN KEY (player_id) REFERENCES erd_03.players(player_id)
);

CREATE TABLE IF NOT EXISTS erd_03.match_lineups (
    lineup_id SERIAL PRIMARY KEY,
    match_id INT NOT NULL,
    team_id INT NOT NULL,
    player_id INT NOT NULL,
    FOREIGN KEY (match_id) REFERENCES erd_03.matches(match_id),
    FOREIGN KEY (team_id) REFERENCES erd_03.teams(team_id),
    FOREIGN KEY (player_id) REFERENCES erd_03.players(player_id)
);

-- Trigger sprawdzający liczbę zawodników w składzie
CREATE OR REPLACE FUNCTION check_lineup_limit()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*)
        FROM erd_03.match_lineups
        WHERE match_id = NEW.match_id AND team_id = NEW.team_id) >= 11 THEN
        RAISE EXCEPTION 'Drużyna w meczu ma już maksymalną liczbę zawodników (11)';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER lineup_limit_trigger
BEFORE INSERT ON erd_03.match_lineups
FOR EACH ROW
EXECUTE FUNCTION check_lineup_limit();

-- Trigger aktualizujący wynik meczu
CREATE OR REPLACE FUNCTION update_match_score()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.event_type = 'goal' THEN
        IF (SELECT home_team_id FROM erd_03.matches WHERE match_id = NEW.match_id) =
           (SELECT team_id FROM erd_03.players WHERE player_id = NEW.player_id) THEN
            UPDATE erd_03.matches
            SET home_team_score = home_team_score + 1
            WHERE match_id = NEW.match_id;
        ELSE
            UPDATE erd_03.matches
            SET away_team_score = away_team_score + 1
            WHERE match_id = NEW.match_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER match_score_update_trigger
AFTER INSERT ON erd_03.match_events
FOR EACH ROW
EXECUTE FUNCTION update_match_score();
