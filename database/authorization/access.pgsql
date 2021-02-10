-- request.jwt.claim.sub is "subject": a unique identifier for the user (a GUID within Keycloak).
-- This field is provisionned by Keycloak, and the JWT token has been verified by the database accessor.
ALTER TABLE public."user" ADD user_from NAME NOT NULL DEFAULT current_setting('request.jwt.claim.sub', true);
ALTER TABLE public."user" ADD role      NAME NOT NULL DEFAULT current_user;
-- TODO: migrate existing users: which "user_from" and "role"?


-- role: read/write access
CREATE ROLE admin NOLOGIN;
-- role: private read/write access
GRANT USAGE ON SCHEMA public TO admin; -- required to grant access to tables within "public"
-- grant "admin" user READ/WRITE access to "product" table
GRANT ALL ON public.product TO admin;
GRANT ALL ON public.user TO admin;

-- role: public website access
CREATE ROLE web_anon NOLOGIN;
GRANT USAGE ON SCHEMA public TO web_anon; -- required to grant access to tables within "public"
-- grant public READ access to "product" table
grant select on public.product to web_anon;
-- NB: no access to "public.user"

-- role: authenticated website access
CREATE ROLE web_user NOLOGIN;
GRANT USAGE ON SCHEMA public TO web_user; -- required to grant access to tables within "public"
-- grant public READ access to "product" table
grant select on public.product to web_user;
-- NB: "web_user" only has access to own user because of RLS (see below)
GRANT ALL ON public.user TO web_user;

-- enable RLS for "users" table
ALTER TABLE public.user ENABLE ROW LEVEL SECURITY;
-- give "web_user" access to only their own user info
CREATE POLICY users_policy_web_user ON public.user TO web_user
  USING (user_from = current_setting('request.jwt.claim.sub', true)) -- access to: SELECT, UPDATE, DELETE
  WITH CHECK (user_from = current_setting('request.jwt.claim.sub', true)); -- access to: INSERT, UPDATE
-- give "admin" access to all users
CREATE POLICY users_policy_admin ON public.user TO admin
  USING (true);