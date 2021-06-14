ALTER TABLE family_relations 
	ADD COLUMN gender enum_users_gender;
	
UPDATE family_relations SET gender = 'male' WHERE id = ANY(ARRAY[1, 3, 5, 7, 9, 11, 13, 16, 18, 20, 22, 24, 26, 28, 30, 33, 34]);
UPDATE family_relations SET gender = 'female' WHERE id = ANY(ARRAY[2, 4, 6, 8, 10, 12, 14, 17, 19, 21, 23, 25, 27, 29, 31, 32, 35]);
