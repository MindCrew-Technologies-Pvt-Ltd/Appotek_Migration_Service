module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.sequelize.query(`
        INSERT INTO family_relations( id, name, associations, gender) VALUES
          (36, 'parent', ARRAY[3,4,37], 'other'),
          (37, 'child', ARRAY[1,2,36], 'other'),
          (38, 'sibling', ARRAY[5,6,38], 'other'),
          (39, 'grandparent', ARRAY[11,12,40], 'other'),
          (40, 'grandchild', ARRAY[9,10,39], 'other'),
          (41, 'auncle', ARRAY[16,17,42], 'other'),
          (42, 'nibling', ARRAY[13,14,41], 'other'),
          (43, 'great grandparent', ARRAY[20,21,44], 'other'),
          (44, 'great grandchild', ARRAY[18,19,43], 'other'),
          (45, 'parent-in-law', ARRAY[24,25,46], 'other'),
          (46, 'child-in-law', ARRAY[22,23,45], 'other'),
          (47, 'sibling-in-law', ARRAY[26,27,47], 'other'),
          (48, 'stepparent', ARRAY[30,31,49], 'other'),
          (49, 'stepchild', ARRAY[28,29,48], 'other'),
          (50, 'stepsibling', ARRAY[32,33,50], 'other'),
          (51, 'halfsibling', ARRAY[34,35,51], 'other'),
          (52, 'spouse', ARRAY[7,8,52], 'other');

        UPDATE family_relations SET associations = ARRAY[3,4,37] WHERE id = 1;
        UPDATE family_relations SET associations = ARRAY[3,4,37] WHERE id = 2;
        UPDATE family_relations SET associations = ARRAY[1,2,36] WHERE id = 3;
        UPDATE family_relations SET associations = ARRAY[1,2,36] WHERE id = 4;
        UPDATE family_relations SET associations = ARRAY[5,6,38] WHERE id = 5;
        UPDATE family_relations SET associations = ARRAY[5,6,38] WHERE id = 6;
        UPDATE family_relations SET associations = ARRAY[8,52] WHERE id = 7;
        UPDATE family_relations SET associations = ARRAY[7,52] WHERE id = 8;
        UPDATE family_relations SET associations = ARRAY[11,12,40] WHERE id = 9;
        UPDATE family_relations SET associations = ARRAY[11,12,40] WHERE id = 10;
        UPDATE family_relations SET associations = ARRAY[9,10,39] WHERE id = 11;
        UPDATE family_relations SET associations = ARRAY[9,10,39] WHERE id = 12;
        UPDATE family_relations SET associations = ARRAY[16,17,42] WHERE id = 13;
        UPDATE family_relations SET associations = ARRAY[16,17,42] WHERE id = 14;
        UPDATE family_relations SET associations = ARRAY[13,14,41] WHERE id = 16;
        UPDATE family_relations SET associations = ARRAY[13,14,41] WHERE id = 17;
        UPDATE family_relations SET associations = ARRAY[20,21,44] WHERE id = 18;
        UPDATE family_relations SET associations = ARRAY[20,21,44] WHERE id = 19;
        UPDATE family_relations SET associations = ARRAY[18,19,43] WHERE id = 20;
        UPDATE family_relations SET associations = ARRAY[18,19,43] WHERE id = 21;
        UPDATE family_relations SET associations = ARRAY[24,25,46] WHERE id = 22;
        UPDATE family_relations SET associations = ARRAY[24,25,46] WHERE id = 23;
        UPDATE family_relations SET associations = ARRAY[22,23,45] WHERE id = 24;
        UPDATE family_relations SET associations = ARRAY[22,23,45] WHERE id = 25;
        UPDATE family_relations SET associations = ARRAY[26,27,47] WHERE id = 26;
        UPDATE family_relations SET associations = ARRAY[26,27,47] WHERE id = 27;
        UPDATE family_relations SET associations = ARRAY[30,31,49] WHERE id = 28;
        UPDATE family_relations SET associations = ARRAY[30,31,49] WHERE id = 29;
        UPDATE family_relations SET associations = ARRAY[28,29,48] WHERE id = 30;
        UPDATE family_relations SET associations = ARRAY[28,29,48] WHERE id = 31;
        UPDATE family_relations SET associations = ARRAY[32,33,50] WHERE id = 32;
        UPDATE family_relations SET associations = ARRAY[32,33,50] WHERE id = 33;
        UPDATE family_relations SET associations = ARRAY[34,35,51] WHERE id = 34;
        UPDATE family_relations SET associations = ARRAY[34,35,51] WHERE id = 35;
    `)
  },
  
  down: (queryInterface, Sequelize) => {
    return queryInterface.sequelize.query(`
      UPDATE family_relations SET associations = ARRAY[3,4] WHERE id = 1;
      UPDATE family_relations SET associations = ARRAY[3,4] WHERE id = 2;
      UPDATE family_relations SET associations = ARRAY[1,2] WHERE id = 3;
      UPDATE family_relations SET associations = ARRAY[1,2] WHERE id = 4;
      UPDATE family_relations SET associations = ARRAY[5,6] WHERE id = 5;
      UPDATE family_relations SET associations = ARRAY[5,6] WHERE id = 6;
      UPDATE family_relations SET associations = ARRAY[8] WHERE id = 7;
      UPDATE family_relations SET associations = ARRAY[7] WHERE id = 8;
      UPDATE family_relations SET associations = ARRAY[11,12] WHERE id = 9;
      UPDATE family_relations SET associations = ARRAY[11,12] WHERE id = 10;
      UPDATE family_relations SET associations = ARRAY[9,10] WHERE id = 11;
      UPDATE family_relations SET associations = ARRAY[9,10] WHERE id = 12;
      UPDATE family_relations SET associations = ARRAY[16,17] WHERE id = 13;
      UPDATE family_relations SET associations = ARRAY[16,17] WHERE id = 14;
      UPDATE family_relations SET associations = ARRAY[13,14] WHERE id = 16;
      UPDATE family_relations SET associations = ARRAY[13,14] WHERE id = 17;
      UPDATE family_relations SET associations = ARRAY[20,21] WHERE id = 18;
      UPDATE family_relations SET associations = ARRAY[20,21] WHERE id = 19;
      UPDATE family_relations SET associations = ARRAY[18,19] WHERE id = 20;
      UPDATE family_relations SET associations = ARRAY[18,19] WHERE id = 21;
      UPDATE family_relations SET associations = ARRAY[24,25] WHERE id = 22;
      UPDATE family_relations SET associations = ARRAY[24,25] WHERE id = 23;
      UPDATE family_relations SET associations = ARRAY[22,23] WHERE id = 24;
      UPDATE family_relations SET associations = ARRAY[22,23] WHERE id = 25;
      UPDATE family_relations SET associations = ARRAY[26,27] WHERE id = 26;
      UPDATE family_relations SET associations = ARRAY[26,27] WHERE id = 27;
      UPDATE family_relations SET associations = ARRAY[30,31] WHERE id = 28;
      UPDATE family_relations SET associations = ARRAY[30,31] WHERE id = 29;
      UPDATE family_relations SET associations = ARRAY[28,29] WHERE id = 30;
      UPDATE family_relations SET associations = ARRAY[28,29] WHERE id = 31;
      UPDATE family_relations SET associations = ARRAY[32,33] WHERE id = 32;
      UPDATE family_relations SET associations = ARRAY[32,33] WHERE id = 33;
      UPDATE family_relations SET associations = ARRAY[34,35] WHERE id = 34;
      UPDATE family_relations SET associations = ARRAY[34,35] WHERE id = 35;

      DELETE FROM family_relations WHERE id >=36;
    `)
  }
}