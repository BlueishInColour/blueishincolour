import 'package:dressr/middle.dart';
import 'package:dressr/screens/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool isLoading = false;
  bool seePassword = true;

  login() async {
    setState(() {
      isLoading = true;
    });
    try {
      await AuthService().login(emailController.text, passwordController.text);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('wrong email or password'),
        showCloseIcon: true,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Middle(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: emailController,
                    obscureText: seePassword,
                    decoration: InputDecoration(
                      hintText: 'email',
                    ),
                  ),
                ),

                SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: passwordController,
                    obscureText: seePassword,
                    decoration: InputDecoration(
                      hintText: 'password',
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            seePassword = !seePassword;
                          });
                        },
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: !seePassword ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                //loginbutton
                GestureDetector(
                  onTap: () async {
                    await login();
                  },
                  child: !isLoading
                      ? Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black45, width: 2),
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromRGBO(0, 0, 0, 1)),
                          height: 60,
                          child: Center(
                              child: Text('login',
                                  style: TextStyle(color: Colors.white))),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black45, width: 2),
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromRGBO(0, 0, 0, 1)),
                          height: 60,
                          child: Center(child: CircularProgressIndicator())),
                ),

                SizedBox(height: 15),
                Row(
                  children: [
                    Text('you dont have an account?'),
                    TextButton(
                        onPressed: widget.onPressed,
                        child: Text('register now'))
                  ],
                ),
              ])),
        ),
      ),
    );
  }
}
