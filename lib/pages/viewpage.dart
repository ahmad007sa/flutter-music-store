import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:musicstore/models/artist.dart';
import 'package:musicstore/models/customer.dart';
import 'package:musicstore/models/invoice.dart';
import 'package:musicstore/models/order.dart';
import 'package:musicstore/models/song.dart';
import 'package:musicstore/pages/artists_page.dart';
import 'package:musicstore/pages/cart_page.dart';
import 'package:musicstore/pages/profile_page.dart';
import 'package:musicstore/pages/songs_page.dart';
import 'package:musicstore/widgets/new_artist.dart';
import 'package:musicstore/widgets/new_song.dart';

final _firebase = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

//Declare variables...
List<Artist> artists = [];
List<Song> songs = [];
List<Song> cart = [];
bool admin = false;
int total = 0;
Customer currentUser = Customer(
    fName: 'fName',
    lName: 'lName',
    email: 'email',
    username: 'username',
    password: 'password',
    address: 'address',
    customerId: 'customerId');
Invoice invoice =
    Invoice(date: '', creditCard: '', total: 0, customerId: '', inVoiceId: '');
List<OrderT> orders = [];

class ViewPage extends StatefulWidget {
  const ViewPage({super.key});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  int selectedPageIndex = 0;
  final user = _firebase.currentUser;

  @override
  void initState() {
    super.initState();
    checkAdmin();
    getUserData();
  }

// Simple admin role check based on Firebase UID.
// In production apps this should be handled via backend or Firestore roles.
  void checkAdmin() {
    user != null
        ? user!.uid == 'kjqWcn6ihaN9kiNUG9dJdcPjjnn2'
            ? admin = true
            : admin = false
        : null;
  }

//get current user data
  void getUserData() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('customers')
        .where('customerId', isEqualTo: user!.uid)
        .get();
    final doc = querySnapshot.docs.firstOrNull;
    doc == null
        ? null
        : currentUser = Customer(
            fName: doc["fName"],
            lName: doc["lName"],
            email: doc["email"],
            username: doc["username"],
            password: 'null',
            address: doc["address"],
            customerId: doc["customerId"]);
  }

//when pressed move to new artist page to add artist
  void addArtist() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewArtist(),
      ),
    );
  }

//when pressed move to new song page to add song
  void addSong() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewSong(),
      ),
    );
  }

//call when press on bottom navigation bar
  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //by default index is 0 and active page is artist page
    Widget activePage = ArtistsPage(isAdmin: admin);
    //if index 1 change active page to songs page
    if (selectedPageIndex == 1) {
      activePage = SongsPage(
        isAdmin: admin,
      );
      //if index 2 change active page to cart page
    } else if (selectedPageIndex == 2) {
      activePage = const CartPage();
      //if index 3 change active page to profile page
    } else if (selectedPageIndex == 3) {
      activePage = ProfilePage(userData: currentUser);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedPageIndex == 0
              ? 'Artists'
              : selectedPageIndex == 1
                  ? 'Songs'
                  : selectedPageIndex == 2
                      ? 'My Cart'
                      : 'My Profile',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        ),
        actions: !admin
            ? null
            : selectedPageIndex == 3
                ? null
                : selectedPageIndex == 2
                    ? null
                    : artists.isEmpty
                        ? selectedPageIndex == 0
                            ? [
                                IconButton(
                                    onPressed: addArtist,
                                    icon: const Icon(Icons.add))
                              ]
                            : null
                        : [
                            IconButton(
                                onPressed: selectedPageIndex == 0
                                    ? addArtist
                                    : selectedPageIndex == 1
                                        ? addSong
                                        : null,
                                icon: const Icon(Icons.add))
                          ],
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey[600],
        onTap: selectPage,
        currentIndex: selectedPageIndex,
        items: const [
          //Bottom Navigation Bar content...
          BottomNavigationBarItem(
              icon: Icon(Icons.person_sharp), label: 'Artists'),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_video), label: 'Songs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'My Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_pin), label: 'My Profile'),
        ],
      ),
    );
  }
}
