// Flutter imports:

// Dart imports:
import 'dart:developer';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:

class FirebaseService {
  int numWrites = 0;
  int numReads = 0;
  final String uid;
  FirebaseService(this.uid);

  //Collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  //Creates new user in database
  Future updateUserData(String email, String firstName, String lastName) async {
    numWrites += 1;
    log("numWrites: " + numWrites.toString());
    return await userCollection.doc(uid).set({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    });
  }

  // get first and last names
  Future<List<String>> getFirstAndLastName() async {
    numReads += 1;
    log("numReads: " + numReads.toString());
    DocumentSnapshot<Map<String, dynamic>> snapshot = await userCollection
        .doc(uid)
        .get() as DocumentSnapshot<Map<String, dynamic>>;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.containsKey('first_name') && data.containsKey('last_name')) {
      final String firstName = data['first_name'] as String;
      final String lastName = data['last_name'] as String;
      List<String> myList = [];
      myList.add(firstName);
      myList.add(lastName);
      return myList;
    } else {
      List<String> empty = [];
      return empty;
    }
  }
}
