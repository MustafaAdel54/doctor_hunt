import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

class AuthService {
  const AuthService({
    required this.auth,
    required this.firestore,
    required this.googleSignIn,
  });

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  Future<UserModel> loginWithEmail(String email, String password) async {
    final cred = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user == null) throw const ServerException('No user returned');

    final doc = await firestore.collection(FbC.users).doc(user.uid).get();
    if (!doc.exists) throw const ServerException('User profile not found');

    return UserModel.fromJson(doc.data()!);
  }

  /// Creates a Firebase Auth account with email + password ONLY.
  ///
  /// Does NOT write to Firestore. The session will transition to
  /// [authenticatedWithoutProfile] and the user will be sent to
  /// Role Selection to complete their profile.
  Future<User> registerWithEmailOnly(
    String email,
    String password,
    String name,
  ) async {
    final cred = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user == null) throw const ServerException('No user returned');

    // Update the Firebase Auth display name so it is available in Role Selection.
    await user.updateDisplayName(name);
    return user;
  }

  /// Creates the Firestore application profile for any authenticated user.
  ///
  /// Called from Role Selection after the user picks Patient or Doctor.
  /// Works for both email-registered users and Google Sign-In users.
  /// The [SessionService] Firestore stream fires automatically after this write,
  /// transitioning the session to [authenticated] and routing to the correct home.
  Future<UserModel> createUserProfile({
    required String uid,
    required String email,
    required String role,
    String? name,
    String? photoUrl,
    String? phone,
    bool isVerified = false,
  }) async {
    final userModel = UserModel(
      uid: uid,
      email: email,
      role: role,
      name: name,
      photoUrl: photoUrl,
      phone: phone,
      isVerified: isVerified,
    );

    await firestore.collection(FbC.users).doc(uid).set(userModel.toJson());
    return userModel;
  }

  /// Performs Google OAuth and Firebase credential sign-in ONLY.
  ///
  /// Does NOT check Firestore. Does NOT create a user profile.
  /// The [SessionService] Firestore listener determines whether a profile
  /// exists and emits the appropriate session state.
  Future<User> loginWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw const ServerException('Google sign in cancelled');
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final authResult = await auth.signInWithCredential(credential);
    final user = authResult.user;
    if (user == null) {
      throw const ServerException(
        'No Firebase user returned from Google credential',
      );
    }

    return user;
  }

  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await Future.wait([
      auth.signOut(),
      if (await googleSignIn.isSignedIn()) googleSignIn.signOut(),
    ]);
  }
}
