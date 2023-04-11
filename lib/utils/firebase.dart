// Flutter imports:

// Dart imports:
import 'dart:developer';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nowtowv1/models/marker.dart';

// Project imports:

class FirebaseService {
  int numWrites = 0;
  int numReads = 0;
  final String uid;
  FirebaseService(this.uid);

  //Collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference markerCollection =
      FirebaseFirestore.instance.collection('Markers');

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

  //Creates new marker in database
  Future<String> createNewMarkerFirebase(CustomMarker marker) async {
    numWrites += 1;
    log("numWrites: " + numWrites.toString());

    final markerDatabaseEntry = {
      'id': "",
      'lat': marker.lat,
      'lng': marker.lng,
      'name': marker.name,
      'upVotes': marker.upVotes,
      'description': marker.description,
      'uid': marker.uid,
      'imagePaths': marker.imagePaths
    };
    DocumentReference doc = await markerCollection.add(markerDatabaseEntry);
    await markerCollection.doc(doc.id).update({'id': doc.id});
    return doc.id;
  }

  //Gets the 10 closest markers in the database
  Future<List<CustomMarker>?> getMarkersFromFirebase(LatLng location) async {
    List<CustomMarker> markerList = await markerCollection
        // .where('lat', isLessThan: location.latitude + 2)
        // .where('lat', isGreaterThan: location.latitude - 2)
        // .where('lng', isLessThan: location.longitude + 2)
        // .where('lng', isGreaterThan: location.longitude + 2)
        .get()
        .then((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((doc) {
        CustomMarker marker = CustomMarker();
        return marker.copyWith(
            id: (doc.data() as Map<String, dynamic>)['id'] ?? '',
            name: (doc.data() as Map<String, dynamic>)['name'] ?? '',
            lat: (doc.data() as Map<String, dynamic>)['lat'] ?? 90,
            lng: (doc.data() as Map<String, dynamic>)['lng'] ?? 90,
            upVotes: (doc.data() as Map<String, dynamic>)['upVotes'] ?? 0,
            description:
                (doc.data() as Map<String, dynamic>)['description'] ?? '',
            uid: (doc.data() as Map<String, dynamic>)['uid'] ?? '',
            imagePaths: List<String>.from(
                (doc.data() as Map<String, dynamic>)['imagePaths'] ?? []));
      }).toList();
    });
    return markerList;
  }

  Future deleteMarker(String id) async {
    numWrites += 1;
    numReads += 1;
    log("numWrites: " + numWrites.toString());
    log("numReads: " + numReads.toString());
    try {
      await markerCollection.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future updateMarker(String id, CustomMarker marker) async {
    numWrites += 1;
    numReads += 1;
    log("numWrites: " + numWrites.toString());
    log("numReads: " + numReads.toString());
    try {
      return await markerCollection.doc(id).update({
        'description': marker.description,
        'imagePaths': marker.imagePaths,
        'lat': marker.lat,
        'lng': marker.lng,
        'name': marker.name,
        'upVotes': marker.upVotes,
      });
    } catch (e) {
      return false;
    }
  }
}
