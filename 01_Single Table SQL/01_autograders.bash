# -- autograder 1 : initial_database_setup --


# .env for connection infos

psql -h pg.pg4e.com -p 5432 -U pg4e_50f0acf931 pg4e_50f0acf931


# -- autograder 2 : making_our_first_tables --

CREATE TABLE pg4e_debug (
  id SERIAL,
  query VARCHAR(4096),
  result VARCHAR(4096),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(id)
);

SELECT query, result, created_at FROM pg4e_debug;

CREATE TABLE pg4e_result (
  id SERIAL,
  link_id INTEGER UNIQUE,
  score FLOAT,
  title VARCHAR(4096),
  note VARCHAR(4096),
  debug_log VARCHAR(8192),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP
);

# -- autograder 3 : Inserting some data into a table --

CREATE TABLE ages ( 
  name VARCHAR(128), 
  age INTEGER
);

DELETE FROM ages;
INSERT INTO ages (name, age) VALUES ('Aamna', 16);
INSERT INTO ages (name, age) VALUES ('Abaigeal', 32);
INSERT INTO ages (name, age) VALUES ('Annaliesse', 33);
INSERT INTO ages (name, age) VALUES ('Gurwinder', 24);
INSERT INTO ages (name, age) VALUES ('Mehmet', 33);


# -- autograder 4 : SERIAL fields / Auto increment --

DROP TABLE IF EXISTS automagic;
CREATE TABLE automagic(
  id SERIAL,
  name VARCHAR(32) NOT NULL,
  height FLOAT NOT NULL
);


# -- autograder 5 : Musical TRack Database --

# download  'library.csv' from 

# create TABLE track_raw:
DROP TABLE IF EXISTS track_raw;
CREATE TABLE track_raw(
  title TEXT, 
  artist TEXT, 
  album TEXT,
  count INTEGER, 
  rating INTEGER, 
  len INTEGER
);

# populate track_raw with data from 'library.csv' 
\copy track_raw(title, artist, album, count, rating, len) FROM 'library.csv' WITH DELIMITER ',' CSV;

# confirm:
SELECT title, album FROM track_raw ORDER BY title LIMIT 3;