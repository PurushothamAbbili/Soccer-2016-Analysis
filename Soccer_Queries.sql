-- 1.	Write a SQL query to find out where the final match of the EURO cup 2016 was played. Return venue name, city.
SELECT 
    sv.venue_name, sc.city
FROM
    soccer_venue sv
        JOIN
    soccer_city sc ON sv.city_id = sc.city_id
        JOIN
    match_mast mm ON sv.venue_id = mm.venue_id
        AND mm.play_stage = 'F';
    
    
-- 2.	Write a SQL query to find the number of goals scored by each team in each match during normal play. Return match number, country name and goal score.
SELECT 
    md.match_no, sc.country_name, goal_score
FROM
    match_details md
        JOIN
    soccer_country sc ON md.team_id = sc.country_id
WHERE
    decided_by = 'N'
ORDER BY 1;


-- 3.	Write a SQL query to count the number of goals scored by each player within a normal play schedule.
--      Group the result set on player name and country name and sorts the result-set according to the highest to the lowest scorer. Return player name, number of goals and country name.
SELECT 
    pm.player_name,
    COUNT(gd.goal_id) no_of_goals,
    sc.country_name
FROM
    goal_details gd
        JOIN
    player_mast pm ON gd.player_id = pm.player_id
        JOIN
    soccer_country sc ON gd.team_id = sc.country_id
WHERE
    gd.goal_schedule = 'NT'
GROUP BY 1 , 3
ORDER BY 2 DESC;


-- 4.	Write a SQL query to find out who scored the most goals in the 2016 Euro Cup. Return player name, country name and highest individual scorer.
SELECT 
    pm.player_name,
    sc.country_name,
    COUNT(gd.goal_id) AS highest_individual_scorer
FROM
    player_mast pm
        JOIN
    goal_details gd ON pm.player_id = gd.player_id
        JOIN
    soccer_country sc ON pm.team_id = sc.country_id
GROUP BY 1 , 2
ORDER BY 3 DESC
LIMIT 1;


-- 5.	Write a SQL query to find out who scored in the final of the 2016 Euro Cup. Return player name, jersey number and country name.
SELECT 
    pm.player_name, pm.jersey_no, sc.country_name
FROM
    match_mast mm
        JOIN
    goal_details gd ON mm.match_no = gd.match_no
        JOIN
    player_mast pm ON gd.player_id = pm.player_id
        JOIN
    soccer_country sc ON pm.team_id = sc.country_id
WHERE
    mm.play_stage = 'F'
        AND gd.play_stage = 'F';


-- 6.	Write a SQL query to find out which country hosted the 2016 Football EURO Cup. Return country name.
SELECT 
    sc.country_name
FROM
    soccer_country sc
        JOIN
    soccer_city sct ON sc.country_id = sct.country_id
        JOIN
    soccer_venue sv ON sct.city_id = sv.city_id
GROUP BY 1;


-- 7.	Write a SQL query to find out who scored the first goal of the 2016 European Championship. 
--      Return player_name, jersey_no, country_name, goal_time, play_stage, goal_schedule, goal_half.
SELECT 
    pm.player_name,
    pm.jersey_no,
    sc.country_name,
    gd.goal_time,
    gd.play_stage,
    gd.goal_schedule,
    gd.goal_half
FROM
    goal_details gd
        JOIN
    player_mast pm ON gd.player_id = pm.player_id
        JOIN
    soccer_country sc ON pm.team_id = sc.country_id
WHERE
    goal_id = 1;


-- 8.	Write a SQL query to find the referee who managed the opening match. Return referee name, country name.
SELECT 
    rm.referee_name, sc.country_name
FROM
    match_mast mm
        JOIN
    referee_mast rm ON mm.referee_id = rm.referee_id
        JOIN
    soccer_country sc ON rm.country_id = sc.country_id
WHERE
    mm.match_no IN (SELECT 
            MIN(match_no)
        FROM
            match_mast);


-- 9.	Write a SQL query to find the referee who managed the final match. Return referee name, country name.
SELECT 
    rm.referee_name, sc.country_name
FROM
    match_mast mm
        JOIN
    referee_mast rm ON mm.referee_id = rm.referee_id
        JOIN
    soccer_country sc ON rm.country_id = sc.country_id
WHERE
    mm.match_no IN (SELECT 
            MAX(match_no)
        FROM
            match_mast)
        AND mm.play_stage = 'F';


-- 10.	Write a SQL query to find the referee who assisted the referee in the opening match. Return associated referee name, country name.
SELECT 
    arm.ass_ref_name, sc.country_name
FROM
    asst_referee_mast arm
        JOIN
    soccer_country sc ON arm.country_id = sc.country_id
        JOIN
    match_details md ON arm.ass_ref_id = md.ass_ref
WHERE
    match_no = 1;


-- 11.	Write a SQL query to find the referee who assisted the referee in the final match. Return associated referee name, country name.
SELECT 
    arm.ass_ref_name, sc.country_name
FROM
    asst_referee_mast arm
        JOIN
    soccer_country sc ON arm.country_id = sc.country_id
        JOIN
    match_details md ON arm.ass_ref_id = md.ass_ref
WHERE
    play_stage = 'F';

-- 12.	Write a SQL query to find the city where the opening match of EURO cup 2016 took place. Return venue name, city.
SELECT 
    sv.venue_name, sc.city
FROM
    match_mast mm
        JOIN
    soccer_venue sv ON mm.venue_id = sv.venue_id
        JOIN
    soccer_city sc ON sv.city_id = sc.city_id
WHERE
    mm.match_no = 1;


-- 13.	Write a SQL query to find out which stadium hosted the final match of the 2016 Euro Cup. Return venue_name, city, aud_capacity, audience.

SELECT 
    sv.venue_name, sc.city, sv.aud_capacity, mm.audience
FROM
    match_mast mm
        JOIN
    soccer_venue sv ON mm.venue_id = sv.venue_id
        JOIN
    soccer_city sc ON sv.city_id = sc.city_id
WHERE
    mm.play_stage = 'F';
    

-- 14.	Write a SQL query to count the number of matches played at each venue. Sort the result-set on venue name. Return Venue name, city, and number of matches.
SELECT 
    sv.venue_name, sc.city, COUNT(mm.match_no) total_matches
FROM
    match_mast mm
        JOIN
    soccer_venue sv ON mm.venue_id = sv.venue_id
        JOIN
    soccer_city sc ON sv.city_id = sc.city_id
GROUP BY 1 , 2
ORDER BY 3 DESC;


-- 15.	Write a SQL query to find the player who was the first player to be sent off at the tournament EURO cup 2016. Return match Number, country name and player name.
SELECT 
    pb.match_no,
    sc.country_name,
    pm.player_name,
    pb.booking_time AS 'sent_off_time',
    pb.play_schedule,
    pm.jersey_no
FROM
    player_booked pb
        JOIN
    player_mast pm ON pb.player_id = pm.player_id
        JOIN
    soccer_country sc ON pb.team_id = sc.country_id
        AND pb.sent_off = 'Y'
        AND pb.match_no = (SELECT 
            MIN(pb.match_no)
        FROM
            player_booked pb)
ORDER BY pb.match_no , pb.play_schedule , pb.play_half , pb.booking_time;
