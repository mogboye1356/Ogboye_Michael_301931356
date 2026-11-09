# Portfolio 3 Transactions and Concurrency

## Commit and rollback
The enrollment status for Ada James in React Basics is successfully updated to 'In Progress' and committed. A repeated update attempt affects zero rows because the condition strictly requires an 'Enrolled' status. In a subsequent transaction, a valid insertion of a 'QA Testing' department is executed before an invalid 'Dropped' status assignment causes a check constraint violation. A `ROLLBACK` removes the uncommitted department insertion, leaving only the earlier committed status update intact.

## Isolation and concurrency control
Two PostgreSQL sessions connect using the `READ COMMITTED` isolation level. Session A inserts a React Basics enrollment for Ben Cole without committing. Session B runs a count query and sees zero visible enrollments, then attempts to insert the exact same record. Session B enters a waiting state, with its `wait_event_type` showing as `Lock`. Once Session A issues a `COMMIT`, Session B immediately receives a duplicate-key error due to the unique constraint on intern and course combinations. Session B rolls back, and the final verification query confirms exactly one active enrollment for Ben.

## Conclusion
The `COMMIT` command securely saves changes to the database, while `ROLLBACK` cleanly abandons a transaction's unsaved modifications following an error. The `READ COMMITTED` isolation level successfully prevents a session from viewing another session's uncommitted data. Ultimately, the database's unique constraints act as the definitive safeguard against duplicate records, actively blocking conflicting operations even if an earlier concurrent check showed no existing data.

## Files
* [Transactions.sql](Ogboye_Michael_301931356_P3_Transactions.sql)
* [Session A](Ogboye_Michael_301931356_P3_SessionA.sql)
* [Session B](Ogboye_Michael_301931356_P3_SessionB.sql)
* [Screenshots](screenshots/)

## References
* [PostgreSQL Documentation: Transactions](https://www.postgresql.org/docs/current/tutorial-transactions.html)
* [PostgreSQL Documentation: Transaction Isolation](https://www.postgresql.org/docs/current/transaction-iso.html)