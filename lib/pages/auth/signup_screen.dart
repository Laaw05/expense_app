import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState(); // sửa đúng tên class
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Bỏ const vì có Image.asset động
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Image.asset(
                "assets/logo.png",
                width: double.maxFinite,
                height: 500,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
