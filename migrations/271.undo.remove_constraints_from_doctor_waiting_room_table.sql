ALTER TABLE doctor_waiting_room 
    ADD CONSTRAINT doctor_waiting_room_user_id_key UNIQUE (user_id),
    ADD CONSTRAINT doctor_waiting_room_pkey PRIMARY KEY (user_id, waiting_room_id);
