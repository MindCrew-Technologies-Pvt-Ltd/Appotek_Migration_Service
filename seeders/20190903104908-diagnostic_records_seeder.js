
  module.exports = {
    up: (queryInterface, Sequelize) => {
      return queryInterface.sequelize.query(`
    INSERT INTO diagnostic_records(id, title, category)
    VALUES (1, 'A1C (Hemoglobin A1C)', NULL),
       (2, 'Bone Biopsy', 'Biopsy'),
       (3, 'Colonoscopy', NULL),
       (4, 'CT Scans', NULL),
       (5, 'Diagnostic Imaging', NULL),
       (6, 'Endoscopy', NULL),
       (7, 'Genetic Testing', NULL),
       (8, 'Hepatitis Testing', NULL),
       (9, 'Kidney Tests', NULL),
       (10, 'Complete Blood Count', 'Laboratory Tests'),
       (11, 'Liver Function Tests', NULL),
       (12, 'Mammography', NULL),
       (13, 'Metabolic Panel', NULL),
       (14, 'MRI Scans', NULL),
       (15, 'Nuclear Scans', NULL),
       (16, 'Prenatal Testing', NULL),
       (17, 'Thyroid Tests', NULL),
       (18, 'Ultrasound', NULL),
       (19, 'Vital Signs', NULL),
       (20, 'X-Rays', NULL),
       (21, 'Kidney Biopsy', 'Biopsy'),
       (22, 'Liver Biopsy', 'Biopsy'),
       (23, 'Needle Biopsy', 'Biopsy'),
       (24, 'Skin Biopsy', 'Biopsy'),
       (25, 'Ultrasound Guided Biopsy', 'Biopsy'),
       (26, 'Prothrombin Time', 'Laboratory Tests'),
       (27, 'Basic Metabolic Panel', 'Laboratory Tests'),
       (28, 'Comprehensive Metabolic Panel', 'Laboratory Tests'),
       (29, 'Lipid Panel', 'Laboratory Tests'),
       (30, 'Liver Panel', 'Laboratory Tests'),
       (31, 'Thyroid Stimulating Hormone', 'Laboratory Tests'),
       (32, 'Hemoglobin A1C', 'Laboratory Tests'),
       (33, 'Urinalysis', 'Laboratory Tests'),
       (34, 'Cultures', 'Laboratory Tests');
      `)
    },
  
    down: (queryInterface, Sequelize) => {
      return queryInterface.bulkDelete('diagnostic_records', null, {});
    },
  };
  