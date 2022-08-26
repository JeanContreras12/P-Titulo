import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riesgo/providers/user_provider.dart';
import 'package:riesgo/screens/buscar_screen.dart';
import 'package:riesgo/screens/feed_screen.dart';
import 'package:riesgo/screens/postear_screen.dart';
import 'package:riesgo/screens/profile_screen.dart';
import 'package:riesgo/utilidades/variables.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({Key? key}) : super(key: key);

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  int _page = 0;
  late PageController pageController;
  var user = FirebaseAuth.instance.currentUser!.uid;

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
        children: homeScreenItems = [
          FeedScreen(),
          SearchScreen(),
          PostearScreen(
            uid: FirebaseAuth.instance.currentUser!.uid,
          ),
          Text('hola4'),
          ProfileScreen(
            uid: FirebaseAuth.instance.currentUser!.uid,
          ),
        ],
        physics:
            const NeverScrollableScrollPhysics(), //evita que se pueda cambiar de ventana arrastrando la pantalla hacia los lados
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Color.fromARGB(255, 231, 231, 231),
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
    );
  }
}
