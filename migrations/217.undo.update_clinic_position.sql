ALTER TABLE clinic_position_schedule
    drop constraint clinic_position_schedule_user_id_fkey;
ALTER TABLE clinic_positions
    DROP CONSTRAINT clinic_positions_pkey;
ALTER TABLE clinic_positions
    ADD CONSTRAINT clinic_positions_pkey PRIMARY KEY (user_id, clinic_id, medical_specialization_id);
ALTER TABLE clinic_positions
    ALTER COLUMN medical_specialization_id DROP NOT NULL;
ALTER TABLE clinic_position_schedule
    ALTER COLUMN medical_specialization_id DROP NOT NULL;
ALTER TABLE clinic_position_schedule
    add CONSTRAINT medical_specializations_schedule_user_id_fkey foreign key (user_id, clinic_id, medical_specialization_id) references clinic_positions (user_id, clinic_id, medical_specialization_id) ON DELETE CASCADE ON UPDATE CASCADE;
