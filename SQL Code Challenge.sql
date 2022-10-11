
 --Question 1

-- Player Table

CREATE TABLE player(
ID VARCHAR(1) PRIMARY KEY,
Name VARCHAR(4) NOT NULL,
LastName VARCHAR(9) NOT NULL
);

-- Game Table 

CREATE TABLE game(
ID INT PRIMARY KEY,
Winner VARCHAR(1) NOT NULL,
Date datetime NOT NULL,

CONSTRAINT fk_game_player_id
    FOREIGN KEY (Winner)
    REFERENCES player (ID)
);

-- Score Table

CREATE TABLE score(
ID INT PRIMARY KEY,
Game INT NOT NULL,
Player VARCHAR(1) NOT NULL,
Score int not null,

  CONSTRAINT fk_score_player_id
    FOREIGN KEY (Player)
    REFERENCES player (ID),
  CONSTRAINT fk_score_game_id
    FOREIGN KEY (Game)
    REFERENCES game (ID)
)

-- Insert into player

INSERT INTO Player values ('A','Phil','Watertank'),
								('B','Eva','Smith'),
								('C','John','Wick'),
								('D','Bill','Bull'),
								('E','Lisa','Owen');

-- Insert Into Game

INSERT INTO Game values (1,'A','2017-01-02'),
						  (2,'A','2016-05-06'),
						  (3,'B','2017-12-15'),
						  (4,'D','2016-05-06');


---Disabling Foreign key

ALTER TABLE Score NOCHECK CONSTRAINT ALL;

-- Insert Into Values 

INSERT INTO score values (1,1,'A',11),
					     (2,1,'B',7),
						 (3,2,'A',15),
						 (4,2,'C',13),
						 (5,3,'B',11),
						 (6,3,'D',9),
						 (7,4,'D',11),
						 (8,4,'A',5),
						 (9,5,'A',11),
						 (10,6,'B',11),
						 (11,6,'C',2),
						 (12,6,'D',5);
								 

--- Enabling Foreign Key
ALTER TABLE Score CHECK CONSTRAINT ALL;



-- Question 2: Show the average score of each player, even if they didn't play any games.

select Player,Name,AVG(Score) "Average Score"
from Player p
left join Score s
on p.ID=s.Player
group by Player,Name;


----Question 3 a:

WITH new_score AS (
select Game,count(player) as count from Score
group by Game
having count(player) =2)

select game, winner from new_score n
join game g on g.ID = n.Game
;

----Question 3 b:

WITH new_score AS (
select Game,max(score) as winnerscore,count(player) as count from Score
group by Game
having count(player) =2)

select game, winner,winnerscore from new_score n
join game g on g.ID = n.Game
;

---- Question 4

select game " Game ID",Name "PLayer Name",LastName "Player LastName",Score from score s
join Player p on p.ID = s.Player 
where name='Phil' and LastName='Watertank' and score=(select min(score) from score s
join Player p on p.ID = s.Player
where name='Phil' and LastName='Watertank')

----- Question 7

SELECT P1.ID AS PLAYER1,
    P2.ID PLAYER2
FROM PLAYER P1,
    PLAYER P2
WHERE P1.ID != P2.ID
EXCEPT
SELECT P1.PLAYER AS PLAYER1,
    P2.PLAYER AS PLAYER2
FROM SCORE P1,
    SCORE P2

---- Question 6 

--Query 1:
--------
Select Distinct Player.ID, Player.Name, Player.LastName from Player
left join Score on Score.Player = Player.ID
where Score.Player is null

--Query 2:
----------
Select Player.ID, Player.Name, Player.LastName from Player
where Player.ID not in (select distinct Score.Player from Score)

--Solution
---------

--Query 2 i.e The Subquery is faster than equivalent LEFT [Outer] JOIN  because the server is able to optimize it better as shown below. Also, it is
--the logically correct way to solve problems of the form, "Get facts from A, conditional on facts from B". 
--In such instances, it makes more logical sense to stick B in a sub-query than to do a join. in a practical sense, 
--since you don't have to be cautious about getting duplicated facts from A due to multiple matches against B.

--Query 2= Query complete 00:00:00.486

--Query 1= Query complete 00:00:01.266

 
----Question 5

--Query 1:

Select * from Player
left join Score on Score.Player = Player.ID
where Score.Player is not null

--Query 2:

Select * from Player
right join Score on Score.Player = Player.ID and Score.Player is not null
where Score.Player is not null

--SOlution
---------------
--In general, both queries generate the details of all the players in the score table.

--Query 1 :
--------------------------------------------------------------------------------------------------
--It uses a left join with an additional condition “where Score.Player is not null “ 
--to generate a result similar to the result gotten when an inner join operation is performed without the where condition.

--Query 2: 
-------------------------------------------------------------------------------------------------------
--It uses a right join with additional conditions specified before the where clause and after
--clause to produce result similar to when an inner join operation is performed without the where condition. Also, 
--when the right join is specified without the conditions it produces the same result.
