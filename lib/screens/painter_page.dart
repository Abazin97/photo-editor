import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PainterPage extends StatefulWidget {
  const PainterPage({super.key});

  @override
  State<PainterPage> createState() => _PainterPageState();
}

class _PainterPageState extends State<PainterPage> {
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
                  height: 100.r,
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
                                "Новое изображение",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.r,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 8,
                              child: GestureDetector(
                                child: Image.asset(
                                  "assets/fi-rr-angle-small-left.png",
                                  width: 40.r,
                                  height: 40.r,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Positioned(
                              right: 8,
                              child: GestureDetector(
                                child: Image.asset(
                                  "assets/fi-rr-check.png",
                                  width: 40.r,
                                  height: 40.r,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            )
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
                Positioned(child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: (){

                    }, icon: Image.asset("assets/Frame 13.png"),),
                    IconButton(onPressed: (){

                    }, icon: Image.asset("assets/Frame 12.png"),),
                    IconButton(onPressed: (){

                    }, icon: Image.asset("assets/Frame 11.png"),),
                    IconButton(onPressed: (){

                    }, icon: Image.asset("assets/Frame 10.png"),),
                    IconButton(onPressed: (){

                    }, icon: Image.asset("assets/Frame 9.png"),)
                  ],
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}