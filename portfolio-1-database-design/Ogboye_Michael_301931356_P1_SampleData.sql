BEGIN;

-- Add departments
INSERT INTO public.department (department_name) 
VALUES ('Product Design'), ('Frontend');

-- Add interns
INSERT INTO public.intern (first_name, last_name, department_id)
VALUES ('Ada', 'James', (SELECT department_id FROM public.department WHERE department_name = 'Product Design')),
       ('Ben', 'Cole', (SELECT department_id FROM public.department WHERE department_name = 'Frontend'));

-- Add courses
INSERT INTO public.course (course_name, capacity) 
VALUES ('React Basics', 15), ('UI/UX Principles', 20);

-- Add enrollments
INSERT INTO public.enrollment (intern_id, course_id, status)
VALUES (
    (SELECT intern_id FROM public.intern WHERE first_name = 'Ada' AND last_name = 'James'),
    (SELECT course_id FROM public.course WHERE course_name = 'React Basics'),
    'Enrolled'
),
(
    (SELECT intern_id FROM public.intern WHERE first_name = 'Ben' AND last_name = 'Cole'),
    (SELECT course_id FROM public.course WHERE course_name = 'UI/UX Principles'),
    'In Progress'
),
(
    (SELECT intern_id FROM public.intern WHERE first_name = 'Ada' AND last_name = 'James'),
    (SELECT course_id FROM public.course WHERE course_name = 'UI/UX Principles'),
    'Completed'
);

COMMIT;