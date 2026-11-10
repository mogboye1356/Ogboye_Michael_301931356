# Portfolio 4 NoSQL and Advanced Data Models

## Document model
The `launchpad_events` database contains an `enrollment_history` collection.
Each document records one milestone event, such as a course enrollment or completion. Its fields are `_id`, `event_type`, `occurred_at`, `intern`, `course`, and `details`. The intern ID/name and course ID/name are embedded directly within the event. Enrollment details contain an initial status, while completion details contain a final grade.

Example completion document:
```javascript
{
  _id: "EV002", event_type: "completed",
  occurred_at: ISODate("2026-10-17T12:00:00Z"),
  intern: { intern_id: 1, full_name: "Ada James" },
  course: { course_id: 2, course_name: "UI/UX Principles" },
  details: { final_grade: "A" }
}
Implementation and results
Four fictional documents are inserted using mongosh. The document count is 4.
The UI/UX Principles history query successfully returns EV004 (enrolled), EV002 (completed), and EV003 (enrolled) in chronological order. Searching details.final_grade for 'A' returns exactly one document: EV002, detailing Ada James completing UI/UX Principles. The events are entered separately; the underlying PostgreSQL relational database remains unchanged.

Why MongoDB fits
A single document keeps the intern, course, and event-specific details together chronologically. Enrollment and completion details differ in structure (status vs. grade) without forcing every event document to have empty or null fields. A separate document per event allows the LMS history log to grow indefinitely without overloading one massive intern record. The embedded names and titles act as historical snapshots and do not automatically update if SQL records change.
PostgreSQL continues to handle strict enrollment rules and constraints. This example does not enforce SQL foreign keys in MongoDB or synchronise the two databases.

Files
MongoDB.js

Setup Notes

Screenshots

References
MongoDB Documentation: Insert Documents

MongoDB Documentation: Query Documents