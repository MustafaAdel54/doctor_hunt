abstract final class SupabaseConfig {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://YOUR_SUPABASE_PROJECT.supabase.co',
  );
  
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGci...',
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

  // RPCs
  static const String createProfile = 'create_profile';
  static const String deactivateAccount = 'deactivate_account';
  static const String bookAppointment = 'book_appointment';
  static const String cancelAppointment = 'cancel_appointment';
  static const String updateAppointmentStatus = 'update_appointment_status';
  static const String addReview = 'add_review';
  static const String updateReview = 'update_review';
}
