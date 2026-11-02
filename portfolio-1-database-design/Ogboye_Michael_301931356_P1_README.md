# Portfolio 1 Database Design and Modelling

## Case study

Upperlink LaunchPad is an internal Learning Management System (LMS) designed to streamline intern onboarding, manage educational modules, and track training progress across various departments at Upperlink Limited.

## Users

* **Interns:** Browse available training courses, enroll in modules relevant to their roles, and track their completion status.
* **Administrators/Supervisors:** Create and manage course catalogs, set course capacity limits, and monitor the training progress of assigned interns.

## Main operations

* Registering new interns and assigning them to specific departments.
* Creating new courses and defining maximum enrollment capacities.
* Processing intern enrollments for specific courses.
* Updating enrollment statuses (e.g., transitioning from 'Enrolled' to 'Completed').
* Deducting available course capacity in real-time as interns enroll.

## Business rules

1. An intern can enroll in multiple courses but cannot have duplicate active enrollments for the exact same course.
2. A course cannot accept new intern enrollments once its defined capacity limit is reached.
3. Every enrollment record must be linked to a valid, existing InternID and CourseID.
4. An enrollment status must strictly be categorized as 'Enrolled', 'In Progress', or 'Completed'.

## Scope

* **Included:** Intern profile management, course catalog creation, enrollment processing, and basic capacity tracking.
* **Excluded:** Financial stipend processing, HR disciplinary records, and detailed external certification tracking.q