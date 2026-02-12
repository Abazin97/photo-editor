import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_task/screens/home_page.dart';
import 'package:test_task/services/notification_service.dart';

class PainterPage extends StatefulWidget {
  final Uint8List? imageBytes;
  const PainterPage({super.key, this.imageBytes});

  @override
  State<PainterPage> createState() => _PainterPageState();
}

class _PainterPageState extends State<PainterPage> {

  List<DrawnPoint?> _points = [];
  Uint8List? selectedImageBytes;
  File? selectedImage;
  Color selectedColor = Colors.white;
  double strokeWidth = 4.0;
  bool isLoading = false;

  @override
  initState() {
    if (widget.imageBytes != null) {
      selectedImageBytes = widget.imageBytes;
    }
    super.initState();
  }

  Future<void> pickImage() async {
    final picker = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picker == null) return;

    setState(() {
      selectedImage = File(picker.path);
    });
  }

  Future<void> saveImage() async {
    setState(() {
      isLoading = true;
    });
    if (selectedImage == null) return;

    await Permission.storage.request();
    await Permission.photos.request();

    final bytes = await selectedImage!.readAsBytes();
    final imageStr = base64Encode(bytes);
    await ImageGallerySaver.saveImage(bytes);

    final imageChunks = splitString(imageStr, 10000);

    final doc = FirebaseFirestore.instance.collection("images").doc();
    final docID = doc.id;
    await doc.set({
      "count": imageChunks.length,
      "createdAt": FieldValue.serverTimestamp(),
    });
    for (int i = 0; i < imageChunks.length; i++) {
      await doc
          .collection("chunks")
          .doc(i.toString())
          .set({"data": imageChunks[i]});
    }


    final prefs = await SharedPreferences.getInstance();
    final idList = prefs.getStringList("image_doc_ids") ?? [];
    idList.add(docID);
    await prefs.setStringList("image_doc_ids", idList);
    
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
    NotificationService().showNotification();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Изображение успешно сохранено"))
    );
    popPage();
  }

  void popPage() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()),);
  }

  List<String> splitString(String str, int chunkSize) {
    List<String> chunks = [];
    for (var i = 0; i < str.length; i += chunkSize) {
      chunks.add(str.substring(i, i + chunkSize > str.length ? str.length : i + chunkSize));
    }
    return chunks;
  }

  void showColorPicker() {
      
  }

  void clearCanvas() {
    setState(() {
      _points.clear();
    });
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
                                  //popPage();
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
                Positioned.fill(
                  child: selectedImageBytes != null 
                    ? Image.memory(selectedImageBytes!, fit: BoxFit.contain,) 
                    : selectedImage != null 
                      ? Image.file(selectedImage!) 
                      : Container(),
                ),
                Positioned.fill(child: GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      _points.add(DrawnPoint(details.localPosition, Paint()
                        ..color = selectedColor
                        ..strokeWidth = strokeWidth
                        ..strokeCap = StrokeCap.round
                      ));
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      _points.add(DrawnPoint(details.localPosition, Paint()
                        ..color = selectedColor
                        ..strokeWidth = strokeWidth
                        ..strokeCap = StrokeCap.round
                      ));
                    });
                  },
                  onPanEnd: (details) {
                    _points.add(null);
                  },
                  child: CustomPaint(
                    painter: Painter(_points),
                    size: Size.infinite,
                  ),
                ),),
                Positioned(child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: (){
                      saveImage();
                    }, icon: Image.asset("assets/Frame 13.png"),),
                    IconButton(onPressed: (){
                      pickImage();
                    }, icon: Image.asset("assets/Frame 12.png"),),
                    IconButton(onPressed: (){

                    }, icon: Image.asset("assets/Frame 11.png"),),
                    IconButton(onPressed: (){
                      clearCanvas();
                    }, icon: Image.asset("assets/Frame 10.png"),),
                    IconButton(onPressed: (){
                      showColorPicker();
                    }, icon: Image.asset("assets/Frame 9.png"),)
                  ],
                )),
                Positioned.fill(child:  isLoading ? Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ) : Container())
                //Positioned(child: selectedImage != null ? Image.file(selectedImage!) : Container(),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawnPoint {
  final Offset offset;
  final Paint paint;

  DrawnPoint(this.offset, this.paint);
}

class Painter extends CustomPainter {
  final List<DrawnPoint?> points;

  Painter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          points[i]!.offset,
          points[i + 1]!.offset,
          points[i]!.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}