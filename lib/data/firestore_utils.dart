import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c15/model/event_dm.dart';
import 'package:evently_c15/model/user_dm.dart';

Future<void> addUserToFirestore(UserDM user) async {
  var userCollection =
  FirebaseFirestore.instance.collection(UserDM.collectionName);
  var emptyDoc = userCollection.doc(user.id);
  emptyDoc.set(user.toJson());
}

Future<UserDM?> getFromUserFirestore(String userId) async {
  try {
    CollectionReference userCollection =
    FirebaseFirestore.instance.collection(UserDM.collectionName);
    DocumentReference userDoc = userCollection.doc(userId);
    DocumentSnapshot snapshot = await userDoc.get();

    if (snapshot.exists && snapshot.data() != null) {
      Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
      var user = UserDM.fromJson(json);
      print("✅ User found in Firestore: ${user.toJson()}");
      return user;
    } else {
      print("⚠️ No user found in Firestore with id: $userId");
      return null;
    }
  } catch (e) {
    print("❌ Error in getFromUserFirestore: $e");
    return null;
  }
}

Future<void> addEventToFirestore(EventDM event) async {
  var eventsCollection =
  FirebaseFirestore.instance.collection(EventDM.collectionName);
  var emptyDoc = eventsCollection.doc();
  event.id = emptyDoc.id;
  emptyDoc.set(event.toJson());
}

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

  currentUserDoc.update({
    "favoriteEvents": FieldValue.arrayUnion([eventId])
  });
  UserDM.currentUser!.favoriteEvents.add(eventId);
}

Future removeEventFromFavorite(String eventId) async {
  var usersCollection =
  FirebaseFirestore.instance.collection(UserDM.collectionName);
  var currentUserDoc = usersCollection.doc(UserDM.currentUser!.id);

  currentUserDoc.update({
    "favoriteEvents": FieldValue.arrayRemove([eventId])
  });
  UserDM.currentUser!.favoriteEvents.remove(eventId);
}
