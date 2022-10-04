import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:riesgo/models/user_provider.dart';
import 'package:riesgo/screens/comentarios_screen.dart';
import 'package:riesgo/screens/profile_screen.dart';
import 'package:riesgo/controller/fb_storage.dart';
import 'package:riesgo/controller/guardado_animacion.dart';
import 'package:riesgo/models/user.dart' as model;

class PostFireBase extends StatelessWidget {
  final snap;
  const PostFireBase({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<Userprovider>(context).getUser;
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
                  return CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      snap['profImage'],
                    ),
                  );
                }),
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
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                uid: snap['uid'],
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snap['username'],
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
                IconButton(
                  //icono derecho 3 puntos con opciones
                  onPressed: () {
                    if (user!.uid == snap['uid']) {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shrinkWrap: true,
                            children: [
                              'Eliminar',
                            ]
                                .map(
                                  (e) => InkWell(
                                    onTap: () async {
                                      FirestoreMethods()
                                          .deletePost(snap['postId']);
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shrinkWrap: true,
                            children: [
                              'Ver detalles',
                            ]
                                .map(
                                  (e) => InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            //IMG
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(snap['photoUrl']),
          ),
          //descripcion
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Center(
                    child: Text('Presiona para ver más detalles',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 107, 107, 107))),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: snap['description'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.bold),
                    child: snap['saves'].length == 0 || snap['saves'].length > 1
                        ? Text(
                            '${snap['saves'].length} guardados',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 105, 105, 105)),
                          )
                        : Text(
                            '${snap['saves'].length} guardado',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 105, 105, 105)),
                          )),
              ],
            ),
          ),

          //Seccion de barra inferior (comentarios, etc)
          Row(
            children: [
              SaveAnimation(
                isAnimating: snap['saves'].contains(user?.uid),
                smallSave: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods()
                        .savePost(snap['postId'], user!.uid, snap['saves']);
                  },
                  icon: snap['saves'].contains(user?.uid)
                      ? const Icon(
                          Icons.save_sharp,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.save_sharp,
                          color: Colors.black,
                        ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(snap: snap),
                  ),
                ),
                icon: const Icon(
                  Icons.comment_outlined,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send_sharp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              DateFormat.yMMMd().format(
                snap['datePublished'].toDate(),
              ),
              style: const TextStyle(
                  fontSize: 12, color: Color.fromARGB(255, 76, 76, 76)),
            ),
          ),
        ],
      ),
    );
  }
}
