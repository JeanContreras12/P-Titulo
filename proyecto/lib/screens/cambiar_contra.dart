import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riesgo/screens/Sign_In_Screen.dart';
import 'package:riesgo/controller/fb_storage.dart';
import 'package:riesgo/controller/reutilizable.dart';

class AuthChangePassScreen extends StatefulWidget {
  final String passw;
  const AuthChangePassScreen({Key? key, required this.passw}) : super(key: key);

  @override
  State<AuthChangePassScreen> createState() => _AuthChangePassScreenState();
}

class _AuthChangePassScreenState extends State<AuthChangePassScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
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
                        controller: _passwordTextController,
                        obscureText: true,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: 'Ingresa tu nueva contraseña',
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
                          if (value != null && value.length < 6) {
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
                      TextFormField(
                        controller: _confirmPasswordTextController,
                        obscureText: true,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: 'Repite la contraseña',
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
                          if (value != null && value.isEmpty) {
                            return 'Demasiado corto';
                          } else if (value != null && value.length > 70) {
                            return 'Demasiado largo';
                          } else if (_passwordTextController.text !=
                              _confirmPasswordTextController.text) {
                            return 'Las contraseñas deben ser idénticas';
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
                        height: 60,
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90)),
                        child: ElevatedButton(
                          onPressed: () async {
                            final isValidForm =
                                _formKey.currentState!.validate();
                            var user = await FirebaseAuth.instance.currentUser!;
                            if (isValidForm) {
                              if (widget.passw !=
                                  _passwordTextController.text) {
                                var cambioContra = await _changePassword(
                                    _passwordTextController.text);
                                if (cambioContra) {
                                  await FirestoreMethods().signOut();
                                  FirebaseAuth.instance.authStateChanges();
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignInScreen()),
                                      (route) => false);
                                  // ignore: use_build_context_synchronously
                                  showSnackBar(
                                      'Vuelve a ingresar con las nuevas credenciales',
                                      context);
                                } else {
                                  // ignore: avoid_print
                                  print('FALLO EL CAMBIO DE CONTRA');
                                }
                              } else {
                                showSnackBar(
                                    'Error la nueva contraseña no puede ser idéntica a la actual',
                                    context);
                              }
                            } else {
                              // ignore: use_build_context_synchronously
                              showSnackBar(
                                  'Error comprueba los datos ingresados',
                                  context);
                            }
                          },
                          // ignore: sort_child_properties_last
                          child: const Text(
                            'Cambiar contraseña',
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

  Future<bool> _changePassword(String newPassword) async {
    setState(() {
      isLoading = true;
    });
    bool success = false;
    var user = await FirebaseAuth.instance.currentUser!;
    try {
      await user.updatePassword(newPassword);
      success = true;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    setState(() {
      isLoading = false;
    });
    return success;
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
