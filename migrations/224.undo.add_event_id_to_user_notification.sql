ALTER TABLE user_notifications 
	DROP event_id;
	
DELETE FROM user_notifications WHERE type_id >=9;
DELETE FROM notification_types WHERE id >= 9;
DELETE FROM notification_type_groups WHERE id = 5;