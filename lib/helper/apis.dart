import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:test/models/UserTest.dart';
import 'package:test/models/chatUser.dart';
import 'package:test/models/message.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  String timeStamp24HR = "2020-07-20T18:15:12";

  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => auth.currentUser!;

  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static chatUser? me;
  static chatUser? users;

  static Future<bool> userExists() async {
    return (await firestore.collection('test').doc(user.uid).get()).exists;
  }

  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me!.pushToken = t;
        print("Push Token : $t");
      }
    });
  }

  static Future<void> sendPushNotification(
      chatUser chatuser, String msg) async {
    try {
      final body = {
        "to": chatuser.pushToken,
        "notification": {
          "title": "chatuser.name",
          "body": "-------------------------------------------------"
        }
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAdFvn3Mo:APA91bEEI1Kgp_VKaJpzGDrDqOHajlNqbi_1gyTp87wsfkb4fSDrBew6E2xh5CKlL2Qo9A9GJsAQcumYXx30VFH7miSUH2yD95N14GogMvOhnmhqPovMGZ0Jc1HbQ1Wp3ZmO-rX61qD2'
          },
          body: jsonEncode(body));
      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
    } catch (e) {
      print('\nsendPushNotification: $e');
    }
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection('test').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = chatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();
      } else {
        await CreateUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> CreateUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUsers = chatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "hey, I'm using this app",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );
    return await firestore
        .collection('doctors')
        .doc(user.uid)
        .set(chatUsers.toJson());
  }

  static Future<void> CreateUserRool(name, email, about, rool, id) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUseerss = chatUserss(
      id: id,
      name: name,
      email: email,
      about: about,
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
      rool: rool,
    );
    return await firestore
        .collection('test')
        .doc(user.uid)
        .set(chatUseerss.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('test')
        .where('rool', isNotEqualTo: 'Doctor')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getdoctors() {
    return firestore
        .collection('test')
        .where('rool', isNotEqualTo: 'Patient')
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> UpdateUserInfo() async {
    await firestore.collection('test').doc(user.uid).update({
      'name': me!.name,
      'about': me!.about,
    });
  }

  static Future<void> UpdateProfilePic(File file) async {
    final ext = file.path.split('.').last;
    print('extention: $ext');
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transfered: ${p0.bytesTransferred / 1000} kb');
    });
    me!.image = await ref.getDownloadURL();
    await firestore
        .collection('test')
        .doc(user.uid)
        .update({'image': me!.image});
  }

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      chatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      chatUser chatuser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    // var now = DateTime.now();
    // var time = DateFormat('jms').format(now);
    final Message message = Message(
        msg: msg,
        read: '',
        told: chatuser.id,
        type: type,
        sent: time,
        fromId: user.uid);

    final ref = firestore
        .collection('chats/${getConversationID(chatuser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatuser, type == Type.text ? msg : 'Photo'));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      chatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(chatUser chatuser, File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child(
        'images/${getConversationID(chatuser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} Kb');
    });

    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatuser, imageUrl, Type.image);
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection("chats/${getConversationID(message.fromId)}/messages")
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }
}
