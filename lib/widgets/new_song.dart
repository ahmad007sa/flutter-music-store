import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:musicstore/pages/viewpage.dart';

final _firestore = FirebaseFirestore.instance;
const uuid = Uuid();

class NewSong extends StatefulWidget {
  const NewSong({super.key});

  @override
  State<NewSong> createState() => _NewItemState();
}

class _NewItemState extends State<NewSong> {
  final formKey = GlobalKey<FormState>();
  String title = '';
  String type = '';
  int price = 0;
  String artistId = '';
  String songId = uuid.v4();

  void saveSong() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      await _firestore.collection('songs').add({
        'title': title,
        'type': type,
        'price': price,
        'artistId': artistId,
        'songId': songId,
      });

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Song'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 15,
                decoration: const InputDecoration(label: Text('Song Title')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length == 1) {
                    return 'Enter a Valid Name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  title = value!;
                },
              ),
              const SizedBox(width: 8),
              TextFormField(
                maxLength: 15,
                decoration: const InputDecoration(label: Text('Song Type')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length == 1) {
                    return 'Enter a Valid Name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  type = value!;
                },
              ),
              const SizedBox(width: 8),
              DropdownButtonFormField(
                items: [
                  for (var x = 0; x < artists.length; x++)
                    DropdownMenuItem(
                      value: artists[x].artistId,
                      child: Text(artists[x].name),
                    )
                ],
                onChanged: (value) {
                  artistId = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Select Artist';
                  }
                  return null;
                },
              ),
              const SizedBox(width: 8),
              TextFormField(
                maxLength: 20,
                decoration: const InputDecoration(label: Text('Price')),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter a Valid Price.';
                  }
                  return null;
                },
                onSaved: (value) {
                  price = int.tryParse(value!) ?? 0;
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
                      onPressed: saveSong, child: const Text('Add Song'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
