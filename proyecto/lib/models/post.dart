import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String titulo;
  final String username;
  final String uid;
  final String postId;
  // ignore: prefer_typing_uninitialized_variables
  final datePublished;
  final String postUrl;
  final String profImage;
  // ignore: prefer_typing_uninitialized_variables
  final saves;
  // ignore: prefer_typing_uninitialized_variables
  final List ingredientes;
  final Map pasos;
  final String tiempo;

  const Post({
    required this.titulo,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.saves,
    required this.ingredientes,
    required this.pasos,
    required this.tiempo,
  });

  //cambiar cualquier info que necesitamos a objeto
  Map<String, dynamic> toJson() => {
        'titulo': titulo,
        'uid': uid,
        'username': username,
        'postId': postId,
        'datePublished': datePublished,
        'profImage': profImage,
        'saves': saves,
        'photoUrl': postUrl,
        'ingredientes': ingredientes,
        'pasos': pasos,
        'tiempo': tiempo,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      titulo: snapshot['titulo'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      profImage: snapshot['profImage'],
      saves: snapshot['saves'],
      postUrl: snapshot['postUrl'],
      ingredientes: snapshot['ingredientes'],
      pasos: snapshot['pasos'],
      tiempo: snapshot['tiempo'],
    );
  }
}
