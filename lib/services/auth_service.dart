import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Error: ${e.message}");
      throw _getErrorMessage(e);
    } catch (e) {
      log("Something went wrong: $e");
      throw "An unexpected error occurred. Please try again.";
    }
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Error: ${e.message}");
      throw _getErrorMessage(e);
    } catch (e) {
      log("Something went wrong: $e");
      throw "An unexpected error occurred. Please try again.";
    }
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Something went wrong: $e");
      throw "An unexpected error occurred while signing out.";
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return "The email address is not valid.";
      case 'user-not-found':
        return "No account found for this email.";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      case 'weak-password':
        return "Password is too weak. Please use a stronger password.";
      case 'email-already-in-use':
        return "An account already exists for this email.";
      default:
        return "An error occurred. Please try again.";
    }
  }
}
