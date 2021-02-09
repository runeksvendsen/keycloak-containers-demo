-- public.currency definition

-- Drop table

-- DROP TABLE public.currency;

CREATE TABLE public.currency (
	code varchar NOT NULL,
	symbol varchar NOT NULL,
	symbol_native varchar NOT NULL,
	name varchar NOT NULL,
	CONSTRAINT "PK_723472e41cae44beb0763f4039c" PRIMARY KEY (code)
);


-- public.discount_rule definition

-- Drop table

-- DROP TABLE public.discount_rule;

CREATE TABLE public.discount_rule (
	id varchar NOT NULL,
	description varchar NOT NULL,
	"type" discount_rule_type_enum NOT NULL,
	value int4 NOT NULL,
	allocation discount_rule_allocation_enum NULL,
	usage_limit int4 NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT "PK_ac2c280de3701b2d66f6817f760" PRIMARY KEY (id)
);


-- public.fulfillment_provider definition

-- Drop table

-- DROP TABLE public.fulfillment_provider;

CREATE TABLE public.fulfillment_provider (
	id varchar NOT NULL,
	is_installed bool NOT NULL DEFAULT true,
	CONSTRAINT "PK_beb35a6de60a6c4f91d5ae57e44" PRIMARY KEY (id)
);


-- public.idempotency_key definition

-- Drop table

-- DROP TABLE public.idempotency_key;

CREATE TABLE public.idempotency_key (
	id varchar NOT NULL,
	idempotency_key varchar NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	locked_at timestamptz NULL,
	request_method varchar NULL,
	request_params jsonb NULL,
	request_path varchar NULL,
	response_code int4 NULL,
	response_body jsonb NULL,
	recovery_point varchar NOT NULL DEFAULT 'started'::character varying,
	CONSTRAINT "PK_213f125e14469be304f9ff1d452" PRIMARY KEY (id)
);
CREATE UNIQUE INDEX "IDX_a421bf4588d0004a9b0c0fe84f" ON public.idempotency_key USING btree (idempotency_key);


-- public.image definition

-- Drop table

-- DROP TABLE public.image;

CREATE TABLE public.image (
	id varchar NOT NULL,
	url varchar NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT "PK_d6db1ab4ee9ad9dbe86c64e4cc3" PRIMARY KEY (id)
);


-- public.migrations definition

-- Drop table

-- DROP TABLE public.migrations;

CREATE TABLE public.migrations (
	id serial NOT NULL,
	"timestamp" int8 NOT NULL,
	name varchar NOT NULL,
	CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id)
);


-- public.oauth definition

-- Drop table

-- DROP TABLE public.oauth;

CREATE TABLE public.oauth (
	id varchar NOT NULL,
	display_name varchar NOT NULL,
	application_name varchar NOT NULL,
	install_url varchar NULL,
	uninstall_url varchar NULL,
	"data" jsonb NULL,
	CONSTRAINT "PK_a957b894e50eb16b969c0640a8d" PRIMARY KEY (id)
);
CREATE UNIQUE INDEX "IDX_c49c061b1a686843c5d673506f" ON public.oauth USING btree (application_name);


-- public.payment_provider definition

-- Drop table

-- DROP TABLE public.payment_provider;

CREATE TABLE public.payment_provider (
	id varchar NOT NULL,
	is_installed bool NOT NULL DEFAULT true,
	CONSTRAINT "PK_ea94f42b6c88e9191c3649d7522" PRIMARY KEY (id)
);


-- public.product_collection definition

-- Drop table

-- DROP TABLE public.product_collection;

CREATE TABLE public.product_collection (
	id varchar NOT NULL,
	title varchar NOT NULL,
	handle varchar NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT "PK_49d419fc77d3aed46c835c558ac" PRIMARY KEY (id)
);
CREATE UNIQUE INDEX "IDX_6910923cb678fd6e99011a21cc" ON public.product_collection USING btree (handle);


-- public.product_tag definition

-- Drop table

-- DROP TABLE public.product_tag;

CREATE TABLE public.product_tag (
	id varchar NOT NULL,
	value varchar NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT "PK_1439455c6528caa94fcc8564fda" PRIMARY KEY (id)
);


-- public.product_type definition

-- Drop table

-- DROP TABLE public.product_type;

CREATE TABLE public.product_type (
	id varchar NOT NULL,
	value varchar NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT "PK_e0843930fbb8854fe36ca39dae1" PRIMARY KEY (id)
);


-- public.shipping_profile definition

-- Drop table

-- DROP TABLE public.shipping_profile;

CREATE TABLE public.shipping_profile (
	id varchar NOT NULL,
	name varchar NOT NULL,
	"type" shipping_profile_type_enum NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT "PK_c8120e4543a5a3a121f2968a1ec" PRIMARY KEY (id)
);


-- public.staged_job definition

-- Drop table

-- DROP TABLE public.staged_job;

CREATE TABLE public.staged_job (
	id varchar NOT NULL,
	event_name varchar NOT NULL,
	"data" jsonb NOT NULL,
	CONSTRAINT "PK_9a28fb48c46c5509faf43ac8c8d" PRIMARY KEY (id)
);


-- public."user" definition

-- Drop table

-- DROP TABLE public."user";

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


-- public.discount definition

-- Drop table

-- DROP TABLE public.discount;

CREATE TABLE public.discount (
	id varchar NOT NULL,
	code varchar NOT NULL,
	is_dynamic bool NOT NULL,
	rule_id varchar NULL,
	is_disabled bool NOT NULL,
	parent_discount_id varchar NULL,
	starts_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ends_at timestamptz NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT "PK_d05d8712e429673e459e7f1cddb" PRIMARY KEY (id),
	CONSTRAINT "FK_2250c5d9e975987ab212f61a663" FOREIGN KEY (parent_discount_id) REFERENCES discount(id),
	CONSTRAINT "FK_ac2c280de3701b2d66f6817f760" FOREIGN KEY (rule_id) REFERENCES discount_rule(id)
);
CREATE UNIQUE INDEX "IDX_087926f6fec32903be3c8eedfa" ON public.discount USING btree (code);


-- public.product definition

-- Drop table

-- DROP TABLE public.product;

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


-- public.product_images definition

-- Drop table

-- DROP TABLE public.product_images;

CREATE TABLE public.product_images (
	product_id varchar NOT NULL,
	image_id varchar NOT NULL,
	CONSTRAINT "PK_10de97980da2e939c4c0e8423f2" PRIMARY KEY (product_id, image_id),
	CONSTRAINT "FK_2212515ba306c79f42c46a99db7" FOREIGN KEY (image_id) REFERENCES image(id) ON DELETE CASCADE,
	CONSTRAINT "FK_4f166bb8c2bfcef2498d97b4068" FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);
CREATE INDEX "IDX_2212515ba306c79f42c46a99db" ON public.product_images USING btree (image_id);
CREATE INDEX "IDX_4f166bb8c2bfcef2498d97b406" ON public.product_images USING btree (product_id);


-- public.product_option definition

-- Drop table

-- DROP TABLE public.product_option;

CREATE TABLE public.product_option (
	id varchar NOT NULL,
	title varchar NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	product_id varchar NULL,
	CONSTRAINT "PK_4cf3c467e9bc764bdd32c4cd938" PRIMARY KEY (id),
	CONSTRAINT "FK_e634fca34f6b594b87fdbee95f6" FOREIGN KEY (product_id) REFERENCES product(id)
);


-- public.product_tags definition

-- Drop table

-- DROP TABLE public.product_tags;

CREATE TABLE public.product_tags (
	product_id varchar NOT NULL,
	product_tag_id varchar NOT NULL,
	CONSTRAINT "PK_1cf5c9537e7198df494b71b993f" PRIMARY KEY (product_id, product_tag_id),
	CONSTRAINT "FK_21683a063fe82dafdf681ecc9c4" FOREIGN KEY (product_tag_id) REFERENCES product_tag(id) ON DELETE CASCADE,
	CONSTRAINT "FK_5b0c6fc53c574299ecc7f9ee22e" FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);
CREATE INDEX "IDX_21683a063fe82dafdf681ecc9c" ON public.product_tags USING btree (product_tag_id);
CREATE INDEX "IDX_5b0c6fc53c574299ecc7f9ee22" ON public.product_tags USING btree (product_id);


-- public.product_variant definition

-- Drop table

-- DROP TABLE public.product_variant;

CREATE TABLE public.product_variant (
	id varchar NOT NULL,
	title varchar NOT NULL,
	product_id varchar NOT NULL,
	sku varchar NULL,
	barcode varchar NULL,
	ean varchar NULL,
	upc varchar NULL,
	inventory_quantity int4 NOT NULL,
	allow_backorder bool NOT NULL DEFAULT false,
	manage_inventory bool NOT NULL DEFAULT true,
	hs_code varchar NULL,
	origin_country varchar NULL,
	mid_code varchar NULL,
	material varchar NULL,
	weight int4 NULL,
	length int4 NULL,
	height int4 NULL,
	width int4 NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT "PK_1ab69c9935c61f7c70791ae0a9f" PRIMARY KEY (id),
	CONSTRAINT "FK_ca67dd080aac5ecf99609960cd2" FOREIGN KEY (product_id) REFERENCES product(id)
);
CREATE UNIQUE INDEX "IDX_7124082c8846a06a857cca386c" ON public.product_variant USING btree (ean);
CREATE UNIQUE INDEX "IDX_9db95c4b71f632fc93ecbc3d8b" ON public.product_variant USING btree (barcode);
CREATE UNIQUE INDEX "IDX_a0a3f124dc5b167622217fee02" ON public.product_variant USING btree (upc);
CREATE UNIQUE INDEX "IDX_f4dc2c0888b66d547c175f090e" ON public.product_variant USING btree (sku);


-- public.region definition

-- Drop table

-- DROP TABLE public.region;

CREATE TABLE public.region (
	id varchar NOT NULL,
	name varchar NOT NULL,
	currency_code varchar NOT NULL,
	tax_rate numeric NOT NULL,
	tax_code varchar NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT "PK_5f48ffc3af96bc486f5f3f3a6da" PRIMARY KEY (id),
	CONSTRAINT "FK_3bdd5896ec93be2f1c62a3309a5" FOREIGN KEY (currency_code) REFERENCES currency(code)
);


-- public.region_fulfillment_providers definition

-- Drop table

-- DROP TABLE public.region_fulfillment_providers;

CREATE TABLE public.region_fulfillment_providers (
	region_id varchar NOT NULL,
	provider_id varchar NOT NULL,
	CONSTRAINT "PK_5b7d928a1fb50d6803868cfab3a" PRIMARY KEY (region_id, provider_id),
	CONSTRAINT "FK_37f361c38a18d12a3fa3158d0cf" FOREIGN KEY (provider_id) REFERENCES fulfillment_provider(id) ON DELETE CASCADE,
	CONSTRAINT "FK_c556e14eff4d6f03db593df955e" FOREIGN KEY (region_id) REFERENCES region(id) ON DELETE CASCADE
);
CREATE INDEX "IDX_37f361c38a18d12a3fa3158d0c" ON public.region_fulfillment_providers USING btree (provider_id);
CREATE INDEX "IDX_c556e14eff4d6f03db593df955" ON public.region_fulfillment_providers USING btree (region_id);


-- public.region_payment_providers definition

-- Drop table

-- DROP TABLE public.region_payment_providers;

CREATE TABLE public.region_payment_providers (
	region_id varchar NOT NULL,
	provider_id varchar NOT NULL,
	CONSTRAINT "PK_9fa1e69914d3dd752de6b1da407" PRIMARY KEY (region_id, provider_id),
	CONSTRAINT "FK_3a6947180aeec283cd92c59ebb0" FOREIGN KEY (provider_id) REFERENCES payment_provider(id) ON DELETE CASCADE,
	CONSTRAINT "FK_8aaa78ba90d3802edac317df869" FOREIGN KEY (region_id) REFERENCES region(id) ON DELETE CASCADE
);
CREATE INDEX "IDX_3a6947180aeec283cd92c59ebb" ON public.region_payment_providers USING btree (provider_id);
CREATE INDEX "IDX_8aaa78ba90d3802edac317df86" ON public.region_payment_providers USING btree (region_id);


-- public.shipping_option definition

-- Drop table

-- DROP TABLE public.shipping_option;

CREATE TABLE public.shipping_option (
	id varchar NOT NULL,
	name varchar NOT NULL,
	region_id varchar NOT NULL,
	profile_id varchar NOT NULL,
	provider_id varchar NOT NULL,
	price_type shipping_option_price_type_enum NOT NULL,
	amount int4 NULL,
	is_return bool NOT NULL DEFAULT false,
	"data" jsonb NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT "CHK_7a367f5901ae0a5b0df75aee38" CHECK ((amount >= 0)),
	CONSTRAINT "PK_2e56fddaa65f3a26d402e5d786e" PRIMARY KEY (id),
	CONSTRAINT "FK_5c58105f1752fca0f4ce69f4663" FOREIGN KEY (region_id) REFERENCES region(id),
	CONSTRAINT "FK_a0e206bfaed3cb63c1860917347" FOREIGN KEY (provider_id) REFERENCES fulfillment_provider(id),
	CONSTRAINT "FK_c951439af4c98bf2bd7fb8726cd" FOREIGN KEY (profile_id) REFERENCES shipping_profile(id)
);


-- public.shipping_option_requirement definition

-- Drop table

-- DROP TABLE public.shipping_option_requirement;

CREATE TABLE public.shipping_option_requirement (
	id varchar NOT NULL,
	shipping_option_id varchar NOT NULL,
	"type" shipping_option_requirement_type_enum NOT NULL,
	amount int4 NOT NULL,
	CONSTRAINT "PK_a0ff15442606d9f783602cb23a7" PRIMARY KEY (id),
	CONSTRAINT "FK_012a62ba743e427b5ebe9dee18e" FOREIGN KEY (shipping_option_id) REFERENCES shipping_option(id)
);


-- public.store definition

-- Drop table

-- DROP TABLE public.store;

CREATE TABLE public.store (
	id varchar NOT NULL,
	name varchar NOT NULL DEFAULT 'Medusa Store'::character varying,
	default_currency_code varchar NOT NULL DEFAULT 'usd'::character varying,
	swap_link_template varchar NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	metadata jsonb NULL,
	CONSTRAINT "PK_f3172007d4de5ae8e7692759d79" PRIMARY KEY (id),
	CONSTRAINT "FK_55beebaa09e947cccca554af222" FOREIGN KEY (default_currency_code) REFERENCES currency(code)
);


-- public.store_currencies definition

-- Drop table

-- DROP TABLE public.store_currencies;

CREATE TABLE public.store_currencies (
	store_id varchar NOT NULL,
	currency_code varchar NOT NULL,
	CONSTRAINT "PK_0f2bff3bccc785c320a4df836de" PRIMARY KEY (store_id, currency_code),
	CONSTRAINT "FK_82a6bbb0b527c20a0002ddcbd60" FOREIGN KEY (currency_code) REFERENCES currency(code) ON DELETE CASCADE,
	CONSTRAINT "FK_b4f4b63d1736689b7008980394c" FOREIGN KEY (store_id) REFERENCES store(id) ON DELETE CASCADE
);
CREATE INDEX "IDX_82a6bbb0b527c20a0002ddcbd6" ON public.store_currencies USING btree (currency_code);
CREATE INDEX "IDX_b4f4b63d1736689b7008980394" ON public.store_currencies USING btree (store_id);


-- public.country definition

-- Drop table

-- DROP TABLE public.country;

CREATE TABLE public.country (
	id serial NOT NULL,
	iso_2 varchar NOT NULL,
	iso_3 varchar NOT NULL,
	num_code int4 NOT NULL,
	name varchar NOT NULL,
	display_name varchar NOT NULL,
	region_id varchar NULL,
	CONSTRAINT "PK_bf6e37c231c4f4ea56dcd887269" PRIMARY KEY (id),
	CONSTRAINT "FK_b1aac8314662fa6b25569a575bb" FOREIGN KEY (region_id) REFERENCES region(id)
);
CREATE UNIQUE INDEX "IDX_e78901b1131eaf8203d9b1cb5f" ON public.country USING btree (iso_2);


-- public.discount_regions definition

-- Drop table

-- DROP TABLE public.discount_regions;

CREATE TABLE public.discount_regions (
	discount_id varchar NOT NULL,
	region_id varchar NOT NULL,
	CONSTRAINT "PK_15974566a8b6e04a7c754e85b75" PRIMARY KEY (discount_id, region_id),
	CONSTRAINT "FK_a21a7ffbe420d492eb46c305fec" FOREIGN KEY (region_id) REFERENCES region(id) ON DELETE CASCADE,
	CONSTRAINT "FK_f4194aa81073f3fab8aa86906ff" FOREIGN KEY (discount_id) REFERENCES discount(id) ON DELETE CASCADE
);
CREATE INDEX "IDX_a21a7ffbe420d492eb46c305fe" ON public.discount_regions USING btree (region_id);
CREATE INDEX "IDX_f4194aa81073f3fab8aa86906f" ON public.discount_regions USING btree (discount_id);


-- public.discount_rule_products definition

-- Drop table

-- DROP TABLE public.discount_rule_products;

CREATE TABLE public.discount_rule_products (
	discount_rule_id varchar NOT NULL,
	product_id varchar NOT NULL,
	CONSTRAINT "PK_351c8c92f5d27283c445cd022ee" PRIMARY KEY (discount_rule_id, product_id),
	CONSTRAINT "FK_4e0739e5f0244c08d41174ca08a" FOREIGN KEY (discount_rule_id) REFERENCES discount_rule(id) ON DELETE CASCADE,
	CONSTRAINT "FK_be66106a673b88a81c603abe7eb" FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);
CREATE INDEX "IDX_4e0739e5f0244c08d41174ca08" ON public.discount_rule_products USING btree (discount_rule_id);
CREATE INDEX "IDX_be66106a673b88a81c603abe7e" ON public.discount_rule_products USING btree (product_id);


-- public.money_amount definition

-- Drop table

-- DROP TABLE public.money_amount;

CREATE TABLE public.money_amount (
	id varchar NOT NULL,
	currency_code varchar NOT NULL,
	amount int4 NOT NULL,
	sale_amount int4 NULL,
	variant_id varchar NULL,
	region_id varchar NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	CONSTRAINT "PK_022e49a7e21a8dfb820f788778a" PRIMARY KEY (id),
	CONSTRAINT "FK_17a06d728e4cfbc5bd2ddb70af0" FOREIGN KEY (variant_id) REFERENCES product_variant(id),
	CONSTRAINT "FK_b433e27b7a83e6d12ab26b15b03" FOREIGN KEY (region_id) REFERENCES region(id),
	CONSTRAINT "FK_e15811f81339e4bd8c440aebe1c" FOREIGN KEY (currency_code) REFERENCES currency(code)
);


-- public.product_option_value definition

-- Drop table

-- DROP TABLE public.product_option_value;

CREATE TABLE public.product_option_value (
	id varchar NOT NULL,
	value varchar NOT NULL,
	option_id varchar NOT NULL,
	variant_id varchar NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT "PK_2ab71ed3b21be5800905c621535" PRIMARY KEY (id),
	CONSTRAINT "FK_7234ed737ff4eb1b6ae6e6d7b01" FOREIGN KEY (variant_id) REFERENCES product_variant(id),
	CONSTRAINT "FK_cdf4388f294b30a25c627d69fe9" FOREIGN KEY (option_id) REFERENCES product_option(id)
);
CREATE INDEX "IDX_cdf4388f294b30a25c627d69fe" ON public.product_option_value USING btree (option_id);


-- public.address definition

-- Drop table

-- DROP TABLE public.address;

CREATE TABLE public.address (
	id varchar NOT NULL,
	customer_id varchar NULL,
	company varchar NULL,
	first_name varchar NULL,
	last_name varchar NULL,
	address_1 varchar NULL,
	address_2 varchar NULL,
	city varchar NULL,
	country_code varchar NULL,
	province varchar NULL,
	postal_code varchar NULL,
	phone varchar NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT "PK_d92de1f82754668b5f5f5dd4fd5" PRIMARY KEY (id)
);


-- public.cart definition

-- Drop table

-- DROP TABLE public.cart;

CREATE TABLE public.cart (
	id varchar NOT NULL,
	email varchar NULL,
	billing_address_id varchar NULL,
	shipping_address_id varchar NULL,
	region_id varchar NOT NULL,
	customer_id varchar NULL,
	payment_id varchar NULL,
	"type" cart_type_enum NOT NULL DEFAULT 'default'::cart_type_enum,
	completed_at timestamptz NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	idempotency_key varchar NULL,
	CONSTRAINT "PK_c524ec48751b9b5bcfbf6e59be7" PRIMARY KEY (id),
	CONSTRAINT "REL_9d1a161434c610aae7c3df2dc7" UNIQUE (payment_id)
);


-- public.cart_discounts definition

-- Drop table

-- DROP TABLE public.cart_discounts;

CREATE TABLE public.cart_discounts (
	cart_id varchar NOT NULL,
	discount_id varchar NOT NULL,
	CONSTRAINT "PK_10bd412c9071ccc0cf555afd9bb" PRIMARY KEY (cart_id, discount_id)
);
CREATE INDEX "IDX_6680319ebe1f46d18f106191d5" ON public.cart_discounts USING btree (cart_id);
CREATE INDEX "IDX_8df75ef4f35f217768dc113545" ON public.cart_discounts USING btree (discount_id);


-- public.cart_gift_cards definition

-- Drop table

-- DROP TABLE public.cart_gift_cards;

CREATE TABLE public.cart_gift_cards (
	cart_id varchar NOT NULL,
	gift_card_id varchar NOT NULL,
	CONSTRAINT "PK_2389be82bf0ef3635e2014c9ef1" PRIMARY KEY (cart_id, gift_card_id)
);
CREATE INDEX "IDX_0fb38b6d167793192bc126d835" ON public.cart_gift_cards USING btree (gift_card_id);
CREATE INDEX "IDX_d38047a90f3d42f0be7909e8ae" ON public.cart_gift_cards USING btree (cart_id);


-- public.customer definition

-- Drop table

-- DROP TABLE public.customer;

CREATE TABLE public.customer (
	id varchar NOT NULL,
	email varchar NOT NULL,
	first_name varchar NULL,
	last_name varchar NULL,
	billing_address_id varchar NULL,
	password_hash varchar NULL,
	phone varchar NULL,
	has_account bool NOT NULL DEFAULT false,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT "PK_a7a13f4cacb744524e44dfdad32" PRIMARY KEY (id),
	CONSTRAINT "REL_8abe81b9aac151ae60bf507ad1" UNIQUE (billing_address_id)
);
CREATE UNIQUE INDEX "IDX_fdb2f3ad8115da4c7718109a6e" ON public.customer USING btree (email);


-- public.fulfillment definition

-- Drop table

-- DROP TABLE public.fulfillment;

CREATE TABLE public.fulfillment (
	id varchar NOT NULL,
	swap_id varchar NULL,
	order_id varchar NULL,
	tracking_numbers jsonb NOT NULL DEFAULT '[]'::jsonb,
	"data" jsonb NOT NULL,
	shipped_at timestamptz NULL,
	canceled_at timestamptz NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	metadata jsonb NULL,
	idempotency_key varchar NULL,
	provider_id varchar NULL,
	CONSTRAINT "PK_50c102da132afffae660585981f" PRIMARY KEY (id)
);


-- public.fulfillment_item definition

-- Drop table

-- DROP TABLE public.fulfillment_item;

CREATE TABLE public.fulfillment_item (
	fulfillment_id varchar NOT NULL,
	item_id varchar NOT NULL,
	quantity int4 NOT NULL,
	CONSTRAINT "PK_bc3e8a388de75db146a249922e0" PRIMARY KEY (fulfillment_id, item_id)
);


-- public.gift_card definition

-- Drop table

-- DROP TABLE public.gift_card;

CREATE TABLE public.gift_card (
	id varchar NOT NULL,
	code varchar NOT NULL,
	value int4 NOT NULL,
	balance int4 NOT NULL,
	region_id varchar NOT NULL,
	order_id varchar NULL,
	is_disabled bool NOT NULL DEFAULT false,
	ends_at timestamptz NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT "PK_af4e338d2d41035042843ad641f" PRIMARY KEY (id),
	CONSTRAINT "REL_dfc1f02bb0552e79076aa58dbb" UNIQUE (order_id)
);
CREATE UNIQUE INDEX "IDX_53cb5605fa42e82b4d47b47bda" ON public.gift_card USING btree (code);


-- public.gift_card_transaction definition

-- Drop table

-- DROP TABLE public.gift_card_transaction;

CREATE TABLE public.gift_card_transaction (
	id varchar NOT NULL,
	gift_card_id varchar NOT NULL,
	order_id varchar NOT NULL,
	amount int4 NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	CONSTRAINT "PK_cfb5b4ba5447a507aef87d73fe7" PRIMARY KEY (id),
	CONSTRAINT gcuniq UNIQUE (gift_card_id, order_id)
);


-- public.line_item definition

-- Drop table

-- DROP TABLE public.line_item;

CREATE TABLE public.line_item (
	id varchar NOT NULL,
	cart_id varchar NULL,
	order_id varchar NULL,
	swap_id varchar NULL,
	title varchar NOT NULL,
	description varchar NULL,
	thumbnail varchar NULL,
	is_giftcard bool NOT NULL DEFAULT false,
	should_merge bool NOT NULL DEFAULT true,
	allow_discounts bool NOT NULL DEFAULT true,
	has_shipping bool NULL,
	unit_price int4 NOT NULL,
	variant_id varchar NULL,
	quantity int4 NOT NULL,
	fulfilled_quantity int4 NULL,
	returned_quantity int4 NULL,
	shipped_quantity int4 NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	metadata jsonb NULL,
	CONSTRAINT "CHK_0cd85e15610d11b553d5e8fda6" CHECK ((shipped_quantity <= fulfilled_quantity)),
	CONSTRAINT "CHK_64eef00a5064887634f1680866" CHECK ((quantity > 0)),
	CONSTRAINT "CHK_91f40396d847f6ecfd9f752bf8" CHECK ((returned_quantity <= quantity)),
	CONSTRAINT "CHK_c61716c68f5ad5de2834c827d3" CHECK ((fulfilled_quantity <= quantity)),
	CONSTRAINT "PK_cce6b13e67fa506d1d9618ac68b" PRIMARY KEY (id)
);
CREATE INDEX "IDX_27283ee631862266d0f1c68064" ON public.line_item USING btree (cart_id);
CREATE INDEX "IDX_3fa354d8d1233ff81097b2fcb6" ON public.line_item USING btree (swap_id);
CREATE INDEX "IDX_43a2b24495fe1d9fc2a9c835bc" ON public.line_item USING btree (order_id);
CREATE INDEX "IDX_5371cbaa3be5200f373d24e3d5" ON public.line_item USING btree (variant_id);


-- public."order" definition

-- Drop table

-- DROP TABLE public."order";

CREATE TABLE public."order" (
	id varchar NOT NULL,
	status order_status_enum NOT NULL DEFAULT 'pending'::order_status_enum,
	fulfillment_status order_fulfillment_status_enum NOT NULL DEFAULT 'not_fulfilled'::order_fulfillment_status_enum,
	payment_status order_payment_status_enum NOT NULL DEFAULT 'not_paid'::order_payment_status_enum,
	display_id serial NOT NULL,
	cart_id varchar NULL,
	customer_id varchar NOT NULL,
	email varchar NOT NULL,
	billing_address_id varchar NULL,
	shipping_address_id varchar NULL,
	region_id varchar NOT NULL,
	currency_code varchar NOT NULL,
	tax_rate int4 NOT NULL,
	canceled_at timestamptz NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	metadata jsonb NULL,
	idempotency_key varchar NULL,
	CONSTRAINT "PK_1031171c13130102495201e3e20" PRIMARY KEY (id),
	CONSTRAINT "REL_c99a206eb11ad45f6b7f04f2dc" UNIQUE (cart_id)
);


-- public.order_discounts definition

-- Drop table

-- DROP TABLE public.order_discounts;

CREATE TABLE public.order_discounts (
	order_id varchar NOT NULL,
	discount_id varchar NOT NULL,
	CONSTRAINT "PK_a7418714ffceebc125bf6d8fcfe" PRIMARY KEY (order_id, discount_id)
);
CREATE INDEX "IDX_0fc1ec4e3db9001ad60c19daf1" ON public.order_discounts USING btree (discount_id);
CREATE INDEX "IDX_e7b488cebe333f449398769b2c" ON public.order_discounts USING btree (order_id);


-- public.order_gift_cards definition

-- Drop table

-- DROP TABLE public.order_gift_cards;

CREATE TABLE public.order_gift_cards (
	order_id varchar NOT NULL,
	gift_card_id varchar NOT NULL,
	CONSTRAINT "PK_49a8ec66a6625d7c2e3526e05b4" PRIMARY KEY (order_id, gift_card_id)
);
CREATE INDEX "IDX_e62ff11e4730bb3adfead979ee" ON public.order_gift_cards USING btree (order_id);
CREATE INDEX "IDX_f2bb9f71e95b315eb24b2b84cb" ON public.order_gift_cards USING btree (gift_card_id);


-- public.payment definition

-- Drop table

-- DROP TABLE public.payment;

CREATE TABLE public.payment (
	id varchar NOT NULL,
	swap_id varchar NULL,
	cart_id varchar NULL,
	order_id varchar NULL,
	amount int4 NOT NULL,
	currency_code varchar NOT NULL,
	amount_refunded int4 NOT NULL DEFAULT 0,
	provider_id varchar NOT NULL,
	"data" jsonb NOT NULL,
	captured_at timestamptz NULL,
	canceled_at timestamptz NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	metadata jsonb NULL,
	idempotency_key varchar NULL,
	CONSTRAINT "PK_fcaec7df5adf9cac408c686b2ab" PRIMARY KEY (id),
	CONSTRAINT "REL_4665f17abc1e81dd58330e5854" UNIQUE (cart_id),
	CONSTRAINT "REL_c17aff091441b7c25ec3d68d36" UNIQUE (swap_id)
);


-- public.payment_session definition

-- Drop table

-- DROP TABLE public.payment_session;

CREATE TABLE public.payment_session (
	id varchar NOT NULL,
	cart_id varchar NOT NULL,
	provider_id varchar NOT NULL,
	is_selected bool NULL,
	status payment_session_status_enum NOT NULL,
	"data" jsonb NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	idempotency_key varchar NULL,
	CONSTRAINT "OneSelected" UNIQUE (cart_id, is_selected),
	CONSTRAINT "PK_a1a91b20f7f3b1e5afb5485cbcd" PRIMARY KEY (id)
);


-- public.refund definition

-- Drop table

-- DROP TABLE public.refund;

CREATE TABLE public.refund (
	id varchar NOT NULL,
	order_id varchar NOT NULL,
	amount int4 NOT NULL,
	note varchar NULL,
	reason refund_reason_enum NOT NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	metadata jsonb NULL,
	idempotency_key varchar NULL,
	CONSTRAINT "PK_f1cefa2e60d99b206c46c1116e5" PRIMARY KEY (id)
);


-- public."return" definition

-- Drop table

-- DROP TABLE public."return";

CREATE TABLE public."return" (
	id varchar NOT NULL,
	status return_status_enum NOT NULL DEFAULT 'requested'::return_status_enum,
	swap_id varchar NULL,
	order_id varchar NULL,
	shipping_data jsonb NULL,
	refund_amount int4 NOT NULL,
	received_at timestamptz NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	metadata jsonb NULL,
	idempotency_key varchar NULL,
	CONSTRAINT "PK_c8ad68d13e76d75d803b5aeebc4" PRIMARY KEY (id),
	CONSTRAINT "REL_bad82d7bff2b08b87094bfac3d" UNIQUE (swap_id)
);


-- public.return_item definition

-- Drop table

-- DROP TABLE public.return_item;

CREATE TABLE public.return_item (
	return_id varchar NOT NULL,
	item_id varchar NOT NULL,
	quantity int4 NOT NULL,
	is_requested bool NOT NULL DEFAULT true,
	requested_quantity int4 NULL,
	received_quantity int4 NULL,
	metadata jsonb NULL,
	CONSTRAINT "PK_46409dc1dd5f38509b9000c3069" PRIMARY KEY (return_id, item_id)
);


-- public.shipping_method definition

-- Drop table

-- DROP TABLE public.shipping_method;

CREATE TABLE public.shipping_method (
	id varchar NOT NULL,
	shipping_option_id varchar NOT NULL,
	order_id varchar NULL,
	cart_id varchar NULL,
	swap_id varchar NULL,
	return_id varchar NULL,
	price int4 NOT NULL,
	"data" jsonb NOT NULL,
	CONSTRAINT "CHK_3c00b878c1426d119cd70aa065" CHECK (((order_id IS NOT NULL) OR (cart_id IS NOT NULL) OR (swap_id IS NOT NULL) OR (return_id IS NOT NULL))),
	CONSTRAINT "CHK_64c6812fe7815be30d688df513" CHECK ((price >= 0)),
	CONSTRAINT "PK_b9b0adfad3c6b99229c1e7d4865" PRIMARY KEY (id),
	CONSTRAINT "REL_1d9ad62038998c3a85c77a53cf" UNIQUE (return_id)
);
CREATE INDEX "IDX_1d9ad62038998c3a85c77a53cf" ON public.shipping_method USING btree (return_id);
CREATE INDEX "IDX_5267705a43d547e232535b656c" ON public.shipping_method USING btree (order_id);
CREATE INDEX "IDX_d92993a7d554d84571f4eea1d1" ON public.shipping_method USING btree (cart_id);
CREATE INDEX "IDX_fb94fa8d5ca940daa2a58139f8" ON public.shipping_method USING btree (swap_id);
CREATE INDEX "IDX_fc963e94854bff2714ca84cd19" ON public.shipping_method USING btree (shipping_option_id);


-- public.swap definition

-- Drop table

-- DROP TABLE public.swap;

CREATE TABLE public.swap (
	id varchar NOT NULL,
	fulfillment_status swap_fulfillment_status_enum NOT NULL,
	payment_status swap_payment_status_enum NOT NULL,
	order_id varchar NOT NULL,
	difference_due int4 NULL,
	shipping_address_id varchar NULL,
	cart_id varchar NULL,
	confirmed_at timestamptz NULL,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	idempotency_key varchar NULL,
	CONSTRAINT "PK_4a10d0f359339acef77e7f986d9" PRIMARY KEY (id),
	CONSTRAINT "REL_402e8182bc553e082f6380020b" UNIQUE (cart_id)
);


-- public.address foreign keys

ALTER TABLE public.address ADD CONSTRAINT "FK_6df8c6bf969a51d24c1980c4ff4" FOREIGN KEY (country_code) REFERENCES country(iso_2);
ALTER TABLE public.address ADD CONSTRAINT "FK_9c9614b2f9d01665800ea8dbff7" FOREIGN KEY (customer_id) REFERENCES customer(id);


-- public.cart foreign keys

ALTER TABLE public.cart ADD CONSTRAINT "FK_242205c81c1152fab1b6e848470" FOREIGN KEY (customer_id) REFERENCES customer(id);
ALTER TABLE public.cart ADD CONSTRAINT "FK_484c329f4783be4e18e5e2ff090" FOREIGN KEY (region_id) REFERENCES region(id);
ALTER TABLE public.cart ADD CONSTRAINT "FK_6b9c66b5e36f7c827dfaa092f94" FOREIGN KEY (billing_address_id) REFERENCES address(id);
ALTER TABLE public.cart ADD CONSTRAINT "FK_9d1a161434c610aae7c3df2dc7e" FOREIGN KEY (payment_id) REFERENCES payment(id);
ALTER TABLE public.cart ADD CONSTRAINT "FK_ced15a9a695d2b5db9dabce763d" FOREIGN KEY (shipping_address_id) REFERENCES address(id);


-- public.cart_discounts foreign keys

ALTER TABLE public.cart_discounts ADD CONSTRAINT "FK_6680319ebe1f46d18f106191d59" FOREIGN KEY (cart_id) REFERENCES cart(id) ON DELETE CASCADE;
ALTER TABLE public.cart_discounts ADD CONSTRAINT "FK_8df75ef4f35f217768dc1135458" FOREIGN KEY (discount_id) REFERENCES discount(id) ON DELETE CASCADE;


-- public.cart_gift_cards foreign keys

ALTER TABLE public.cart_gift_cards ADD CONSTRAINT "FK_0fb38b6d167793192bc126d835e" FOREIGN KEY (gift_card_id) REFERENCES gift_card(id) ON DELETE CASCADE;
ALTER TABLE public.cart_gift_cards ADD CONSTRAINT "FK_d38047a90f3d42f0be7909e8aea" FOREIGN KEY (cart_id) REFERENCES cart(id) ON DELETE CASCADE;


-- public.customer foreign keys

ALTER TABLE public.customer ADD CONSTRAINT "FK_8abe81b9aac151ae60bf507ad15" FOREIGN KEY (billing_address_id) REFERENCES address(id);


-- public.fulfillment foreign keys

ALTER TABLE public.fulfillment ADD CONSTRAINT "FK_a52e234f729db789cf473297a5c" FOREIGN KEY (swap_id) REFERENCES swap(id);
ALTER TABLE public.fulfillment ADD CONSTRAINT "FK_beb35a6de60a6c4f91d5ae57e44" FOREIGN KEY (provider_id) REFERENCES fulfillment_provider(id);
ALTER TABLE public.fulfillment ADD CONSTRAINT "FK_f129acc85e346a10eed12b86fca" FOREIGN KEY (order_id) REFERENCES "order"(id);


-- public.fulfillment_item foreign keys

ALTER TABLE public.fulfillment_item ADD CONSTRAINT "FK_a033f83cc6bd7701a5687ab4b38" FOREIGN KEY (fulfillment_id) REFERENCES fulfillment(id);
ALTER TABLE public.fulfillment_item ADD CONSTRAINT "FK_e13ff60e74206b747a1896212d1" FOREIGN KEY (item_id) REFERENCES line_item(id);


-- public.gift_card foreign keys

ALTER TABLE public.gift_card ADD CONSTRAINT "FK_b6bcf8c3903097b84e85154eed3" FOREIGN KEY (region_id) REFERENCES region(id);
ALTER TABLE public.gift_card ADD CONSTRAINT "FK_dfc1f02bb0552e79076aa58dbb0" FOREIGN KEY (order_id) REFERENCES "order"(id);


-- public.gift_card_transaction foreign keys

ALTER TABLE public.gift_card_transaction ADD CONSTRAINT "FK_3ff5597f1d7e02bba41541846f4" FOREIGN KEY (gift_card_id) REFERENCES gift_card(id);
ALTER TABLE public.gift_card_transaction ADD CONSTRAINT "FK_d7d441b81012f87d4265fa57d24" FOREIGN KEY (order_id) REFERENCES "order"(id);


-- public.line_item foreign keys

ALTER TABLE public.line_item ADD CONSTRAINT "FK_27283ee631862266d0f1c680646" FOREIGN KEY (cart_id) REFERENCES cart(id);
ALTER TABLE public.line_item ADD CONSTRAINT "FK_3fa354d8d1233ff81097b2fcb6b" FOREIGN KEY (swap_id) REFERENCES swap(id);
ALTER TABLE public.line_item ADD CONSTRAINT "FK_43a2b24495fe1d9fc2a9c835bc7" FOREIGN KEY (order_id) REFERENCES "order"(id);
ALTER TABLE public.line_item ADD CONSTRAINT "FK_5371cbaa3be5200f373d24e3d5b" FOREIGN KEY (variant_id) REFERENCES product_variant(id);


-- public."order" foreign keys

ALTER TABLE public."order" ADD CONSTRAINT "FK_19b0c6293443d1b464f604c3316" FOREIGN KEY (shipping_address_id) REFERENCES address(id);
ALTER TABLE public."order" ADD CONSTRAINT "FK_5568d3b9ce9f7abeeb37511ecf2" FOREIGN KEY (billing_address_id) REFERENCES address(id);
ALTER TABLE public."order" ADD CONSTRAINT "FK_717a141f96b76d794d409f38129" FOREIGN KEY (currency_code) REFERENCES currency(code);
ALTER TABLE public."order" ADD CONSTRAINT "FK_c99a206eb11ad45f6b7f04f2dcc" FOREIGN KEY (cart_id) REFERENCES cart(id);
ALTER TABLE public."order" ADD CONSTRAINT "FK_cd7812c96209c5bdd48a6b858b0" FOREIGN KEY (customer_id) REFERENCES customer(id);
ALTER TABLE public."order" ADD CONSTRAINT "FK_e1fcce2b18dbcdbe0a5ba9a68b8" FOREIGN KEY (region_id) REFERENCES region(id);


-- public.order_discounts foreign keys

ALTER TABLE public.order_discounts ADD CONSTRAINT "FK_0fc1ec4e3db9001ad60c19daf16" FOREIGN KEY (discount_id) REFERENCES discount(id) ON DELETE CASCADE;
ALTER TABLE public.order_discounts ADD CONSTRAINT "FK_e7b488cebe333f449398769b2cc" FOREIGN KEY (order_id) REFERENCES "order"(id) ON DELETE CASCADE;


-- public.order_gift_cards foreign keys

ALTER TABLE public.order_gift_cards ADD CONSTRAINT "FK_e62ff11e4730bb3adfead979ee2" FOREIGN KEY (order_id) REFERENCES "order"(id) ON DELETE CASCADE;
ALTER TABLE public.order_gift_cards ADD CONSTRAINT "FK_f2bb9f71e95b315eb24b2b84cb3" FOREIGN KEY (gift_card_id) REFERENCES gift_card(id) ON DELETE CASCADE;


-- public.payment foreign keys

ALTER TABLE public.payment ADD CONSTRAINT "FK_4665f17abc1e81dd58330e58542" FOREIGN KEY (cart_id) REFERENCES cart(id);
ALTER TABLE public.payment ADD CONSTRAINT "FK_c17aff091441b7c25ec3d68d36c" FOREIGN KEY (swap_id) REFERENCES swap(id);
ALTER TABLE public.payment ADD CONSTRAINT "FK_f41553459a4b1491c9893ebc921" FOREIGN KEY (currency_code) REFERENCES currency(code);
ALTER TABLE public.payment ADD CONSTRAINT "FK_f5221735ace059250daac9d9803" FOREIGN KEY (order_id) REFERENCES "order"(id);


-- public.payment_session foreign keys

ALTER TABLE public.payment_session ADD CONSTRAINT "FK_d25ba0787e1510ddc5d442ebcfa" FOREIGN KEY (cart_id) REFERENCES cart(id);


-- public.refund foreign keys

ALTER TABLE public.refund ADD CONSTRAINT "FK_eec9d9af4ca098e19ea6b499eaa" FOREIGN KEY (order_id) REFERENCES "order"(id);


-- public."return" foreign keys

ALTER TABLE public."return" ADD CONSTRAINT "FK_bad82d7bff2b08b87094bfac3d6" FOREIGN KEY (swap_id) REFERENCES swap(id);
ALTER TABLE public."return" ADD CONSTRAINT "FK_d4bd17f918fc6c332b74a368c36" FOREIGN KEY (order_id) REFERENCES "order"(id);


-- public.return_item foreign keys

ALTER TABLE public.return_item ADD CONSTRAINT "FK_7edab75b4fc88ea6d4f2574f087" FOREIGN KEY (return_id) REFERENCES return(id);
ALTER TABLE public.return_item ADD CONSTRAINT "FK_87774591f44564effd8039d7162" FOREIGN KEY (item_id) REFERENCES line_item(id);


-- public.shipping_method foreign keys

ALTER TABLE public.shipping_method ADD CONSTRAINT "FK_1d9ad62038998c3a85c77a53cfb" FOREIGN KEY (return_id) REFERENCES return(id);
ALTER TABLE public.shipping_method ADD CONSTRAINT "FK_5267705a43d547e232535b656c2" FOREIGN KEY (order_id) REFERENCES "order"(id);
ALTER TABLE public.shipping_method ADD CONSTRAINT "FK_d92993a7d554d84571f4eea1d13" FOREIGN KEY (cart_id) REFERENCES cart(id);
ALTER TABLE public.shipping_method ADD CONSTRAINT "FK_fb94fa8d5ca940daa2a58139f86" FOREIGN KEY (swap_id) REFERENCES swap(id);
ALTER TABLE public.shipping_method ADD CONSTRAINT "FK_fc963e94854bff2714ca84cd193" FOREIGN KEY (shipping_option_id) REFERENCES shipping_option(id);


-- public.swap foreign keys

ALTER TABLE public.swap ADD CONSTRAINT "FK_402e8182bc553e082f6380020b4" FOREIGN KEY (cart_id) REFERENCES cart(id);
ALTER TABLE public.swap ADD CONSTRAINT "FK_52dd74e8c989aa5665ad2852b8b" FOREIGN KEY (order_id) REFERENCES "order"(id);
ALTER TABLE public.swap ADD CONSTRAINT "FK_f5189d38b3d3bd496618bf54c57" FOREIGN KEY (shipping_address_id) REFERENCES address(id);