CREATE TABLE public."user" (
	id varchar NOT NULL,
	email varchar NOT NULL,
	first_name varchar NULL,
	last_name varchar NULL,
	password_hash varchar NOT NULL,
	api_token varchar NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT "PK_cace4a159ff9f2512dd42373760" PRIMARY KEY (id)
);
CREATE UNIQUE INDEX "IDX_e12875dfb3b1d92d7d7c5377e2" ON public."user" USING btree (email);

CREATE TABLE public.product (
	id varchar NOT NULL,
	title varchar NOT NULL,
	subtitle varchar NULL,
	description varchar NULL,
	handle varchar NULL,
	is_giftcard bool NOT NULL DEFAULT false,
	thumbnail varchar NULL,
	profile_id varchar NOT NULL,
	weight int4 NULL,
	length int4 NULL,
	height int4 NULL,
	width int4 NULL,
	hs_code varchar NULL,
	origin_country varchar NULL,
	mid_code varchar NULL,
	material varchar NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	collection_id varchar NULL,
	type_id varchar NULL,
	CONSTRAINT "PK_bebc9158e480b949565b4dc7a82" PRIMARY KEY (id),
	CONSTRAINT "FK_49d419fc77d3aed46c835c558ac" FOREIGN KEY (collection_id) REFERENCES product_collection(id),
	CONSTRAINT "FK_80823b7ae866dc5acae2dac6d2c" FOREIGN KEY (profile_id) REFERENCES shipping_profile(id),
	CONSTRAINT "FK_e0843930fbb8854fe36ca39dae1" FOREIGN KEY (type_id) REFERENCES product_type(id)
);
CREATE UNIQUE INDEX "IDX_db7355f7bd36c547c8a4f539e5" ON public.product USING btree (handle);
