import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/services/auth_service.dart';

class AuthNotifier extends Cubit<User?> {
  final AuthService _authService;
  late StreamSubscription _authSubscription;

  AuthNotifier(this._authService) :super(null) {
    _authSubscription = _authService.authStateChanges.listen((user) {
      emit(user);
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    await _authService.signIn(email: email, password: password);
  }

  Future<void> signUp({required String email, required String password}) async {
    await _authService.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}