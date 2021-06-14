ALTER TABLE clinic_button_list ADD COLUMN has_domain bool NOT NULL DEFAULT FALSE;
UPDATE clinic_button_list SET has_domain = TRUE WHERE title = 'Add website';