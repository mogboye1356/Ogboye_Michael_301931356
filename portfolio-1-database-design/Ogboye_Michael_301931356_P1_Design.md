Upperlink LaunchPad Database Design

### Entities

I chose four entities for my internal learning management system:

| Entity | Information stored |
| --- | --- |
| department | A company division |
| intern | A trainee registered in the system |
| course | A training module in the catalog |
| enrollment | One record of an intern taking a specific course |

I kept intern and enrollment separate. For example, the system might offer a React Basics course. I record the intern details once, and use the enrollment record to track when that intern takes a specific course.

### Attributes and keys

I use an automatically generated ID for each record. In the tables below, unique means no repeated values. Required means the value cannot be `NULL` (missing); checking for blank text is a separate rule.

| Entity | Attributes and proposed PostgreSQL types | Keys and required values |
| --- | --- | --- |
| department | department_id BIGINT; department_name VARCHAR(100) | PK: department_id. Unique: department_name. All required. |
| intern | intern_id BIGINT; first_name VARCHAR(100); last_name VARCHAR(100); department_id BIGINT | PK: intern_id. FK: department_id ➔ department.department_id. All required. |
| course | course_id BIGINT; course_name VARCHAR(150); capacity INTEGER | PK: course_id. Unique: course_name. All required. |
| enrollment | enrollment_id BIGINT; intern_id BIGINT; course_id BIGINT; status VARCHAR(20) | PK: enrollment_id. FKs: intern_id ➔ intern.intern_id; course_id ➔ course.course_id. All required. |

`BIGINT` holds whole numbers, such as IDs. `VARCHAR(150)` holds text up to 150 characters. `INTEGER` holds whole numbers for course capacities.

Design assumption: Interns remain in a single department for the duration of their placement, so I store department_id directly in the intern table rather than creating a separate placement history table.

### Relationships

| Tables linked | Relationship | Meaning |
| --- | --- | --- |
| department ➔ intern | One to many | A department can have zero or more interns; each intern belongs to exactly one department. |
| intern ➔ enrollment | One to many | An intern can have zero or more enrollments; each enrollment belongs to exactly one intern. |
| course ➔ enrollment | One to many | A course can have zero or more enrollments; each enrollment refers to exactly one course. |

For example, intern 5 can take a UI/UX course in January and a React course in February. I keep both enrollment records. The enrollment table resolves the many-to-many relationship between interns and courses; a foreign key links the records.

### Business rules and constraints

* **Rule 1:** An intern cannot have duplicate enrollments for the exact same course. The design uses a unique index on the combination of `intern_id` and `course_id`.
* **Rule 2:** A course cannot accept new enrollments once its defined capacity limit is reached. This rule needs transaction logic or a trigger to count existing enrollments before inserting, not just a static key.
* **Rule 3:** Required foreign keys link each enrollment to an existing intern and course.
* **Rule 4:** A check constraint on the `status` column ensures it only accepts 'Enrolled', 'In Progress', or 'Completed'.

Course vacancy is calculated when needed. An enrollment count is compared against the capacity field, so the design has no separate "total_enrolled" field to prevent data inconsistency.