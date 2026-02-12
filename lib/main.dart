import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/bloc/auth_notifier.dart';
import 'package:test_task/screens/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_task/services/auth_service.dart';
import 'package:test_task/services/network_service.dart';
import 'package:test_task/services/notification_service.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NetworkService().init();
  NotificationService().init();
  runApp(
    BlocProvider(create: (_) => AuthNotifier(AuthService()),
    child: const MainApp(),),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: MediaQuery.of(context).size,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashPage()
      ),
    );
  }
}
