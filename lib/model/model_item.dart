import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String sentence;
  final bool like;
  final DocumentReference? reference;

  Item.fromMap(Map<String, dynamic> map, {this.reference})
      : sentence = map['sentence'],
        like = map['like'];

  Item.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>, reference: snapshot.reference);

  @override
  String toString() => "Item<$sentence:$like>";
}