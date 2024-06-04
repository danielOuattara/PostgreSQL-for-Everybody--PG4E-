# -- Auto grader 1 : Entering Many-to-One Data - Automobiles

# .env for connection infos

psql -h pg.pg4e.com -p 5432 -U pg4e_50f0acf931 pg4e_50f0acf931


CREATE TABLE make (
    id SERIAL,
    name VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

CREATE TABLE model (
  id SERIAL,
  name VARCHAR(128),
  make_id INTEGER REFERENCES make(id) ON DELETE CASCADE,
  PRIMARY KEY(id)
);


# Insert the following data into your database separating it appropriately into the make and model tables and setting the make_id foreign key to link each model to its corresponding make.
# make	model
# BMW	650i Coupe
# BMW	650i Coupe xDrive
# BMW	650i Gran Coupe
# Eagle	Renault Medallion Sedan
# Eagle	Renault Medallion Wagon


# To grade this assignment, the program will run a query like this on your database and look for the data above:

SELECT make.name, model.name
    FROM model
    JOIN make ON model.make_id = make.id
    ORDER BY make.name LIMIT 5;


# solution

INSERT INTO 
    make(name) 
VALUES
    ('BMW'), 
    ('Eagle');


INSERT INTO 
    model(name, make_id)
VALUES
    ('650i Coupe', 1),
    ('650i Coupe xDrive', 1),
    ('650i Gran Coupe', 1),
    ('Renault Medallion Sedan', 2),
    ('Renault Medallion Wagon', 2);





# -- Auto grader 2 : Building a many-to-many roster
 
# Create the following tables.

CREATE TABLE student (
    id SERIAL,
    name VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

DROP TABLE course CASCADE;

CREATE TABLE course (
    id SERIAL,
    title VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

DROP TABLE roster CASCADE;

CREATE TABLE roster (
    id SERIAL,
    student_id INTEGER REFERENCES student(id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES course(id) ON DELETE CASCADE,
    role INTEGER,
    UNIQUE(student_id, course_id),
    PRIMARY KEY (id)
);

# Course Data

# You will normalize the following data (each user gets different data), 
# and insert the following data items into your database, creating and 
# linking all the foreign keys properly. Encode instructor with a role 
# of 1 and a learner with a role of 0.

# Jacques, si106, Instructor
# Aleishia, si106, Learner
# Joe, si106, Learner
# Miah, si106, Learner
# Tala, si106, Learner
# Riyadh, si110, Instructor
# Joris, si110, Learner
# Mali, si110, Learner
# Sonni, si110, Learner
# Zahra, si110, Learner
# Abbeygail, si206, Instructor
# Caelyn, si206, Learner
# Kaitlan, si206, Learner
# Morna, si206, Learner
# Riley, si206, Learner

# You can test to see if your data has been entered properly with the following SQL statement.

SELECT student.name, course.title, roster.role
    FROM student 
    JOIN roster ON student.id = roster.student_id
    JOIN course ON roster.course_id = course.id
    ORDER BY course.title, roster.role DESC, student.name;

# Solution

# Instructor role = 1, Learner role = 0

# 1, si106, Instructor
# 2, si106, Learner
# 3, si106, Learner
# 4, si106, Learner
# 5, si106, Learner
# 5, si110, Instructor
# 6, si110, Learner
# 7, si110, Learner
# 8, si110, Learner
# 9, si110, Learner
# 10, si206, Instructor
# 11, si206, Learner
# 12, si206, Learner
# 13, si206, Learner
# 14, si206, Learner

# ---

# 1, 1, Instructor
# 2, 1, Learner
# 3, 1, Learner
# 4, 1, Learner
# 5, 1, Learner
# 5, 2, Instructor
# 6, 2, Learner
# 7, 2, Learner
# 8, 2, Learner
# 9, 2, Learner
# 10, 3, Instructor
# 11, 3, Learner
# 12, 3, Learner
# 13, 3, Learner
# 14, 3, Learner

# ---

# 1, 1, 1
# 2, 1, 0
# 3, 1, 0
# 4, 1, 0
# 5, 1, 0
# 5, 2, 1
# 6, 2, 0
# 7, 2, 0
# 8, 2, 0
# 9, 2, 0
# 10, 3, 1
# 11, 3, 0
# 12, 3, 0
# 13, 3, 0
# 14, 3, 0

INSERT INTO 
    student(name)
VALUES 
    ('Jacques'),
    ('Aleishia'),
    ('Joe'),
    ('Miah'),
    ('Tala'),
    ('Riyadh'),
    ('Joris'),
    ('Mali'),
    ('Sonni'),
    ('Zahra'),
    ('Abbeygail'),
    ('Caelyn'),
    ('Kaitlan'),
    ('Morna'),
    ('Riley');

INSERT INTO 
    course(title)
VALUES 
    ('si106'),
    ('si110'),
    ('si206');

INSERT INTO
    roster(student_id, course_id,role)
VALUES
    (1, 1, 1),
    (2, 1, 0),
    (3, 1, 0),
    (4, 1, 0),
    (5, 1, 0),
    (5, 2, 1),
    (6, 2, 0),
    (7, 2, 0),
    (8, 2, 0),
    (9, 2, 0),
    (10, 3, 1),
    (11, 3, 0),
    (12, 3, 0),
    (13, 3, 0),
    (14, 3, 0);

