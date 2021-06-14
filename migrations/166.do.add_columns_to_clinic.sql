ALTER TABLE clinics
ADD COLUMN description varchar NULL,
ADD clinic_domain varchar NULL,
ADD UNIQUE(clinic_domain);