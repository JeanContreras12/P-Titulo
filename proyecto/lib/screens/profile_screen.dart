import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riesgo/screens/Sign_In_Screen.dart';
import 'package:riesgo/utilidades/perfil_variables.dart';
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
      // obteniendo el largo del posts
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
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
    TabController _tabController = TabController(length: 2, vsync: this);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey,
              title: Text(''),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
              centerTitle: false,
              elevation: 0,
              // leading: IconButton(
              //   icon: const Icon(
              //     Icons.exit_to_app,
              //     color: Colors.black,
              //     size: 40,
              //   ),
              //   onPressed: () {
              //     FirebaseAuth.instance.signOut().then((value) {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => const SignInScreen()));
              //     });
              //   },
              // ),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                            radius: 35,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildColum(userData['username'],
                                        userData['description']),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            backgroundcolor: Color.fromARGB(
                                                255, 84, 173, 246),
                                            borderColor: Colors.grey,
                                            text: 'Editar Perfil',
                                            textColor: Colors.white,
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                backgroundcolor: Colors.grey,
                                                borderColor: Colors.grey,
                                                text: 'Dejar de seguir',
                                                textColor: Colors.white,
                                              )
                                            : FollowButton(
                                                backgroundcolor: Color.fromARGB(
                                                    255, 84, 173, 246),
                                                borderColor: Colors.grey,
                                                text: 'Seguir',
                                                textColor: Colors.white,
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
                          color: Color.fromARGB(255, 255, 6, 6),
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
                                    return Container(
                                      child: Image(
                                        image: NetworkImage(snap['photoUrl']),
                                        fit: BoxFit.cover,
                                      ),
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
                                    return Container(
                                      child: Image(
                                        image: NetworkImage(snap['photoUrl']),
                                        fit: BoxFit.cover,
                                      ),
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
