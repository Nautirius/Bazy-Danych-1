INSERT INTO erd_03.teams (team_name) VALUES ('Team A'), ('Team B'), ('Team C'), ('Team D');

INSERT INTO erd_03.players (first_name, last_name, team_id) VALUES
-- Team A
('Jan', 'Kowalski', 1),
('Anna', 'Nowak', 1),
('Michał', 'Wiśniewski', 1),
('Tomasz', 'Zieliński', 1),
('Ewa', 'Kamińska', 1),
('Piotr', 'Kozłowski', 1),
('Aleksander', 'Jankowski', 1),
('Karolina', 'Wójcik', 1),
('Zofia', 'Krawczyk', 1),
('Maciej', 'Nowicki', 1),
('Joanna', 'Kaczmarek', 1),
-- Team B
('Katarzyna', 'Mazur', 2),
('Jakub', 'Kowalczyk', 2),
('Łukasz', 'Grabowski', 2),
('Patryk', 'Dąbrowski', 2),
('Martyna', 'Wróbel', 2),
('Szymon', 'Pawlak', 2),
('Natalia', 'Baran', 2),
('Grzegorz', 'Sikorski', 2),
('Marcin', 'Michalski', 2),
('Agata', 'Król', 2),
('Dominik', 'Głowacki', 2),
-- Team C
('Izabela', 'Kruk', 3),
('Robert', 'Szczepański', 3),
('Mateusz', 'Adamski', 3),
('Klaudia', 'Czajka', 3),
('Paweł', 'Piotrowski', 3),
('Julia', 'Sadowska', 3),
('Adrian', 'Wilk', 3),
('Oliwia', 'Rutkowska', 3),
('Bartłomiej', 'Kalinowski', 3),
('Wiktoria', 'Sosnowska', 3),
('Damian', 'Chmielewski', 3),
-- Team D
('Dariusz', 'Błaszczyk', 4),
('Emilia', 'Kubiak', 4),
('Artur', 'Żurek', 4),
('Sebastian', 'Woźniak', 4),
('Alicja', 'Laskowska', 4),
('Cezary', 'Urban', 4),
('Justyna', 'Makowska', 4),
('Wojciech', 'Leśniak', 4),
('Marta', 'Kaźmierczak', 4),
('Przemysław', 'Mucha', 4),
('Dorota', 'Szulc', 4);

INSERT INTO erd_03.matches (home_team_id, away_team_id, match_date) VALUES
(1, 2, '2025-01-01'),
(2, 3, '2025-01-05'),
(3, 4, '2025-01-10'),
(4, 1, '2025-01-15'),
(1, 3, '2025-01-20');


INSERT INTO erd_03.match_lineups (match_id, team_id, player_id) VALUES
-- Match 1
(1, 1, 1), (1, 1, 2), (1, 1, 3), (1, 1, 4), (1, 1, 5), (1, 1, 6), (1, 1, 7), (1, 1, 8), (1, 1, 9), (1, 1, 10), (1, 1, 11),
(1, 2, 12), (1, 2, 13), (1, 2, 14), (1, 2, 15), (1, 2, 16), (1, 2, 17), (1, 2, 18), (1, 2, 19), (1, 2, 20), (1, 2, 21), (1, 2, 22),
-- Match 2
(2, 2, 12), (2, 2, 13), (2, 2, 14), (2, 2, 15), (2, 2, 16), (2, 2, 17), (2, 2, 18), (2, 2, 19), (2, 2, 20), (2, 2, 21), (2, 2, 22),
(2, 3, 23), (2, 3, 24), (2, 3, 25), (2, 3, 26), (2, 3, 27), (2, 3, 28), (2, 3, 29), (2, 3, 30), (2, 3, 31), (2, 3, 32), (2, 3, 33),
-- Match 3
(3, 3, 23), (3, 3, 24), (3, 3, 25), (3, 3, 26), (3, 3, 27), (3, 3, 28), (3, 3, 29), (3, 3, 30), (3, 3, 31), (3, 3, 32), (3, 3, 33),
(3, 4, 34), (3, 4, 35), (3, 4, 36), (3, 4, 37), (3, 4, 38), (3, 4, 39), (3, 4, 40), (3, 4, 41), (3, 4, 42), (3, 4, 43), (3, 4, 44),
-- Match 4
(4, 4, 34), (4, 4, 35), (4, 4, 36), (4, 4, 37), (4, 4, 38), (4, 4, 39), (4, 4, 40), (4, 4, 41), (4, 4, 42), (4, 4, 43), (4, 4, 44),
(4, 1, 1), (4, 1, 2), (4, 1, 3), (4, 1, 4), (4, 1, 5), (4, 1, 6), (4, 1, 7), (4, 1, 8), (4, 1, 9), (4, 1, 10), (4, 1, 11),
-- Match 5
(5, 1, 1), (5, 1, 2), (5, 1, 3), (5, 1, 4), (5, 1, 5), (5, 1, 6), (5, 1, 7), (5, 1, 8), (5, 1, 9), (5, 1, 10), (5, 1, 11),
(5, 3, 23), (5, 3, 24), (5, 3, 25), (5, 3, 26), (5, 3, 27), (5, 3, 28), (5, 3, 29), (5, 3, 30), (5, 3, 31), (5, 3, 32), (5, 3, 33);


INSERT INTO erd_03.match_events (match_id, player_id, event_type, event_time) VALUES
(1, 1, 'goal', 15),
(1, 2, 'goal', 35),
(1, 4, 'goal', 45),
(1, 3, 'red_card', 60),
(2, 23, 'goal', 10),
(2, 23, 'goal', 25),
(2, 24, 'goal', 55),
(2, 15, 'red_card', 30),
(3, 24, 'goal', 15),
(3, 23, 'goal', 45),
(3, 34, 'goal', 60),
(3, 35, 'goal', 80),
(3, 35, 'red_card', 90),
(4, 36, 'goal', 25),
(4, 1, 'red_card', 30),
(5, 1, 'goal', 10),
(5, 2, 'goal', 20),
(5, 23, 'goal', 30),
(5, 2, 'red_card', 50);
