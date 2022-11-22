import 'package:flutter/material.dart';
import 'package:riesgo/controller/reutilizable.dart';

class DetalleRecetaScreen extends StatefulWidget {
  final snap;
  const DetalleRecetaScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<DetalleRecetaScreen> createState() => _DetalleRecetaScreenState();
}

class _DetalleRecetaScreenState extends State<DetalleRecetaScreen> {
  int iterable = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    icon: Image.network(widget.snap['photoUrl']),
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
                            child: FutureBuilder(builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      widget.snap['titulo'],
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
                                    "Tiempo: ${widget.snap['tiempo']}",
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
                                  for (var item in widget.snap['ingredientes'])
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
                                  for (var item in widget.snap['pasos'].keys)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 40),
                                      child: Text(
                                        "$item.-  ${widget.snap['pasos'][item]} \n",
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

  ingredientes() {
    List<Widget> list = [];
    try {
      print(widget.snap);
      widget.snap['ingredientes'].forEach((item) {
        Text(item);
      });
    } catch (e) {
      print(e);
    }
    return Text("algo");
  }
}
