# --> connect as admin: Creating a User and Database
sudo -u postgres psql postgres

postgres=# CREATE USER pg4e WITH PASSWORD '**Azerty**';

postgres=# CREATE DATABASE pg4e_people WITH OWNER 'pg4e';

postgres=# \q

# --> connect as 'pg4e' and start using the database;

# --> syntax: psql DATABASE USER
psql pg4e_people pg4e 

Password for user pg4e: 
psql (16.3 (Debian 16.3-1.pgdg120+1))
Type "help" for help.


\dt
Did not find any relations.


# --> Creating a Table
CREATE TABLE users(
  name VARCHAR(128), 
  email VARCHAR(128)
);


\d users 
                       Table "public.users"
 Column |          Type          | Collation | Nullable | Default 
--------+------------------------+-----------+----------+---------
 name   | character varying(128) |           |          | 
 email  | character varying(128) |           |          | 




\d+ users 
                                                  Table "public.users"
 Column |          Type          | Collation | Nullable | Default | Storage  | Compression | Stats target | Description 
--------+------------------------+-----------+----------+---------+----------+-------------+--------------+-------------
 name   | character varying(128) |           |          |         | extended |             |              | 
 email  | character varying(128) |           |          |         | extended |             |              | 
Access method: heap



# --> SQL: Insert The INSERT statement inserts a row into a table

INSERT INTO users (name, email) VALUES ('Chuck', 'csev@umich.edu') ;
INSERT INTO users (name, email) VALUES ('Somesh', 'somesh@umich.edu') ;
INSERT INTO users (name, email) VALUES ('Caitlin', 'cait@umich.edu') ;
INSERT INTO users (name, email) VALUES ('Ted', 'ted@umich.edu') ;
INSERT INTO users (name, email) VALUES ('Sally', 'sally@umich.edu') ;

# --> SQL: Delete: Deletes a row in a table based on selection criteria

DELETE FROM users WHERE email='ted@umich.edu';

# --> SQL: Update: Allows the updating of a field with a WHERE clause

UPDATE users SET name='Charles' WHERE email='csev@umich.edu';

# --> Retrieving Records: Select
# --  Retrieves a group of records - you can either retrieve all the records or a 
# --  subset of the records with a WHERE clause

SELECT * FROM users;
SELECT * FROM users WHERE email='csev@umich.edu';

# --> Sorting with ORDER BY:
# --  You can add an ORDER BY clause to SELECT statements to get 
# --  the results sorted in ascending or descending order

SELECT * FROM users ORDER BY email;

# --> The LIKE Clause
# -- We can do wildcard matching in a WHERE clause using the LIKE operator

SELECT * FROM users WHERE name LIKE '%e%';

# --> The LIMIT/OFFSET Clauses:
# --  We can request the first "n" rows, or the first "n" rows after skipping some rows. 
# --  The WHERE and ORDER BY clauses happen *before* the LIMIT / OFFSET are applied.
# --  The OFFSET starts from row 0

SELECT * FROM users ORDER BY email DESC LIMIT 2;
SELECT * FROM users ORDER BY email OFFSET 1 LIMIT 2;

# --> Counting Rows with SELECT: 
# --  You can request to receive the count of the rows 
# --  that would be retrieved instead of the rows

SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM users WHERE email='csev@umich.edu';

# --> Data Types in PostgreSQL:

# Text fields (small and large)
# Binary fields (small and large)
# Numeric fields
# AUTO_INCREMENT fields

# --> String Fields :
# Understand character sets and are indexable for searching
# CHAR(n) allocates the entire space (faster for small strings where length is known)
# VARCHAR(n) allocates a variable amount of space depending on the data length (less space)

# --> Text Fields:

# Have a character set - paragraphs or HTML pages
# -  TEXT varying length
# Generally not used with indexing or sorting( no `order by` or `where` clauses ) 
# - and only then limited to a prefix


# --> Binary Types (rarely used):

# Character = 8 - 32 bits of information depending on character set
# Byte = 8 bits of information 
#   -  BYTEA(n) up to 255 bytes
# Small Images - data
# Not indexed or sorted

# --> Integer Numbers:

# Integer numbers are very efficient, take little storage, and are easy 
# to process because CPUs can often compare them with a single instruction.
# 	-  SMALLINT (-32768, +32768)
#   -  INTEGER (2 Billion)
#   -  BIGINT - (10**18 ish)


# --> Floating Point Numbers: 

# Floating point numbers can represent a wide range of values, but accuracy is limited.
#   -  REAL (32-bit) 10**38 with seven digits of accuracy
#   -  DOUBLE PRECISION (64-bit) 10**308 with 14 digits of accuracy 
#   -  NUMERIC(accuracy, decimal) – Specified digits of accuracy and digits after the decimal point


# --> Dates:

# TIMESTAMP - 'YYYY-MM-DD HH:MM:SS' 
# (4713 BC, 294276 AD)
#  DATE - 'YYYY-MM-DD'
#  TIME - 'HH:MM:SS'
#  Built-in PostgreSQL function NOW()


# --> Database Keys and Indexes:

# --> AUTO_INCREMENT:

# Often as we make multiple tables and need to 'JOIN' them together. 
# We need an integer 'primary key' for each row so we can efficiently 
# add a reference to a row in some other table as a 'foreign key'.

DROP TABLE users;

CREATE TABLE users (
  id SERIAL, # <-- To say 'auto-icrement'
  name VARCHAR(128), 
  email VARCHAR(128) UNIQUE, # UNIQUE = logical key, constraint
  PRIMARY KEY(id) # <-- primary key
);


# OR

ALTER TABLE users ADD COLUMN id SERIAL;
ALTER TABLE users ADD PRIMARY KEY(id);
ALTER TABLE users ADD UNIQUE(email)


# --> PostgreSQL Functions : 

# Many operations in PostgreSQL need to use the built-in 
# functions (like NOW() for dates).


# --> Indexes :

# As a table gets large (they always do), scanning all the data 
# to find a single row becomes very costly.

# When 'drchuck@gmail.com' logs into Twitter, they must find my 
# password amongst 500 million users.

# There are techniques to greatly shorten the scan as long as 
# you create data structures and maintain those structures - 
# like shortcuts

# Hashes or Trees are the most common indexes : 'unique' OR 'primary key'

# indexes is more data on disk


# --> B-tree:

# A B-tree is a tree data structure that keeps data sorted 
# and allows searches, sequential access, insertions, and 
# deletions in logarithmic amortized time.  
# The B-tree is optimized for systems that read and write 
# large blocks of data. 
# It is commonly used in databases and file systems.


# --> Hashes:

# A hash function is any algorithm or subroutine that maps 
# large data sets to smaller data sets, called keys. 
# For example, a single integer can serve as an index to an 
# array (cf. associative array). 
# The values returned by a hash function are called hash 
# values, hash codes, hash sums, checksums, or simply hashes.

# Hash functions are mostly used to accelerate table lookup 
# or data comparison tasks such as finding items in a database...


# --> Summary :

# SQL allows us to describe the shape of data to be stored 
# and give many hints to the database engine as to how we 
# will be accessing or using the data.

# SQL is a language that provides us operations to Create, 
# Read, Update, and Delete (CRUD) our data in a database.