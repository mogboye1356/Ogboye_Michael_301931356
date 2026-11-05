-- 1. Create Tables
CREATE TABLE department (
    department_id BIGINT PRIMARY KEY,
    department_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE intern (
    intern_id BIGINT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    department_id BIGINT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES department(department_id)
);

CREATE TABLE course (
    course_id BIGINT PRIMARY KEY,
    course_name VARCHAR(150) UNIQUE NOT NULL,
    capacity INTEGER NOT NULL
);

CREATE TABLE enrollment (
    enrollment_id BIGINT PRIMARY KEY,
    intern_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('Enrolled', 'In Progress', 'Completed')),
    FOREIGN KEY (intern_id) REFERENCES intern(intern_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    UNIQUE (intern_id, course_id)
);

-- 2. Insert Sample Data
INSERT INTO department VALUES (1, 'Product Design'), (2, 'Frontend');
INSERT INTO intern VALUES (101, 'Alex', 'Smith', 1), (102, 'Sam', 'Doe', 2);
INSERT INTO course VALUES (201, 'UI/UX', 20), (202, 'React', 15);
INSERT INTO enrollment VALUES (301, 101, 201, 'Enrolled'), (302, 101, 202, 'Enrolled'), (303, 102, 202, 'In Progress');
