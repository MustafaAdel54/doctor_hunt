import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoctorModel Tests', () {
    test('fromJson deserializes real Supabase public.doctors record correctly', () {
      final json = {
        'id': 'b1c2d3e4-5678-90ab-cdef-111111111111',
        'name': {'en': 'Dr. Fillerup Grab', 'ar': 'د. فيليروب جراب'},
        'image': 'assets/images/home/pop_doc_1.png',
        'phone': '+1234567890',
        'rating_sum': 190,
        'rating_count': 40,
        'specialization': 'Specialist Cardiologist',
        'years_experience': 9,
        'patients_count': 1200,
        'running_count': 150,
        'ongoing_count': 850,
        'hourly_rate': 35.0,
        'services': ['Cardiology Consultation', 'ECG'],
        'created_at': '2026-01-01T12:00:00Z',
      };

      final doctor = DoctorModel.fromJson(json);

      expect(doctor.id, 'b1c2d3e4-5678-90ab-cdef-111111111111');
      expect(doctor.name['en'], 'Dr. Fillerup Grab');
      expect(doctor.name['ar'], 'د. فيليروب جراب');
      expect(doctor.image, 'assets/images/home/pop_doc_1.png');
      expect(doctor.phone, '+1234567890');
      expect(doctor.ratingSum, 190);
      expect(doctor.ratingCount, 40);
      expect(doctor.rating, 4.75);
      expect(doctor.specialization, 'Specialist Cardiologist');
      expect(doctor.yearsExperience, 9);
      expect(doctor.patientsCount, 1200);
      expect(doctor.runningCount, 150);
      expect(doctor.ongoingCount, 850);
      expect(doctor.hourlyRate, 35.0);
      expect(doctor.services, ['Cardiology Consultation', 'ECG']);
    });

    test('localizedName returns correct language based on locale', () {
      const doctor = DoctorModel(
        id: 'test-id',
        name: {'en': 'Dr. John', 'ar': 'د. جون'},
        phone: '123',
        ratingSum: 10,
        ratingCount: 2,
        specialization: 'Dentist',
        yearsExperience: 5,
        patientsCount: 100,
        runningCount: 10,
        ongoingCount: 50,
        hourlyRate: 25.0,
        services: [],
      );

      expect(doctor.localizedName('en'), 'Dr. John');
      expect(doctor.localizedName('ar'), 'د. جون');
      // Fallback for unsupported locale
      expect(doctor.localizedName('fr'), 'Dr. John');
    });

    test('rating returns 0.0 when ratingCount is 0 to avoid division by zero', () {
      const doctor = DoctorModel(
        id: 'test-id',
        name: {'en': 'Dr. New'},
        phone: '123',
        ratingSum: 0,
        ratingCount: 0,
        specialization: 'Surgeon',
        yearsExperience: 1,
        patientsCount: 0,
        runningCount: 0,
        ongoingCount: 0,
        hourlyRate: 20.0,
        services: [],
      );

      expect(doctor.rating, 0.0);
    });

    test('hasValidImage identifies empty, null, and valid image strings', () {
      const docWithAsset = DoctorModel(
        name: {'en': 'Dr. A'},
        image: 'assets/doc.png',
        phone: '',
        ratingSum: 0,
        ratingCount: 0,
        specialization: '',
        yearsExperience: 0,
        patientsCount: 0,
        runningCount: 0,
        ongoingCount: 0,
        hourlyRate: 0,
        services: [],
      );
      expect(docWithAsset.hasValidImage, isTrue);

      const docWithUrl = DoctorModel(
        name: {'en': 'Dr. B'},
        image: 'https://example.com/doc.png',
        phone: '',
        ratingSum: 0,
        ratingCount: 0,
        specialization: '',
        yearsExperience: 0,
        patientsCount: 0,
        runningCount: 0,
        ongoingCount: 0,
        hourlyRate: 0,
        services: [],
      );
      expect(docWithUrl.hasValidImage, isTrue);

      const docWithNull = DoctorModel(
        name: {'en': 'Dr. C'},
        image: null,
        phone: '',
        ratingSum: 0,
        ratingCount: 0,
        specialization: '',
        yearsExperience: 0,
        patientsCount: 0,
        runningCount: 0,
        ongoingCount: 0,
        hourlyRate: 0,
        services: [],
      );
      expect(docWithNull.hasValidImage, isFalse);

      const docWithEmpty = DoctorModel(
        name: {'en': 'Dr. D'},
        image: '   ',
        phone: '',
        ratingSum: 0,
        ratingCount: 0,
        specialization: '',
        yearsExperience: 0,
        patientsCount: 0,
        runningCount: 0,
        ongoingCount: 0,
        hourlyRate: 0,
        services: [],
      );
      expect(docWithEmpty.hasValidImage, isFalse);
    });

    test('formattedHourlyRate formats correctly', () {
      const doctor = DoctorModel(
        name: {'en': 'Dr. Hourly'},
        hourlyRate: 28.5,
        phone: '',
        ratingSum: 0,
        ratingCount: 0,
        specialization: '',
        yearsExperience: 0,
        patientsCount: 0,
        runningCount: 0,
        ongoingCount: 0,
        services: [],
      );

      expect(doctor.formattedHourlyRate, '\$ 28.50/ hours');
    });
  });
}
