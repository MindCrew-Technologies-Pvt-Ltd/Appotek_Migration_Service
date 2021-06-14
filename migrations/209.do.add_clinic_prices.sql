CREATE TABLE clinics_prices(
    id serial primary key,
    clinic_id uuid unique not null,
    online_consultation_price int default 0,
    home_visit_price int default 0,
    consultation_price int default 0
);
