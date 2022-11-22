// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riesgo/screens/Registro_screen.dart';
import 'package:riesgo/screens/inicio_screen.dart';
import 'package:riesgo/screens/reset_password.dart';
import 'package:riesgo/utilidades/colores.dart';
import 'package:riesgo/controller/reutilizable.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<
      FormState>(); //formkey necesaria para comprobacion de campos correctamente rellenados
  // ignore: prefer_final_fields
  TextEditingController _passwordTextController = TextEditingController();
  // ignore: prefer_final_fields
  TextEditingController _emailTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passwordTextController.dispose();
    _emailTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [hexStringToColor("88FFFF"), hexStringToColor("FFFFCC")]),
      ),
      child: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formKey,
                child: Column(
                  children: <Widget>[
                    logoWidget("assets/logo-.png", 240, 200),
                    const SizedBox(
                      height: 30,
                    ),
                    reutilizableEmailFormField(
                        "Correo electronico",
                        Icons.person_outline,
                        false,
                        _emailTextController,
                        'ejemplo@correo.com'),
                    const SizedBox(
                      height: 20,
                    ),
                    reutilizableTextFormField(
                        "Contraseña",
                        Icons.lock,
                        true,
                        _passwordTextController,
                        'Contraseña',
                        1,
                        100,
                        'Debe introducir contraseña'),
                    const SizedBox(
                      height: 5,
                    ),
                    OlvidoContrasena(context),
                    firebaseBoton2(context, 'Iniciar sesion', formKey, () {
                      IniciarSesion();
                    }),
                    RegistroOpcion()
                  ],
                ))),
      ),
    ));
  }

  // ignore: non_constant_identifier_names
  Row RegistroOpcion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "¿No registrado?",
          style: TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegistroScreen()));
          },
          child: const Text(
            "   Registrarse",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget OlvidoContrasena(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text('¿Olvidaste la contraseña?',
            style: TextStyle(color: Colors.black), textAlign: TextAlign.right),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ResetPasswordScreen())),
      ),
    );
  }

  Future IniciarSesion() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text)
          .then((value) => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const InicioScreen())));
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
                    Text('Datos invalidos', textAlign: TextAlign.center)
                  ],
                ),
              ),
            );
          });
    }
  }
}
