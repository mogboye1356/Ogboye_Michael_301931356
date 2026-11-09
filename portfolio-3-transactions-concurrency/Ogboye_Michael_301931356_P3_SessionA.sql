-- Session A: Start an enrollment, but do not save it yet
SET application_name = 'p3_session_a';
BEGIN ISOLATION LEVEL READ COMMITTED;
SHOW transaction_isolation;

-- Add an enrollment for Ben in React Basics, but do not commit it yet.
INSERT INTO public.enrollment (intern_id, course_id, status)
SELECT i.intern_id, c.course_id, 'Enrolled'
FROM public.intern i CROSS JOIN public.course c
WHERE i.first_name = 'Ben' AND i.last_name = 'Cole' AND c.course_name = 'React Basics';

-- STOP HERE. Switch to Session B.

-- Check the wait status of Session B
SELECT application_name, wait_event_type FROM pg_stat_activity
WHERE application_name = 'p3_session_b';

-- Commit the transaction to save Ben's enrollment and release the lock
COMMIT;