import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthResult {
  final bool isSuccess;
  final String? errorMessage;

  AuthResult.success() : isSuccess = true, errorMessage = null;
  AuthResult.failure(this.errorMessage) : isSuccess = false;
}

class AuthServiceClass {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Expose the authentication state stream and current user
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // Register a new user and store their profile details in Firestore
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

      // Save the user's display name in Firebase Auth as well
      await userCredential.user?.updateDisplayName(name.trim());

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

  // Sign in an existing user with email and password
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

  // Fetch the user's profile document from Firestore
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      return null;
    }
  }

  // Sign out the currently authenticated user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

// =========================================================================
// PROVIDER LAYER (Connects UI with AuthServiceClass)
// =========================================================================
class AuthClassProvider extends ChangeNotifier {
  final AuthServiceClass _authService = AuthServiceClass();
  StreamSubscription<User?>? _authSubscription;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _userName = '';
  String get userName => _userName;

  User? get currentUser => _authService.currentUser;
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // Listen to auth changes so the user's name loads automatically on app start or login
  AuthClassProvider() {
    _authSubscription = _authService.authStateChanges.listen((User? user) {
      if (user != null) {
        loadUserProfile(user.uid);
      } else {
        _userName = '';
        notifyListeners();
      }
    });
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Load the current user's name from Firestore into provider state
  Future<void> loadUserProfile(String uid) async {
    final profileData = await _authService.getUserProfile(uid);
    if (profileData != null && profileData['name'] != null) {
      _userName = profileData['name'].toString().trim();
      notifyListeners();
    } else if (_authService.currentUser?.displayName != null) {
      _userName = _authService.currentUser!.displayName!.trim();
      notifyListeners();
    }
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
    if (result.isSuccess) {
      _userName = name.trim();
    }
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
    if (result.isSuccess && _authService.currentUser != null) {
      await loadUserProfile(_authService.currentUser!.uid);
    }
    _setLoading(false);
    return result;
  }

  Future<void> logout() async {
    await _authService.signOut();
    _userName = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
