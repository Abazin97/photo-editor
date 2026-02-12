import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:test_task/bloc/auth_notifier.dart';
import 'package:test_task/screens/home_page.dart';
import 'package:test_task/screens/registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final StreamSubscription _subscription;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _subscription = InternetConnectionChecker.createInstance().onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.disconnected) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Отсутствует подключение к интернету", style: TextStyle(color: Colors.white),), backgroundColor: Colors.red,)
        );
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _subscription.cancel();
    super.dispose();
  }

  void login() async {
    try {
      await context.read<AuthNotifier>().signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      emailController.clear();
      passwordController.clear();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );

    } on FirebaseAuthException catch (e) {
      String message = "Ошибка входа";

      switch (e.code) {
        case 'user-not-found':
          message = "Пользователь не найден";
          break;
        case 'wrong-password':
          message = "Неверный пароль";
          break;
        case 'invalid-email':
          message = "Неверный email";
          break;
        case 'invalid-credential':
          message = "Неверные учетные данные";
          break;
        case 'too-many-requests':
          message = "Слишком много попыток. Попробуйте позже";
          break;
        default:
          message = "Ошибка";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Неизвестная ошибка")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/Abstract gradient neon lights.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
          Positioned(
            top: 30.r,
            child: Image.asset(
              "assets/pattern.png",
              fit: BoxFit.contain,
              width: 380.r,
            ),
          ),
          AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutExpo,
            padding: EdgeInsets.only(left: 20.r, right: 20.r, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Center(
            child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Вход", style: TextStyle(color: Colors.white, fontSize: 26.r),),
                    SizedBox(height: 10.r),
                    Container(
                      height: 85.r,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.cyan.withValues(alpha: 0.25),
                            Colors.transparent,
                            Colors.cyan.withValues(alpha: 0.25),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            blurRadius: 5,
                          ),
                        ],
                        // color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.r, right: 20.r, bottom: 10.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5.h),
                              child: Text("e-mail", style: TextStyle(color: Colors.blueGrey[300], fontSize: 12.r),),
                            ),
                            TextField(
                              controller: emailController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.r,
                              ),
                              decoration: InputDecoration(
                                hintText: "Введите электронную почту",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 85,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.cyan.withValues(alpha: 0.25),
                            Colors.transparent,
                            Colors.cyan.withValues(alpha: 0.25),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            blurRadius: 5,
                          ),
                        ],
                        // color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.r, right: 20.r, bottom: 10.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5.r),
                              child: Text("Подтверждение пароля", style: TextStyle(color: Colors.blueGrey[300], fontSize: 12.r),),
                            ),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              obscuringCharacter: '*',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.r,
                              ),
                              decoration: InputDecoration(
                                hintText: "Введите пароль",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ), 
                ),
                onPressed: () {
                  if (formKey.currentState!.validate() && emailController.text.trim().isNotEmpty && passwordController.text.trim().isNotEmpty) {
                    login();
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Пожалуйста, заполните все поля"))
                    );
                  }
                },
                child: Text("Войти", style: TextStyle(color: Colors.white,fontSize: 16, fontWeight: FontWeight.bold))),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ), 
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationPage()));
                },
                child: Text("Регистрация", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black))),
              ),
          ],
        ),
      ),
    );
  }
}