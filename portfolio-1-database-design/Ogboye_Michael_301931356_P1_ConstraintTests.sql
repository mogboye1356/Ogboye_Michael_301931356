-- Expected error: violates not-null constraint on first_name
INSERT INTO public.intern (first_name, last_name, department_id)
VALUES (NULL, 'Test', (SELECT department_id FROM public.department WHERE department_name = 'Frontend'));

-- Expected error: duplicate key value violates unique constraint on department_name
INSERT INTO public.department (department_name)
VALUES ('Product Design');

-- Expected error: violates foreign key constraint on department_id
INSERT INTO public.intern (first_name, last_name, department_id)
VALUES ('Test', 'Intern', -1);

-- Expected error: new row violates check constraint "enrollment_status_check"
INSERT INTO public.enrollment (intern_id, course_id, status)
VALUES (
    (SELECT intern_id FROM public.intern WHERE first_name = 'Ada' AND last_name = 'James'),
    (SELECT course_id FROM public.course WHERE course_name = 'React Basics'),
    'Failed'
);

-- Expected error: duplicate key value violates unique constraint "enrollment_unique_intern_course"
INSERT INTO public.enrollment (intern_id, course_id, status)
VALUES (
    (SELECT intern_id FROM public.intern WHERE first_name = 'Ada' AND last_name = 'James'),
    (SELECT course_id FROM public.course WHERE course_name = 'React Basics'),
    'In Progress'
);

-- Final count query expected: department(2), intern(2), course(2), enrollment(3)
SELECT 'department' AS table_name, count(*) AS row_count FROM public.department
UNION ALL SELECT 'intern', count(*) FROM public.intern
UNION ALL SELECT 'course', count(*) FROM public.course
UNION ALL SELECT 'enrollment', count(*) FROM public.enrollment;