INSERT INTO user_settings (user_id)
SELECT id as user_id FROM users
ON CONFLICT DO NOTHING
