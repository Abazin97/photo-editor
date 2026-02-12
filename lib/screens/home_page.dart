import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_task/bloc/auth_notifier.dart';
import 'package:test_task/screens/painter_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final StreamSubscription _subscription;
  
  List<Uint8List> imageBytes = [];
  bool isLoading = false;

  @override
  initState() {
    super.initState();
    getImage();
    _subscription = InternetConnectionChecker.createInstance().onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.disconnected) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Отсутствует подключение к интернету", style: TextStyle(color: Colors.white),), backgroundColor: Colors.red,)
        );
      }
    });
  }

  Future<void> getImage() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final idList = prefs.getStringList("image_doc_ids") ?? [];

    List<Uint8List> images = [];

    for (String docID in idList) {
      final docRef = FirebaseFirestore.instance.collection("images").doc(docID);
      final doc = await docRef.get();
      if (!doc.exists) continue;

      final chunksSnapshot = await docRef.collection("chunks").get();

      final sortedChunks = chunksSnapshot.docs
          .map((d) => MapEntry(int.parse(d.id), d.data()["data"] as String)).toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      final convString = sortedChunks.map((e) => e.value).join();
      images.add(base64Decode(convString));
    }

    if (!mounted) return;
    setState(() {
      imageBytes = images;
      isLoading = false;
    });
  }


  void signOut() async{
    await context.read<AuthNotifier>().signOut();
  }

  void popPage() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
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
                            imageBytes.isEmpty ? Container() : Positioned(
                              right: 8.r,
                              child: GestureDetector(
                                child: Image.asset(
                                  "assets/Paint Roller.png",
                                  width: 40.r,
                                  height: 40.r,
                                ),
                                onTap: () {
                                  
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
                Positioned.fill(child: isLoading
                  ? Center(child: CircularProgressIndicator(),)
                  : imageBytes.isEmpty
                    ? Container()
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2
                        ),
                        itemCount: imageBytes.length, 
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(8.r),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PainterPage(imageBytes: imageBytes[index])));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.memory(imageBytes[index], fit: BoxFit.cover,))),
                          );
                        },
                    )
                )
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