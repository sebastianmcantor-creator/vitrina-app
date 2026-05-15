CREATE TABLE IF NOT EXISTS public.social_posts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE NOT NULL,
  caption TEXT NOT NULL,
  image_url TEXT,
  platforms TEXT[] DEFAULT ARRAY['instagram'],
  scheduled_at TIMESTAMPTZ,
  status TEXT DEFAULT 'draft' CHECK (status IN ('draft','scheduled','publishing','published','failed','cancelled')),
  ig_container_id TEXT,
  ig_post_id TEXT,
  fb_post_id TEXT,
  error_msg TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  published_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS social_posts_restaurant_idx ON public.social_posts(restaurant_id);
CREATE INDEX IF NOT EXISTS social_posts_status_idx ON public.social_posts(status, scheduled_at);
ALTER TABLE public.social_posts ENABLE ROW LEVEL SECURITY;
GRANT ALL ON public.social_posts TO service_role;
