CREATE TABLE notification_types
(
  id                	SERIAL PRIMARY KEY,
  "type"				varchar NOT NULL,
  icon_attachment_id	uuid NULL,
  action_text			varchar,
  CONSTRAINT notification_types_attachment_fkey FOREIGN KEY (icon_attachment_id)
  	REFERENCES attachments(id) 
  	MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE user_notifications
(
  id                	SERIAL PRIMARY KEY,
  user_id				uuid NOT NULL,
  type_id				int NOT NULL,
  title					varchar,
  description			varchar,
  created_at			timestamptz NOT NULL DEFAULT now(),
  complited_at			timestamptz NULL,
  CONSTRAINT user_notifications_users_fkey FOREIGN KEY (user_id)
  	REFERENCES users(id) 
  	MATCH FULL ON DELETE CASCADE,
  CONSTRAINT user_notifications_types_fkey FOREIGN KEY (type_id)
  	REFERENCES notification_types(id) 
  	MATCH FULL
);