import 'package:flutter/material.dart';
import 'package:test_task/screens/painter_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/Login 2.png"),
        title: Text("Галерея", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
      ),
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
            top: 30,
            //right: 20,
            child: Image.asset(
              "assets/pattern.png",
              fit: BoxFit.contain,
              width: 380,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PainterPage()));
            },
            child: Text("Создать", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
          ),
      ),
    );
  }
}