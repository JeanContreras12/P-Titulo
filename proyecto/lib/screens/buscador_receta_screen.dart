import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:riesgo/controller/catalog.dart';
import 'package:riesgo/controller/reutilizable.dart';
import 'package:riesgo/screens/detalle_receta.dart';

class BuscadorRecetaScreen extends StatefulWidget {
  final String documento;
  final String titulo;
  const BuscadorRecetaScreen(
      {Key? key, required this.documento, required this.titulo})
      : super(key: key);

  @override
  State<BuscadorRecetaScreen> createState() => _BuscadorRecetaScreenState();
}

class _BuscadorRecetaScreenState extends State<BuscadorRecetaScreen> {
  var userData = {};
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('catalogo')
          .doc(widget.documento)
          .collection('recetas')
          .doc(widget.titulo)
          .get();
      userData = userSnap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              centerTitle: true,
              title: logoWidget("assets/logo-.png", 90, 70),
            ),
            body: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: double.infinity,
                      child: IconButton(
                        icon: Image.network(userData['photoUrl']),
                        onPressed: () {},
                      ),
                    ),
                    //CABEZERA
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 1,
                        horizontal: 12,
                      ).copyWith(right: 0),
                      child: Row(
                        children: [
                          FutureBuilder(builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                ),
                                child:
                                    FutureBuilder(builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          userData['titulo'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Tiempo: ${userData['tiempo']}",
                                        style: const TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      // ingredientes(),
                                      const Text(
                                        "Ingredientes:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      for (var item in userData['ingredientes'])
                                        Text(
                                          "- $item \n",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text("Pasos:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21,
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      for (var item in userData['pasos'].keys)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 40),
                                          child: Text(
                                            "$item.-  ${userData['pasos'][item]} \n",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                }),
                              ),
                            );
                          }),
                        ],
                      ),
                      //IMG
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ));
  }
}
