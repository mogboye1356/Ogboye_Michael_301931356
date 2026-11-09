-- Session B: Try to enroll Ben in the same course
SET application_name = 'p3_session_b';
BEGIN ISOLATION LEVEL READ COMMITTED;
SHOW transaction_isolation;

-- Check if Ben is enrolled in React Basics yet (Expected: 0).
SELECT count(*) AS visible_enrollments 
FROM public.enrollment e
JOIN public.intern i USING (intern_id)
JOIN public.course c USING (course_id)
WHERE i.first_name = 'Ben' AND c.course_name = 'React Basics';

-- Attempt to insert the exact same enrollment. 
-- THIS WILL HANG AND WAIT FOR SESSION A.
INSERT INTO public.enrollment (intern_id, course_id, status)
SELECT i.intern_id, c.course_id, 'Enrolled'
FROM public.intern i CROSS JOIN public.course c
WHERE i.first_name = 'Ben' AND i.last_name = 'Cole' AND c.course_name = 'React Basics';

-- STOP HERE. Switch back to Session A to check the lock and commit.

-- After Session A commits, this session wakes up with a duplicate-key error.
ROLLBACK;

-- Verify Ben only has one enrollment for React Basics (Expected: 1)
SELECT i.first_name, c.course_name, count(*) AS total_enrollments
FROM public.enrollment e 
JOIN public.intern i USING (intern_id)
JOIN public.course c USING (course_id)
WHERE i.first_name = 'Ben' AND c.course_name = 'React Basics'
GROUP BY i.first_name, c.course_name;