import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_task/bloc/auth_notifier.dart';
import 'package:test_task/screens/painter_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void signOut() async{
    await context.read<AuthNotifier>().signOut();
    if (!mounted)return;
    popPage();
  }

  void popPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            PreferredSize(
              preferredSize: Size.fromHeight(120),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(8.r),
                ),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.cyan.withValues(alpha: 0.25),
                        Colors.transparent,
                        Colors.cyan.withValues(alpha: 0.25),
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 7, 27, 48).withValues(alpha: 0.8),
                        blurRadius: 8.r,
                        offset: Offset(0, 4.r),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.r),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Галерея",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.r,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 8.r,
                              child: GestureDetector(
                                child: Image.asset(
                                  "assets/Login 2.png",
                                  width: 40.r,
                                  height: 40.r,
                                ),
                                onTap: () {
                                  signOut();
                                },
                              ),
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ),
          ),
          Expanded(
            child: Stack(
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
                  top: 5.r,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    "assets/pattern.png",
                    fit: BoxFit.contain,
                    width: 380.r,
                  ),
                ),
              ],
            ),
          ),
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
              backgroundColor: Colors.deepPurpleAccent[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ), 
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PainterPage()));
            },
            child: Text("Создать", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
          ),
      ),
    );
  }
}