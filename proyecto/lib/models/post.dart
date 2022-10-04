import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
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
  final List ingred;
  final Map steps;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.saves,
    required this.ingred,
    required this.steps,
  });

  //cambiar cualquier info que necesitamos a objeto
  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'username': username,
        'postId': postId,
        'datePublished': datePublished,
        'profImage': profImage,
        'saves': saves,
        'photoUrl': postUrl,
        'ingred': ingred,
        'steps': steps,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      profImage: snapshot['profImage'],
      saves: snapshot['saves'],
      postUrl: snapshot['postUrl'],
      ingred: snapshot['ingred'],
      steps: snapshot['steps'],
    );
  }
}
