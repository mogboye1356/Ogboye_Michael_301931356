-- Check starting data
SELECT i.first_name, c.course_name, e.status 
FROM public.enrollment e 
JOIN public.intern i USING (intern_id) 
JOIN public.course c USING (course_id) 
ORDER BY i.first_name, c.course_name;

-- Save a status update with COMMIT
BEGIN;
-- Update Ada's React Basics enrollment to 'In Progress' only if currently 'Enrolled'.
UPDATE public.enrollment
SET status = 'In Progress'
WHERE intern_id = (SELECT intern_id FROM public.intern WHERE first_name = 'Ada' AND last_name = 'James')
  AND course_id = (SELECT course_id FROM public.course WHERE course_name = 'React Basics')
  AND status = 'Enrolled';
COMMIT;

-- Verify repeat check prevents overwriting
UPDATE public.enrollment
SET status = 'In Progress'
WHERE intern_id = (SELECT intern_id FROM public.intern WHERE first_name = 'Ada' AND last_name = 'James')
  AND course_id = (SELECT course_id FROM public.course WHERE course_name = 'React Basics')
  AND status = 'Enrolled';

-- Undo changes after an error
BEGIN;
-- Valid insertion of a new department track
INSERT INTO public.department (department_name) VALUES ('QA Testing');

-- Invalid insertion: 'Dropped' is not an allowed status
INSERT INTO public.enrollment (intern_id, course_id, status)
VALUES (
    (SELECT intern_id FROM public.intern WHERE first_name = 'Ben'),
    (SELECT course_id FROM public.course WHERE course_name = 'React Basics'),
    'Dropped'
);

-- Rollback the transaction due to the error above
ROLLBACK;

-- Check final results
-- Confirm Ada's update was kept
SELECT status AS ada_react_status FROM public.enrollment 
WHERE intern_id = (SELECT intern_id FROM public.intern WHERE first_name = 'Ada')
  AND course_id = (SELECT course_id FROM public.course WHERE course_name = 'React Basics');

-- Confirm the QA Testing department insertion was cancelled
SELECT count(*) AS qa_dept_count FROM public.department WHERE department_name = 'QA Testing';