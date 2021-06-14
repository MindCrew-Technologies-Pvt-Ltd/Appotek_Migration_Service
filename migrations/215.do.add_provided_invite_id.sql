ALTER TABLE "registrationSessions"
    add column provided_invite_id INT references invites (id) ON DELETE SET NULL ON UPDATE CASCADE;
