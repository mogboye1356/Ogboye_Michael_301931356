# Upperlink LaunchPad Normalisation

### Unnormalised Data

The starting point is a raw record where an intern has a repeated list of courses stored in a single cell.

| intern_name | department_name | courses_taken |
| --- | --- | --- |
| Alex Smith | Product Design | UI/UX (Cap: 20, Enrolled), React (Cap: 15, Enrolled) |
| Sam Doe | Frontend | React (Cap: 15, In Progress) |

This structure creates problems. Searching for everyone in the "React" course requires scanning inside the text of the `courses_taken` list, which is slow and prone to errors.

### First Normal Form (1NF)

To reach 1NF, every cell must hold only one value, eliminating repeating groups. The list is separated into individual rows.

**Assumption:** For these examples, assume `intern_name` is unique and no two courses share a name. The Primary Key (PK) for this table is the combination of `intern_name` and `course_name`.

**Table: Intern_Course (1NF)**

| intern_name (PK) | course_name (PK) | department_name | capacity | status |
| --- | --- | --- | --- | --- |
| Alex Smith | UI/UX | Product Design | 20 | Enrolled |
| Alex Smith | React | Product Design | 15 | Enrolled |
| Sam Doe | React | Frontend | 15 | In Progress |

**Why it moved:** The list is expanded into multiple rows.
**Problem removed:** You can now easily search, filter, and sort by individual courses or statuses.

### Second Normal Form (2NF)

To reach 2NF, the data must be in 1NF and have no partial dependencies. A partial dependency happens when a field only depends on one part of a combined primary key.

In the 1NF table, the key is `intern_name` + `course_name`.

* `department_name` only depends on the `intern_name`, not the course.
* `capacity` only depends on the `course_name`, not the intern.
* `status` correctly depends on both (the specific intern taking that specific course).

**Table: Intern (2NF)**

| intern_name (PK) | department_name |
| --- | --- |
| Alex Smith | Product Design |
| Sam Doe | Frontend |

**Table: Course (2NF)**

| course_name (PK) | capacity |
| --- | --- |
| UI/UX | 20 |
| React | 15 |

**Table: Enrollment (2NF)**

| intern_name (PK) | course_name (PK) | status |
| --- | --- | --- |
| Alex Smith | UI/UX | Enrolled |
| Alex Smith | React | Enrolled |
| Sam Doe | React | In Progress |

**Why it moved:** Fields are grouped with the specific subject they describe.
**Problem removed:** This removes update anomalies. If the capacity of the React course changes to 20, the database only updates one row in the Course table, rather than updating multiple enrollment rows for every intern taking React.

### Third Normal Form (3NF) and Final Design

To reach 3NF, the data must be in 2NF and have no transitive dependencies. A transitive dependency occurs when a non-key field depends on another non-key field.

In the 2NF Intern table, the `department_name` describes the department, not the intern directly. If "Product Design" is renamed to "Design Team", changing it on every intern's record causes update problems. Separating the department into its own table solves this.

At this stage, the design also introduces automatically generated IDs (`department_id`, `intern_id`, `course_id`, and `enrollment_id`). An ID alone does not prove 3NF, but it provides a stable, unique number that never changes, even if an intern or course changes their name. The combined key in the Enrollment table is replaced by `enrollment_id`, while foreign keys (FK) keep the tables linked. The single `intern_name` is also split into `first_name` and `last_name` to match the final agreed design.

**Table: department**

| department_id (PK) | department_name |
| --- | --- |
| 1 | Product Design |
| 2 | Frontend |

**Table: intern**

| intern_id (PK) | first_name | last_name | department_id (FK) |
| --- | --- | --- | --- |
| 101 | Alex | Smith | 1 |
| 102 | Sam | Doe | 2 |

**Table: course**

| course_id (PK) | course_name | capacity |
| --- | --- | --- |
| 201 | UI/UX | 20 |
| 202 | React | 15 |

**Table: enrollment**

| enrollment_id (PK) | intern_id (FK) | course_id (FK) | status |
| --- | --- | --- | --- |
| 301 | 101 | 201 | Enrolled |
| 302 | 101 | 202 | Enrolled |
| 303 | 102 | 202 | In Progress |

**Why it moved:** The department details move to a dedicated table. Generated IDs replace text-based primary keys.
**Problem removed:** Renaming a department now only requires changing one cell in the `department` table. The `department_id` in the `intern` table ensures the intern remains perfectly linked to the correct department name.