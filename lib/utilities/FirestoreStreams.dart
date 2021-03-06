import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instant/utilities/Auth.dart';

class FirestoreStreams {
  static Stream<QuerySnapshot> messagesStream(String compositeId) {
    return Firestore.instance
        .collection('chats')
        .document(compositeId)
        .collection('messages')
        .orderBy('timeSent', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> recipientsStream() {
    return Firestore.instance
        .collection('users')
        .document(Auth.uid)
        .collection('recipients')
        .orderBy('timeSent', descending: true)
        .snapshots();
  }

  static Stream<DocumentSnapshot> userStream() {
    return Firestore.instance
        .collection('users')
        .document(Auth.uid)
        .snapshots();
  }
}
