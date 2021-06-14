CREATE TABLE patient_feedback_records
(
    id         SERIAL PRIMARY KEY,
    score double precision default 0,
    feedback varchar,
    feedback_verified BOOLEAN DEFAULT false,
    user_id UUID references users (id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    doctor_id  UUID references users (id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    clinic_id UUID references clinics(id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    created_at timestamptz default now()
);
