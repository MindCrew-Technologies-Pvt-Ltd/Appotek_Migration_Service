CREATE TABLE notification_type_groups (
	id int PRIMARY KEY,
	title varchar
);

INSERT INTO notification_type_groups (id, title)  VALUES
	(1, 'Chat'),
	(2, 'Group'),
	(3, 'Calls');

DELETE FROM user_notifications;
DELETE FROM notification_types;

ALTER TABLE notification_types 
	ADD COLUMN type_group_id int NOT NULL,
	ADD CONSTRAINT notification_type_type_grops_fkey FOREIGN KEY (type_group_id) REFERENCES notification_type_groups(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

INSERT INTO notification_types ("type", type_group_id) VALUES
	('Message notification', 1),
	('Message preview', 1),
	('Group notification', 2),
	('Message preview', 2),
	('Calls notification', 3);

CREATE TABLE user_notification_settings (
	id serial PRIMARY KEY,
	user_id uuid NOT NULL,
	notification_type_id int NOT NULL,
	enabled bool NOT NULL DEFAULT 'false',
	CONSTRAINT notif_settings_to_users_fkey FOREIGN KEY (user_id) REFERENCES users(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT notif_settings_to_notif_types_fkey FOREIGN KEY (notification_type_id) REFERENCES notification_types(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT ids_uniq UNIQUE (user_id, notification_type_id)
);
    