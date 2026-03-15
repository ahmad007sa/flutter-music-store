import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Song {
  Song({
    required this.title,
    required this.type,
    required this.price,
    required this.artistId,
  }) : songId = uuid.v4();

  final String title;
  final String type;
  final int price;
  final String artistId;
  final String songId;
}
