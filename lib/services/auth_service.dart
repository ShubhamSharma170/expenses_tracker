import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthResult {
  final bool isSuccess;
  final String? errorMessage;

  AuthResult.success() : isSuccess = true, errorMessage = null;
  AuthResult.failure(this.errorMessage) : isSuccess = false;
}

class AuthServiceClass {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getter for auth state stream & current user
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // Method for signup
  Future<AuthResult> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': email.trim(),
        'name': name.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return AuthResult.failure(
        e.message ?? "An unknown error occurred. Please try again later.",
      );
    } catch (e) {
      debugPrint(e.toString());
      return AuthResult.failure(
        "An unknown error occurred. Please try again later.",
      );
    }
  }

  // Method for login
  Future<AuthResult> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return AuthResult.success();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return AuthResult.failure(
        e.message ?? "An unknown error occurred. Please try again later.",
      );
    } catch (e) {
      debugPrint(e.toString());
      return AuthResult.failure(
        "An unknown error occurred. Please try again later.",
      );
    }
  }

  // Method for logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

// =========================================================================
// PROVIDER LAYER (Connects UI with AuthServiceClass)
// =========================================================================
class AuthClassProvider extends ChangeNotifier {
  final AuthServiceClass _authService = AuthServiceClass();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? get currentUser => _authService.currentUser;
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _setLoading(true);
    final result = await _authService.signUpWithEmailAndPassword(
      email,
      password,
      name,
    );
    _setLoading(false);
    return result;
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    final result = await _authService.loginWithEmailAndPassword(
      email,
      password,
    );
    _setLoading(false);
    return result;
  }

  Future<void> logout() async {
    await _authService.signOut();
    notifyListeners();
  }
}

// // ignore_for_file: unused_local_variable

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthResult {
//   final bool isSuccess;
//   final String? errorMessage;

//   AuthResult.success() : isSuccess = true, errorMessage = null;
//   AuthResult.failure(this.errorMessage) : isSuccess = false;
// }

// class AuthServiceClass {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   // method for signup
//   Future<AuthResult> signUpWithEmailAndPassword(
//     String email,
//     String password,
//     String name,
//   ) async {
//     UserCredential? userCredential;
//     try {
//       final userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email.trim(),
//         password: password,
//       );
//       await firestore.collection('users').doc(userCredential.user?.uid).set({
//         'uid': userCredential.user?.uid,
//         'email': email,
//         'name': name,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//       return AuthResult.success();
//     } on FirebaseAuthException catch (e) {
//       print(e.message);
//       return AuthResult.failure(
//         e.message ?? "An unknown error occurred. Please try again later.",
//       );
//     } catch (e) {
//       print(e);
//       return AuthResult.failure(
//         "An unknown error occurred. Please try again later.",
//       );
//     }
//   }

//   // method for login
//   Future<AuthResult> loginWithEmailAndPassword(
//     String email,
//     String password,
//   ) async {
//     UserCredential? userCredential;
//     try {
//       final userCredential = await _auth.signInWithEmailAndPassword(
//         email: email.trim(),
//         password: password,
//       );
//       return AuthResult.success();
//     } on FirebaseAuthException catch (e) {
//       print(e.message);
//       return AuthResult.failure(
//         e.message ?? "An unknown error occurred. Please try again later.",
//       );
//     } catch (e) {
//       print(e);
//       return AuthResult.failure(
//         "An unknown error occurred. Please try again later.",
//       );
//     }
//   }

//   // method for logout
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }
