import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

final _firestore = FirebaseFirestore.instance;
const uuid = Uuid();

class NewArtist extends StatefulWidget {
  const NewArtist({super.key});

  @override
  State<NewArtist> createState() => _NewItemState();
}

class _NewItemState extends State<NewArtist> {
  final formKey = GlobalKey<FormState>();
  String fName = '';
  String enteredName = '';
  String lName = '';
  String gender = '';
  String country = '';
  String artistId = uuid.v4();

  Color choosenColor = Colors.white;

  void saveArtist() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      await _firestore.collection('artists').add({
        'fName': fName,
        'lName': lName,
        'gender': gender,
        'country': country,
        'artistId': artistId,
      });

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Artist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 15,
                decoration: const InputDecoration(label: Text('First Name')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length == 1) {
                    return 'Enter a Valid Name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  fName = value!;
                },
              ),
              const SizedBox(width: 8),
              TextFormField(
                maxLength: 15,
                decoration: const InputDecoration(label: Text('Last Name')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length == 1) {
                    return 'Enter a Valid Name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  lName = value!;
                },
              ),
              const SizedBox(width: 8),
              DropdownButtonFormField(
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Select Gender';
                  }
                  return null;
                },
                onChanged: (value) {
                  gender = value!;
                },
              ),
              const SizedBox(width: 8),
              TextFormField(
                maxLength: 20,
                decoration: const InputDecoration(label: Text('Country')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length == 1) {
                    return 'Enter a Valid Name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  country = value!;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        formKey.currentState!.reset();
                      },
                      child: const Text('Reset')),
                  ElevatedButton(
                      onPressed: saveArtist, child: const Text('Add Artist'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
