import 'package:flutter/material.dart';
import 'package:riesgo/screens/detalle_receta.dart';

class CatalogFireBase extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const CatalogFireBase({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          //CABEZERA
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                FutureBuilder(builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snap['titulo'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ],
                          ),
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

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: IconButton(
              icon: Image.network(snap['photoUrl']),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetalleRecetaScreen(snap: snap),
                  ),
                );
              },
            ),
          ),

          const Divider(
            color: Colors.black,
            thickness: 7,
          ),
        ],
      ),
    );
  }
}
