-- NGMVP tables for the existing NGM Supabase project.
-- Run in Supabase SQL Editor. These tables are separate from NGM membership data.
create extension if not exists pgcrypto;

create table if not exists public.ngmvp_incident_reports (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  election_type text not null check (length(election_type) <= 80),
  state text not null check (length(state) <= 80),
  lga text not null check (length(lga) <= 100),
  ward_or_area text not null default '' check (length(ward_or_area) <= 120),
  polling_unit_reference text not null default '' check (length(polling_unit_reference) <= 120),
  incident_category text not null check (length(incident_category) <= 100),
  incident_date date not null,
  description text not null check (length(description) between 20 and 4000),
  reporter_contact text not null default '' check (length(reporter_contact) <= 160),
  status text not null default 'submitted' check (status in ('submitted','under_review','referred','closed'))
);

create table if not exists public.ngmvp_observer_applications (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  full_name text not null check (length(full_name) between 2 and 140),
  email text not null check (length(email) <= 254),
  phone text not null default '' check (length(phone) <= 40),
  state text not null check (length(state) <= 80),
  lga text not null check (length(lga) <= 100),
  experience text not null default '' check (length(experience) <= 1500),
  status text not null default 'pending' check (status in ('pending','contacted','approved','declined'))
);

alter table public.ngmvp_incident_reports enable row level security;
alter table public.ngmvp_observer_applications enable row level security;

-- Public may submit but cannot read, update or delete records through the anon key.
-- No public SELECT policy is intentionally created.
drop policy if exists "Public may submit NGMVP incident reports" on public.ngmvp_incident_reports;
create policy "Public may submit NGMVP incident reports"
  on public.ngmvp_incident_reports for insert to anon, authenticated
  with check (status = 'submitted');

drop policy if exists "Public may submit NGMVP observer applications" on public.ngmvp_observer_applications;
create policy "Public may submit NGMVP observer applications"
  on public.ngmvp_observer_applications for insert to anon, authenticated
  with check (status = 'pending');

-- Add reviewer SELECT/UPDATE policies only after creating a secure reviewer role/workflow.
-- Do NOT put the Supabase service_role key in browser code.
