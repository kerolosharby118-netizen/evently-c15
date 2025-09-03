import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c15/model/event_dm.dart';
import 'package:evently_c15/model/user_dm.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> addUserToFirestore(UserDM user) async {
  var userCollection =
      FirebaseFirestore.instance.collection(UserDM.collectionName);
  var emptyDoc = userCollection.doc(user.id);
  emptyDoc.set(user.toJson());
}

Future<UserDM> getFromUserFirestore(String userId) async {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection(UserDM.collectionName);
  DocumentReference userDoc = userCollection.doc(userId);
  DocumentSnapshot snapshot = await userDoc.get();
  Map json = snapshot.data() as Map;
  var user = UserDM.fromJson(json);
  return user;
}

Future<void> addEventToFirestore(EventDM event) async {
  ///Create new collection
  var eventsCollection =
      FirebaseFirestore.instance.collection(EventDM.collectionName);
  var emptyDoc = eventsCollection.doc();
  event.id = emptyDoc.id;
  emptyDoc.set(event.toJson());
}

//
Stream<List<EventDM>> getAllEventsFromFirestore() {
  var eventsCollection =
      FirebaseFirestore.instance.collection(EventDM.collectionName);
  Stream<QuerySnapshot<Map<String, dynamic>>> stream =
      eventsCollection.snapshots();

  return stream.map((querySnapshot) {
    List<EventDM> events = querySnapshot.docs.map((docSnapshot) {
      var json = docSnapshot.data();
      return EventDM.fromJson(json);
    }).toList();
    return events;
  });
}

Future<List<EventDM>> getFavoriteEvents() async {
  var eventsCollection =
      FirebaseFirestore.instance.collection(EventDM.collectionName);
  var querySnapshot = await eventsCollection
      .where("id", whereIn: UserDM.currentUser!.favoriteEvents)
      .get();
  List<EventDM> events = querySnapshot.docs.map((docSnapshot) {
    var json = docSnapshot.data();
    return EventDM.fromJson(json);
  }).toList();
  return events;
}

Future addEventToFavorite(String eventId) async {
  var usersCollection =
      FirebaseFirestore.instance.collection(UserDM.collectionName);
  var currentUserDoc = usersCollection.doc(UserDM.currentUser!.id);

  // eventsList.add(eventId);
  currentUserDoc.update({
    "favoriteEvents": FieldValue.arrayUnion([eventId])
  });
  UserDM.currentUser!.favoriteEvents.add(eventId);
}

Future removeEventFromFavorite(String eventId) async {
  var usersCollection =
      FirebaseFirestore.instance.collection(UserDM.collectionName);
  var currentUserDoc = usersCollection.doc(UserDM.currentUser!.id);
  // var eventsList = UserDM.currentUser!.favoriteEvents;
  // eventsList.add(eventId);
  currentUserDoc.update({
    "favoriteEvents": FieldValue.arrayRemove([eventId])
  });
  UserDM.currentUser!.favoriteEvents.remove(eventId);
}
