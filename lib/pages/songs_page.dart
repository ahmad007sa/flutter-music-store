import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:musicstore/pages/viewpage.dart';
import 'package:musicstore/models/song.dart';
import 'package:musicstore/pages/song_info_page.dart';

final _firestore = FirebaseFirestore.instance;

class SongsPage extends StatefulWidget {
  const SongsPage({super.key, required this.isAdmin});

  final bool isAdmin;

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  List<Song> foundSongs = songs;

  void selectSong(BuildContext context, Song song) {
//get song information...
    final artistOfSong = artists
        .singleWhere((element) => element.artistId.contains(song.artistId));
    //move to song info page...
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SongInfoPage(
          song: song,
          artist: artistOfSong,
        ),
      ),
    );
  }

  void searchForSong(String searchInput) {
    List<Song> result = [];
// filters songs list according to search input...
    if (searchInput.isEmpty) {
      result = songs;
    } else {
      result = songs
          .where((element) =>
              element.title.toLowerCase().contains(searchInput.toLowerCase()))
          .toList();
    }

    setState(() {
      foundSongs = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    //by default when no songs added...
    Widget content = const Center(
      child: Text(
        'No Songs!',
        style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic),
      ),
    );

    // if artists isn't null ...
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          //Spacing...
          const SizedBox(height: 5),

          //Search Bar...
          TextField(
            onChanged: (value) => searchForSong(value),
            decoration: const InputDecoration(
                labelText: 'Search', suffixIcon: Icon(Icons.search)),
          ),
          //Spacing...
          const SizedBox(height: 5),
          // Grid view for artists...
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('songs').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  songs.clear();

                  final songData = snapshot.data!.docs;
                  for (var doc in songData) {
                    songs.add(
                      Song(
                        title: doc["title"],
                        type: doc["type"],
                        price: doc["price"],
                        artistId: doc["artistId"],
                      ),
                    );
                  }
                }

                if (foundSongs.isEmpty) {
                  return content; //No Songs...
                } else {
                  return GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          2, //The number of children in the cross axis.
                      childAspectRatio: 3 /
                          2, //The ratio of the cross-axis to the main-axis extent of each child.
                      crossAxisSpacing:
                          5, //The number of logical pixels between each child along the cross axis.
                      mainAxisSpacing:
                          5, //The number of logical pixels between each child along the main axis.
                    ),
                    children: [
                      for (final song in foundSongs)
                        InkWell(
                          onTap: () {
                            //move to artist info page to read information about artist...
                            selectSong(context, song);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.blueAccent),
                              child: Center(
                                child: Text(
                                  song.title,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
