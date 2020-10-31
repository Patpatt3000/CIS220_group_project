
DROP DATABASE IF EXISTS G3_Build;
CREATE DATABASE         G3_Build;
USE                     G3_Build;

CREATE TABLE request_type (
    id              INT UNSIGNED    NOT NULL    AUTO_INCREMENT,
    topic_label     VARCHAR(45)     NOT NULL,
    application     VARCHAR(45)     NOT NULL,

    PRIMARY KEY     (id)    
);

CREATE TABLE user (
    id              INT UNSIGNED    NOT NULL    AUTO_INCREMENT,
    department_id   INT UNSIGNED    NOT NULL,
    first_name      VARCHAR(45)     NOT NULL,
    last_name       VARCHAR(45)     NOT NULL,
    email           VARCHAR(45)     NOT NULL,
    phone           CHAR(12),

    PRIMARY KEY     (id)
    /* department_id is a foreign key, but department doesn't exist yet */
);

CREATE TABLE department (
    id              INT UNSIGNED    NOT NULL    AUTO_INCREMENT,
    name            VARCHAR(45)     NOT NULL,
    manager_id      INT UNSIGNED,

    PRIMARY KEY     (id),
    FOREIGN KEY     (manager_id) REFERENCES user(id)
);

/* add the FK to the user table only after the department table is created */
ALTER TABLE user
ADD FOREIGN KEY (department_id) REFERENCES department(id);

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

CREATE TABLE stakeholder_request (
    request_id      INT UNSIGNED    NOT NULL,
    stakeholder_id  INT UNSIGNED    NOT NULL,

    PRIMARY KEY     (request_id, stakeholder_id),

    FOREIGN KEY     (request_id)    REFERENCES change_request(id),
    FOREIGN KEY     (stakeholder_id) REFERENCES user(id)
);

/* a few simple insertions below just as a quick experiment */
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

INSERT INTO user(department_id, first_name, last_name, email, phone)
VALUES (6,' Anne-corinne','Bilton',   'abilton0@squidoo.com',     '850-947-3461'),
       (1,' Casandra',    'Plowman',  'cplowman1@privacy.gov.au', '840-527-9292'),
       (7,' Orsa',        'Dinnis',   'odinnis2@biglobe.ne.jp',   '516-185-6879'),
       (7,' Jodi',        'Raoux',    'jraoux3@gov.uk',           '341-342-1095'),
       (4,' Ken',         'Claydon',  'kclaydon4@nba.com',        '354-336-8754'),
       (5,' Frederica',   'Coonan',   'fcoonan5@1688.com',        '725-863-6496'),
       (1,' Orelle',      'Heare',    'oheare6@jiathis.com',      '952-241-4487'),
       (2,' Henka',       'Brundill', 'hbrundill7@army.mil',      '475-792-9175'),
       (5,' Baird',       'Belitz',   'bbelitz8@opensource.org',  '700-849-0437');

UPDATE department
SET manager_id = 1
WHERE name = 'Human Resources';

UPDATE department
SET manager_id = 2
WHERE name = 'Marketing';

UPDATE department
SET manager_id = 3
WHERE name = 'Accounting';

SELECT * FROM department;

SELECT * FROM user;

SELECT * FROM request_type;

SELECT * FROM department_request_type;

SELECT * FROM change_request;

SELECT * FROM request_note;

SELECT * FROM stakeholder_request;