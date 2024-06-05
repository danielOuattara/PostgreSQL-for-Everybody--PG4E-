# SQL Techniques

##  Starting

```bash
# log as root
sudo -u postgres psql postgres  

# Should have already be done: 
# CREATE USER pg4e WITH PASSWORD 'secret';

CREATE DATABASE pg4e_discuss WITH OWNER 'pg4e' ENCODING 'UTF8';

# quit as root
\q 


# Now login as pg4e user, 

# NOTE: login in the working folder, to get access to files for \i command later

psql -U pg4e  pg4e_discuss 

```

## After CREATE TABLE

```sql

CREATE TABLE account (
  id SERIAL,
  email VARCHAR(128) UNIQUE,
  created_at DATE NOT NULL DEFAULT NOW(),
  updated_at DATE NOT NULL DEFAULT NOW(),
  PRIMARY KEY(id)
);

CREATE TABLE post (
  id SERIAL,
  title VARCHAR(128) UNIQUE NOT NULL, 
  content VARCHAR(1024), -- Will extend with ALTER
  account_id INTEGER REFERENCES account(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY(id)
);


-- Allow multiple comments : DONE
CREATE TABLE comment (
  id SERIAL,
  content TEXT NOT NULL,
  account_id INTEGER REFERENCES account(id) ON DELETE CASCADE,
  post_id INTEGER REFERENCES post(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY(id)
);

CREATE TABLE fav (
  id SERIAL,
  oops TEXT,  -- Will remove later with ALTER
  post_id INTEGER REFERENCES post(id) ON DELETE CASCADE,
  account_id INTEGER REFERENCES account(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(post_id, account_id),
  PRIMARY KEY(id)
);

```

### We can adjust our schema

- Sometimes you make a mistake or your application evolves

```sql
ALTER TABLE fav DROP COLUMN oops;
```

### Add, Drop , Alter columns

- Can also alter `indexes`, `uniqueness constraints`, `foreign keys`
- Can run `on a live database`

```sql
ALTER TABLE fav DROP COLUMN oops;  -- done
ALTER TABLE post ALTER COLUMN content TYPE TEXT; -- done
ALTER TABLE fav ADD COLUMN how_much INTEGER; -- done
```

### Reading commands from a file

- Download <https://www.pg4e.com/lectures/03-Techniques-Load.sql>

```sql
discuss=> \i 03-Techniques-load.sql  -- done
DELETE 4 scuss=>
ALTER SEQUENCE scuss=>
ALTER SEQUENCE
ALTER SEQUENCE
ALTER SEQUENCE
INSERT 0 3
INSERT 0 3
INSERT 0 5
discuss=> 
```

##  Dates

### Date Types (Review)

- 8 bits field in memory
- DATE - 'YYYY-MM-DD'
- TIME - 'HH:MM:SS'
- TIMESTAMP - 'YYYY-MM-DD HH:MM:SS' (4713 BC, 294276 AD)
- TIMESTAMPTZ – "TIMESTAMP WITH TIME ZONE"
- Built-in PostgreSQL function NOW()

### Setting default values

- We can save some code by auto-populating date fields
  when a row is inserted

- We will auto-set on UPDATEs later…

```sql
CREATE TABLE fav (
  id SERIAL,
  post_id INTEGER REFERENCES post(id) ON DELETE CASCADE,
  account_id INTEGER REFERENCES account(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(post_id, account_id),
  PRIMARY KEY(id)
);
```

### TIMESTAMPTZ – Best Practice

- Store time stamps with timezone
- Prefer UTC for stored time stamps
- Convert to local time zone when retrieving

```sql
SELECT NOW(), NOW() AT TIME ZONE 'UTC', NOW() AT TIME ZONE 'HST';
              now              |          timezone          |          timezone          
-------------------------------+----------------------------+----------------------------
 2024-06-05 18:35:21.380517+02 | 2024-06-05 16:35:21.380517 | 2024-06-05 06:35:21.380517
(1 row)

```

### PostgreSQL time zones

```sql
SELECT * FROM pg_timezone_names;
SELECT * FROM pg_timezone_names WHERE name LIKE '%Hawaii%';
```

### Casting to different types

- We use the phrase 'casting' to mean convert from one type to another
- Postgres has several forms of casting

```sql
SELECT NOW()::DATE, CAST(NOW() AS DATE), CAST(NOW() AS TIME);
```

### Intervals

- We can do date interval arithmetic

```sql
SELECT NOW(), NOW() - INTERVAL '2 days', (NOW() - INTERVAL '2 days')::DATE;
```

###  Using date_trunc()

- Sometimes we want to discard some of the accuracy that is in a TIMESTAMP

```sql
SELECT id, content, created_at FROM comment 
WHERE created_at >= DATE_TRUNC('day',NOW()) 
AND created_at < DATE_TRUNC('day',NOW() + INTERVAL '1 day');
```

### Performance: Table Scans

- Not all equivalent queries have the same performance

```sql
SELECT id, content, created_at FROM comment
WHERE created_at::DATE = NOW()::DATE;
```

## DISTINCT / GROUP BY

### Reducing the result set

- `DISTINCT` only returns unique rows in a result set –
  and row will only appear once

- `DISTINCT ON` limits duplicate removal to a set of columns

- `GROUP BY` is combined with aggregate functions like `COUNT()`,
  `MAX()`, `SUM()`, `AVERAGE()`, etc …

```sql

DROP TABLE IF EXISTS racing;

CREATE TABLE racing (
   make VARCHAR,
   model VARCHAR,
   year INTEGER,
   price INTEGER
);

INSERT INTO racing (make, model, year, price)
VALUES
('Nissan', 'Stanza', 1990, 2000),
('Dodge', 'Neon', 1995, 800),
('Dodge', 'Neon', 1998, 2500),
('Dodge', 'Neon', 1999, 3000),
('Ford', 'Mustang', 2001, 1000),
('Ford', 'Mustang', 2005, 2000),
('Subaru', 'Impreza', 1997, 1000),
('Mazda', 'Miata', 2001, 5000),
('Mazda', 'Miata', 2001, 3000),
('Mazda', 'Miata', 2001, 2500),
('Mazda', 'Miata', 2002, 5500),
('Opel', 'GT', 1972, 1500),
('Opel', 'GT', 1969, 7500),
('Opel', 'Cadet', 1973, 500)
;

select * from racing;

SELECT DISTINCT model FROM racing;
-- Can have duplicates in the make column
SELECT DISTINCT ON (model) 
  make,model FROM racing;

-- Must include the DISTINCT column in ORDER BY
SELECT DISTINCT ON (model) make,model,year FROM racing ORDER BY model, year;

SELECT DISTINCT ON (model) make,model,year FROM racing ORDER BY model, year DESC;

SELECT DISTINCT ON (model) make,model,year FROM racing ORDER BY model, year DESC LIMIT 2;

```

#### Lets play with time zones

```sql
SELECT * FROM pg_timezone_names;
SELECT * FROM pg_timezone_names WHERE name LIKE '%Hawaii%';
```

### Aggregate / GROUP BY

```sql
SELECT COUNT(abbrev), abbrev FROM pg_timezone_names GROUP BY abbrev;

SELECT * FROM pg_timezone_names LIMIT 20;

SELECT COUNT(*) FROM pg_timezone_names;

SELECT DISTINCT is_dst FROM pg_timezone_names;

SELECT COUNT(is_dst), is_dst FROM pg_timezone_names GROUP BY is_dst;

SELECT COUNT(abbrev), abbrev FROM pg_timezone_names GROUP BY abbrev;
```

### HAVING clause

```sql
SELECT COUNT(abbrev) AS ct, abbrev FROM  pg_timezone_names 
WHERE is_dst= 't' GROUP BY abbrev HAVING COUNT(abbrev) > 10;

-- WHERE is before GROUP BY, HAVING is after GROUP BY

SELECT COUNT(abbrev) AS ct, abbrev FROM  pg_timezone_names WHERE is_dst= 't' GROUP BY abbrev HAVING COUNT(abbrev) > 10;

SELECT COUNT(abbrev) AS ct, abbrev FROM  pg_timezone_names GROUP BY abbrev HAVING COUNT(abbrev) > 10;

SELECT COUNT(abbrev) AS ct, abbrev FROM  pg_timezone_names GROUP BY abbrev HAVING COUNT(abbrev) > 10 ORDER BY COUNT(abbrev) DESC;

```

## Sub-Queries

### A query within an query

- Can use a value or set of values in a query that are computed
  by another query

```sql

SELECT * FROM account
 WHERE email='ed@umich.edu';

SELECT content FROM comment
 WHERE account_id = 1;

SELECT content FROM comment
 WHERE account_id = (SELECT id FROM account WHERE email='ed@umich.edu');

```
