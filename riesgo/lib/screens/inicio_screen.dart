<<<<<<< HEAD
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riesgo/providers/user_provider.dart';
import 'package:riesgo/utilidades/variables.dart';
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riesgo/screens/Sign_In_Screen.dart';
import 'package:riesgo/screens/subir_imagen.dart';
>>>>>>> 7b7824a15f9b710cb67966c8677c6f92c354acf5

class InicioScreen extends StatefulWidget {
  const InicioScreen({Key? key}) : super(key: key);

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
<<<<<<< HEAD
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    addData();
    pageController = PageController();
  }

  addData() async {
    Userprovider _userProvider = Provider.of(context,
        listen:
            false); //listen: false nos deja que solo una vez se llame al user
    await _userProvider.refreshUser();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        physics:
            const NeverScrollableScrollPhysics(), //evita que se pueda cambiar de ventana arrastrando la pantalla hacia los lados
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? Colors.black : Colors.grey,
            ),
            label: '',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _page == 1 ? Colors.black : Colors.grey,
            ),
            label: '',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: _page == 2 ? Colors.black : Colors.grey,
            ),
            label: '',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.beenhere,
              color: _page == 3 ? Colors.black : Colors.grey,
            ),
            label: '',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 4 ? Colors.black : Colors.grey,
            ),
            label: '',
            backgroundColor: Colors.white,
          ),
        ],
        onTap: navigationTapped,
      ),

      // Container(
      //   decoration: const BoxDecoration(
      //     boxShadow: <BoxShadow>[
      //       BoxShadow(
      //           color: Colors.black54,
      //           blurRadius: 15.0,
      //           offset: Offset(0.0, 0.75))
      //     ],
      //   ),
=======
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Inspiracion",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.black,
            size: 40,
          ),
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignInScreen()));
            });
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 15.0,
                offset: Offset(0.0, 0.75))
          ],
        ),
        child: BottomAppBar(
          elevation: 10,
          // ignore: avoid_unnecessary_containers
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PhotoUpload()));
                  },
                  icon: const Icon(Icons.add_a_photo),
                  iconSize: 40,
                  color: Colors.pink,
                )
              ],
            ),
          ),
        ),
      ),
>>>>>>> 7b7824a15f9b710cb67966c8677c6f92c354acf5
    );
  }
}
