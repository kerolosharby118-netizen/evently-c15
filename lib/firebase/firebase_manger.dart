// lib/firebase/firebase_manager.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_dm.dart';

class FirebaseManager {
  // إنشاء GoogleSignIn object
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  // تسجيل الدخول باستخدام Google
  static Future<User?> signInWithGoogle() async {
    try {
      // تسجيل الدخول بشكل تفاعلي
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // المستخدم ألغى تسجيل الدخول

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // تسجيل الدخول في Firebase
      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // جلب بيانات المستخدم من Firestore
      UserDM.currentUser =
      await getFromUserFirestore(userCredential.user!.uid);

      return userCredential.user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  // تسجيل الدخول بالبريد وكلمة السر
  static Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      UserDM.currentUser =
      await getFromUserFirestore(userCredential.user!.uid);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Email Sign-In Error: $e");
      throw e;
    }
  }

  // تسجيل خروج
  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    UserDM.currentUser = null;
  }

  // جلب بيانات المستخدم من Firestore
  static Future<UserDM> getFromUserFirestore(String uid) async {
    final doc =
    await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserDM.fromJson(doc.data()!);
    } else {
      return UserDM(
        id: uid,
        name: 'Unknown',
        email: 'Unknown',
        favoriteEvents: [],
      );
    }
  }
}
