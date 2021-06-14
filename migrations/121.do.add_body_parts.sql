INSERT INTO body_parts(type, title) VALUES ('front', 'bowel');
INSERT INTO body_parts(type, title) VALUES ('back', 'back thights');
INSERT INTO body_parts(type, title) VALUES ('back', 'spine');
INSERT INTO body_parts(type, title) VALUES ('back', 'elbow');
INSERT INTO body_parts(type, title) VALUES ('back', 'hand');

UPDATE body_parts SET type = trim(type), title = trim(title);
