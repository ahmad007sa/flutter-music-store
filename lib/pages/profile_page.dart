import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:musicstore/models/customer.dart';
import 'package:musicstore/pages/welcome_page.dart';
import 'package:musicstore/widgets/rounded_button.dart';

final _auth = FirebaseAuth.instance;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.userData});
  final Customer userData;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Center(
            child: Text(
              'MUSIC STORE',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'NAME: ${widget.userData.fName} ${widget.userData.lName}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Center(
                child: Text(
                  'USERNAME: ${widget.userData.username}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Center(
                child: Text(
                  'E-MAIL: ${widget.userData.email}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Center(
                child: Text(
                  'ADDRESS: ${widget.userData.address}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const Center(
                child: Text(
                  'Customer ID:',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Center(
                child: Text(
                  widget.userData.customerId,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          RoundedButton(
            title: 'Sign Out',
            colour: Colors.lightBlueAccent,
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return const WelcomePage();
              }));
            },
          ),
        ],
      ),
    );
  }
}
