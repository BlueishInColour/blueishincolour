import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            //logo
            Icon(
              Icons.key,
              size: 100,
              color: Colors.black,
            ),
            SizedBox(height: 15),
            //email
            TextField(),

            SizedBox(height: 15),

            //pasowed
            TextField(),

            SizedBox(height: 15),

            //button
            TextButton(
                onPressed: () {},
                child: Text(
                  'login',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                )),

            SizedBox(height: 15),

            //if no login. sign in
            Row(
              children: [
                Text('you dont hava an account yet?  '),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'signup',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
