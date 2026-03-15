import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:musicstore/pages/viewpage.dart';
import 'package:musicstore/models/artist.dart';
import 'package:musicstore/models/song.dart';
import 'package:musicstore/pages/artist_info_page.dart';

final _firestore = FirebaseFirestore.instance;

class ArtistsPage extends StatefulWidget {
  const ArtistsPage({super.key, required this.isAdmin});
  final bool isAdmin;

  @override
  State<ArtistsPage> createState() => _ArtistsPageState();
}

class _ArtistsPageState extends State<ArtistsPage> {
  List<Artist> foundedArtists = artists;
  List<Song> songsOfArtist = [];

  void selectArtist(BuildContext context, Artist artist) async {
    //Find the artist in the firestore and get all songs that related to...
    QuerySnapshot querySnapshot = await _firestore
        .collection('songs')
        .where('artistId', isEqualTo: artist.artistId)
        .get();
    songsOfArtist.clear();
    // put all songs of the artist in list of <Song> called songsOfArtist...
    for (var doc in querySnapshot.docs) {
      songsOfArtist.add(
        Song(
          title: doc["title"],
          type: doc["type"],
          price: doc["price"],
          artistId: doc["artistId"],
        ),
      );
    }
//move to Artist info Page... to display artist information and his songs...
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ArtistInfoPage(
          artist: artist,
          songsOfArtist: songsOfArtist,
        ),
      ),
    );
  }

  void searchForArtist(String searchInput) {
    List<Artist> result = [];
// filters artists list according to search input...
    if (searchInput.isEmpty) {
      result = artists;
    } else {
      result = artists
          .where((element) =>
              element.name.toLowerCase().contains(searchInput.toLowerCase()))
          .toList();
    }

    setState(() {
      foundedArtists = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    //by default when no artists added...
    Widget content = const Center(
      child: Text(
        'No Artists!',
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
            onChanged: (value) => searchForArtist(value),
            decoration: const InputDecoration(
                labelText: 'Search', suffixIcon: Icon(Icons.search)),
          ),

          //Spacing...
          const SizedBox(height: 5),

          // Grid view for artists...
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('artists').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  artists.clear();
                  final artData = snapshot.data!.docs;
                  for (var doc in artData) {
                    artists.add(
                      Artist(
                        name: doc["fName"] + ' ' + doc["lName"],
                        gender: doc["gender"],
                        country: doc["country"],
                        artistId: doc["artistId"],
                      ),
                    );
                  }
                }

                if (foundedArtists.isEmpty) {
                  return content; //No Artists...
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
                      for (final artist in foundedArtists)
                        InkWell(
                          onTap: () {
                            //move to artist info page to read information about artist...
                            selectArtist(context, artist);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.blueAccent),
                              child: Center(
                                child: Text(
                                  artist.name,
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
