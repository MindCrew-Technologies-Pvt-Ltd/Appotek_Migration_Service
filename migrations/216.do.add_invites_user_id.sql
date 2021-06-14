ALTER TABLE invites
    add column user_id UUID REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE;
