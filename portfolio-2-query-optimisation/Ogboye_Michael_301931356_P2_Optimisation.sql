-- Create a separate schema for the benchmark test so Portfolio 1 data is untouched.
CREATE SCHEMA p2_benchmark;

-- Generate 100,000 plausible enrollment records for Ada James and React Basics.
CREATE TABLE p2_benchmark.enrollment_history AS
SELECT g AS history_id, i.intern_id, c.course_id,
       TIMESTAMPTZ '2020-01-01 00:00:00+00' + g * INTERVAL '1 hour' AS enrolled_at,
       TIMESTAMPTZ '2020-01-01 00:00:00+00' + g * INTERVAL '1 hour' + INTERVAL '30 days' AS completed_at
FROM generate_series(1, 100000) AS g
CROSS JOIN public.intern i CROSS JOIN public.course c
WHERE i.first_name = 'Ada' AND i.last_name = 'James' AND c.course_name = 'React Basics';

-- Refresh database statistics and check the total row count (Expected: 100000).
ANALYZE p2_benchmark.enrollment_history;
SELECT count(*) AS test_rows FROM p2_benchmark.enrollment_history;

-- Count enrollments on a single day (Expected: 24).
SELECT count(*) AS enrollments_on_day 
FROM p2_benchmark.enrollment_history
WHERE enrolled_at >= TIMESTAMPTZ '2025-01-01 00:00:00+00'
  AND enrolled_at < TIMESTAMPTZ '2025-01-02 00:00:00+00';

-- Explain the execution plan and measure performance without an index.
EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*) AS enrollments_on_day 
FROM p2_benchmark.enrollment_history
WHERE enrolled_at >= TIMESTAMPTZ '2025-01-01 00:00:00+00'
  AND enrolled_at < TIMESTAMPTZ '2025-01-02 00:00:00+00';

-- Add a B-tree index to speed up date-based filtering.
CREATE INDEX enrollment_history_enrolled_at_idx
    ON p2_benchmark.enrollment_history (enrolled_at);

-- Explain the execution plan and measure performance with the new index.
EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*) AS enrollments_on_day 
FROM p2_benchmark.enrollment_history
WHERE enrolled_at >= TIMESTAMPTZ '2025-01-01 00:00:00+00'
  AND enrolled_at < TIMESTAMPTZ '2025-01-02 00:00:00+00';