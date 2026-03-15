import 'package:flutter/material.dart';

import 'package:musicstore/models/artist.dart';
import 'package:musicstore/models/song.dart';
import 'package:musicstore/pages/song_info_page.dart';

class ArtistInfoPage extends StatefulWidget {
  const ArtistInfoPage(
      {super.key, required this.artist, required this.songsOfArtist});
  final Artist artist;
  final List<Song> songsOfArtist;

  @override
  State<ArtistInfoPage> createState() => _ArtistInfoPageState();
}

class _ArtistInfoPageState extends State<ArtistInfoPage> {
  @override
  Widget build(BuildContext context) {
    //if no songs related to the artist...or build listview for songs...
    Widget content = widget.songsOfArtist.isEmpty
        ? const Center(
            child: Text(
              'No Songs!',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  fontStyle: FontStyle.italic),
            ),
          )
        //build list view for songs
        : ListView.builder(
            itemCount: widget.songsOfArtist.length,
            itemBuilder: (ctx, index) => Padding(
              padding: const EdgeInsets.all(2.0),
              child: ListTile(
                tileColor: Colors.blueAccent.shade100,
                onTap: () {
                  //move to song info page if pressed on a song...
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => SongInfoPage(
                        song: widget.songsOfArtist[index],
                        artist: widget.artist,
                      ),
                    ),
                  );
                },
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.songsOfArtist[index].type),
                  ],
                ),
                title: Text(widget.songsOfArtist[index].title),
                leading: const Icon(Icons.music_note),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.songsOfArtist[index].price} SP',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.artist.name,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            color: Colors.blueAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Display Artist Information...
                Center(
                  child: Text(
                    widget.artist.name,
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Text(
                    'GENDER: ${widget.artist.gender}',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    'COUNTRY: ${widget.artist.country}',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: content,
          ),
        ],
      ),
    );
  }
}
