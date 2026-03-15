import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:musicstore/pages/viewpage.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _form = GlobalKey<FormState>();

  var email = '';
  var password = '';
  var userName = '';
  var fName = '';
  var lName = '';
  var address = '';

// call validate to check input and then connect to firebase to signin the user and access database...
  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    try {
      //signup with email and password...and wait to finish the process...
      final usercredentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //connect to firestoreand add usercredential to firestore...
      _firestore.collection('customers').add({
        'customerId': usercredentials.user!.uid,
        'fName': fName,
        'lName': lName,
        'email': email,
        'password': password,
        'username': userName,
        'address': address,
      });

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
                          //Text feild to input first name...
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Enter Your First Name'),
                            //  check for the input if valid
                            validator: (value) {
                              if (value == null || value.trim().length < 3) {
                                return 'First Name must be at least 3 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              fName = value!;
                            },
                          ),
                          //Text feild to input last name...
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Enter Your Last Name'),
                            //  check for the input if valid
                            validator: (value) {
                              if (value == null || value.trim().length < 3) {
                                return 'Last Name must be at least 3 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              lName = value!;
                            },
                          ),
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
                            onSaved: (value) {
                              email = value!;
                            },
                          ),
                          //Text feild to input username...
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Enter Your Username'),
                            //  check for the input if valid
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'username must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              userName = value!;
                            },
                          ),
                          //Text feild to input password...

                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Enter Your Password'),
                            obscureText: true,
                            //  check for the input if valid
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              password = value!;
                            },
                          ),
                          //Text feild to input address...

                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Enter Your Address'),
                            //  check for the input if valid
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter Your Address.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              address = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 209, 202, 227)),
                            child: const Text('Sign Up'),
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
