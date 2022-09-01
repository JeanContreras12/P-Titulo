import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riesgo/screens/Sign_In_Screen.dart';
import 'package:riesgo/screens/comprobar_contra.dart';
import 'package:riesgo/screens/edit_perfil.dart';
import 'package:riesgo/widgets/fb_storage.dart';
import 'package:riesgo/widgets/follow_button.dart';
import 'package:riesgo/widgets/reutilizable.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  var userData = {};
  var userData2 = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
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
          .collection('users')
          .doc(widget.uid)
          .get();
      var userSnap2 = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      // obteniendo el largo del posts
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData2 = userSnap2.data()!;
      userData = userSnap
          .data()!; //USER DATA ES EL PERFIL QUE ESTAMOS VIENDO AHORA MISMO ES DECIR LOS DATOS DEL USUARIO DONDE ESTAMOS PARADOS
      followers = userSnap.data()!['seguidores'].length;
      following = userSnap.data()!['seguidos'].length;
      isFollowing = userSnap
          .data()!['seguidores']
          .contains(FirebaseAuth.instance.currentUser!.uid);

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
    // ignore: no_leading_underscores_for_local_identifiers
    TabController _tabController = TabController(length: 2, vsync: this);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 117, 116, 116),
              title: const Text(''),
              titleTextStyle:
                  const TextStyle(color: Colors.black, fontSize: 20),
              centerTitle: false,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  //icono derecho 3 puntos con opciones
                  onPressed: () {
                    if (userData2['uid'] == userData['uid']) {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shrinkWrap: true,
                            children: ['Cerrar sesión', 'Cambiar contraseña']
                                .map(
                                  (e) => InkWell(
                                    onTap: () async {
                                      if (e == 'Cerrar sesión') {
                                        await FirestoreMethods().signOut();
                                        FirebaseAuth.instance
                                            .authStateChanges();
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SignInScreen()),
                                                (route) => false);
                                        // Navigator.of(context).pushReplacement(
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             const SignInScreen()));
                                      } else {
                                        Navigator.pop(context);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChangePassScreen(
                                                    uid: FirebaseAuth.instance
                                                        .currentUser!.uid),
                                          ),
                                        );
                                      }
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
                              'Enviar mensaje',
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
                ),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          FutureBuilder(builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                userData['photoUrl'],
                              ),
                              radius: 35,
                            );
                          }),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      child: buildColum(userData['username'],
                                          userData['description']),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            backgroundcolor:
                                                const Color.fromARGB(
                                                    255, 84, 173, 246),
                                            borderColor: Colors.grey,
                                            text: 'Editar Perfil',
                                            textColor: Colors.white,
                                            function: () =>
                                                Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProfil(
                                                        uid: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid),
                                              ),
                                            ),
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                backgroundcolor: Colors.grey,
                                                borderColor: Colors.grey,
                                                text: 'Dejar de seguir',
                                                textColor: Colors.white,
                                                function: () async {
                                                  await FirestoreMethods()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );
                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                backgroundcolor:
                                                    const Color.fromARGB(
                                                        255, 84, 173, 246),
                                                borderColor: Colors.grey,
                                                text: 'Seguir',
                                                textColor: Colors.white,
                                                function: () async {
                                                  await FirestoreMethods()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );
                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              )
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildColum2(followers, 'Seguidores'),
                                    buildColum2(following, 'Seguidos'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        indicator: DotIndicator(
                          color: const Color.fromARGB(255, 255, 6, 6),
                          distanceFromCenter: 16,
                          radius: 3,
                          paintingStyle: PaintingStyle.fill,
                        ),
                        controller: _tabController,
                        tabs: const [
                          Tab(
                            text: 'Recetas',
                          ),
                          Tab(
                            text: 'Guardados',
                          )
                        ],
                      ),
                      const Divider(),
                      Container(
                        width: double.maxFinite,
                        height: 300,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('posts')
                                  .where('uid', isEqualTo: widget.uid)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return GridView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      (snapshot.data! as dynamic).docs.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 1.5,
                                    childAspectRatio: 1,
                                  ),
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot snap =
                                        (snapshot.data! as dynamic).docs[index];
                                    return Image(
                                      image: NetworkImage(snap['photoUrl']),
                                      fit: BoxFit.cover,
                                    );
                                  },
                                );
                              },
                            ),
                            FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('posts')
                                  .where('saves', arrayContains: widget.uid)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return GridView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      (snapshot.data! as dynamic).docs.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 1.5,
                                    childAspectRatio: 1,
                                  ),
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot snap =
                                        (snapshot.data! as dynamic).docs[index];
                                    return Image(
                                      image: NetworkImage(snap['photoUrl']),
                                      fit: BoxFit.cover,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Column buildColum(String text, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 7, left: 1),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Column buildColum2(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 7, left: 9),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
