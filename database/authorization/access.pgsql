-- role: public website access
CREATE ROLE web_anon NOLOGIN;

-- grant READ access to public website: "storefront" (/store/*)
GRANT USAGE ON SCHEMA api TO web_anon;
grant select on api.roles_example to web_anon;

-- role: read/write access
CREATE ROLE standard NOLOGIN;
GRANT USAGE ON SCHEMA api TO standard;
GRANT ALL ON api.roles_example TO standard;


-- TODO: example "users" table w/ RLS
CREATE TABLE api.users_example (
  uuid            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  message_time    TIMESTAMP NOT NULL DEFAULT now(),
  user_from       NAME      NOT NULL DEFAULT current_setting('request.jwt.claim.sub', true),
  role            NAME      NOT NULL DEFAULT current_user,
  message_body    TEXT
);

GRANT ALL ON api.users_example TO standard;

ALTER TABLE api.users_example ENABLE ROW LEVEL SECURITY;

-- Keycloak provides JWT ("jwtData"), database accessor
--  must execute "set_config('request.jwt.data', jwtData)" for each user.
CREATE POLICY users_example_rls_policy ON api.users_example
  USING (user_from = current_setting('request.jwt.claim.sub', true))
  WITH CHECK (user_from = current_setting('request.jwt.claim.sub', true));