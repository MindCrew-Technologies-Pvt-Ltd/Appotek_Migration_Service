ALTER TABLE permissions_sharing
  DROP CONSTRAINT permissions_sharing_pkey;
ALTER TABLE permissions_sharing
  ADD COLUMN id BIGSERIAL PRIMARY KEY;
CREATE UNIQUE INDEX dist_tag_to_share_id_uni_user_to_share_id ON permissions_sharing (user_id, tag_to_share_id) WHERE user_to_share_id IS NULL;
CREATE UNIQUE INDEX dist_user_to_share_id_uni_tag_to_share_id ON permissions_sharing (user_id, user_to_share_id) WHERE tag_to_share_id IS NULL;
ALTER TABLE permissions_sharing
  ALTER COLUMN tag_to_share_id DROP NOT NULL;
ALTER TABLE permissions_sharing
  ALTER COLUMN user_to_share_id DROP NOT NULL;
