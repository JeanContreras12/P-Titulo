import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String username;
  final String uid;
  final List seguidores;
  final List seguidos;
  final String photoUrl;

  const User({
    required this.email,
    required this.username,
    required this.uid,
    required this.seguidores,
    required this.seguidos,
    required this.photoUrl,
  });

  //cambiar cualquier info que necesitamos a objeto
  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'seguidores': seguidores,
        'seguidos': seguidos,
        'photoUrl': photoUrl,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
        username: snapshot['username'],
        email: snapshot['email'],
        uid: snapshot['uid'],
        seguidores: snapshot['seguidores'],
        seguidos: snapshot['seguidos'],
        photoUrl: snapshot['photoUrl']);
  }
}
