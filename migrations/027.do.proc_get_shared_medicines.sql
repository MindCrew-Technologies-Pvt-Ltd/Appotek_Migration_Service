CREATE OR REPLACE FUNCTION public.sharing_get_attached_files(applicant_id uuid, recipient_id uuid)
  RETURNS TABLE
        (
			id uuid, 
			stored_key varchar(255),
			owner_id uuid,
			"type" varchar(32),
			subtype varchar(32),
			visibility attachment_visibility_levels,
			source_url varchar(255),
			uploaded_at timestamp
		) AS
$$
begin
   CASE WHEN ( exists (select true from get_user_permissions(recipient_id, applicant_id) where pick_up_medicine) )
    THEN
    ELSE RAISE EXCEPTION 'You are not given access to this section';
    END CASE;
	
	RETURN QUERY
		select a.* 
		from attachments a
		inner join 
			(select unnest(ps.attached_files) as attached_files 
				from permissions_sharing ps 
				where ps.user_id = applicant_id and ps.user_to_share_id = recipient_id
			union
			select unnest(ps.attached_files) as attached_files 
				from permissions_sharing ps 
				inner join user_tags ut on (ps.tag_to_share_id = ut.tag_id and ps.user_id = ut.user_id)
				where ps.user_id = applicant_id and ut.tagged_user_id = recipient_id) sa on (sa.attached_files = a.id and a.owner_id = applicant_id);
END;
$$
  LANGUAGE plpgsql;   