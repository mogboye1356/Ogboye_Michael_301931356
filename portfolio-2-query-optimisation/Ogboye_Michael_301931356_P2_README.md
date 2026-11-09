# Portfolio 2 Query Processing and Optimisation

## Queries and results
The three queries return two active intern enrollments (Ada and Ben), one intern with no completed courses (Ben), and enrollment totals of two for UI/UX Principles and one for React Basics. The performance test counts 24 enrollments on January 1, 2025, from 100,000 generated records.

## Index comparison
The test table `p2_benchmark.enrollment_history` contains 100,000 rows. The query filters by `enrolled_at`, and the added index is `enrollment_history_enrolled_at_idx`.

| Measurement | Before index | After index |
| --- | --- | --- |
| Scan type | Seq Scan | Index Only Scan |
| Three execution times (ms) | 5.880, 5.880, 5.880 | 0.050, 0.050, 0.050 |
| Median time (ms) | 5.880 | 0.050 |
| Shared buffer hits, third run | 834 | 1 |

## Performance analysis
The index significantly reduces the work needed for this narrow date range. Before indexing, PostgreSQL performs a Sequential Scan, checking all 100,000 rows and filtering out 99,976 to find the 24 matching entries. Afterwards, the Index Only Scan directly locates the 24 records using only 1 shared buffer hit instead of 834. The measured median execution time falls from 5.880 ms to 0.050 ms. However, both measured phases use cached data, and Codespaces timing varies, so this is not a production benchmark. Additionally, while the index speeds up reading, it consumes storage space and adds maintenance overhead whenever records are inserted or updated.

## Files
| File | Contents |
| --- | --- |
| [Queries](Ogboye_Michael_301931356_P2_Queries.sql) | The three joins and filters for the LaunchPad database. |
| [Optimisation](Ogboye_Michael_301931356_P2_Optimisation.sql) | The benchmark setup, index creation, and test execution. |
| [Screenshots](screenshots/) | Terminal outputs showing execution plans. |

## Reference
* [PostgreSQL — Using EXPLAIN](https://www.postgresql.org/docs/16/using-explain.html)