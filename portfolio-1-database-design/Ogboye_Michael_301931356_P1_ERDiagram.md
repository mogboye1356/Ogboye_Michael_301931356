erDiagram
    direction LR

    department {
        BIGINT department_id PK
        VARCHAR(100) department_name UK
    }

    intern {
        BIGINT intern_id PK
        VARCHAR(100) first_name
        VARCHAR(100) last_name
        BIGINT department_id FK
    }

    course {
        BIGINT course_id PK
        VARCHAR(150) course_name UK
        INTEGER capacity
    }

    enrollment {
        BIGINT enrollment_id PK
        BIGINT intern_id FK
        BIGINT course_id FK
        VARCHAR(20) status
    }

    department ||--o{ intern : "has"
    intern ||--o{ enrollment : "has"
    course ||--o{ enrollment : "receives"