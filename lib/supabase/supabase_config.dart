String get supabaseUrl => _urlMap[env] ?? '';
String get supabaseAnonKey => _keyMap[env] ?? '';

late String env;

const _urlMap = {
  'dev': 'https://vfjzaffjjqbypvtiyrfv.supabase.co',
  'staging': 'https://vfjzaffjjqbypvtiyrfv.supabase.co',
  'prod': 'https://vfjzaffjjqbypvtiyrfv.supabase.co',
};

const _keyMap = {
  'dev': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZmanphZmZqanFieXB2dGl5cmZ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMzMzg1MTAsImV4cCI6MjA2ODkxNDUxMH0.nFE0CJIqbirVvwikKraZXJCCY35gVX4iZr79E84zTPY',
  'staging': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZmanphZmZqanFieXB2dGl5cmZ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMzMzg1MTAsImV4cCI6MjA2ODkxNDUxMH0.nFE0CJIqbirVvwikKraZXJCCY35gVX4iZr79E84zTPY',
  'prod': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZmanphZmZqanFieXB2dGl5cmZ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMzMzg1MTAsImV4cCI6MjA2ODkxNDUxMH0.nFE0CJIqbirVvwikKraZXJCCY35gVX4iZr79E84zTPY',
};


