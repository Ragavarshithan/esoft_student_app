-- Esoft Uni Student Performance App - Supabase PostgreSQL Schema

-- 1. Create Enums for Role
CREATE TYPE user_role AS ENUM ('admin', 'student', 'lecturer');

-- 2. Create Users Table (Linked to Supabase Auth)
CREATE TABLE public.users (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  role user_role NOT NULL DEFAULT 'student',
  name TEXT NOT NULL,
  fcm_token TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Trigger to automatically create a user on sign up is omitted here, 
-- but normally you would want to trigger inserting into public.users.

-- 3. Courses
CREATE TABLE public.courses (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  code VARCHAR(50) UNIQUE NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Batches
CREATE TABLE public.batches (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
  name TEXT NOT NULL, -- e.g., 'Semester 1 - 2024'
  year INTEGER,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. Modules
CREATE TABLE public.modules (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  code VARCHAR(50) NOT NULL,
  credits INTEGER DEFAULT 3,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. Many-to-Many: Student <-> Batch
CREATE TABLE public.student_batches (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  student_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  batch_id UUID REFERENCES public.batches(id) ON DELETE CASCADE,
  assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(student_id, batch_id)
);

-- 7. Many-to-Many: Lecturer <-> Module
CREATE TABLE public.lecturer_modules (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  lecturer_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  module_id UUID REFERENCES public.modules(id) ON DELETE CASCADE,
  assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(lecturer_id, module_id)
);

-- 8. Assignments
CREATE TABLE public.assignments (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  module_id UUID REFERENCES public.modules(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  due_date TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 9. Marks
CREATE TABLE public.marks (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  student_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  module_id UUID REFERENCES public.modules(id) ON DELETE CASCADE,
  assignment_id UUID REFERENCES public.assignments(id) ON DELETE SET NULL, -- optional
  score NUMERIC NOT NULL,
  type VARCHAR(50) DEFAULT 'Exam', -- 'Exam', 'Coursework'
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 10. Attendance
CREATE TABLE public.attendance (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  student_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  module_id UUID REFERENCES public.modules(id) ON DELETE CASCADE,
  batch_id UUID REFERENCES public.batches(id) ON DELETE CASCADE,
  class_date DATE NOT NULL,
  is_present BOOLEAN DEFAULT FALSE,
  UNIQUE(student_id, module_id, class_date)
);

-- 11. Messages (Real-time Chat)
CREATE TABLE public.chats (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_1 UUID REFERENCES public.users(id) ON DELETE CASCADE,
  user_2 UUID REFERENCES public.users(id) ON DELETE CASCADE,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.messages (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  chat_id UUID REFERENCES public.chats(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  text TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 12. Set Row Level Security (RLS) - Basic (Update as needed)
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.batches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.modules ENABLE ROW LEVEL SECURITY;

-- Examples of Admin Policies (You will want to refine these)
CREATE POLICY "Admins can do everything on Users" ON public.users
  FOR ALL USING ( (SELECT role FROM public.users WHERE id = auth.uid()) = 'admin' );

CREATE POLICY "Users can view their own profile" ON public.users
  FOR SELECT USING ( id = auth.uid() );
  
-- Allow lecturers to read students
CREATE POLICY "Lecturer can read students" ON public.users
  FOR SELECT USING ( (SELECT role FROM public.users WHERE id = auth.uid()) = 'lecturer' );

-- (Run these SQL commands in Supabase SQL editor)
