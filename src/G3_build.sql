
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
    manager_id      INT UNSIGNED    NOT NULL,

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