CREATE TABLE prescription_nutrition
(
  id              SERIAL PRIMARY KEY,
  prescription_id SERIAL REFERENCES treatment_prescriptions (id) ON DELETE CASCADE ON UPDATE CASCADE,
  type            VARCHAR,
  title           VARCHAR
);

CREATE TABLE nutrition_feedback
(
  prescription_nutrition_id INT REFERENCES prescription_nutrition (id) ON DELETE CASCADE ON UPDATE CASCADE,
  prescription_procedure_id INT REFERENCES prescription_procedures (id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (prescription_nutrition_id, prescription_procedure_id)
)
