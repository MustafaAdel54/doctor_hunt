abstract final class SupabaseConfig {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://spvsllxjtbwyfpdvfqgg.supabase.co',
  );
  
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNwdnNsbHhqdGJ3eWZwZHZmcWdnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTAwNTA5MzYsImV4cCI6MjEwNTYyNjkzNn0.uCvl8rImq1UjBvcs1eAfB0otGOsGNyT_t0yhbkr-3Us',
  );
}

/// Supabase Table, Column, and RPC Constants
abstract final class SbC {
  // Tables
  static const String profiles = 'profiles';
  static const String doctors = 'doctors';
  static const String appointments = 'appointments';
  static const String availability = 'availability';
  static const String reviews = 'reviews';
  static const String favorites = 'favorites';

  // Legacy Fields for compilation until services are migrated
  static const String users = 'profiles'; // Mapped to profiles
  static const String role = 'role';
  static const String isVerified = 'is_verified';
  static const String isActive = 'is_active';
  static const String email = 'email';
  static const String patientId = 'patient_id';
  static const String doctorId = 'doctor_id';
  static const String status = 'status';
  static const String startTime = 'start_time';
  static const String rating = 'rating';
  static const String ratingSum = 'rating_sum';
  static const String ratingCount = 'rating_count';

  // RPCs
  static const String createProfile = 'create_profile';
  static const String deactivateAccount = 'deactivate_account';
  static const String bookAppointment = 'book_appointment';
  static const String cancelAppointment = 'cancel_appointment';
  static const String updateAppointmentStatus = 'update_appointment_status';
  static const String addReview = 'add_review';
  static const String updateReview = 'update_review';
}
