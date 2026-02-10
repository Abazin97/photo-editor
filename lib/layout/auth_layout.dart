import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/bloc/auth_notifier.dart';
import 'package:test_task/screens/home_page.dart';
import 'package:test_task/screens/login_page.dart';
import 'package:test_task/screens/splash_page.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthNotifier, User?>(builder: (context, user) {
      return user == null ? const LoginPage() : const HomePage();
    });
  }
}