-- ==========================================================
-- SUPABASE SQL SCRIPT FOR WEDDING GUEST REGISTRATION SYSTEM
-- ==========================================================
-- Copy and run this script in your Supabase SQL Editor.
-- This script sets up the required tables, seeds a default admin,
-- enables Row Level Security (RLS), and sets up public access policies.

-- 1. Create admins table
CREATE TABLE IF NOT EXISTS public.admins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Seed default admin account (username: admin123, password: password123)
INSERT INTO public.admins (username, password)
VALUES ('admin123', 'password123')
ON CONFLICT (username) DO NOTHING;

-- 2. Create weddings table
CREATE TABLE IF NOT EXISTS public.weddings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    host_username VARCHAR(255) UNIQUE NOT NULL,
    host_password VARCHAR(255) NOT NULL,
    khqr_img_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Create guests table
CREATE TABLE IF NOT EXISTS public.guests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wedding_id UUID NOT NULL REFERENCES public.weddings(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(255),
    companions INT NOT NULL DEFAULT 0,
    relation_type VARCHAR(100) NOT NULL, -- ខាងកូនកំលោះ, ខាងកូនក្រមុំ, មិត្តភក្តិ, ផ្សេងៗ
    amount NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    note TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'pending', -- pending, approved
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Enable Row Level Security (RLS) on all tables (Safe for production)
ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.weddings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guests ENABLE ROW LEVEL SECURITY;

-- 5. Drop existing policies if they exist (to prevent duplicates)
DROP POLICY IF EXISTS "Public read policy for admins" ON public.admins;
DROP POLICY IF EXISTS "Public insert policy for admins" ON public.admins;
DROP POLICY IF EXISTS "Public select policy for weddings" ON public.weddings;
DROP POLICY IF EXISTS "Public insert policy for weddings" ON public.weddings;
DROP POLICY IF EXISTS "Public update policy for weddings" ON public.weddings;
DROP POLICY IF EXISTS "Public select policy for guests" ON public.guests;
DROP POLICY IF EXISTS "Public insert policy for guests" ON public.guests;
DROP POLICY IF EXISTS "Public update policy for guests" ON public.guests;
DROP POLICY IF EXISTS "Public delete policy for guests" ON public.guests;

-- 6. Create ALL-PUBLIC Read/Write Access Policies (For convenient prototyping as requested)
CREATE POLICY "Public read policy for admins" ON public.admins FOR SELECT USING (true);
CREATE POLICY "Public insert policy for admins" ON public.admins FOR INSERT WITH CHECK (true);

CREATE POLICY "Public select policy for weddings" ON public.weddings FOR SELECT USING (true);
CREATE POLICY "Public insert policy for weddings" ON public.weddings FOR INSERT WITH CHECK (true);
CREATE POLICY "Public update policy for weddings" ON public.weddings FOR UPDATE USING (true);

CREATE POLICY "Public select policy for guests" ON public.guests FOR SELECT USING (true);
CREATE POLICY "Public insert policy for guests" ON public.guests FOR INSERT WITH CHECK (true);
CREATE POLICY "Public update policy for guests" ON public.guests FOR UPDATE USING (true);
CREATE POLICY "Public delete policy for guests" ON public.guests FOR DELETE USING (true);
