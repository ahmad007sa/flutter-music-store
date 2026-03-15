class ArtistT {
  ArtistT(
      {required this.fName,
      required this.lName,
      required this.gender,
      required this.country,
      required this.artistId});

  final String fName;
  final String lName;
  final String gender;
  final String country;
  final String artistId;
}

class Artist {
  Artist(
      {required this.name,
      required this.gender,
      required this.country,
      required this.artistId});

  final String name;
  final String gender;
  final String country;
  final String artistId;
}
