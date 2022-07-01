// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riesgo/screens/inicio_screen.dart';
import 'package:riesgo/screens/utilidades/colores.dart';
import 'package:riesgo/widgets/reutilizable.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({Key? key}) : super(key: key);

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final formKey = GlobalKey<FormState>();

  // ignore: prefer_final_fields
  TextEditingController _passwordTextController = TextEditingController();
  // ignore: prefer_final_fields
  TextEditingController _confirmPasswordTextController =
      TextEditingController();
  // ignore: prefer_final_fields
  TextEditingController _emailTextController = TextEditingController();
  // ignore: prefer_final_fields, non_constant_identifier_names
  TextEditingController _nombreUsuarioTextController = TextEditingController();
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
                          3,
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
                          3,
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
                          3,
                          70,
                          'Demasiado corta'),
                      const SizedBox(
                        height: 20,
                      ),
                      firebaseBoton2(context, 'Registrarse', formKey, () {
                        if (_passwordTextController.text ==
                            _confirmPasswordTextController.text) {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text)
                              .then((value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const InicioScreen()));
                          }).onError((error, stackTrace) {
                            // ignore: avoid_print
                            AlertDialog(
                              title: const Text(
                                'In our kitchen',
                                textAlign: TextAlign.center,
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: const [
                                    Text('Contraseñas diferentes',
                                        textAlign: TextAlign.center)
                                  ],
                                ),
                              ),
                            );
                          });
                        } else {
                          return showDialog(
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
                                        Text('Contraseñas diferentes',
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
