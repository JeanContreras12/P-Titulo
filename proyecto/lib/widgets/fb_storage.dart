import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:riesgo/models/post.dart';
import 'package:uuid/uuid.dart';

class MetodosStorage {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //funcion para añadir imagenes a firebase Storage
  Future<String> SubirImagenAStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!
        .uid); //2 child para que sea una carpeta de imagenes con una carpeta del usuario con sus imagenes

    if (isPost) {
      //dado que un usuario puede postear mas de 1 vez
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //subir el post a firebase
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String rest = "Ocurrio un error";
    try {
      String photoUrl =
          await MetodosStorage().SubirImagenAStorage('posts', file, true);

      String postId = const Uuid()
          .v1(); //extension uuid, v1 crea un identificador unico basado en tiempo actual, v4

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        saves: [],
      ); //con esto subimos a la storage, falta subirlo a firebase

      _firestore.collection('posts').doc(postId).set(post.toJson());

      rest = "exito";
    } catch (error) {
      rest = error.toString();
    }
    return rest;
  }

  Future<void> savePost(String postId, String uid, List saves) async {
    try {
      if (saves.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'saves': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'saves': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('empty');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  //ELIMINAR UN POST

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();

      List following = (snap.data()! as dynamic)['seguidos'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'seguidores': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'seguidos': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'seguidores': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'seguidos': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> ChangeProfilePic(
      String uid, String file, String? nombre, String? description) async {
    try {
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      // var snapshots = FirebaseFirestore.instance.collection('posts');
      await _firestore.collection('users').doc(uid).update({'photoUrl': file});
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'username': nombre});
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'description': description});
      // await snapshots.forEach((document) async {
      //   print(document.toString());
      // });
      postSnap.docs.forEach((msgDoc) async {
        await msgDoc.reference.update({'username': nombre});
      });
    } catch (e) {
      print('Debe seleccionar una imagen para cambiar');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
