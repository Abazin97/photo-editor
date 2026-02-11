import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_task/bloc/auth_notifier.dart';


class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool fieldsFilled = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  void register() async{
    try {
      await context.read<AuthNotifier>().signUp(email: emailController.text, password: passwordController.text);
      popPage();
    }on FirebaseAuthException catch (e) {
      String message = "Ошибка регистрации";
      switch (e.code){
        case "email-already-in-use":
          message = "Пользователь с таким email уже существует";
          break;
        case "invalid-email":
          message = "Неверный email";
          break;
        case "weak-password":
          message = "Слабый пароль";
          break;
        default: message = e.message ?? "Ошибка";
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message))
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Неизвестная ошибка"))
      );
    }
  }

  void popPage() {
    Navigator.pop(context);
  }

  void checkFieldsFilled() {
    setState(() {
      fieldsFilled = nameController.text.trim().isNotEmpty &&
          emailController.text.trim().isNotEmpty &&
          passwordController.text.trim().isNotEmpty &&
          passwordConfirmController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            top: 40,
            child: Image.asset(
              "assets/pattern.png",
              fit: BoxFit.contain,
              width: 380,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Регистрация", style: TextStyle(color: Colors.white, fontSize: 26),),
                    SizedBox(height: 10.r),
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
                              child: Text("Имя", style: TextStyle(color: Colors.blueGrey[300], fontSize: 14.r),),
                            ),
                            TextField(
                              onChanged: (_){
                                checkFieldsFilled();
                              },
                              controller: nameController,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.r,
                              ),
                              decoration: InputDecoration(
                                hint: Text("Введите ваше имя", style: TextStyle(color: Colors.blueGrey[300]),),
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
                              child: Text("e-mail", style: TextStyle(color: Colors.blueGrey[300], fontSize: 14.r),),
                            ),
                            TextField(
                              controller: emailController,
                              onChanged: (_){
                                checkFieldsFilled();
                              },
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.r,
                              ),
                              decoration: InputDecoration(
                                hint: Text("Ваша электронная почта", style: TextStyle(color: Colors.blueGrey[300]),),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueGrey, width: 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.r),
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
                              padding: EdgeInsets.only(top: 5.r),
                              child: Text("Пароль", style: TextStyle(color: Colors.blueGrey[300], fontSize: 14.r),),
                            ),
                            TextField(
                              controller: passwordController,
                              onChanged: (_){
                                checkFieldsFilled();
                              },
                              obscureText: true,
                              obscuringCharacter: '*',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.r,
                              ),
                              decoration: InputDecoration(
                                hint: Text("8-16 символов", style: TextStyle(color: Colors.blueGrey[300], fontSize: 14.r),),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.r),
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.r, right: 20.r, bottom: 10.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5.r),
                              child: Text("Подтверждение пароля", style: TextStyle(color: Colors.blueGrey[300], fontSize: 14.r),),
                            ),
                            TextField(
                              controller: passwordConfirmController,
                              onChanged: (_){
                                checkFieldsFilled();
                              },
                              obscureText: true,
                              obscuringCharacter: '*',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                hint: Text("8-16 символов", style: TextStyle(color: Colors.blueGrey[300]),),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueGrey, width: 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ))),  
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.r),
        child: SizedBox(
          width: double.infinity,
          height: 50.r,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: fieldsFilled ? Colors.white : Colors.white.withValues(alpha: 0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ), 
            ),
            onPressed: () {
              if (formKey.currentState!.validate() && emailController.text.trim().isNotEmpty && passwordController.text.trim().isNotEmpty && passwordConfirmController.text.trim().isNotEmpty) {
                register();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Пожалуйста, заполните все поля"))
                );
              }
            },
            child: Text("Зарегистрироваться", style: TextStyle(color: fieldsFilled ? Colors.black : Colors.black.withValues(alpha: 0.7), fontSize: 16.r, fontWeight: FontWeight.bold))),
        ),
      ),   
    );
  }
}