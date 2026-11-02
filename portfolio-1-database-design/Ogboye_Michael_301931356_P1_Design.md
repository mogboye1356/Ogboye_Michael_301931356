Upperlink LaunchPad Database Design

1. Entities
The database keeps records of four main entities:

* Department: The specific company divisions where interns are assigned.
* Intern: The trainees using the system.
* Course: The training modules available in the system catalog.
* Enrollment: The individual records tracking an intern's participation and progress in a specific course.

2. Attributes and keys

* Department
* department_id (Primary Key, integer, required)
* department_name (varchar, required, unique)


* Intern
* intern_id (Primary Key, integer, required)
* first_name (varchar, required)
* last_name (varchar, required)
* department_id (Foreign Key, integer, required)


* Course
* course_id (Primary Key, integer, required)
* course_name (varchar, required, unique)
* capacity (integer, required)


* Enrollment
* enrollment_id (Primary Key, integer, required)
* intern_id (Foreign Key, integer, required)
* course_id (Foreign Key, integer, required)
* status (varchar, required)



3. Relationships

* Department and Intern: A one-to-many relationship. A department can have zero or many interns assigned to it. Each intern belongs to exactly one department.
* Intern and Enrollment: A one-to-many relationship. An intern can have zero or many course enrollments. Each enrollment belongs to exactly one intern.
* Course and Enrollment: A one-to-many relationship. A course can have zero or many enrollments. Each enrollment belongs to exactly one course.

The Enrollment entity acts as a linking table (also known as an associative entity). It connects the Intern and Course tables, resolving what is naturally a many-to-many relationship (since one intern takes many courses, and one course holds many interns) into two one-to-many relationships.

4. Business rules and constraints

* Rule 1: An intern can enroll in multiple courses but cannot have duplicate active enrollments for the exact same course.
* Check/Operation: A UNIQUE constraint applied to the combination of the intern_id and course_id columns in the Enrollment table ensures the database rejects duplicate pairings.


* Rule 2: A course cannot accept new intern enrollments once its defined capacity limit is reached.
* Check/Operation: A basic table key cannot enforce this rule. It requires a database trigger (a script that runs automatically before a change) or an application-level check. Before a new enrollment is saved, the system must count the existing enrollments for that course_id and compare it to the capacity field in the Course table. For example, if a React Basics course has a capacity of 15, the system blocks the 16th registration.


* Rule 3: Every enrollment record must be linked to a valid, existing InternID and CourseID.
* Check/Operation: Foreign Key constraints on the intern_id and course_id columns in the Enrollment table enforce this. This creates referential integrity, meaning the database prevents the creation of an enrollment if the intern or course does not actually exist.


* Rule 4: An enrollment status must strictly be categorized as 'Enrolled', 'In Progress', or 'Completed'.
* Check/Operation: A CHECK constraint on the status column in the Enrollment table ensures that only these three specific text values are accepted.



5. Design assumptions

* I chose not to add a "current_enrolled_count" column to the Course table. This number can be calculated at any time by counting the rows in the Enrollment table. Storing calculated values often leads to data inconsistencies if the total fails to update when an enrollment changes.
* I assume interns remain in a single department for the duration of their temporary placement, so historical tracking of department transfers is unnecessary for this scope.