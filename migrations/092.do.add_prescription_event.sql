CREATE TABLE prescription_to_event
(
  prescription_id INT REFERENCES treatment_prescriptions (id) ON DELETE CASCADE ON UPDATE CASCADE,
  event_id        INT REFERENCES event (id) ON DELETE CASCADE ON UPDATE CASCADE
);
