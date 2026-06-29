-- =====================================================================
-- FitArena - Skema Supabase (profiles: XP/level + 6 badge gallery)
-- Jalankan di: Supabase Dashboard > SQL Editor > Run.
-- (Sudah diterapkan ke project lloibeyejbqfqklnimtn via migration.)
-- =====================================================================

create table if not exists public.profiles (
  id                  uuid primary key references auth.users (id) on delete cascade,
  full_name           text,
  title               text    default 'SPARK',   -- nama tier (dihitung dari level)
  level               int     default 1,
  current_xp          int     default 0,
  xp_to_next          int     default 650,        -- (level*150)+500 untuk level 1
  points_total        int     default 0,
  minutes_training    int     default 0,
  current_streak      int     default 0,          -- juga dipakai badge Iron Streak (14 hari)
  last_active_date    date,
  sessions_completed  int     default 0,
  sessions_hosted     int     default 0,
  badges              text[]  default '{}',        -- key badge yang sudah terbuka
  -- Metrik 6 badge (Badge Gallery)
  bg_dynamic_duo      int     default 0,           -- sesi grup selesai (target 60)
  bg_early_bird       int     default 0,           -- sesi 04:00-06:30 (target 20)
  bg_trendsetter      int     default 0,           -- host terisi >=80% (target 20)
  bg_active_followers int     default 0,           -- ikut sesi orang lain (target 20)
  bg_locations        text[]  default '{}',         -- lokasi unik (target 20 distinct)
  preferences         text[]  default '{}',          -- olahraga favorit (onboarding)
  onboarded           boolean default false,         -- sudah isi nama + preferensi?
  created_at          timestamptz default now()
);

-- Untuk DB lama: tambahkan kolom yang belum ada.
alter table public.profiles add column if not exists sessions_completed int default 0;
alter table public.profiles add column if not exists sessions_hosted int default 0;
alter table public.profiles add column if not exists badges text[] default '{}';
alter table public.profiles add column if not exists last_active_date date;
alter table public.profiles add column if not exists bg_dynamic_duo int default 0;
alter table public.profiles add column if not exists bg_early_bird int default 0;
alter table public.profiles add column if not exists bg_trendsetter int default 0;
alter table public.profiles add column if not exists bg_active_followers int default 0;
alter table public.profiles add column if not exists bg_locations text[] default '{}';
alter table public.profiles add column if not exists preferences text[] default '{}';
alter table public.profiles add column if not exists onboarded boolean default false;

-- Row Level Security: tiap user hanya akses profilnya sendiri.
alter table public.profiles enable row level security;

drop policy if exists "select own profile" on public.profiles;
create policy "select own profile" on public.profiles
  for select using (auth.uid() = id);

drop policy if exists "insert own profile" on public.profiles;
create policy "insert own profile" on public.profiles
  for insert with check (auth.uid() = id);

drop policy if exists "update own profile" on public.profiles;
create policy "update own profile" on public.profiles
  for update using (auth.uid() = id);

-- Trigger: buat profil otomatis untuk user baru.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'full_name', 'ATHLETE'));
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Backfill profil untuk user yang sudah terdaftar.
insert into public.profiles (id, full_name)
select id, coalesce(raw_user_meta_data ->> 'full_name', 'ATHLETE')
from auth.users
on conflict (id) do nothing;
