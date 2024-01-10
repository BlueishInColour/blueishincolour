import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.onPressed});
  final void Function()? onPressed;

  @override
  State<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final secondPasswordController = TextEditingController();

  void Function()? signup() {}
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
              Text('register with us and explore fashion'),
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
              TextField(
                controller: secondPasswordController,
                obscureText: true,
                decoration: InputDecoration(hintText: 'confirm password'),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                  onPressed: signup,
                  child: Text('signup'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black))),
              SizedBox(height: 15),
              Row(
                children: [
                  Text('you have an account?'),
                  TextButton(
                      onPressed: widget.onPressed, child: Text('login now'))
                ],
              ),
            ]),
          ],
        )),
      ),
    );
  }
}
