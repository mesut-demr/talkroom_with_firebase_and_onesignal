import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_system/feature/auth/cubit/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthCubit extends Cubit<AuthState> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController registerUsernameController = TextEditingController();
  TextEditingController registerEmailController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();

  AuthCubit() : super(AuthState.initial()) {
    init();
  }
  void init() {}

//? Login and register page control.
  void isLoginPage(bool isLoginPage) {
    emit(state.copyWith(isLoginPage: isLoginPage));
  }

//? Check the login information.
  void checkLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      emit(state.copyWith(errorMessage: 'E-mail and password cannot be empty.'));
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      context.pushReplacement('/home'); //* If the login information is correct, redirect to the room page
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'An error occurred. Please try again.'));
    }
  }

//? Register the user.
  Future<String?> registerUser(String email, String password, String username) async {
    try {
      //* Register the user with email and password.
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      final userId = userCredential.user!.uid;

      //* Get the playerId from OneSignal.
      final deviceState = await OneSignal.shared.getDeviceState();
      final playerId = deviceState?.userId;

      //* Save the user information in Firestore.
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'playerId': playerId,
      });

      return null; //* Successful registration.
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  }

  //? Add Register the user.
  void addRegister() async {
    final email = registerEmailController.text.trim();
    final password = registerPasswordController.text.trim();
    final username = registerUsernameController.text.trim();

    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      emit(state.copyWith(errorMessage: 'Please fill in all fields.'));
      return;
    }

    final result = await registerUser(email, password, username);
    if (result != null) {
      emit(state.copyWith(errorMessage: result));
    } else {
      emit(state.copyWith(isLoginPage: true));
    }
  }

  //? Google login
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      //* Select the Google user.
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return; //* The user did not log in.
      }

      //* Get the Google authentication credentials.
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      //* Create authentication credentials for Firebase.
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //* Log in with Firebase.
      await FirebaseAuth.instance.signInWithCredential(credential);

      context.pushReplacement('/home');
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Google login failed: $e'));
    }
  }
}
