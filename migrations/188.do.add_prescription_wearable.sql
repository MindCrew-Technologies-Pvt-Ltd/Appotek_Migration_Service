
CREATE TABLE prescription_wearable
(
    id                 SERIAL PRIMARY KEY,
    prescription_id    INT REFERENCES treatment_prescriptions (id) ON DELETE CASCADE ON UPDATE CASCADE,
    tracker_id         INT REFERENCES trackers (id) ON DELETE CASCADE ON UPDATE CASCADE,
    body_part_id       INT REFERENCES body_parts (id) ON DELETE CASCADE ON UPDATE CASCADE,
    metrics            varchar[],
    session_duration_m INT
);
