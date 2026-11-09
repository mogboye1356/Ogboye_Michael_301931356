-- Q1: Interns with active enrollments (Enrolled or In Progress).
SELECT i.first_name, i.last_name, c.course_name, e.status
FROM public.enrollment e
JOIN public.intern i USING (intern_id)
JOIN public.course c USING (course_id)
WHERE e.status IN ('Enrolled', 'In Progress') 
ORDER BY c.course_name;

-- Q2: An intern has not completed any training if no 'Completed' record exists for them.
SELECT i.first_name, i.last_name
FROM public.intern i
WHERE NOT EXISTS (
    SELECT 1 FROM public.enrollment e
    WHERE e.intern_id = i.intern_id AND e.status = 'Completed'
)
ORDER BY i.last_name;

-- Q3: Count all enrollments for each course, including empty courses.
SELECT c.course_name, count(e.enrollment_id) AS total_enrollments
FROM public.course c
LEFT JOIN public.enrollment e USING (course_id)
GROUP BY c.course_id, c.course_name 
ORDER BY c.course_name;