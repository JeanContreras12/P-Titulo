import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riesgo/screens/cambiar_contra.dart';
import 'package:riesgo/widgets/reutilizable.dart';

class ChangePassScreen extends StatefulWidget {
  final String uid;
  const ChangePassScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  final TextEditingController _contraUsuarioTextController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
          .collection('users')
          .doc(widget.uid)
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
  void dispose() {
    super.dispose();
    _contraUsuarioTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text('Cambiar contraseña'),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
        centerTitle: false,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Image.asset("assets/logo-.png"),
                      ),
                      TextFormField(
                        controller: _contraUsuarioTextController,
                        obscureText: true,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: 'Ingresa tu contraseña actual',
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 0,
                                style: BorderStyle.none),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value != null && value.length < 1) {
                            return 'Demasiado corto';
                          } else if (value != null && value.length > 70) {
                            return 'Demasiado largo';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90)),
                        child: ElevatedButton(
                          onPressed: () async {
                            final isValidForm =
                                _formKey.currentState!.validate();
                            var currentPassword = await checkCurrentPass(
                                _contraUsuarioTextController.text);
                            if (isValidForm && currentPassword) {
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AuthChangePassScreen(),
                                ),
                              );
                            } else {
                              // ignore: use_build_context_synchronously
                              showSnackBar(
                                  'Error comprueba la contraseña', context);
                            }
                          },
                          // ignore: sort_child_properties_last
                          child: const Text(
                            'Comprobar contraseña',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.black26;
                              }
                              return const Color.fromARGB(255, 98, 176, 101);
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> checkCurrentPass(String password) async {
    bool success = false;
    var user = await FirebaseAuth.instance.currentUser!;
    var credentials = await EmailAuthProvider.credential(
        email: user.email!, password: password);
    try {
      await user.reauthenticateWithCredential(credentials);
      success = true;
    } catch (e) {
      success = false;
    }
    return success;
  }
}
