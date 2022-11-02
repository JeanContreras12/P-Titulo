import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riesgo/controller/post.dart';
import 'package:riesgo/controller/reutilizable.dart';
import 'package:riesgo/screens/historial_mensajes_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: logoWidget("assets/logo-.png", 90, 70),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HistorialMensajesScreen(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.messenger_outline_sharp,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount:
                snapshot.data!.docs.length, //obtener la cantidad de post hechos
            itemBuilder: (context, index) => PostFireBase(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }
}
