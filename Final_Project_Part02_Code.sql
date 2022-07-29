-- Chess Games Datahub: Final Project- Part 02
-- Authors: Hunter Sikora, Gunturu Sharath, and Saddam Al-Zubaidi .
-- D532: Summer 2022

DROP SCHEMA IF EXISTS chess_hub;
CREATE SCHEMA chess_hub;
USE chess_hub;


## Create a table and import the data with table import wizard.

drop table IF EXISTS lichess;
CREATE TABLE lichess (
id	varchar (160) NOT NULL	,
rated	Text	,
created_at VARCHAR(160) NOT NULL,
last_move VARCHAR(160) NOT NULL,
turns	int	,
victory_status	varchar (160) NOT NULL	,
winner	text	,
minutes varchar (160) NOT NULL,
increment	text	,
white_id	varchar(160) NOT NULL	,
white_rating	int	,
black_id	varchar (160) NOT NULL	,
black_rating	int	,
opening_eco	varchar (160)NOT NULL	,
opening_name	varchar (160)NOT NULL	,
opening_ply	int	,
moves text 	);
 
 ##Imported data from CSV using Table  data Import wizard in SQL bench.attached the data as well fo reference.
 
 ##Saddam
Drop table IF EXISTS game;
CREATE TABLE game (
  game_id VARCHAR(160) NOT NULL,
  rated Text,
  created_at VARCHAR(160) NOT NULL,
  last_move VARCHAR(160) NOT NULL,
  turns	int	,
white_id	varchar(160) NOT NULL	,
black_id	varchar (160) NOT NULL	,
victory_status	varchar (160) NOT NULL	,
 winner	text	,
  PRIMARY KEY (game_id)
);

INSERT INTO game 
SELECT distinct id as game_id,rated,created_at,last_move,winner,white_id,black_id
FROM lichess;

##Saddam
drop table IF EXISTS victory_status;
CREATE TABLE victory_status (
  victory_id INTEGER NOT NULL AUTO_INCREMENT,
game_id VARCHAR(160) NOT NULL,
victory_status	varchar (160) NOT NULL	,
winner	text	,
  PRIMARY KEY (victory_id),
  FOREIGN KEY(game_id) REFERENCES game(game_id)
  
);

INSERT INTO victory_status (game_id,victory_status,winner)
SELECT distinct id as game_id,victory_status,winner
FROM lichess;

##Hunter
drop table IF EXISTS time_control;
CREATE TABLE time_control (
time_control_id INTEGER NOT NULL AUTO_INCREMENT,
game_id VARCHAR(160) NOT NULL,
  minutes varchar (160) NOT NULL,
increment	text	,
  PRIMARY KEY (time_control_id),
  FOREIGN KEY(game_id) REFERENCES game(game_id)
);

INSERT INTO time_control (game_id,minutes,increment)
SELECT distinct id as game_id,minutes,increment
FROM lichess;

##Sharath
drop table IF EXISTS player;
CREATE TABLE player (
player_id INTEGER NOT NULL AUTO_INCREMENT, 
 Player_name varchar (160) NOT NULL	,
 black_rating varchar (160) 	,
white_rating varchar (160) ,
  PRIMARY KEY (player_id)
);

insert into player (Player_name,black_rating,white_rating)
(
Select Distinct coalesce(A.player_name,B.player_name) as Player_name,black_rating,white_rating
from 
(
(Select distinct black_id as player_name,avg(black_rating)as black_rating from lichess group by 1)A
left join  
(Select distinct white_id as player_name,avg(white_rating) as white_rating from lichess  group by 1 )B
on A.player_name=B.player_name
)
);

##Sharath
drop table IF EXISTS moves;
CREATE TABLE moves (
  total_moves_id INTEGER NOT NULL AUTO_INCREMENT, 
  moves text NOT NULL,
  game_id VARCHAR(160) NOT NULL,
  created_at VARCHAR(160) NOT NULL,
  last_move VARCHAR(160) NOT NULL,
  turns	int,
  PRIMARY KEY (total_moves_id),
  FOREIGN KEY(game_id) REFERENCES game(game_id)
);

INSERT INTO moves (moves,game_id,created_at,last_move,turns)
SELECT distinct moves,id as game_id,created_at,last_move,turns
FROM lichess;

##Hunter
drop table IF EXISTS opening_eco;
CREATE TABLE opening_eco (
   opening_eco_id INTEGER NOT NULL AUTO_INCREMENT, 
    opening_eco varchar (160)NOT NULL,
    opening_name VARCHAR(160) NOT NULL, 
   game_id VARCHAR(160) NOT NULL,
  opening_ply int	,
  PRIMARY KEY (opening_eco_id),
  FOREIGN KEY(game_id) REFERENCES game(game_id)
);

INSERT INTO opening_eco (opening_eco,opening_name,game_id,opening_ply)
SELECT distinct opening_eco as opening_eco,opening_name,id as game_id,opening_ply
FROM lichess;

