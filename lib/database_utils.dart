import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook/models/my_user.dart';
import 'Chat/message.dart';

class DatabaseUtils {
  static CollectionReference<MyUser> getUsersCollection() {
    return FirebaseFirestore.instance.collection(MyUser.collectionName).
    withConverter<MyUser>(
      fromFirestore: (snapshot, options) =>
          MyUser.fromFireStore(snapshot.data()),
      toFirestore: (user, options) => user.toFireStore(),
    );
  }

  static Future<MyUser?> getUser(String userId) async{
    var documentSnapshot = await getUsersCollection().doc(userId).get();
    documentSnapshot.data();
  }

  static CollectionReference<Message> getMessageCollection(String userId){
    return FirebaseFirestore.instance.collection(MyUser.collectionName).
        doc(userId).
        collection(Message.collectionName).
    withConverter<Message>(
        fromFirestore: (snapshot, options) =>
        Message.fromJson(snapshot.data()!),
        toFirestore: (message, options) => message.toJson(),
    );
  }

  static Future<void> addUserToFireStore(MyUser user) {
    return getUsersCollection().doc(user.id).set(user);
  }

  static Future<MyUser?> readUserFromFireStore(String uId) async {
    var querySnapShot = await getUsersCollection().doc(uId).get();
    return querySnapShot.data();
  }

  static Future<void> insertMessage (Message message) async{
    var messageCollection = getMessageCollection(message.id);
    var docRef = messageCollection.doc();
    message.id = docRef.id;
    return docRef.set(message);
  }
}