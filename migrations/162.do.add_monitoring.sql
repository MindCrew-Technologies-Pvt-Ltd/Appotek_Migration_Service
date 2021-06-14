create table clinic_subscription
(
	id serial not null
		constraint clinic_subscription_pkey
			primary key,
	clinic_id uuid
		constraint clinic_subscription_clinic_id_key
			unique
		constraint clinic_subscription_clinic_id_fkey
			references clinics
				on update cascade on delete cascade,
	monitoring_end_date timestamp with time zone,
	monitoring_patients_count integer default 0
);

create table clinic_monitoring_area
(
	id serial not null
		constraint clinic_monitoring_area_pkey
			primary key,
	clinic_id uuid
		constraint clinic_monitoring_area_clinic_id_key
			unique
		constraint clinic_monitoring_area_clinic_id_fkey
			references clinics
				on update cascade on delete cascade,
	name varchar,
	created_by uuid
		constraint clinic_monitoring_area_created_by_fkey
			references users
				on update cascade on delete cascade,
	created_at timestamp with time zone default now()
);

create table clinic_monitoring_area_stuff
(
	monitoring_area_id integer not null
		constraint clinic_monitoring_area_stuff_monitoring_area_id_fkey
			references clinic_monitoring_area
				on update cascade on delete cascade,
	user_id uuid not null
		constraint clinic_monitoring_area_stuff_user_id_fkey
			references users
				on update cascade on delete cascade,
	constraint clinic_monitoring_area_stuff_pkey
		primary key (monitoring_area_id, user_id)
);

create table clinic_monitoring_area_patients
(
	monitoring_area_id integer not null
		constraint clinic_monitoring_area_patients_monitoring_area_id_fkey
			references clinic_monitoring_area
				on update cascade on delete cascade,
	user_id uuid not null
		constraint clinic_monitoring_area_patients_user_id_fkey
			references users
				on update cascade on delete cascade,
	constraint clinic_monitoring_area_patients_pkey
		primary key (monitoring_area_id, user_id)
);
