import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riesgo/screens/Sign_In_Screen.dart';
import 'package:riesgo/utilidades/colores.dart';
import 'package:riesgo/controller/reutilizable.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({Key? key}) : super(key: key);

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  // ignore: prefer_final_fields, non_constant_identifier_names
  final TextEditingController _nombreUsuarioTextController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passwordTextController.dispose();
    _emailTextController.dispose();
    _nombreUsuarioTextController.dispose();
    _confirmPasswordTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(
          "Registro",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringToColor("88FFFF"),
              hexStringToColor("FFFFCC")
            ]),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Form(
                  autovalidateMode: AutovalidateMode
                      .onUserInteraction, //necesario para realizar la validacion de campos
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      reutilizableTextFormField(
                          "Nombre de usuario",
                          Icons.person_outline,
                          false,
                          _nombreUsuarioTextController,
                          'Nombre',
                          4,
                          15,
                          'Demasiado corto'),
                      const SizedBox(
                        height: 20,
                      ),
                      reutilizableEmailFormField(
                          "Correo electronico",
                          Icons.email_outlined,
                          false,
                          _emailTextController,
                          'ejemplo@correo.com'),
                      const SizedBox(
                        height: 20,
                      ),
                      reutilizableTextFormField(
                          "Contraseña",
                          Icons.lock_outline,
                          true,
                          _passwordTextController,
                          'Contraseña',
                          6,
                          70,
                          'Demasiado corta'),
                      const SizedBox(
                        height: 20,
                      ),
                      reutilizableTextFormField(
                          "Repetir contraseña",
                          Icons.lock_reset_outlined,
                          true,
                          _confirmPasswordTextController,
                          'Contraseña',
                          6,
                          70,
                          'Demasiado corta'),
                      const SizedBox(
                        height: 20,
                      ),
                      firebaseBoton2(context, 'Registrarse', formKey, () async {
                        if (_passwordTextController.text ==
                            _confirmPasswordTextController.text) {
                          bool nameUsed = false;
                          var postSnap = await FirebaseFirestore.instance
                              .collection('users')
                              .where('username',
                                  isEqualTo: _nombreUsuarioTextController.text)
                              .get();
                          postSnap.docs.forEach(
                            (msgDoc) async {
                              print(msgDoc['username']);
                              if (msgDoc['username'] ==
                                  _nombreUsuarioTextController.text) {
                                nameUsed = true;
                              }
                            },
                          );
                          if (nameUsed != true) {
                            try {
                              var emailUser = await MetodosdeAuth().registro(
                                  username: _nombreUsuarioTextController.text,
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text);
                              if (emailUser == "fallo email") {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Error',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const [
                                              Text('Correo ya registrado',
                                                  textAlign: TextAlign.center)
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              } else if (emailUser == 'Exitoso') {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'In our kitchen',
                                          textAlign: TextAlign.center,
                                        ),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const [
                                              Text('Registro exitoso',
                                                  textAlign: TextAlign.center)
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }
                            } catch (e) {
                              print(e);
                            }
                          } else {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Error',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const [
                                          Text(
                                              'Nombre de usuario ya registrado',
                                              textAlign: TextAlign.center)
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        } else {
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Error',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: const [
                                        Text(
                                            'Las contraseñas deben ser identicas',
                                            textAlign: TextAlign.center)
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                      }),
                    ],
                  )),
            ),
          )),
    );
  }
}
