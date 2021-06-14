DROP TABLE user_notification_settings;

ALTER TABLE notification_types
	DROP CONSTRAINT notification_type_type_grops_fkey,
	DROP COLUMN type_group_id;
DROP TABLE notification_type_groups;