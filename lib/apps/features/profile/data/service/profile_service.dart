import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../auth/data/models/user_model.dart';

class ProfileService {
  const ProfileService({required this.firestore});

  final FirebaseFirestore firestore;

  Future<UserModel> getProfile(String uid) async {
    final doc = await firestore.collection(SbC.users).doc(uid).get();
    if (!doc.exists) throw const ServerException('Profile not found');

    return UserModel.fromJson(doc.data()!);
  }

  Future<void> updateProfile(UserModel user) async {
    await firestore
        .collection(SbC.users)
        .doc(user.uid)
        .set(user.toJson(), SetOptions(merge: true));
  }

  Future<void> updateActiveStatus(String uid, bool isActive) async {
    await firestore.collection(SbC.users).doc(uid).update({
      SbC.isActive: isActive,
    });
  }
}
