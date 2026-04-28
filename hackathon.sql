create database if not exists e_sports_db;
use e_sports_db;
#1	
create table games (
    game_id varchar(5) primary key,
    game_name varchar(100) not null unique,
    genre varchar(50) not null,
    developer varchar(100) not null
);

create table matches (
    match_id varchar(5) primary key,
    game_id varchar(5) not null,
    arena_name varchar(50) not null,
    start_time datetime not null,
    entry_fee decimal(10, 2) not null,
    foreign key (game_id) references games(game_id)
);

create table players (
    player_id varchar(5) primary key,
    nickname varchar(100) not null,
    email varchar(100) not null unique,
    rank_level varchar(50) not null
);

create table registrations (
    reg_id int primary key auto_increment,
    match_id varchar(5) not null,
    player_id varchar(5) not null,
    team_name varchar(50) not null,
    status varchar(20) not null,
    foreign key (match_id) references matches(match_id),
    foreign key (player_id) references players(player_id),
    unique (match_id, player_id) 
);
#2
insert into games (game_id, game_name, genre, developer) values
('G01', 'League of Legends', 'MOBA', 'Riot'),
('G02', 'Valorant', 'FPS', 'Riot'),
('G03', 'DOTA 2', 'MOBA', 'Valve'),
('G04', 'CS2', 'FPS', 'Valve');

insert into matches (match_id, game_id, arena_name, start_time, entry_fee) values
('S01', 'G01', 'Stadium A', '2025-11-10 18:00:00', 500000.00),
('S02', 'G02', 'Studio B', '2025-11-10 20:00:00', 300000.00),
('S03', 'G01', 'Stadium A', '2025-11-11 09:00:00', 200000.00),
('S04', 'G04', 'Online Server', '2025-11-12 14:00:00', 150000.00);

insert into players (player_id, nickname, email, rank_level) values
('P01', 'Faker', 'faker@t1.com', 'Challenger'),
('P02', 'TenZ', 'tenz@sentinels.com', 'Radiant'),
('P03', 'S1mple', 'simple@navi.com', 'Global Elite');

insert into registrations (reg_id, match_id, player_id, team_name, status) values
(1, 'S01', 'P01', 'T1', 'Confirmed'),
(2, 'S02', 'P02', 'Sentinels', 'Confirmed'),
(3, 'S01', 'P03', 'NAVI', 'Canceled'),
(4, 'S04', 'P01', 'T1', 'Confirmed'),
(5, 'S03', 'P02', 'MixTeam', 'Pending');
#3
update matches 
set entry_fee = entry_fee * 1.15 
where match_id = 'S01';

update players 
set rank_level = 'Legendary' 
where nickname = 'Faker';

delete from registrations 
where status = 'Canceled';

alter table matches 
add constraint chk_entry_fee check (entry_fee >= 0);

alter table registrations 
alter column status set default 'Pending';

alter table players 
add column nationality varchar(50);

select * from games 
where genre = 'MOBA';

select nickname, email from players 
where nickname like '%e%';

select match_id, arena_name, start_time from matches 
order by start_time desc;

select * from matches 
order by entry_fee asc 
limit 3;

select game_name, genre from games 
limit 2 offset 1;

update matches 
set entry_fee = entry_fee * 0.8 
where arena_name = 'Online Server';

update players 
set nickname = upper(nickname);

delete from registrations 
where match_id in (select match_id from matches where entry_fee = 0);

delete from matches 
where entry_fee = 0;

select r.reg_id, p.nickname, g.game_name, r.team_name
from registrations r
join matches m on r.match_id = m.match_id
join games g on m.game_id = g.game_id
join players p on r.player_id = p.player_id
where r.status = 'Confirmed';

select g.game_name, m.start_time
from games g
left join matches m on g.game_id = m.game_id;

select status, count(*) as total_registrations
from registrations
group by status;

select p.nickname, count(r.match_id) as total_matches
from players p
join registrations r on p.player_id = r.player_id
group by p.player_id, p.nickname
having count(r.match_id) >= 2;

select * from matches
where entry_fee < (select avg(entry_fee) from matches);

select distinct p.nickname, p.rank_level
from players p
join registrations r on p.player_id = r.player_id
join matches m on r.match_id = m.match_id
join games g on m.game_id = g.game_id
where g.game_name = 'League of Legends';

select * from matches
where year(start_time) = 2025 and month(start_time) = 11;