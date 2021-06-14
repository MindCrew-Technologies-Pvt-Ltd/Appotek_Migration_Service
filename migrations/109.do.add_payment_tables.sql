create table "payments"
(
    "id"         bigserial primary key not null,
    "payment_id" varchar(255)          not null,
    "token"      varchar(255)          null,
    "user_id"    varchar(255)          not null,
    "type"       varchar(255)          null,
    "items"      text                  null
);

create table "packages"
(
    "id"              bigserial primary key          not null,
    "plan_name"       varchar(255)                   not null,
    "appotek_plan_id" varchar(255)                   not null,
    "stripe_plan_id"  varchar(255)                   not null,
    "created_at"      timestamp(0) without time zone null,
    "updated_at"      timestamp(0) without time zone null
);
alter table "packages" add constraint "packages_appotek_plan_id_unique" unique ("appotek_plan_id");
alter table "packages" add constraint "packages_stripe_plan_id_unique" unique ("stripe_plan_id");

create table "stripe_user"
(
    "id"              bigserial primary key          not null,
    "appotek_user_id" varchar(255)                   not null,
    "stripe_user_id"  varchar(255)                   not null,
    "email"           varchar(255)                   not null,
    "created_at"      timestamp(0) without time zone null,
    "updated_at"      timestamp(0) without time zone null
);
