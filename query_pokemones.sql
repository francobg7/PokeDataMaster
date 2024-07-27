
--creando mi base de datos
create database POKEDB;

use POKEDB

create table pokemones(
pokemon_id int primary key identity (1,1) not null,
nombre varchar(30),
tipo varchar(30),
Habilidad varchar(30),
estadistica_general varchar (50)
); 

alter table pokemones
alter column estadistica_general int; 


INSERT INTO pokemones (nombre, tipo, habilidad, estadistica_general) VALUES
('Pikachu', 'Eléctrico', 'Electricidad estática', 320),
('Charizard', 'Fuego/Volador', 'Mar llamas', 534),
('Mewtwo', 'Psíquico', 'Presión', 680),
('Bulbasaur', 'Planta/Veneno', 'Espesura', 318),
('Gyarados', 'Agua/Volador', 'Intimidación', 540);


create table entrenadores(
entrenadores_id int primary key identity (1,1) not null,
Nombre varchar(30)
); 

insert into entrenadores (Nombre) values
('Brock'),
('Ash');


create table relacion(
pokemon_id int,
entrenadores_id int,
primary key (pokemon_id,entrenadores_id),
foreign key (pokemon_id) references Pokemones(pokemon_id),
foreign key (entrenadores_id) references entrenadores(entrenadores_id)
);

insert into relacion (pokemon_id,entrenadores_id) values
(1,1),
(2,2);


create table batallas(
batalla_id int primary key identity (1,1) not null,
entrenador1_id int,
entrenador2_id int,
pokemon1_id int,
pokemon2_id int,
fecha datetime,
ganador varchar(30),
FOREIGN KEY (entrenador1_id) REFERENCES entrenadores(entrenadores_id),
FOREIGN KEY (entrenador2_id) REFERENCES entrenadores(entrenadores_id),
FOREIGN KEY (pokemon1_id) REFERENCES pokemones(pokemon_id),
FOREIGN KEY (pokemon2_id) REFERENCES pokemones(pokemon_id),
);

INSERT INTO batallas (entrenador1_id, entrenador2_id, pokemon1_id, pokemon2_id, fecha, ganador) VALUES
(1, 2, 1, 2, '2023-07-01 10:00:00', 'Ash'),      -- Brock con Pikachu vs Ash con Charizard
(2, 1, 3, 4, '2023-07-02 11:00:00', 'Brock'),     -- Ash con Mewtwo vs Brock con Bulbasaur
(1, 2, 5, 1, '2023-07-03 12:00:00', 'Ash'),       -- Brock con Gyarados vs Ash con Pikachu
(2, 1, 4, 2, '2023-07-04 13:00:00', 'Brock');     -- Ash con Bulbasaur vs Brock con Charizard

--create 
INSERT INTO pokemones (nombre, tipo, habilidad, estadistica_general) VALUES
('fransia','planta', 'embestida', 419);

--read
SELECT * from Batallas
SELECT * from Pokemones
SELECT * from entrenadores

SELECT * FROM Pokemones WHERE pokemon_id = 3 
-- update
ALTER TABLE batallas
ALTER COLUMN fecha DATE;

UPDATE batallas
SET fecha = CAST(fecha AS DATE);

-- Consulta para verificar la eliminación de la hora
SELECT batalla_id, entrenador1_id, entrenador2_id, pokemon1_id, pokemon2_id, 
       CONVERT(VARCHAR(10), fecha, 120) AS fecha, ganador
FROM batallas;

--eliminar
DELETE from pokemones where nombre = 'fransia';

--multi tablas

-- Información detallada sobre Pokémon y sus entrenadores
SELECT p.nombre AS Pokemon, p.tipo, p.habilidad, p.estadistica_general, e.Nombre AS Entrenador
FROM pokemones p
JOIN relacion r ON p.pokemon_id = r.pokemon_id
JOIN entrenadores e ON r.entrenadores_id = e.entrenadores_id;

-- Información sobre las batallas, incluyendo nombres de los entrenadores y Pokemones
SELECT b.batalla_id, e1.Nombre AS Entrenador1, p1.nombre AS Pokemon1, 
       e2.Nombre AS Entrenador2, p2.nombre AS Pokemon2, 
       b.fecha, b.ganador
FROM batallas b
JOIN entrenadores e1 ON b.entrenador1_id = e1.entrenadores_id
JOIN pokemones p1 ON b.pokemon1_id = p1.pokemon_id
JOIN entrenadores e2 ON b.entrenador2_id = e2.entrenadores_id
JOIN pokemones p2 ON b.pokemon2_id = p2.pokemon_id;



BEGIN TRANSACTION

-- Eliminar registros relacionados en la tabla batalla
DELETE b
FROM batallas b
JOIN pokemones p ON b.pokemon1_id = p.pokemon_id OR b.pokemon2_id = p.pokemon_id
WHERE p.pokemon_id = 1;

-- Eliminar registros relacionados en la tabla relacion
DELETE r
FROM relacion r
JOIN pokemones p ON r.pokemon_id = p.pokemon_id
WHERE p.pokemon_id = 1;
select * from entrenadores

-- Eliminar el Pokémon de la tabla pokemones
DELETE p
FROM pokemones p
WHERE p.pokemon_id = 1;

COMMIT TRANSACTION;