import 'package:flutter/material.dart';

import 'package:musicstore/models/artist.dart';
import 'package:musicstore/models/song.dart';
import 'package:musicstore/pages/viewpage.dart';
import 'package:musicstore/widgets/rounded_button.dart';

class SongInfoPage extends StatefulWidget {
  const SongInfoPage({super.key, required this.song, required this.artist});
  final Song song;
  final Artist artist;

  @override
  State<SongInfoPage> createState() => _SongInfoPageState();
}

class _SongInfoPageState extends State<SongInfoPage> {
  bool isAdded = false;

//status of song Added or not...
  void addStatus() {
    final temp = cart.contains(widget.song) ? true : false;
    cart.contains(widget.song)
        ? cart.remove(widget.song)
        : cart.add(widget.song);
    setState(() {
      isAdded = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.song.title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        ),
      ),
      backgroundColor: Colors.blueAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //Display Song Information...
              Center(
                child: Text(
                  '${widget.song.title} ',
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  'Artist: ${widget.artist.name}',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  'GENDER: ${widget.artist.gender}',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  'COUNTRY: ${widget.artist.country}',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  'SONG TYPE: ${widget.song.type}',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  'PRICE: ${widget.song.price}',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
          //add song to Cart or delet it from Cart
          RoundedButton(
            title: cart.contains(widget.song) ? 'Added' : 'Add To Cart',
            colour: Colors.lightBlueAccent,
            onPressed: addStatus,
          ),
        ],
      ),
    );
  }
}
