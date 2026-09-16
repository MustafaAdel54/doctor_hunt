/// Firebase Collection and Field Constants
abstract final class FbC {
  // Collections
  static const String users = 'users';
  static const String doctors = 'doctors';
  static const String appointments = 'appointments';
  static const String slotLocks = 'slotLocks';
  static const String availability = 'availability';

  // Fields - Users
  static const String role = 'role';
  static const String isVerified = 'isVerified';
  static const String isActive = 'isActive';
  static const String email = 'email';

  // Fields - Appointments
  static const String patientId = 'patientId';
  static const String doctorId = 'doctorId';
  static const String slotLockId = 'slotLockId';
  static const String status = 'status';
  static const String startTime = 'startTime';

  // Subcollections
  static const String reviews = 'reviews';

  // Fields - Reviews
  static const String rating = 'rating';

  // Fields - Doctors (aggregates)
  static const String ratingSum = 'ratingSum';
  static const String ratingCount = 'ratingCount';
}
