ALTER TABLE clinic_monitoring_area add column attachment_id UUID REFERENCES attachments(id) ON DELETE SET NULL ON UPDATE CASCADE;
