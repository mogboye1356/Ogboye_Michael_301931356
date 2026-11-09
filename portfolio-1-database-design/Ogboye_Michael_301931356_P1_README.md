# Portfolio 1: Database Design - Upperlink LaunchPad

## Case study
Upperlink LaunchPad is an intern Learning Management System (LMS) designed for Upperlink Limited. It handles structured track management and automated certification workflows. This database focuses on managing interns, their respective departments, training courses, and their enrollment statuses.

## Users
* **Interns:** Participate in training courses and track their progress.
* **Administrators / Managers:** Manage departments, add new courses, and oversee intern enrollments.

## Operations
* Register new departments and training courses.
* Onboard new interns and assign them to specific departments.
* Enroll interns into courses.
* Track and update enrollment statuses.

## Business rules
* Every intern must be assigned to a valid, existing department.
* Every intern must provide a first name.
* Department names and course names must be unique.
* An enrollment status must only be 'Enrolled', 'In Progress', or 'Completed'.
* An intern cannot have duplicate enrollments for the exact same course.

## Scope
This portfolio covers the core relational schema, testing data integrity constraints, and verifying business rules for the foundational intern and course tracking.

## Design and implementation files

| File | Contents |
| --- | --- |
| [Design](Ogboye_Michael_301931356_P1_Design.md) | Entities, attributes, keys and relationships. |
| [ER diagram](Ogboye_Michael_301931356_P1_ERDiagram.md) | The four tables and their relationships. |
| [Normalisation](Ogboye_Michael_301931356_P1_Normalisation.md) | Example tables showing 1NF, 2NF and 3NF. |
| [Schema](Ogboye_Michael_301931356_P1_Schema.sql) | Table definitions, keys and constraints. |
| [Sample records](Ogboye_Michael_301931356_P1_SampleData.sql) | Fictional departments, interns, courses and enrollments. |
| [Constraint tests](Ogboye_Michael_301931356_P1_ConstraintTests.sql) | Invalid inserts and the final count query. |
| [Screenshots](screenshots/) | Saved commands and results. |

## Implementation

The database runs on PostgreSQL in GitHub Codespaces. Its name is `launchpad_portfolio`. It contains `department`, `intern`, `course`, and `enrollment`. Each table has a primary key automatically generated using the identity property. Foreign keys connect interns to departments, and enrollments to both interns and courses.

Department names and course names are unique. A check constraint restricts enrollment status to 'Enrolled', 'In Progress', or 'Completed'. A unique index prevents duplicate active enrollments for the same intern and course. The schema and sample records were committed before the invalid inserts were tested separately in the terminal.

## Test results

Five invalid inserts were rejected: a missing intern first name (not-null), a repeated department name (unique), a non-existent department link (foreign key), an invalid status of 'Failed' (check constraint), and a duplicate enrollment attempt for the same course (unique index).

The final counts are 2 departments, 2 interns, 2 courses, and 3 enrollments. The failed inserts added no rows, confirming the constraints actively protect the data.

Reference: [PostgreSQL constraints](https://www.postgresql.org/docs/16/ddl-constraints.html).