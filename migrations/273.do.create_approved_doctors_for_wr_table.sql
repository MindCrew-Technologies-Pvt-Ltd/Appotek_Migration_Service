CREATE TABLE approved_position_for_wr (
	id serial NOT NULL,
	admin_id uuid NOT null,
	staff_id uuid NOT null,
	clinic_id uuid not null,
	room_id int4 not null,
	status varchar(100) not null default 'invited', 
	"createdAt" timestamptz NOT NULL DEFAULT now(),
	"updatedAt" timestamptz NOT NULL DEFAULT now(),
	CONSTRAINT apfwr_pkey PRIMARY KEY (id),
	CONSTRAINT fk_admin
      FOREIGN KEY(admin_id) 
	  references users(id),
	 CONSTRAINT fk_staff
      FOREIGN KEY(staff_id) 
	  references users(id),
	 CONSTRAINT fk_clinic
      FOREIGN KEY(clinic_id) 
	  references clinics(id),
	 CONSTRAINT fk_wr
      FOREIGN KEY(room_id) 
	  references waiting_room(id)
);