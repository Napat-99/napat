import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profilesetup.dart';

class AuthService {
  // ประกาศตัวแปร _auth เพื่อเรียกใช้ FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getter สำหรับผู้ใช้ปัจจุบัน
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      showSnackbar(context, 'เข้าสู่ระบบสำเร็จ');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackbar(context, 'ไม่พบอีเมลของท่าน/ท่านกรอกอีเมลไม่ถูกต้อง');
      } else if (e.code == 'wrong-password') {
        showSnackbar(context, 'ท่านกรอกรหัสผ่านไม่ถูกต้อง');
      } else {
        showSnackbar(context, 'เกิดข้อผิดพลาด: ${e.message}');
      }
      return null;
    }
  }

  // Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      showSnackbar(context, 'ลงทะเบียนสำเร็จ');

    
      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(context, Profilesetup.routeName);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackbar(context, 'รหัสผ่านที่ระบุไม่ปลอดภัย');
      } else if (e.code == 'email-already-in-use') {
        showSnackbar(context, 'อีเมลนี้ถูกใช้งานไปแล้ว');
      } else {
        showSnackbar(context, 'เกิดข้อผิดพลาด: ${e.message}');
      }
      return null;
    }
  }

  // Sign out
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      showSnackbar(context, 'ออกจากระบบสำเร็จ');
    } catch (e) {
      showSnackbar(context, 'เกิดข้อผิดพลาดในการออกจากระบบ: $e');
    }
  }

  // เช็คสถานะการยืนยันตัวตนของผู้ใช้
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Method สำหรับแสดง Snackbar
  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
