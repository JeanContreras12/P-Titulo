import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'chat.g.dart';

// ignore: library_private_types_in_public_api
class ChatState = _ChatState with _$ChatState;

// The store-class
abstract class _ChatState with Store {
  var currentUser = FirebaseAuth.instance.currentUser?.uid;
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  @observable
  Map<String, dynamic> messages = ObservableMap();

  @action
  void refreshChatsForCurrentUser() {
    messages = ({});
    var chatDocuments = [];
    var currentuser = FirebaseAuth.instance.currentUser!.uid;
    // ignore: prefer_typing_uninitialized_variables
    chats
        .where('users.$currentuser', isEqualTo: currentuser)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      chatDocuments = snapshot.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, dynamic> names = data['names'];
        names.remove(currentuser);
        Map<String, dynamic> friendUid = data['users'];
        friendUid.remove(currentuser);

        return {
          'docid': doc.id,
          'name': names.values.first,
          'friendid': friendUid.values.first
        };
      }).toList();
      chatDocuments.forEach((doc) {
        FirebaseFirestore.instance
            .collection('chats/${doc['docid']}/messages')
            .orderBy('createdOn', descending: true)
            .limit(1)
            .snapshots()
            .listen((QuerySnapshot snapshot) {
          if (snapshot.docs.isNotEmpty) {
            messages[doc['name']] = {
              'msg': snapshot.docs.first['msg'],
              'time': snapshot.docs.first['createdOn'],
              'friendName': doc['name'],
              'friendUid': doc['friendid'],

              ///AQUI EL PROBLEMA NO ESTA OBTENIENDO EL UID DEL AMIGO SI NO DEL ULTIMO MENSAJE
            };
          }
        });
      });
    });
  }
}
