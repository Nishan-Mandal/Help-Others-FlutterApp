import 'package:cloud_firestore/cloud_firestore.dart';

class Search {
  String title;
  String description;
  String category;
  double latitude;
  double longitude;
  Search(this.title, this.description, this.category, this.latitude,
      this.longitude);

  Search.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot['title'],
        description = snapshot['description'],
        category = snapshot['category'],
        latitude = snapshot['latitude'],
        longitude = snapshot['longitude'];
}
