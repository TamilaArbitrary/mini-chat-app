import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth_service.dart';
import '../models/auth_user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  AuthUser? _currentUser;
  bool _isLoading = true; 

  AuthUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _authService.firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        _currentUser = AuthUser.fromFirebaseUser(user);
      } else {
        _currentUser = null;
      }
      _isLoading = false; 
      notifyListeners();
    });
  }

  Future<User?> signUp({required String name, required String email, required String password}) async {
    try {
      final user = await _authService.signUp(name: name, email: email, password: password);
      return user; 
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signIn({required String email, required String password}) async {
    try {
      final user = await _authService.signIn(email: email, password: password);
      return user; 
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final user = await _authService.signInWithGoogle();
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.signOut(); 
  }
}