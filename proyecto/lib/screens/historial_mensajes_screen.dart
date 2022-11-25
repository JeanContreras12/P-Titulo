import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:riesgo/controller/reutilizable.dart';
import 'package:riesgo/models/lib.dart';
import 'package:riesgo/screens/mensajes_screen.dart';

class HistorialMensajesScreen extends StatefulWidget {
  final String uid;
  const HistorialMensajesScreen({Key? key, required this.uid})
      : super(key: key);

  @override
  State<HistorialMensajesScreen> createState() => _HistorialMensajesScreen();
}

class _HistorialMensajesScreen extends State<HistorialMensajesScreen> {
  var userData = {};
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
    chatState.refreshChatsForCurrentUser();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      userData = userSnap
          .data()!; //USER DATA ES EL PERFIL QUE ESTAMOS VIENDO AHORA MISMO ES DECIR LOS DATOS DEL USUARIO DONDE ESTAMOS PARADOS
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  void callChatDetailScreen(BuildContext context, String name, String uid) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => MensajesScreen(
                  friendUid: uid,
                  friendName: name,
                  historial: 1,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Observer(
            builder: (BuildContext context) => Container(
                  color: Colors.white,
                  child: CustomScrollView(
                    slivers: [
                      const CupertinoSliverNavigationBar(
                        largeTitle: Text("Mensajes"),
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate(
                              chatState.messages.values.toList().map((data) {
                        // ignore: avoid_print
                        print(chatState.messages.values);
                        return Observer(
                          builder: (_) => CupertinoListTile(
                            onTap: () {
                              Navigator.pop(context);
                              callChatDetailScreen(context, data['friendName'],
                                  data['friendUid']);
                            },
                            title: Text(data['friendName']),
                            subtitle: Text(data['msg']),
                          ),
                        );
                      }).toList()))
                    ],
                  ),
                ));
  }
}























// import 'package:cupertino_list_tile/cupertino_list_tile.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:riesgo/models/lib.dart';
// import 'package:riesgo/screens/mensajes_screen.dart';

// class HistorialMensajesScreen extends StatefulWidget {
//   const HistorialMensajesScreen({Key? key}) : super(key: key);

//   @override
//   State<HistorialMensajesScreen> createState() =>
//       _HistorialMensajesScreenState();
// }

// class _HistorialMensajesScreenState extends State<HistorialMensajesScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     chatState.refreshChatsForCurrentUser();
//   }

//   void callChatDetailScreen(BuildContext context, String name, String uid) {
//     Navigator.push(
//         context,
//         CupertinoPageRoute(
//             builder: (context) =>
//                 MensajesScreen(friendUid: uid, friendName: name)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Observer(
//       builder: (BuildContext context) => Container(
//         color: Colors.white,
//         child: CustomScrollView(
//           slivers: [
//             CupertinoSliverNavigationBar(
//               largeTitle: Text("Mensajes"),
//             ),
//             SliverList(
//                 delegate: SliverChildListDelegate(
//                     chatState.messages.values.toList().map((data) {
//               return CupertinoListTile(
//                 onTap: () => callChatDetailScreen(
//                     context, data['friendName'], data['friendUid']),
//                 title: Text(data['friendName']),
//                 subtitle: Text(data['msg']),
//               );
//             }).toList())),
//           ],
//         ),
//       ),
//     );

//   }
// }
