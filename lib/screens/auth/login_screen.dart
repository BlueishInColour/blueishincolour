import 'package:blueishincolour/screens/auth/auth_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onPressed});
  final void Function()? onPressed;
  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void Function()? login() {
    AuthService().login(emailController.text, passwordController.text);

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Center(
            child: ListView(
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.key, size: 100, color: Colors.black),
              Text('welcome back, fashionistas!'),
              SizedBox(height: 15),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'email'),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(hintText: 'password'),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: login,
                child: Text('login'),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black)),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text('you dont have an account?'),
                  TextButton(
                      onPressed: widget.onPressed, child: Text('register now'))
                ],
              ),
            ]),
          ],
        )),
      ),
    );
  }
}
