ALTER TABLE user_notifications 
	ADD event_id int NULL,
	ADD CONSTRAINT user_notifications_event_id_fkey FOREIGN KEY (event_id) REFERENCES event(id) ON UPDATE CASCADE ON DELETE CASCADE;

INSERT INTO notification_type_groups (id, title) VALUES (5, 'Information');

INSERT INTO notification_types (id, type, type_group_id) VALUES (9, 'New audio call request', 4);
INSERT INTO notification_types (id, type, type_group_id) VALUES (10, 'New consultation request', 4);
INSERT INTO notification_types (id, type, type_group_id) VALUES (11, 'New home visit request', 4);
INSERT INTO notification_types (id, type, type_group_id) VALUES (12, 'Appointment date change request', 4);
INSERT INTO notification_types (id, type, type_group_id) VALUES (13, 'Home address changed', 5);
INSERT INTO notification_types (id, type, type_group_id) VALUES (14, 'Appointment has been accepted', 5);
INSERT INTO notification_types (id, type, type_group_id) VALUES (15, 'Appointment has been declined', 5);
