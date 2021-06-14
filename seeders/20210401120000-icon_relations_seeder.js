module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.sequelize.query(`
        UPDATE medical_specializations SET icon_filename = 'img_allergy_immunology.jpg' WHERE title = 'Allergy & immunology specialist';
        UPDATE medical_specializations SET icon_filename = 'img_anesthesiology.jpg' WHERE title = 'Anesthesiology specialist';
        UPDATE medical_specializations SET icon_filename = 'img_dermatology.jpg' WHERE title = 'Dermatology specialist';
        UPDATE medical_specializations SET icon_filename = 'img_heart_disease_hypertension.jpg' WHERE title = 'Diagnostic radiology specialist';
        UPDATE medical_specializations SET icon_filename = 'img_emergency.jpg' WHERE title = 'Emergency medicine specialist';
        UPDATE medical_specializations SET icon_filename = 'img_family_medicine.jpg' WHERE title = 'Family medicine specialist';
        UPDATE medical_specializations SET icon_filename = 'img_radiography.jpg' WHERE title = 'Internal medicine specialist';
        UPDATE medical_specializations SET icon_filename = 'img_medical_genetics.jpg' WHERE title = 'Medical genetics specialist';
        UPDATE medical_specializations SET icon_filename = 'img_neurology.jpg' WHERE title = 'Neurology specialist';
        UPDATE medical_specializations SET icon_filename = 'img_nuclear_medicine.jpg' WHERE title = 'Nuclear medicine specialist';
        UPDATE medical_specializations SET icon_filename = 'img_gynecology.jpg' WHERE title = 'Obstetrics and gynecology specialist';
        UPDATE medical_specializations SET icon_filename = 'img_ophthalmology.jpg' WHERE title = 'Ophthalmology specialist';
        UPDATE medical_specializations SET icon_filename = 'img_pathology.jpg' WHERE title = 'Pathology specialist';
        UPDATE medical_specializations SET icon_filename = 'img_pediatrics.jpg' WHERE title = 'Pediatrics specialist';
        UPDATE medical_specializations SET icon_filename = 'img_physical_rehabilitation.jpg' WHERE title = 'Physical medicine & rehabilitation specialist';
        UPDATE medical_specializations SET icon_filename = 'img_preventive_medicine.jpg' WHERE title = 'Preventive medicine specialist';
        UPDATE medical_specializations SET icon_filename = 'img_psychiatry.jpg' WHERE title = 'Psychiatry specialist';
        UPDATE medical_specializations SET icon_filename = 'img_radiation_oncology.jpg' WHERE title = 'Radiation oncology specialist';
        UPDATE medical_specializations SET icon_filename = 'img_surgery.jpg' WHERE title = 'Surgery specialist';
        UPDATE medical_specializations SET icon_filename = 'img_urology.jpg' WHERE title = 'Urology Programs specialist';
    `)
  },
  
  down: (queryInterface, Sequelize) => {
    return queryInterface.sequelize.query(`
    UPDATE medical_specializations SET icon_filename = NULL;   
    `)
  }
}