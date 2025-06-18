import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_internship_task/features/auth/data/models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool ispassword = true;

  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        // Firebase login logic
        UserCredential userCredential = await _firebaseAuth
            .signInWithEmailAndPassword(
              email: event.email,
              password: event.password,
            );

        // Fetch user data from Firestore
        DocumentSnapshot userDoc =
            await _firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .get();
        if (userDoc.exists) {
          UserModel user = UserModel.fromJson(
            userDoc.data() as Map<String, dynamic>,
            userCredential.user!.uid,
          );
          emit(AuthSuccess(user));
        } else {
          emit(AuthFailure('User data not found in Firestore.'));
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Login failed';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided.';
        } else if (e.code == 'network-request-failed') {
          errorMessage = 'Network error. Please check your connection.';
        }
        emit(AuthFailure(errorMessage));
      } catch (e) {
        emit(AuthFailure('An unexpected error occurred ${e.toString()}.'));
      }
    });

    on<SignupEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        // Firebase signup logic
        UserCredential userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(
              email: event.email,
              password: event.password,
            );

        // Store additional user details in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': event.name,
          'email': event.email,
          'phone': event.phone,
        });

        // Fetch user data from Firestore
        UserModel user = UserModel(
          id: userCredential.user!.uid,
          name: event.name,
          email: event.email,
          phone: event.phone,
        );
        emit(AuthSuccess(user));
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Signup failed';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'The email is already in use.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'The password is too weak.';
        } else if (e.code == 'network-request-failed') {
          errorMessage = 'Network error. Please check your connection.';
        }
        errorMessage = 'sssssssssssss${e.code}';
        emit(AuthFailure(errorMessage));
      } catch (e) {
        emit(AuthFailure('An unexpected error occurred ${e.toString()}.'));
      }
    });

    on<PasswordVisibilityEvent>((event, emit) {
      ispassword = event.isPasswordVisible;
      emit(AuthPasswordVisibility(ispassword));
    });
  }
}
