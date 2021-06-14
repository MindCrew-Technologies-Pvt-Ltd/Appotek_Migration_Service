ALTER TABLE permissions_sharing
  ADD COLUMN avatar UUID REFERENCES attachments (id) ON DELETE SET NULL;

CREATE OR REPLACE FUNCTION get_user_permissions(requester_id UUID, target_id UUID)
  RETURNS TABLE
          (
            medical_history  BOOLEAN,
            remind_tasks     BOOLEAN,
            pick_up_medicine BOOLEAN,
            tasks            BOOLEAN,
            activity         BOOLEAN
          ) AS
$$
DECLARE
  personal_permissions permissions_sharing;
BEGIN

  SELECT * INTO personal_permissions
  FROM permissions_sharing
  WHERE permissions_sharing.user_id = target_id
    AND permissions_sharing.user_to_share_id = requester_id
    AND permissions_sharing.tag_to_share_id IS NULL;

  CASE WHEN (personal_permissions.user_id IS NOT NULL)
    THEN RETURN QUERY SELECT personal_permissions.medical_history,
                             personal_permissions.remind_tasks,
                             personal_permissions.pick_up_medicine,
                             personal_permissions.tasks,
                             personal_permissions.activity;
    ELSE RETURN
      QUERY
      SELECT TRUE = any (array_agg(permissions_sharing.medical_history)),
             TRUE = any (array_agg(permissions_sharing.remind_tasks)),
             TRUE = any (array_agg(permissions_sharing.pick_up_medicine)),
             TRUE = any (array_agg(permissions_sharing.tasks)),
             TRUE = any (array_agg(permissions_sharing.activity))
      FROM permissions_sharing
             INNER JOIN user_tags ON user_tags.tag_id = permissions_sharing.tag_to_share_id AND
                                     user_tags.user_id = permissions_sharing.user_id AND
                                     user_tags.tagged_user_id = requester_id
      WHERE permissions_sharing.user_id = target_id
        AND permissions_sharing.user_to_share_id IS NULL;
    END CASE;
END;
$$
  LANGUAGE plpgsql;
