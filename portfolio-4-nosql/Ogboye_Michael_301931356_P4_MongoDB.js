// Select the MongoDB database for LaunchPad events
db = db.getSiblingDB("launchpad_events")

// Verify the collection is empty before inserting
db.enrollment_history.countDocuments()

// Insert four fictional event records (enrolled vs completed)
db.enrollment_history.insertMany([
  {
    _id: "EV001", event_type: "enrolled",
    occurred_at: ISODate("2026-10-01T09:00:00Z"),
    intern: { intern_id: 1, full_name: "Ada James" },
    course: { course_id: 1, course_name: "React Basics" },
    details: { initial_status: "Enrolled" }
  },
  {
    _id: "EV002", event_type: "completed",
    occurred_at: ISODate("2026-10-17T12:00:00Z"),
    intern: { intern_id: 1, full_name: "Ada James" },
    course: { course_id: 2, course_name: "UI/UX Principles" },
    details: { final_grade: "A" }
  },
  {
    _id: "EV003", event_type: "enrolled",
    occurred_at: ISODate("2026-10-17T14:00:00Z"),
    intern: { intern_id: 2, full_name: "Ben Cole" },
    course: { course_id: 2, course_name: "UI/UX Principles" },
    details: { initial_status: "In Progress" }
  },
  {
    _id: "EV004", event_type: "enrolled",
    occurred_at: ISODate("2026-10-15T09:00:00Z"),
    intern: { intern_id: 1, full_name: "Ada James" },
    course: { course_id: 2, course_name: "UI/UX Principles" },
    details: { initial_status: "Enrolled" }
  }
])

// Query 1: Count the total documents
db.enrollment_history.countDocuments()

// Query 2: Read the event history for UI/UX Principles, sorted by date
db.enrollment_history.find(
  { "course.course_name": "UI/UX Principles" },
  { _id: 1, event_type: 1, occurred_at: 1, details: 1 }
).sort({ occurred_at: 1, _id: 1 }).toArray()

// Query 3: Find completed courses marked with an 'A' grade
db.enrollment_history.find({ "details.final_grade": "A" }).toArray()