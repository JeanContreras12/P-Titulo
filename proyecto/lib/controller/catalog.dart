import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:riesgo/screens/comentarios_screen.dart';
import 'package:riesgo/screens/profile_screen.dart';
import 'package:riesgo/controller/fb_storage.dart';
import 'package:riesgo/controller/guardado_animacion.dart';

class CatalogFireBase extends StatelessWidget {
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
                        return InkWell(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snap['titulo'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.35,
          //   width: double.infinity,
          //   child: Image.network(snap['photoUrl']),
          // ),
          // //descripcion
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Center(
          //         child: Text('Presiona para ver más',
          //             style: TextStyle(
          //                 fontSize: 14,
          //                 color: Color.fromARGB(255, 107, 107, 107))),
          //       ),
          //       Container(
          //         width: double.infinity,
          //         padding: const EdgeInsets.only(top: 8),
          //         child: RichText(
          //           text: TextSpan(
          //             style: const TextStyle(color: Colors.black),
          //             children: [
          //               TextSpan(
          //                 text: snap['description'],
          //                 style: const TextStyle(fontWeight: FontWeight.bold),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       const SizedBox(
          //         height: 10,
          //       ),
          //       DefaultTextStyle(
          //           style: Theme.of(context)
          //               .textTheme
          //               .subtitle2!
          //               .copyWith(fontWeight: FontWeight.bold),
          //           child: snap['saves'].length == 0 || snap['saves'].length > 1
          //               ? Text(
          //                   '${snap['saves'].length} guardados',
          //                   style: const TextStyle(
          //                       color: Color.fromARGB(255, 105, 105, 105)),
          //                 )
          //               : Text(
          //                   '${snap['saves'].length} guardado',
          //                   style: const TextStyle(
          //                       color: Color.fromARGB(255, 105, 105, 105)),
          //                 )),
          //     ],
          //   ),
          // ),

          //Seccion de barra inferior (comentarios, etc)
        ],
      ),
    );
  }
}
