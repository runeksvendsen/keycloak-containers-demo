-- role: read/write access
CREATE ROLE standard NOLOGIN;
-- role: private read/write access
GRANT USAGE ON SCHEMA public TO standard; -- required to grant access to tables within "public"
-- grant "standard" user READ/WRITE access to "product" table
GRANT ALL ON public.product TO standard;

-- role: public website access
CREATE ROLE web_anon NOLOGIN;
GRANT USAGE ON SCHEMA public TO web_anon; -- required to grant access to tables within "public"
-- grant public READ access to "product" table
grant select on public.product to web_anon;

-- request.jwt.claim.sub is "subject": a unique identifier for the user (a GUID within Keycloak).
-- This field is provisionned by Keycloak, and the JWT token has been verified by the database accessor.
ALTER TABLE public."user" ADD user_from NAME NOT NULL DEFAULT current_setting('request.jwt.claim.sub', true);
ALTER TABLE public."user" ADD role      NAME NOT NULL DEFAULT current_user;
-- TODO: migrate existing users: which "user_from" and "role"?

-- enable RLS for "users" table
GRANT ALL ON public.user TO standard;
ALTER TABLE public.user ENABLE ROW LEVEL SECURITY;
-- give a user access to only their own user info
CREATE POLICY users_rls_policy_1 ON public.user
  USING (user_from = current_setting('request.jwt.claim.sub', true)) -- access to: SELECT, UPDATE, DELETE
  WITH CHECK (user_from = current_setting('request.jwt.claim.sub', true)); -- access to: INSERT, UPDATE
