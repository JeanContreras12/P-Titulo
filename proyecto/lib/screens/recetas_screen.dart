// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riesgo/controller/catalog.dart';
import 'package:riesgo/controller/reutilizable.dart';

class RecetasScreen extends StatefulWidget {
  final String nom;
  const RecetasScreen({Key? key, required this.nom}) : super(key: key);

  @override
  State<RecetasScreen> createState() => _RecetasScreenState();
}

class _RecetasScreenState extends State<RecetasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: logoWidget("assets/logo-.png", 90, 70),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('catalogo')
            .doc(widget.nom)
            .collection('recetas')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // return ListView(
          //   padding: const EdgeInsets.symmetric(
          //     vertical: 16,
          //   ),
          //   children: [
          //     Text(snapshot['titulo'])
          //   ],
          // );
          return ListView.builder(
            itemCount:
                snapshot.data!.docs.length, //obtener la cantidad de post hechos
            itemBuilder: (context, index) => CatalogFireBase(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }
}
