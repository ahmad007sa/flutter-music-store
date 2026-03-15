import 'package:flutter/material.dart';

import 'package:musicstore/pages/signin_page.dart';
import 'package:musicstore/pages/signup_page.dart';
import 'package:musicstore/widgets/rounded_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Set color for background
      backgroundColor: const Color.fromARGB(255, 63, 17, 177),
      body: Padding(
        //Set padding
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        //Put elements in column...
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Center(
              child: Text(
                'MY MUSIC STORE',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Spacing...
            const SizedBox(height: 15),
            //Sign In Button
            RoundedButton(
              title: 'SignIn',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                // move to signin page...
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return const SigninPage();
                    },
                  ),
                );
              },
            ),
            //SignUp Button
            RoundedButton(
              title: 'SignUp',
              colour: Colors.blueAccent,
              onPressed: () {
                //move to signup page...
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return const SignupPage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
