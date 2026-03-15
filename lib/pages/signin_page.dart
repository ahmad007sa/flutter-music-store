import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:musicstore/pages/viewpage.dart';

final _auth = FirebaseAuth.instance;

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SigninPage> {
  final _form = GlobalKey<FormState>();

  var email = '';
  var password = '';

// call validate to check input and then connect to firebase to signin the user and access database...
  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    try {
      //signin with email and password...and wait to finish the process
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      //move to view page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) {
            return const ViewPage();
          },
        ),
      );
    } on FirebaseAuthException catch (error) {
      //use snack bar to display the error...
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 63, 17, 177),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Card Widget with multi feilds for input email and password to signin...
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //Text feild to input email...
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Enter Your E-mail'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            //  check for the input if valid
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid E-mail address.';
                              }

                              return null;
                            },
                            // email value...
                            onSaved: (value) {
                              email = value!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Enter Your Password'),
                            //using obsecuretext to hide password input
                            obscureText: true,
                            // with check for the input if valid
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            //password value...
                            onSaved: (value) {
                              password = value!;
                            },
                          ),
                          //spacing...
                          const SizedBox(height: 12),
                          // Signin Button
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 209, 202, 227)),
                            child: const Text('Sign In'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
