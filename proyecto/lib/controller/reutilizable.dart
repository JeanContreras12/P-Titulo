// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riesgo/models/user.dart' as model;
import 'package:riesgo/screens/Registro_screen.dart';

Image logoWidget(String imageName, double wid, double hei) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: wid,
    height: hei,
  );
}

Container firebaseBoton(BuildContext context, String titulo, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      // ignore: sort_child_properties_last
      child: Text(
        titulo,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

// ignore: non_constant_identifier_names
Row RegistroOpcion(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "¿No registrado?",
        style: TextStyle(color: Colors.white70),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RegistroScreen()));
        },
        child: const Text(
          "Registro",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

TextFormField reutilizableTextFormField(
    String text,
    IconData icon,
    bool isPasswordType,
    TextEditingController controller,
    String hint,
    num minimo,
    num maximo,
    String dialogo) {
  return TextFormField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(
        icon: Icon(icon, color: Colors.black),
        hintText: hint,
        labelText: text,
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
    validator: (value) {
      if (value != null && value.length < minimo) {
        return dialogo;
      } else if (value != null && value.length > maximo) {
        return 'Demasiado largo';
      } else {
        return null;
      }
    },
  );
}

TextFormField reutilizableEmailFormField(
  String text,
  IconData icon,
  bool isPasswordType,
  TextEditingController controller,
  String hint,
) {
  return TextFormField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(
        icon: Icon(icon, color: Colors.black),
        hintText: hint,
        labelText: text,
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
    validator: (email) => email != null && !EmailValidator.validate(email)
        ? 'Introduzca un email válido'
        : null,
  );
}

Container firebaseBoton2(
    BuildContext context, String titulo, formkey, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        final isValidForm = formkey.currentState!.validate();
        if (isValidForm) {
          onTap();
        }
      },
      // ignore: sort_child_properties_last
      child: Text(
        titulo,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

class MetodosdeAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  Future<String> registro({
    required String username,
    required String email,
    required String password,
  }) async {
    String res = "Ocurrio un error";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        //registrar al usuario
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        //añadir los otros datos a la base de datos
        print(cred.user!.uid);
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          seguidores: [],
          seguidos: [],
          description: 'Nueva cuenta',
          photoUrl:
              'https://firebasestorage.googleapis.com/v0/b/titulo-a5fe7.appspot.com/o/FotoPerfil%2Fundef.jpg?alt=media&token=cd66cfb5-5e24-43fc-be7b-7d7b102cfc44',
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "Exitoso";
      }
    } catch (error) {
      if (error.toString() ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        res = "fallo email";

        ///FALTA VERIFICAR NOMBRE DE USUARIO YA USADO

        var postSnap = await FirebaseFirestore.instance
            .collection('users')
            .where(username, isEqualTo: username)
            .get();
        postSnap.docs.forEach((msgDoc) async {
          print(msgDoc);
        });
      } else {
        res = 'ERROR';
      }
    }
    return res;
  }
}

pickimage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('Ninguna imagen fue seleccionada');
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
