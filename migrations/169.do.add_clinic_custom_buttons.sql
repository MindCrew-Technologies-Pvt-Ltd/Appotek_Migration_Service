CREATE TABLE clinic_button_list
(
  id SERIAL PRIMARY KEY,
  title VARCHAR NOT NULL
);

INSERT INTO clinic_button_list (title) VALUES ('Book a consultation'), ('Chat with us'), ('Add website'), ('Buy treatment');

CREATE TABLE clinic_to_button
(
  id SERIAL PRIMARY KEY,
  clinic_id uuid NOT NULL,
  button_id int NOT NULL,
  "action" json NOT NULL DEFAULT '{}'::json,
  CONSTRAINT fk_clinic_button_to_clinics FOREIGN KEY ("clinic_id") REFERENCES clinics(id) MATCH FULL ON DELETE CASCADE,
  CONSTRAINT fk_clinic_button_to_buttons FOREIGN KEY ("button_id") REFERENCES clinic_button_list(id) MATCH FULL,
  CONSTRAINT uniq_clinic_button UNIQUE (clinic_id, button_id)
);