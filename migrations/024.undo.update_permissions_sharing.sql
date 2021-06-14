ALTER TABLE permissions_sharing
  ADD CONSTRAINT permissions_sharing_pkey;
ALTER TABLE permissions_sharing
  DROP id;
DROP INDEX dist_tag_to_share_id_uni_user_to_share_id;
DROP INDEX dist_user_to_share_id_uni_tag_to_share_id;
