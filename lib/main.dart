import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart'; // น าเข้าไฟล์ที่ต้องการเรียกใช้จากหน้า 'auth.dart'
import 'signin_page.dart'; // น าเข้าไฟล์ที่ต้องการเรียกใช้จากหน้า 'signin_page.dart'
import 'home_page.dart'; // น าเข้าไฟล์ที่ต้องการเรียกใช้จากหน้า 'homepage_page.dart'
import 'profilesetup.dart';

//Method หลักทีRun
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAJTD_xyNgd40NXmgwvnWS2K6JpRXoDE4g",
            authDomain: "dbartists.firebaseapp.com",
            databaseURL: "https://dbartists.firebaseio.com",
            projectId: "dbartists",
            storageBucket: "dbartists.firebasestorage.app",
            messagingSenderId: "820027671017",
            appId: "1:820027671017:web:fa00e7f874ca6978bc4b78",
            measurementId: "G-GRDP50GTGY"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

// Class MyApp ส าหรับการแสดงผลหน้าจอ
class MyApp extends StatelessWidget {
  MyApp({super.key});
// ตรวจสอบ AuthService
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      home: StreamBuilder(
        stream: _auth.authStateChanges, // ตรวจสอบการเชื่อมต่อ Stream
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return HomePage(); // ตรวจสอบว่ามี HomePage และท างานได้
          } else {
            return const LoginPage(); // ตรวจสอบว่ามี LoginPage และท างานได้
          }
        },
      ),
      routes: {
        LoginPage.routeName: (BuildContext context) => const LoginPage(),
        HomePage.routeName: (BuildContext context) => HomePage(),
        Profilesetup.routeName: (BuildContext context) => Profilesetup(),
      },
    );
  }
}
