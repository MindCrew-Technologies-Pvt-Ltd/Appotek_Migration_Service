ALTER TABLE prescription_wearable drop column body_part_id;
ALTER TABLE prescription_wearable add column body_part_ids int[];
