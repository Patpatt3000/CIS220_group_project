
DROP DATABASE IF EXISTS G3_Build;
CREATE DATABASE         G3_Build;
USE                     G3_Build;

CREATE TABLE user (
    id              INT UNSIGNED    NOT NULL    AUTO_INCREMENT,
    first_name      VARCHAR(45)     NOT NULL,
    last_name       VARCHAR(45)     NOT NULL,
    email           VARCHAR(45)     NOT NULL,
    phone           CHAR(12),

    PRIMARY KEY     (id)
);

CREATE TABLE department (
    id              INT UNSIGNED    NOT NULL    AUTO_INCREMENT,
    name            VARCHAR(45)     NOT NULL,
    manager_id      INT UNSIGNED,

    PRIMARY KEY     (id),
    FOREIGN KEY     (manager_id) REFERENCES user(id)
);

CREATE TABLE department_user (
    department_id   INT UNSIGNED    NOT NULL,
    user_id         INT UNSIGNED    NOT NULL,

    PRIMARY KEY     (department_id, user_id),
    FOREIGN KEY     (department_id) REFERENCES department(id),
    FOREIGN KEY     (user_id)       REFERENCES user(id)
);

CREATE TABLE request_type (
    id              INT UNSIGNED    NOT NULL    AUTO_INCREMENT,
    topic_label     VARCHAR(45)     NOT NULL,
    application     VARCHAR(45)     NOT NULL,

    PRIMARY KEY     (id)    
);

CREATE TABLE department_request_type (
    department_id   INT UNSIGNED    NOT NULL,
    request_type_id INT UNSIGNED    NOT NULL,

    PRIMARY KEY     (department_id, request_type_id),
    FOREIGN KEY     (department_id) REFERENCES department(id),
    FOREIGN KEY     (request_type_id) REFERENCES request_type(id)
);

CREATE TABLE change_request (
    id              INT UNSIGNED    NOT NULL    AUTO_INCREMENT,
    user_id         INT UNSIGNED    NOT NULL,
    request_type_id INT UNSIGNED    NOT NULL,
    description     VARCHAR(255)    NOT NULL,
    data_stamp      DATETIME        NOT NULL,
    is_approved     BOOLEAN         NOT NULL,
    due_date        DATETIME,

    PRIMARY KEY     (id),

    FOREIGN KEY     (user_id)       REFERENCES user(id),
    FOREIGN KEY     (request_type_id) REFERENCES request_type(id)
);

CREATE TABLE request_note (
    id              INT UNSIGNED    NOT NULL    AUTO_INCREMENT,
    request_id      INT UNSIGNED    NOT NULL,
    description     VARCHAR(255),
    date_stamp      DATETIME        NOT NULL,
    is_open         BOOLEAN         NOT NULL,
    is_complete     BOOLEAN         NOT NULL,
    closed_notes    VARCHAR(255),
    complete_notes  VARCHAR(255),

    PRIMARY KEY     (id),

    FOREIGN KEY     (request_id) REFERENCES change_request(id)
);

CREATE TABLE request_stakeholder (
    request_id      INT UNSIGNED    NOT NULL,
    stakeholder_id  INT UNSIGNED    NOT NULL,

    PRIMARY KEY     (request_id, stakeholder_id),

    FOREIGN KEY     (request_id)    REFERENCES change_request(id),
    FOREIGN KEY     (stakeholder_id) REFERENCES user(id)
);

/* describe all the tables during testing */
DESCRIBE user \p;
DESCRIBE department \p;
DESCRIBE department_user \p;
DESCRIBE request_type \p;
DESCRIBE department_request_type \p;
DESCRIBE change_request \p;
DESCRIBE request_note \p;
DESCRIBE request_stakeholder \p;

/* a few simple insertions below just as a quick experiment */

-- add some departments
INSERT INTO department(name)
VALUES ('Human Resources'),
       ('Marketing'),
       ('Accounting'),
       ('Research and Development'),
       ('Business Development'),
       ('IT'),
       ('Trout grilling'),
       ('Department X'),
       ('Control'),
       ('Blacksmithing');

-- add some users
INSERT INTO user(first_name, last_name, email, phone)
VALUES ('Anne-corinne','Bilton',   'abilton0@squidoo.com',     '850-947-3461'),
       ('Casandra',    'Plowman',  'cplowman1@privacy.gov.au', '840-527-9292'),
       ('Orsa',        'Dinnis',   'odinnis2@biglobe.ne.jp',   '516-185-6879'),
       ('Jodi',        'Raoux',    'jraoux3@gov.uk',           '341-342-1095'),
       ('Ken',         'Claydon',  'kclaydon4@nba.com',        '354-336-8754'),
       ('Frederica',   'Coonan',   'fcoonan5@1688.com',        '725-863-6496'),
       ('Orelle',      'Heare',    'oheare6@jiathis.com',      '952-241-4487'),
       ('Henka',       'Brundill', 'hbrundill7@army.mil',      '475-792-9175'),
       ('Baird',       'Belitz',   'bbelitz8@opensource.org',  '700-849-0437');

-- assign some users to departments
INSERT INTO department_user(department_id, user_id)
VALUES ((SELECT id
         FROM department
         WHERE name = 'Human Resources'),
        (SELECT id
         FROM user
         WHERE last_name = 'Bilton'));

INSERT INTO department_user(department_id, user_id)
VALUES ((SELECT id
         FROM department
         WHERE name = 'Marketing'),
        (SELECT id
         FROM user
         WHERE last_name = 'Raoux'));

INSERT INTO department_user(department_id, user_id)
VALUES ((SELECT id
         FROM department
         WHERE name = 'Research and Development'),
        (SELECT id
         FROM user
         WHERE last_name = 'Plowman'));

INSERT INTO department_user(department_id, user_id)
VALUES ((SELECT id
         FROM department
         WHERE name = 'Business Development'),
        (SELECT id
         FROM user
         WHERE last_name = 'Plowman'));

INSERT INTO department_user(department_id, user_id)
VALUES ((SELECT id
         FROM department
         WHERE name = 'IT'),
        (SELECT id
         FROM user
         WHERE last_name = 'Belitz'));

INSERT INTO department_user(department_id, user_id)
VALUES ((SELECT id
         FROM department
         WHERE name = 'IT'),
        (SELECT id
         FROM user
         WHERE last_name = 'Claydon'));

-- assign some managers using a select statement
UPDATE department
SET manager_id = (SELECT id
                  FROM user
                  WHERE last_name = 'Bilton')
WHERE name = 'Human Resources';

UPDATE department
SET manager_id = (SELECT id
                  FROM user
                  WHERE last_name = 'Plowman')
WHERE name = 'Research and Development';

UPDATE department
SET manager_id = (SELECT id
                  FROM user
                  WHERE last_name = 'Coonan')
WHERE name = 'Control';

UPDATE department
SET manager_id = (SELECT id
                  FROM user
                  WHERE last_name = 'Belitz')
WHERE name = 'IT';

/* show all the data in all the tables during testing */
SELECT * FROM user \p;
SELECT * FROM department \p;
SELECT * FROM department_user \p;
SELECT * FROM request_type \p;
SELECT * FROM department_request_type \p;
SELECT * FROM change_request \p;
SELECT * FROM request_note \p;
SELECT * FROM request_stakeholder \p;

/* show all of the users that are assigned to departments */
SELECT
    department.name,
    user.first_name,
    user.last_name
FROM 
    department
JOIN 
    department_user ON department.id = department_user.department_id
JOIN 
    user ON department_user.user_id = user.id \p;
