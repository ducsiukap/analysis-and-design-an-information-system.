drop database f1db;
create database f1db;
use f1db;

-- ====================================================
-- USER db: user, staff
-- ====================================================
-- user(id, fullName, username, password, mail)
create table tblUser(
	id int auto_increment primary key,
    fullName varchar(100) not null,
    username varchar(50) not null,
    password varchar(50) not null,
    mail varchar(255) not null,
    type varchar(255) not null 
);
-- staff(tblUserId, position)
create table tblStaff(
	tblUserId int primary key,
    position varchar(100) not null,
    foreign key (tblUserId) references tblUser(id) on delete cascade
);

-- ====================================================
-- F1 db: tournament, circuit, race, driver, team, driverRaceResult
-- ====================================================
-- tournament(id, name, year, expectedRaceAmount)
create table tblTournament(
	id int auto_increment primary key,
    name varchar(100) not null,
    year int not null,
    expectedRaceAmount int not null
);
-- circuit(id, name, country, city, lapLength)
create table tblCircuit(
	id int auto_increment primary key,
    name varchar(100) not null,
    country varchar(100) not null, 
    city varchar(100) not null,
    lapLength float not null
); 
-- race(id, name, numberOfLaps, raceNumber, time, status, tblTournamentId, tblCircuitId 
create table tblRace(
	id int auto_increment primary key,
    name varchar(100) not null,
    numberOfLaps int not null,
    raceNumber int not null,
    time datetime not null,
    status varchar(50) not null,
    tblTournamentId int not null,
    tblCircuitId int not null,
    foreign key(tblTournamentId) references tblTournament(id),
    foreign key(tblCircuitId) references tblCircuit(id)
);
-- driver(id, name, number, nationality)
create table tblDriver(
	id int auto_increment primary key,
    name varchar(100) not null,
    number int not null,
    nationality varchar(100) not null
); 
-- team(id, name, country)
create table tblTeam(
	id int auto_increment primary key,
    name varchar(100) not null,
    country varchar(100) not null
); 
-- driverRaceResult(id, statingPos, laps, time, point, tblRaceId, tblDriverId, tblTeamId) 
create table tblDriverRaceResult(
	id int auto_increment primary key,
    startingPos int check(startingPos>=0),
    laps int not null check(laps>=0),
    time bigint not null check(time>=0),
    position int not null check(position>=0),
    point int not null default 0 check(point>=0),
    tblRaceId int not null,
    tblDriverId int not null, 
    tblTeamId int not null,
    foreign key (tblRaceId) references tblRace(id) on delete cascade,
    foreign key (tblDriverId) references tblDriver(id),
    foreign key (tblTeamId) references tblTeam(id)
);
-- ====================================================
-- F1 db views: teamResult, teamRaceStat 
-- tắt ONLY_FULL_GROUP_BY để cho phép truy vấn các thuộc tính của view ngoài các thuộc tính có trong phần groupby :_)
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
-- ====================================================
-- vTeamRaceStat(team.id, team.name, tournament.id, tournament.year, race.id, race.raceNumber, race.name, race.time, totalPoint)
create view vTeamRaceStat as
select 
	t.id as teamId, t.name as teamName, t.country as teamCountry,
    s.id as seasonId, s.year as seasonYear, 
    r.id as raceId, r.raceNumber as raceNumber, r.name as raceName, r.time as raceTime,
    coalesce(sum(d.point), 0) as totalPoint
from tblTeam as t
	left join tblDriverRaceResult as d
		on t.id = d.tblTeamId
	left join tblRace as r
		on d.tblRaceId = r.id
	left join tblTournament as s
		on r.tblTournamentId = s.id
GROUP BY t.id, t.name, t.country, s.id, s.year, r.id, r.raceNumber, r.name, r.time;
-- vTeamResult (season result) 
create view vTeamResult as 
select 
	stat.teamId, stat.teamName, stat.teamCountry,
    stat.seasonId, stat.seasonYear, 
    sum(stat.totalPoint) as totalPoint
from vTeamRaceStat as stat
group by stat.seasonId, stat.seasonYear, stat.teamId, stat.teamName, stat.teamCountry;

-- ====================================================
-- insert data 
-- ==================================================== 

--  user
insert into tblUser(fullName, username, password, mail, type) values 
("Pham Duc", "vduczz", "123456", "DucPV.contact@gmail.com", "staff"),
("Staff Staff1", "staff1", "123456", "staff1.contact@gmail.com", "staff");
-- staff
insert into tblStaff(tblUserId, position) values 
(1, "manager"),
(2, "ほしい"); 
-- ==================================================== 
-- team
insert into tblTeam(name, country) values
("McLaren Formula 1 Team", "Great Britain"),
("Mercedes Formula 1 Team", "Germany"),
("Scuderia Ferrari", "Italy"),
("Red Bull Racing", "Austria"),
("Williams Racing", "Great Britain"),
("RB F1 Team", "Italy"),
("Aston Martin F1 Team", "Great Britain"),
("Sauber F1 Team", "Switzerland"),
("Haas F1 Team", "United States"),
("Alpine F1 Team", "France");
-- driver 
insert into tblDriver(name, number, nationality) values
("Oscar Piastri", 81, "Australia"),
("Lando Norris", 4, "Great Britain"),
("Max Verstappen", 33, "Netherlands"),
("George Russell", 63, "Great Britain"),
("Charles Leclerc", 16, "Monaco"),
("Lewis Hamilton", 44, "Great Britain"),
("Andrea Kimi Antonelli", 12, "Italy"),
("Alex Albon", 23, "Thailand"),
("Isack Hadjar", 6, "France"),
("Nico Hulkenberg", 27, "Germany"),
("Fernando Alonso", 14, "Spain"),
("Carlos Sainz", 55, "Spain"),
("Lance Stroll", 18, "Canada"),
("Liam Lawson", 30, "New Zealand"),
("Esteban Ocon", 31, "France"),
("Pierre Gasly", 10, "France"),
("Yuki Tsunoda", 22, "Japan"),
("Gabriel Bortoleto", 5, "Brazil"),
("Oliver Bearman", 87, "Great Britain"),
("Franco Colapinto", 43, "Argentina"),
("Jack Doohan", 7, "Australia");
-- tournament
insert into tblTournament(name, year, expectedRaceAmount) values
("2025 Formula 1 World Championship", 2025, 30); 
-- circuit
insert into tblCircuit(name, country, city, lapLength) values
("Bahrein International Circuit", "Bahrein", "Sakhir", 5.412),
("Jeddah Corniche Circuit", "Saudi Arabia", "Jedda", 6.174),
("Albert Park Circuit", "Australia", "Melbourne", 5.278),
("Suzuka International Circuit", "Japan", "Suzuka", 5.807),
("Shangai International Circuit", "China", "Shangai", 5.451),
("Miami International Autodrome", "United States", "Miami", 5.412),
("Imola Autodromo Internazionale Enzo e Dino Ferrari", "Italy", "Imola", 4.909),
("Circuit de Monaco", "Monaco", "Monte Carlo", 3.337),
("Circuit Gilles Villeneuve", "Canada", "Montreal", 4.361),
("Circuit de Barcelona-Catalunya", "Spain", "Barcelona", 4.657),
("Red Bull Ring", "Austria", "Spielberg", 4.318),
("Silverstone Circuit", "Great Britain", "Silverstone", 5.891),
("Hungaroring", "Hungary", "Mogyorod", 4.381),
("Circuit Zandvoort", "Netherlands", "Zandvoort", 4.259),
("Circuit de Spa-Francorchamps", "Belgium", "Stavelot", 7.004),
("Autodromo Nazionale Monza", "Italy", "Monza", 5.793),
("Baku City Circuit", "Azerbaijan", "Baku", 6.003),
("Marina Bay Street Circuit", "Singapore", "Singapore", 4.94),
("Autódromo Hermanos Rodríguez", "Mexico", "Mexico City", 4.304),
("Circuit of The Americas", "United States", "Austin", 3.426),
("Autodromo José Carlos Pace | Interlagos", "Brazil", "Sao Paulo", 4.309),
("Lusail International Circuit", "Qatar", "Lusail", 5.419),
("Yas Marina Circuit", "United Arab Emirates", "Abu Dhabi", 5.281),
("Las Vegas Strip Circuit", "United States", "Las Vegas", 3.853),
("Autodromo Internazionale del Mugello", "Italy", "Florence", 5.245),
("Autodromo Internacional do Algarve", "Portugal", "Portimao", 4.653),
("Istanbul Park", "Turkey", "Istanbul", 5.338),
("Circuit Paul Ricard", "France", "Le Castellet", 5.842),
("Sochi Autodrom", "Russia", "Sochi", 5.848),
("Nurburgring", "Germany", "Nurburg", 5.148);
-- race
insert into tblRace(name, numberOfLaps, raceNumber, time, status, tblTournamentId, tblCircuitId) values 
("Louis Vuitton Australian Grand Prix 2025", 58, 1, "2025-03-16 04:00:00", "active", 1, 3),
("Heineken Chinese Grand Prix 2025", 56, 2, "2025-03-23 07:00:00", "active", 1, 5),
("Lenovo Japanese Grand Prix 2025", 53, 3, "2025-04-06 05:00:00", "active", 1, 4),
("Bahrain Grand Prix 2025", 57, 4, "2025-04-13 15:00:00", "active", 1, 1),
("STC Saudi Arabian Grand Prix 2025", 50, 5, "2025-04-20 17:00:00", "active", 1, 2),
("CRYPTO.COM Miami Grand Prix 2025", 57, 6, "2025-05-04 20:00:00", "active", 1, 6),
("AWS Gran Premio del Made in Italy e Dell Emilia-Romagna 2025", 63, 7, "2025-05-18 13:00:00", "active", 1, 7),
("Grand Prix de Monaco 2025", 78, 8, "2025-05-25 13:00:00", "active", 1, 8),
("Aramco Gran Premio de España 2025", 66, 9, "2025-06-01 13:00:00", "active", 1, 10),
("Pirelli Grand Prix Du Canada 2025", 70, 10, "2025-06-15 18:00:00", "active", 1, 9),
("MSC Cruises Austrian Grand Prix 2025", 71, 11, "2025-06-29 13:00:00", "active", 1, 11),
("Qatar Airways British Grand Prix 2025", 52, 12, "2025-07-06 14:00:00", "active", 1, 12),
("Belgian Grand Prix 2025", 44, 13, "2025-07-27 13:00:00", "active", 1, 15),
("Lenovo Hungarian Grand Prix 2025", 70, 14, "2025-08-03 13:00:00", "active", 1, 13),
("Heineken Dutch Grand Prix 2025", 72, 15, "2025-08-31 13:00:00", "active", 1, 14),
("Pirelli Gran D'Italia 2025", 53, 16, "2025-09-07 13:00:00", "active", 1, 16),
("Qatar Airways Azerbaijan Grand Prix 2025", 51, 17, "2025-09-21 11:00:00", "active", 1, 17),
("Singapore Airlines Singapore Grand Prix 2025", 62, 18, "2025-10-05 12:00:00", "active", 1, 18),
("MSC Cruises United States Grand Prix 2025", 56, 19, "2025-10-19 19:00:00", "active", 1, 20),
("Gran Premio de La Ciudad de México 2025", 71, 20, "2025-10-26 20:00:00", "active", 1, 19),
("MSC Cruises Grande Premio de Sao Paulo 2025", 71, 21, "2025-11-09 17:00:00", "active", 1, 21),
("Heineken Las Vegas Grand Prix 2025", 50, 22, "2025-11-22 04:00:00", "active", 1, 24),
("Qatar Airways Qatar Grand Prix 2025", 57, 23, "2025-11-30 16:00:00", "active", 1, 22),
("Etihad Airways Abu Dhabi Grand Prix 2025", 58, 24, "2025-12-07 13:00:00", "active", 1, 23);  
-- driverRaceResult
insert into tblDriverRaceResult(startingPos, laps, time, position, point, tblRaceId, tblDriverId, tblTeamId) values
(1, 58, 6126304, 1, 25, 1, 2, 1),
(3, 58, 6127199, 2, 18, 1, 3, 4),
(4, 58, 6134785, 3, 15, 1, 4, 2),
(16, 58, 6136439, 4, 12, 1, 7, 2),
(6, 58, 6139077, 5, 10, 1, 8, 5),
(13, 58, 6143717, 6, 8, 1, 13, 7),
(17, 58, 6144727, 7, 6, 1, 10, 8),
(7, 58, 6146130, 8, 4, 1, 5, 3),
(2, 58, 6146752, 9, 2, 1, 1, 1),
(8, 58, 6148777, 10, 1, 1, 6, 3),
(9, 58, 6152806, 11, 0, 1, 16, 10),
(5, 58, 6156188, 12, 0, 1, 17, 6),
(18, 58, 6159465, 13, 0, 1, 15, 9),
(null, 58, 6166655, 14, 0, 1, 19, 9),
(null, 46, 0, 0, 0, 1, 14, 4),
(15, 45, 0, 0, 0, 1, 18, 8),
(12, 32, 0, 0, 0, 1, 11, 7),
(10, 0, 0, 0, 0, 1, 12, 5),
(11, 0, 0, 0, 0, 1, 9, 6),
(14, 0, 0, 0, 0, 1, 21, 10),
(1, 56, 5455026, 1, 25, 2, 1, 1),
(3, 56, 5464774, 2, 18, 2, 2, 1),
(2, 56, 5466123, 3, 15, 2, 4, 2),
(4, 56, 5471682, 4, 12, 2, 3, 4),
(11, 56, 5504995, 5, 10, 2, 15, 9),
(8, 56, 5508774, 6, 8, 2, 7, 2),
(10, 56, 5511347, 7, 6, 2, 8, 5),
(17, 56, 5456026, 8, 4, 2, 19, 9),
(14, 56, 5456026, 9, 2, 2, 13, 7),
(15, 56, 5456026, 10, 1, 2, 12, 5),
(7, 56, 5456026, 11, 0, 2, 9, 6),
(null, 56, 5456026, 12, 0, 2, 14, 4),
(18, 56, 5456026, 13, 0, 2, 21, 10),
(19, 56, 5456026, 14, 0, 2, 18, 8),
(12, 56, 5456026, 15, 0, 2, 10, 8),
(9, 56, 5456026, 16, 0, 2, 17, 6),
(5, 56, 5455026, 0, 0, 2, 6, 3),
(6, 56, 5455026, 0, 0, 2, 5, 3),
(16, 56, 5455026, 0, 0, 2, 16, 10),
(13, 4, 0, 0, 0, 2, 11, 7),
(1, 53, 4926983, 1, 25, 3, 3, 4),
(2, 53, 4928406, 2, 18, 3, 2, 1),
(3, 53, 4929112, 3, 15, 3, 1, 1),
(4, 53, 4943080, 4, 12, 3, 5, 3),
(5, 53, 4944345, 5, 10, 3, 4, 2),
(6, 53, 4945654, 6, 8, 3, 7, 2),
(8, 53, 4956165, 7, 6, 3, 6, 3),
(7, 53, 4964117, 8, 4, 3, 9, 6),
(9, 53, 4967350, 9, 2, 3, 8, 5),
(10, 53, 4981512, 10, 1, 3, 19, 9),
(12, 53, 4984316, 11, 0, 3, 11, 7),
(14, 53, 4985384, 12, 0, 3, 17, 4),
(11, 53, 4927983, 13, 0, 3, 16, 10),
(15, 53, 4927983, 14, 0, 3, 12, 5),
(19, 53, 4927983, 15, 0, 3, 21, 10),
(16, 53, 4927983, 16, 0, 3, 10, 8),
(13, 53, 4927983, 17, 0, 3, 14, 6),
(18, 53, 4927983, 18, 0, 3, 15, 9),
(17, 53, 4927983, 19, 0, 3, 18, 8),
(20, 53, 4927983, 20, 0, 3, 13, 7),
(1, 57, 5739435, 1, 25, 4, 1, 1),
(3, 57, 5754934, 2, 18, 4, 4, 2),
(6, 57, 5755708, 3, 15, 4, 2, 1),
(2, 57, 5759114, 4, 12, 4, 5, 3),
(9, 57, 5767428, 5, 10, 4, 6, 3),
(7, 57, 5773830, 6, 8, 4, 3, 4),
(4, 57, 5775437, 7, 6, 4, 16, 10),
(14, 57, 5783679, 8, 4, 4, 15, 9),
(10, 57, 5784496, 9, 2, 4, 17, 4),
(20, 57, 5787029, 10, 1, 4, 19, 9),
(5, 57, 5787451, 11, 0, 4, 7, 2),
(15, 57, 5788274, 12, 0, 4, 8, 5),
(11, 57, 5792241, 13, 0, 4, 21, 10),
(16, 57, 5792907, 14, 0, 4, 10, 8),
(12, 57, 5795749, 15, 0, 4, 9, 6),
(13, 57, 5740435, 16, 0, 4, 11, 7),
(17, 57, 5740435, 17, 0, 4, 14, 6),
(19, 57, 5740435, 18, 0, 4, 13, 7),
(18, 57, 5740435, 19, 0, 4, 18, 8),
(8, 50, 0, 0, 0, 4, 12, 5),
(2, 50, 4866758, 1, 25, 5, 1, 1),
(1, 50, 4869601, 2, 18, 5, 3, 4),
(4, 50, 4874862, 3, 15, 5, 5, 3),
(10, 50, 4875954, 4, 12, 5, 2, 1),
(3, 50, 4893994, 5, 10, 5, 4, 2),
(5, 50, 4901446, 6, 8, 5, 7, 2),
(7, 50, 4905831, 7, 6, 5, 6, 3),
(6, 50, 4867758, 8, 4, 5, 12, 5),
(11, 50, 4867758, 9, 2, 5, 8, 5),
(14, 50, 4867758, 10, 1, 5, 9, 6),
(13, 50, 4867758, 11, 0, 5, 11, 7),
(12, 50, 4867758, 12, 0, 5, 14, 6),
(15, 50, 4867758, 13, 0, 5, 19, 9),
(19, 50, 4867758, 14, 0, 5, 15, 9),
(18, 50, 4867758, 15, 0, 5, 10, 8),
(16, 50, 4867758, 16, 0, 5, 13, 7),
(17, 50, 4867758, 17, 0, 5, 21, 10),
(20, 50, 4867758, 18, 0, 5, 18, 8),
(8, 1, 0, 0, 0, 5, 17, 4),
(9, 0, 0, 0, 0, 5, 16, 10),
(4, 57, 5331587, 1, 25, 6, 1, 1),
(2, 57, 5336217, 2, 18, 6, 2, 1),
(5, 57, 5369231, 3, 15, 6, 4, 2),
(1, 57, 5371543, 4, 12, 6, 3, 4),
(7, 57, 5379654, 5, 10, 6, 8, 5),
(3, 57, 5387089, 6, 8, 6, 7, 2),
(8, 57, 5388623, 7, 6, 6, 5, 3),
(12, 57, 5332587, 8, 4, 6, 6, 3),
(6, 57, 5332587, 9, 2, 6, 12, 5),
(10, 57, 5332587, 10, 1, 6, 17, 4),
(11, 57, 5332587, 11, 0, 6, 9, 6),
(9, 57, 5332587, 12, 0, 6, 15, 9),
(null, 57, 5332587, 13, 0, 6, 16, 10),
(16, 57, 5332587, 14, 0, 6, 10, 8),
(17, 57, 5332587, 15, 0, 6, 11, 7),
(18, 57, 5332587, 16, 0, 6, 13, 7),
(15, 36, 0, 0, 0, 6, 14, 6),
(13, 30, 0, 0, 0, 6, 18, 8),
(19, 28, 0, 0, 0, 6, 19, 9),
(14, 1, 0, 0, 0, 6, 21, 10),
(2, 63, 5493199, 1, 25, 7, 3, 4),
(4, 63, 5499308, 2, 18, 7, 2, 1),
(1, 63, 5506155, 3, 15, 7, 1, 1),
(12, 63, 5507555, 4, 12, 7, 6, 3),
(7, 63, 5511144, 5, 10, 7, 8, 5),
(11, 63, 5513973, 6, 8, 7, 5, 3),
(3, 63, 5515233, 7, 6, 7, 4, 2),
(6, 63, 5516097, 8, 4, 7, 12, 5),
(9, 63, 5516785, 9, 2, 7, 9, 6),
(null, 63, 5519645, 10, 1, 7, 17, 4),
(5, 63, 5520449, 11, 0, 7, 11, 7),
(17, 63, 5523495, 12, 0, 7, 10, 8),
(10, 63, 5524623, 13, 0, 7, 16, 10),
(15, 63, 5525710, 14, 0, 7, 14, 6),
(8, 63, 5526192, 15, 0, 7, 13, 7),
(16, 63, 5526610, 16, 0, 7, 20, 10),
(19, 63, 5527007, 17, 0, 7, 19, 9),
(14, 63, 5531771, 18, 0, 7, 18, 8),
(13, 44, 0, 0, 0, 7, 7, 2),
(18, 27, 0, 0, 0, 7, 15, 9),
(1, 78, 6033843, 1, 25, 8, 2, 1),
(2, 78, 6036974, 2, 18, 8, 5, 3),
(3, 78, 6037501, 3, 15, 8, 1, 1),
(4, 78, 6054415, 4, 12, 8, 3, 4),
(7, 78, 6085230, 5, 10, 8, 6, 3),
(5, 78, 6034843, 6, 8, 8, 9, 6),
(8, 78, 6034843, 7, 6, 8, 15, 9),
(9, 78, 6034843, 8, 4, 8, 14, 6),
(10, 78, 6035843, 9, 2, 8, 8, 5),
(11, 78, 6035843, 10, 1, 8, 12, 5),
(14, 78, 6035843, 11, 0, 8, 4, 2),
(20, 78, 6035843, 12, 0, 8, 19, 9),
(18, 78, 6035843, 13, 0, 8, 20, 10),
(16, 78, 6035843, 14, 0, 8, 18, 8),
(19, 78, 6035843, 15, 0, 8, 13, 7),
(13, 78, 6035843, 16, 0, 8, 10, 8),
(12, 78, 6035843, 17, 0, 8, 17, 4),
(15, 78, 6036843, 18, 0, 8, 7, 2),
(6, 38, 0, 0, 0, 8, 11, 7),
(17, 9, 0, 0, 0, 8, 16, 10),
(1, 66, 5577375, 1, 25, 9, 1, 1),
(2, 66, 5579846, 2, 18, 9, 2, 1),
(7, 66, 5587830, 3, 15, 9, 5, 3),
(4, 66, 5588734, 4, 12, 9, 4, 2),
(15, 66, 5591023, 5, 10, 9, 10, 8),
(5, 66, 5592883, 6, 8, 9, 6, 3),
(9, 66, 5593397, 7, 6, 9, 9, 6),
(8, 66, 5595257, 8, 4, 9, 16, 10),
(10, 66, 5598939, 9, 2, 9, 11, 7),
(3, 66, 5599201, 10, 1, 9, 3, 4),
(13, 66, 5602907, 11, 0, 9, 14, 6),
(12, 66, 5603371, 12, 0, 9, 18, 8),
(null, 66, 5606197, 13, 0, 9, 17, 4),
(17, 66, 5606684, 14, 0, 9, 12, 5),
(18, 66, 5608756, 15, 0, 9, 20, 10),
(16, 66, 5609572, 16, 0, 9, 15, 9),
(14, 66, 5614440, 17, 0, 9, 19, 9),
(6, 53, 0, 0, 0, 9, 7, 2),
(11, 27, 0, 0, 0, 9, 8, 5),
(null, 0, 0, 0, 0, 9, 13, 7),
(1, 70, 5512688, 1, 25, 10, 4, 2),
(2, 70, 5512916, 2, 18, 10, 3, 4),
(4, 70, 5513702, 3, 15, 10, 7, 2),
(3, 70, 5514797, 4, 12, 10, 1, 1),
(8, 70, 5516130, 5, 10, 10, 5, 3),
(5, 70, 5523401, 6, 8, 10, 6, 3),
(6, 70, 5523660, 7, 6, 10, 11, 7),
(11, 70, 5528052, 8, 4, 10, 10, 8),
(14, 70, 5513688, 9, 2, 10, 15, 9),
(16, 70, 5513688, 10, 1, 10, 12, 5),
(13, 70, 5513688, 11, 0, 10, 19, 9),
(18, 70, 5513688, 12, 0, 10, 17, 4),
(10, 70, 5513688, 13, 0, 10, 20, 10),
(15, 70, 5513688, 14, 0, 10, 18, 8),
(null, 70, 5513688, 15, 0, 10, 16, 10),
(12, 70, 5513688, 16, 0, 10, 9, 6),
(17, 70, 5513688, 17, 0, 10, 13, 7),
(7, 66, 0, 0, 0, 10, 2, 1),
(null, 52, 0, 0, 0, 10, 14, 6),
(9, 48, 0, 0, 0, 10, 8, 5),
(1, 71, 5027693, 1, 25, 11, 2, 1),
(3, 71, 5030388, 2, 18, 11, 1, 1),
(2, 71, 5047513, 3, 15, 11, 5, 3),
(4, 71, 5056713, 4, 12, 11, 6, 3),
(5, 71, 5028693, 5, 10, 11, 4, 2),
(6, 71, 5028693, 6, 8, 11, 14, 6),
(11, 71, 5028693, 7, 6, 11, 11, 7),
(8, 71, 5028693, 8, 4, 11, 18, 8),
(20, 71, 5028693, 9, 2, 11, 10, 8),
(17, 71, 5028693, 10, 1, 11, 15, 9),
(15, 71, 5028693, 11, 0, 11, 19, 9),
(13, 71, 5028693, 12, 0, 11, 9, 6),
(10, 71, 5028693, 13, 0, 11, 16, 10),
(16, 71, 5028693, 14, 0, 11, 13, 7),
(14, 71, 5028693, 15, 0, 11, 20, 10),
(18, 71, 5029693, 16, 0, 11, 17, 4),
(12, 15, 0, 0, 0, 11, 8, 5),
(7, 0, 0, 0, 0, 11, 3, 4),
(9, 0, 0, 0, 0, 11, 7, 2),
(19, 0, 0, 0, 0, 11, 12, 5),
(3, 52, 5835735, 1, 25, 12, 2, 1),
(2, 52, 5842547, 2, 18, 12, 1, 1),
(19, 52, 5870477, 3, 15, 12, 10, 8),
(5, 52, 5875547, 4, 12, 12, 6, 3),
(1, 52, 5892516, 5, 10, 12, 3, 4),
(8, 52, 5895592, 6, 8, 12, 16, 10),
(17, 52, 5836735, 7, 6, 12, 13, 7),
(13, 52, 5836735, 8, 4, 12, 8, 5),
(7, 52, 5836735, 9, 2, 12, 11, 7),
(4, 52, 5836735, 10, 1, 12, 4, 2),
(18, 52, 5836735, 11, 0, 12, 19, 9),
(9, 52, 5836735, 12, 0, 12, 12, 5),
(14, 52, 5836735, 13, 0, 12, 15, 9),
(6, 52, 5836735, 14, 0, 12, 5, 3),
(11, 52, 5836735, 15, 0, 12, 17, 4),
(10, 23, 0, 0, 0, 12, 7, 2),
(12, 17, 0, 0, 0, 12, 9, 6),
(16, 3, 0, 0, 0, 12, 18, 8),
(15, 0, 0, 0, 0, 12, 14, 6),
(null, 0, 0, 0, 0, 12, 20, 10),
(2, 44, 5122601, 1, 25, 13, 1, 1),
(1, 44, 5126016, 2, 18, 13, 2, 1),
(3, 44, 5142786, 3, 15, 13, 5, 3),
(4, 44, 5144332, 4, 12, 13, 3, 4),
(6, 44, 5157464, 5, 10, 13, 4, 2),
(5, 44, 5162527, 6, 8, 13, 8, 5),
(null, 44, 5163280, 7, 6, 13, 6, 3),
(9, 44, 5174634, 8, 4, 13, 14, 6),
(10, 44, 5179035, 9, 2, 13, 18, 8),
(13, 44, 5123601, 10, 1, 13, 16, 10),
(12, 44, 5123601, 11, 0, 13, 19, 9),
(14, 44, 5123601, 12, 0, 13, 10, 8),
(7, 44, 5123601, 13, 0, 13, 17, 4),
(16, 44, 5123601, 14, 0, 13, 13, 7),
(11, 44, 5123601, 15, 0, 13, 15, 9),
(null, 44, 5123601, 16, 0, 13, 7, 2),
(null, 44, 5123601, 17, 0, 13, 11, 7),
(null, 44, 5123601, 18, 0, 13, 12, 5),
(15, 44, 5123601, 19, 0, 13, 20, 10),
(8, 44, 5123601, 20, 0, 13, 9, 6),
(3, 70, 5721231, 1, 25, 14, 2, 1),
(2, 70, 5721929, 2, 18, 14, 1, 1),
(4, 70, 5743147, 3, 15, 14, 4, 2),
(1, 70, 5763791, 4, 12, 14, 5, 3),
(5, 70, 5780271, 5, 10, 14, 11, 7),
(7, 70, 5722231, 6, 8, 14, 18, 8),
(6, 70, 5722231, 7, 6, 14, 13, 7),
(9, 70, 5722231, 8, 4, 14, 14, 6),
(8, 70, 5722231, 9, 2, 14, 3, 4),
(15, 70, 5722231, 10, 1, 14, 7, 2),
(10, 70, 5722231, 11, 0, 14, 9, 6),
(12, 70, 5722231, 12, 0, 14, 6, 3),
(18, 70, 5722231, 13, 0, 14, 10, 8),
(13, 70, 5722231, 14, 0, 14, 12, 5),
(19, 70, 5722231, 15, 0, 14, 8, 5),
(17, 70, 5722231, 16, 0, 14, 15, 9),
(null, 70, 5722231, 17, 0, 14, 17, 4),
(14, 70, 5722231, 18, 0, 14, 20, 10),
(16, 70, 5722231, 19, 0, 14, 16, 10),
(11, 48, 0, 0, 0, 14, 19, 9),
(1, 72, 5909849, 1, 25, 15, 1, 1),
(3, 72, 5911120, 2, 18, 15, 3, 4),
(4, 72, 5913082, 3, 15, 15, 9, 6),
(5, 72, 5915503, 4, 12, 15, 4, 2),
(15, 72, 5916176, 5, 10, 15, 8, 5),
(null, 72, 5918893, 6, 8, 15, 19, 9),
(19, 72, 5919346, 7, 6, 15, 13, 7),
(10, 72, 5921558, 8, 4, 15, 11, 7),
(12, 72, 5923446, 9, 2, 15, 17, 4),
(18, 72, 5923912, 10, 1, 15, 15, 9),
(16, 72, 5924360, 11, 0, 15, 20, 10),
(8, 72, 5926912, 12, 0, 15, 14, 6),
(9, 72, 5927225, 13, 0, 15, 12, 5),
(17, 72, 5929574, 14, 0, 15, 10, 8),
(13, 72, 5931414, 15, 0, 15, 18, 8),
(11, 72, 5931878, 16, 0, 15, 7, 2),
(14, 72, 5933478, 17, 0, 15, 16, 10),
(2, 64, 0, 0, 0, 15, 2, 1),
(6, 52, 0, 0, 0, 15, 5, 3),
(7, 22, 0, 0, 0, 15, 6, 3),
(1, 53, 4404325, 1, 25, 16, 3, 4),
(2, 53, 4423532, 2, 18, 16, 2, 1),
(3, 53, 4425676, 3, 15, 16, 1, 1),
(4, 53, 4429949, 4, 12, 16, 5, 3),
(5, 53, 4437206, 5, 10, 16, 4, 2),
(10, 53, 4441774, 6, 8, 16, 6, 3),
(14, 53, 4454862, 7, 6, 16, 8, 5),
(7, 53, 4462809, 8, 4, 16, 18, 8),
(6, 53, 4464087, 9, 2, 16, 7, 2),
(null, 53, 4405325, 10, 1, 16, 9, 6),
(13, 53, 4405325, 11, 0, 16, 12, 5),
(11, 53, 4405325, 12, 0, 16, 19, 9),
(9, 53, 4405325, 13, 0, 16, 17, 4),
(18, 53, 4405325, 14, 0, 16, 14, 6),
(15, 53, 4405325, 15, 0, 16, 15, 9),
(null, 53, 4405325, 16, 0, 16, 16, 10),
(17, 53, 4405325, 17, 0, 16, 20, 10),
(16, 53, 4405325, 18, 0, 16, 13, 7),
(8, 24, 0, 0, 0, 16, 11, 7),
(12, 0, 0, 0, 0, 16, 10, 8),
(1, 51, 5606408, 1, 25, 17, 3, 4),
(5, 51, 5621017, 2, 18, 17, 4, 2),
(2, 51, 5625607, 3, 15, 17, 12, 5),
(4, 51, 5628168, 4, 12, 17, 7, 2),
(3, 51, 5639698, 5, 10, 17, 14, 6),
(6, 51, 5640216, 6, 8, 17, 17, 4),
(7, 51, 5640635, 7, 6, 17, 2, 1),
(12, 51, 5642718, 8, 4, 17, 6, 3),
(10, 51, 5643182, 9, 2, 17, 5, 3),
(8, 51, 5645390, 10, 1, 17, 9, 6),
(13, 51, 5607408, 11, 0, 17, 18, 8),
(15, 51, 5607408, 12, 0, 17, 19, 9),
(19, 51, 5607408, 13, 0, 17, 8, 5),
(20, 51, 5607408, 14, 0, 17, 15, 9),
(11, 51, 5607408, 15, 0, 17, 11, 7),
(17, 51, 5607408, 16, 0, 17, 10, 8),
(14, 51, 5607408, 17, 0, 17, 13, 7),
(18, 51, 5607408, 18, 0, 17, 16, 10),
(16, 51, 5607408, 19, 0, 17, 20, 10),
(9, 0, 0, 0, 0, 17, 1, 1),
(1, 62, 6022367, 1, 25, 18, 4, 2),
(2, 62, 6027797, 2, 18, 18, 3, 4),
(5, 62, 6028433, 3, 15, 18, 2, 1),
(3, 62, 6030513, 4, 12, 18, 1, 1),
(4, 62, 6056048, 5, 10, 18, 7, 2),
(7, 62, 6068363, 6, 8, 18, 5, 3),
(6, 62, 6023367, 7, 6, 18, 6, 3),
(10, 62, 6023367, 8, 4, 18, 11, 7),
(9, 62, 6023367, 9, 2, 18, 19, 9),
(18, 62, 6023367, 10, 1, 18, 12, 5),
(8, 62, 6023367, 11, 0, 18, 9, 6),
(13, 62, 6023367, 12, 0, 18, 17, 4),
(15, 62, 6023367, 13, 0, 18, 13, 7),
(null, 62, 6023367, 14, 0, 18, 8, 5),
(12, 62, 6023367, 15, 0, 18, 14, 6),
(16, 62, 6023367, 16, 0, 18, 20, 10),
(14, 62, 6023367, 17, 0, 18, 18, 8),
(17, 62, 6023367, 18, 0, 18, 15, 9),
(null, 62, 6023367, 19, 0, 18, 16, 10),
(11, 62, 6023367, 20, 0, 18, 10, 8),
(0, 0, 0, 0, 0, 19, 1, 1),
(0, 0, 0, 0, 0, 19, 2, 1),
(0, 0, 0, 0, 0, 19, 4, 2),
(0, 0, 0, 0, 0, 19, 7, 2),
(0, 0, 0, 0, 0, 19, 5, 3),
(0, 0, 0, 0, 0, 19, 6, 3),
(0, 0, 0, 0, 0, 19, 3, 4),
(0, 0, 0, 0, 0, 19, 17, 4),
(0, 0, 0, 0, 0, 19, 8, 5),
(0, 0, 0, 0, 0, 19, 12, 5),
(0, 0, 0, 0, 0, 19, 9, 6),
(0, 0, 0, 0, 0, 19, 14, 6),
(0, 0, 0, 0, 0, 19, 11, 7),
(0, 0, 0, 0, 0, 19, 13, 7),
(0, 0, 0, 0, 0, 19, 10, 8),
(0, 0, 0, 0, 0, 19, 18, 8),
(0, 0, 0, 0, 0, 19, 15, 9),
(0, 0, 0, 0, 0, 19, 19, 9),
(0, 0, 0, 0, 0, 19, 16, 10),
(0, 0, 0, 0, 0, 19, 20, 10),
(0, 0, 0, 0, 0, 20, 1, 1),
(0, 0, 0, 0, 0, 20, 2, 1),
(0, 0, 0, 0, 0, 20, 4, 2),
(0, 0, 0, 0, 0, 20, 7, 2),
(0, 0, 0, 0, 0, 20, 5, 3),
(0, 0, 0, 0, 0, 20, 6, 3),
(0, 0, 0, 0, 0, 20, 3, 4),
(0, 0, 0, 0, 0, 20, 17, 4),
(0, 0, 0, 0, 0, 20, 8, 5),
(0, 0, 0, 0, 0, 20, 12, 5),
(0, 0, 0, 0, 0, 20, 9, 6),
(0, 0, 0, 0, 0, 20, 14, 6),
(0, 0, 0, 0, 0, 20, 11, 7),
(0, 0, 0, 0, 0, 20, 13, 7),
(0, 0, 0, 0, 0, 20, 10, 8),
(0, 0, 0, 0, 0, 20, 18, 8),
(0, 0, 0, 0, 0, 20, 15, 9),
(0, 0, 0, 0, 0, 20, 19, 9),
(0, 0, 0, 0, 0, 20, 16, 10),
(0, 0, 0, 0, 0, 20, 20, 10),
(0, 0, 0, 0, 0, 21, 1, 1),
(0, 0, 0, 0, 0, 21, 2, 1),
(0, 0, 0, 0, 0, 21, 4, 2),
(0, 0, 0, 0, 0, 21, 7, 2),
(0, 0, 0, 0, 0, 21, 5, 3),
(0, 0, 0, 0, 0, 21, 6, 3),
(0, 0, 0, 0, 0, 21, 3, 4),
(0, 0, 0, 0, 0, 21, 17, 4),
(0, 0, 0, 0, 0, 21, 8, 5),
(0, 0, 0, 0, 0, 21, 12, 5),
(0, 0, 0, 0, 0, 21, 9, 6),
(0, 0, 0, 0, 0, 21, 14, 6),
(0, 0, 0, 0, 0, 21, 11, 7),
(0, 0, 0, 0, 0, 21, 13, 7),
(0, 0, 0, 0, 0, 21, 10, 8),
(0, 0, 0, 0, 0, 21, 18, 8),
(0, 0, 0, 0, 0, 21, 15, 9),
(0, 0, 0, 0, 0, 21, 19, 9),
(0, 0, 0, 0, 0, 21, 16, 10),
(0, 0, 0, 0, 0, 21, 20, 10),
(0, 0, 0, 0, 0, 22, 1, 1),
(0, 0, 0, 0, 0, 22, 2, 1),
(0, 0, 0, 0, 0, 22, 4, 2),
(0, 0, 0, 0, 0, 22, 7, 2),
(0, 0, 0, 0, 0, 22, 5, 3),
(0, 0, 0, 0, 0, 22, 6, 3),
(0, 0, 0, 0, 0, 22, 3, 4),
(0, 0, 0, 0, 0, 22, 17, 4),
(0, 0, 0, 0, 0, 22, 8, 5),
(0, 0, 0, 0, 0, 22, 12, 5),
(0, 0, 0, 0, 0, 22, 9, 6),
(0, 0, 0, 0, 0, 22, 14, 6),
(0, 0, 0, 0, 0, 22, 11, 7),
(0, 0, 0, 0, 0, 22, 13, 7),
(0, 0, 0, 0, 0, 22, 10, 8),
(0, 0, 0, 0, 0, 22, 18, 8),
(0, 0, 0, 0, 0, 22, 15, 9),
(0, 0, 0, 0, 0, 22, 19, 9),
(0, 0, 0, 0, 0, 22, 16, 10),
(0, 0, 0, 0, 0, 22, 20, 10),
(0, 0, 0, 0, 0, 23, 1, 1),
(0, 0, 0, 0, 0, 23, 2, 1),
(0, 0, 0, 0, 0, 23, 4, 2),
(0, 0, 0, 0, 0, 23, 7, 2),
(0, 0, 0, 0, 0, 23, 5, 3),
(0, 0, 0, 0, 0, 23, 6, 3),
(0, 0, 0, 0, 0, 23, 3, 4),
(0, 0, 0, 0, 0, 23, 17, 4),
(0, 0, 0, 0, 0, 23, 8, 5),
(0, 0, 0, 0, 0, 23, 12, 5),
(0, 0, 0, 0, 0, 23, 9, 6),
(0, 0, 0, 0, 0, 23, 14, 6),
(0, 0, 0, 0, 0, 23, 11, 7),
(0, 0, 0, 0, 0, 23, 13, 7),
(0, 0, 0, 0, 0, 23, 10, 8),
(0, 0, 0, 0, 0, 23, 18, 8),
(0, 0, 0, 0, 0, 23, 15, 9),
(0, 0, 0, 0, 0, 23, 19, 9),
(0, 0, 0, 0, 0, 23, 16, 10),
(0, 0, 0, 0, 0, 23, 20, 10),
(0, 0, 0, 0, 0, 24, 1, 1),
(0, 0, 0, 0, 0, 24, 2, 1),
(0, 0, 0, 0, 0, 24, 4, 2),
(0, 0, 0, 0, 0, 24, 7, 2),
(0, 0, 0, 0, 0, 24, 5, 3),
(0, 0, 0, 0, 0, 24, 6, 3),
(0, 0, 0, 0, 0, 24, 3, 4),
(0, 0, 0, 0, 0, 24, 17, 4),
(0, 0, 0, 0, 0, 24, 8, 5),
(0, 0, 0, 0, 0, 24, 12, 5),
(0, 0, 0, 0, 0, 24, 9, 6),
(0, 0, 0, 0, 0, 24, 14, 6),
(0, 0, 0, 0, 0, 24, 11, 7),
(0, 0, 0, 0, 0, 24, 13, 7),
(0, 0, 0, 0, 0, 24, 10, 8),
(0, 0, 0, 0, 0, 24, 18, 8),
(0, 0, 0, 0, 0, 24, 15, 9),
(0, 0, 0, 0, 0, 24, 19, 9),
(0, 0, 0, 0, 0, 24, 16, 10),
(0, 0, 0, 0, 0, 24, 20, 10);

-- ================================
-- stored procedure
-- ================================
delimiter zz
create procedure updateRace(
	in p_id int,
    in p_name varchar(100),
    in p_numberOfLaps int,
    in p_raceNumber int,
    in p_time datetime,
    in p_status varchar(50),
    in p_tblTournamentId int,
    in p_tblCircuitId int,
    out ok boolean
)
begin
	-- check
    if p_name is null or p_numberOfLaps <= 0 or p_raceNumber <= 0 then 
		signal sqlstate '45000' set message_text='name/numberOfLaps/raceNumber is not valid';
	end if;
	
	-- check tournament 
    if not exists(select 1 from tblTournament where id = p_tblTournamentId) then 
		signal sqlstate '45000' set message_text='Tournament not found';
	end if;
    
	-- check circuit
	if not exists(select 1 from tblCircuit where id = p_tblCircuitId) then 
		signal sqlstate '45000' set message_text='Circuit not found';
	end if;
    
    -- new race    
	if p_id = -1 then
		if exists (select 1 from tblRace where name=p_name or timestampdiff(day, time, p_time)=0 or raceNumber=p_raceNumber) then
			signal sqlstate '45000' set message_text = 'Duplicate race/time';
		end if;
        --  insert
		insert into tblRace(name, numberOfLaps, raceNumber, time, status, tblTournamentId, tblCircuitId) values
        (p_name, p_numberOfLaps, p_raceNumber, p_time, p_status, p_tblTournamentId, p_tblCircuitId);
		set ok = true;
    else 
		if exists(
        select 1 from tblRace where 
			name = p_name and
            numberOfLaps = p_numberOfLaps and 
            raceNumber = p_raceNumber and 
            time = p_time and 
            status = p_status and
            tblTournamentId = p_tblTournamentId and
            tblCircuitId = p_tblCircuitId
        ) then
			signal sqlstate '45000' set message_text = 'Nothing to change';
		end if;
        
		update tblRace set 
			name = p_name,
            numberOfLaps = p_numberOfLaps,
            raceNumber = p_raceNumber, 
            time = p_time,
            status = p_status, 
            tblTournamentId = p_tblTournamentId, 
            tblCircuitId = p_tblCircuitId
		where id = p_id;
        
        if row_count() = 0 then 
			signal sqlstate '45000' set message_text = 'Race not found';
		end if;
        set ok = true;
	end if;
end zz
delimiter ;
