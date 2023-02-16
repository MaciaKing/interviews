CREATE DATABASE IF NOT EXISTS video;
\c video

-- Create table for rents
CREATE TABLE Rent (
  idRent SERIAL PRIMARY KEY,
  day_rented DATE
);

-- Create table for type of film
CREATE TABLE Type_of_film (
  name_type VARCHAR(50) PRIMARY KEY,
  normal_price INTEGER,
  price_extra_day INTEGER,
  CONSTRAINT chk_name_type CHECK (name_type IN ('new release', 'regular films', 'old film'))
);

-- Create table for film
CREATE TABLE Film (
  idFilm SERIAL PRIMARY KEY,
  name VARCHAR(255),
  synopsis TEXT,
  name_type VARCHAR(50) REFERENCES Type_of_film(name_type)
);

-- Create table for time
CREATE TABLE Time (
  idTime SERIAL PRIMARY KEY,
  n_rented_days INTEGER,
  n_extra_days INTEGER,
  idFilm INTEGER REFERENCES Film(idFilm),
  idRent INTEGER REFERENCES Rent(idRent),
  CONSTRAINT fk_time_film FOREIGN KEY (idFilm) REFERENCES Film(idFilm),
  CONSTRAINT fk_time_rent FOREIGN KEY (idRent) REFERENCES Rent(idRent)
);

-- Create table for relation between film and rent
CREATE TABLE R_Film_Rent (
  idFilm INTEGER REFERENCES Film(idFilm),
  idRent INTEGER REFERENCES Rent(idRent),
  CONSTRAINT fk_r_film_rent_film FOREIGN KEY (idFilm) REFERENCES Film(idFilm),
  CONSTRAINT fk_r_film_rent_rent FOREIGN KEY (idRent) REFERENCES Rent(idRent),
  PRIMARY KEY (idFilm, idRent)
);

--INSERTS
--TYPE OF FILM
INSERT INTO Type_of_film (name_type, normal_price, price_extra_day) VALUES 
('new release', 40, 40), ('regular films', 30, 20), ('old film', 5, 10);

--FILM
INSERT INTO Film (name, synopsis, name_type) VALUES ('The Godfather', 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.', 'old film'),
('The Shawshank Redemption', 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.', 'regular films'),
('The Dark Knight', 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.', 'regular films'),
('Star Wars: Episode IV - A New Hope', 'Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a Wookiee and two droids to save the galaxy from the Empire''s world-destroying battle station, while also attempting to rescue Princess Leia from the mysterious Darth Vader.', 'old film'),
('The Matrix', 'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.', 'regular films'),
('The Lion King', 'Lion prince Simba and his father are targeted by his bitter uncle, who wants to ascend the throne himself.', 'old film'),
('Titanic', 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.', 'old film'),
('Jurassic Park', 'A pragmatic paleontologist visiting an almost complete theme park is tasked with protecting a couple of kids after a power failure causes the park''s cloned dinosaurs to run loose.', 'regular films'),
('The Incredibles', 'A family of undercover superheroes, while trying to live the quiet suburban life, are forced into action to save the world.', 'new release'),
('Avengers: Endgame', 'After the devastating events of Avengers: Infinity War (2018), the universe is in ruins. With the help of remaining allies, the Avengers assemble once more in order to reverse Thanos'' actions and restore balance to the universe.', 'new release'),
('Joker', 'In Gotham City, mentally-troubled comedian Arthur Fleck embarks on a downward-spiral of social revolution and bloody crime. This path brings him face-to-face with his infamous alter-ego: "The Joker".', 'new release'),
('The Lord of the Rings: The Fellowship of the Ring', 'A meek hobbit of the Shire and eight companions set out on a journey to Mount Doom to destroy the One Ring and the dark lord Sauron.', 'old film'),
('Forrest Gump', 'The presidencies of Kennedy and Johnson, the events of Vietnam, Watergate and other historical events unfold through the perspective of an Alabama man with an IQ of 75, whose only desire is to be reunited','old film');

--RENT
INSERT INTO Rent (day_rented) VALUES (CURRENT_DATE - INTERVAL '1 day'),
(CURRENT_DATE - INTERVAL '2 days'), (CURRENT_DATE - INTERVAL '3 days'),(CURRENT_DATE - INTERVAL '4 days'),
(CURRENT_DATE - INTERVAL '5 days'),(CURRENT_DATE - INTERVAL '6 days'),(CURRENT_DATE),
(CURRENT_DATE - INTERVAL '8 days'),(CURRENT_DATE - INTERVAL '9 days'), (CURRENT_DATE - INTERVAL '10 days');

--R_FILM_RENT
INSERT INTO R_Film_Rent (idFilm, idRent) VALUES (1,1), (2,1), (3,1), (4,1), 
(12,2), (11,2), (10,2),
(9, 3);

INSERT INTO Time (n_rented_days, n_extra_days, idFilm, idRent) VALUES (2, 0, 1,1), (2, 0, 2, 1), (4, 0, 3, 1), (4, 0, 4,1),
(5, 0, 12, 2), (5, 0, 11, 2), (3, 0, 10, 2),
(1, 0, 9, 3);

/* 
Create the function that will be executed every day, this will update
if there are to update n_extra_days to see if it has passed
of the rental days.
*/
CREATE OR REPLACE FUNCTION actualiza_dias() RETURNS VOID AS $$
DECLARE
    idFilm_r INTEGER;
    idRent_r INTEGER;
    new_n_extra_days_r INTEGER;
    cur_rentas CURSOR FOR 
        --SELECT Film.idFilm, Film.name, Rent.idRent, Rent.day_rented, Time.n_rented_days, Time.n_extra_days, (current_date - Rent.day_rented - Time.n_rented_days) AS new_n_extra_days 
        SELECT Film.idFilm, Rent.idRent, (current_date - Rent.day_rented - Time.n_rented_days) AS new_n_extra_days 
        FROM Rent 
        JOIN TIME ON Rent.idRent=Time.idRent 
        JOIN Film ON Time.idFilm=Film.idFilm 
        WHERE current_date - Rent.day_rented > Time.n_rented_days 
        ORDER BY Time.n_rented_days DESC;
BEGIN
    OPEN cur_rentas;
    LOOP
        FETCH cur_rentas INTO idFilm_r, idRent_r, new_n_extra_days_r;
        EXIT WHEN NOT FOUND;
        
        UPDATE Time SET n_extra_days = new_n_extra_days_r WHERE idFilm = idFilm_r AND idRent = idRent_r; 
    END LOOP;
    CLOSE cur_rentas;
END;
$$ LANGUAGE plpgsql;

-- Create the event to execute the function every day at 00:00
CREATE EXTENSION pg_cron;
SELECT cron.schedule('0 0 * * *', 'SELECT actualiza_dias();');

-- Create the user
CREATE USER macia WITH PASSWORD 'macia';

-- Set privileges to the user
GRANT ALL PRIVILEGES ON DATABASE video TO macia;

GRANT ALL PRIVILEGES ON TABLE Rent TO macia;
GRANT ALL PRIVILEGES ON TABLE Type_of_film TO macia;
GRANT ALL PRIVILEGES ON TABLE Film TO macia;
GRANT ALL PRIVILEGES ON TABLE Time TO macia;
GRANT ALL PRIVILEGES ON TABLE R_Film_Rent TO macia;

/*
psql -U macia -d video
Para conectarse a la base de datos
*/

/*
--Querys for testing

--Ver todas las películas que se han rentado en un rent
SELECT Film.idFilm, Film.name, Rent.idRent from Rent
JOIN R_Film_Rent ON  Rent.idRent=1 AND Rent.idRent=R_Film_Rent.idRent
JOIN Film ON R_Film_Rent.idFilm=Film.idFilm;


--Ver las películas que se han rentado en un rent con su n_rented_days y n_extra_days
SELECT Film.idFilm, Film.name, Rent.idRent, Rent.day_rented, Time.n_rented_days, Time.n_extra_days from Rent
JOIN TIME ON Rent.idRent=Time.idRent
JOIN Film ON Time.idFilm=Film.idFilm
ORDER BY Time.n_rented_days DESC;


--Ver las películas que se han pasado del dia de alquiler.
SELECT Film.idFilm, Film.name, Rent.idRent, Rent.day_rented, Time.n_rented_days, Time.n_extra_days from Rent
JOIN TIME ON Rent.idRent=1 AND Rent.idRent=Time.idRent AND current_date - Rent.day_rented > Time.n_rented_days
JOIN Film ON Time.idFilm=Film.idFilm
ORDER BY Time.n_rented_days DESC;

SELECT Film.idFilm, Film.name, Rent.idRent, Rent.day_rented, Time.n_rented_days, Time.n_extra_days, (current_date - Rent.day_rented - Time.n_rented_days) AS new_n_extra_days 
FROM Rent 
JOIN TIME ON Rent.idRent=3 AND Rent.idRent=Time.idRent 
JOIN Film ON Time.idFilm=Film.idFilm 
WHERE current_date - Rent.day_rented > Time.n_rented_days 
ORDER BY Time.n_rented_days DESC;

SELECT Film.idFilm, Film.name, Rent.idRent, Rent.day_rented, Time.n_rented_days, Time.n_extra_days, DATE_PART('day', current_date - Rent.day_rented - Time.n_rented_days) AS new_n_extra_days 
FROM Rent 
JOIN TIME ON Rent.idRent=3 AND Rent.idRent=Time.idRent 
JOIN Film ON Time.idFilm=Film.idFilm 
WHERE Rent.day_rented + Time.n_rented_days < current_date 
ORDER BY Time.n_rented_days DESC;


--Rents que he creado
select * from Rent WHERE idRent=1 OR idRent=2 OR idRent=3;
*/
