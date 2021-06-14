DROP TABLE body_parts;

CREATE TABLE body_parts
(
  id     SERIAL PRIMARY KEY,
  type   VARCHAR not null,
  gender VARCHAR default 'other',
  title  VARCHAR not null
);

INSERT INTO body_parts (type, title, gender)
VALUES ('front', 'Penis', 'male'),
       ('front', 'Vagina', 'female');
INSERT INTO body_parts (type, title, gender)
VALUES ('front', 'Breasts', 'female');

INSERT INTO body_parts (type, title)
VALUES ($$ front $$, $$ Head $$),
       ($$ front $$, $$ Forehead $$),
       ($$ front $$, $$ Ear $$),
       ($$ front $$, $$ Eye $$),
       ($$ front $$, $$ Nose $$),
       ($$ front $$, $$ Cheek $$),
       ($$ front $$, $$ Mouth $$),
       ($$ front $$, $$ Chin $$),
       ($$ front $$, $$ Neck $$),
       ($$ front $$, $$ Shoulder $$),
       ($$ front $$, $$ Upper arm $$),
       ($$ front $$, $$ Elbow $$),
       ($$ front $$, $$ Forearm $$),
       ($$ front $$, $$ Wrist $$),
       ($$ front $$, $$ Palm $$),
       ($$ front $$, $$ Fingers $$),
       ($$ front $$, $$ Chest $$),
       ($$ front $$, $$ Diaphragm $$),
       ($$ front $$, $$ Abdomen $$),
       ($$ front $$, $$ Hips $$),
       ($$ front $$, $$ Thigh $$),
       ($$ front $$, $$ Knee $$),
       ($$ front $$, $$ Shin $$),
       ($$ front $$, $$ Ankle $$),
       ($$ front $$, $$ Foot $$),
       ($$ front $$, $$ Toes $$);
INSERT INTO body_parts (type, title)
VALUES ($$ back $$, $$ Hair $$),
       ($$ back $$, $$ Shoulder blade $$),
       ($$ back $$, $$ Back $$),
       ($$ back $$, $$ Lower back $$),
       ($$ back $$, $$ Hip $$),
       ($$ back $$, $$ Buttocks $$),
       ($$ back $$, $$ Calf $$),
       ($$ back $$, $$ Heel $$);
