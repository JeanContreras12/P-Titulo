// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:riesgo/utilidades/colores.dart';
import 'package:riesgo/widgets/reutilizable.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  // ignore: prefer_final_fields
  TextEditingController _emailTextController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailTextController.dispose();
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
        title: const Center(
          child: Text(
            "Restablecer contraseña",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
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
                      reutilizableEmailFormField(
                          "Correo electronico",
                          Icons.email_outlined,
                          false,
                          _emailTextController,
                          'ejemplo@correo.com'),
                      const SizedBox(
                        height: 20,
                      ),
                      firebaseBoton2(context, "Restablecer contraseña", formKey,
                          () {
                        RecuperarContra();
                      }),
                    ],
                  ),
                )),
          )),
    );
  }

  // ignore: non_constant_identifier_names
  Future RecuperarContra() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailTextController.text)
          .then((value) => showDialog(
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
                        Text(
                            'Si la cuenta existe el enlace fue enviado al correo electronico',
                            textAlign: TextAlign.center)
                      ],
                    ),
                  ),
                );
              }));
    } on FirebaseAuthException catch (e) {
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
                    Text(
                        'Si la cuenta existe el enlace fue enviado al correo electronico',
                        textAlign: TextAlign.center)
                  ],
                ),
              ),
            );
          });
    }
  }
}
