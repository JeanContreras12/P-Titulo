// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:riesgo/models/user_provider.dart';
import 'package:riesgo/controller/fb_storage.dart';
import 'package:riesgo/controller/reutilizable.dart';
import 'package:riesgo/models/user.dart' as model;

// ignore: must_be_immutable
class PostearScreen extends StatefulWidget {
  String uid;
  PostearScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<PostearScreen> createState() => _PostearScreenState();
}

class _PostearScreenState extends State<PostearScreen> {
  final _formKey = GlobalKey<FormState>();
  var userData = {};
  List ingredients = [""];
  final Map<String, String?> stepsMap = {'1': ""};
  Uint8List? _file;
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final TextEditingController _timeTextController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap
          .data()!; //USER DATA ES EL PERFIL QUE ESTAMOS VIENDO AHORA MISMO ES DECIR LOS DATOS DEL USUARIO DONDE ESTAMOS PARADOS

      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionTextController.text,
        _file!,
        uid,
        username,
        profImage,
        ingredients,
        stepsMap,
        _timeTextController.text,
      );

      if (res == "exito") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Publicado!', context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              'Elige el formato',
            ),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Selecciona desde la galería',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickimage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionTextController.dispose();
    _timeTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<Userprovider>(context).getUser;

    return _file == null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: logoWidget("assets/logo-.png", 90, 70),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Comparte tus recetas',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18, right: 13),
                      child: Text(
                          'Ayuda a otros usuarios a descubrir nuevas ideas',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 107, 107, 107))),
                    ),
                    Image.asset(
                      "assets/receta.jpg",
                      width: 180,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _selectImage(context),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.black26;
                            }
                            return const Color.fromARGB(255, 138, 230, 141);
                          }),
                        ),
                        child: const Text(
                          'Publica tu receta',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : WillPopScope(
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      clearImage();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    )),
                title: const Text(
                  "Publica tu receta",
                  style: TextStyle(
                      color: Colors.black, fontSize: 20, fontFamily: 'Raleway'),
                ),
                centerTitle: false,
                backgroundColor: Colors.white,
                actions: [
                  TextButton(
                    onPressed: (() {
                      final isValidForm = _formKey.currentState!.validate();
                      if (isValidForm) {
                        postImage(
                          user!.uid,
                          userData['username'],
                          userData['photoUrl'],
                        );
                      }
                    }),
                    child: const Text('¡Publícalo!'),
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    _isLoading
                        ? const LinearProgressIndicator()
                        : const Padding(
                            padding: EdgeInsets.only(top: 0),
                          ),
                    const Divider(),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: AspectRatio(
                              aspectRatio: 487 / 451,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.fill,
                                    alignment: FractionalOffset.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 2,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 80,
                            child: TextFormField(
                              enableSuggestions: true,
                              autocorrect: true,
                              controller: _descriptionTextController,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                labelText: "Título de la receta",
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.center,
                                floatingLabelStyle: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 90, 90, 90),
                                  fontSize: 15,
                                ),
                                hintText: 'Ej: "Arroz con pollo"',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                      color: Colors.red,
                                    )),
                              ),
                              validator: (value) {
                                if (value != null && value.length < 3) {
                                  return 'Ingresa un título más descriptivo';
                                } else if (value != null && value.length > 33) {
                                  return 'Demasiado largo';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 80,
                            child: TextFormField(
                              enableSuggestions: true,
                              autocorrect: true,
                              controller: _timeTextController,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                labelText: "Tiempo de elaboración",
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.center,
                                floatingLabelStyle: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 90, 90, 90),
                                  fontSize: 15,
                                ),
                                hintText: 'Ej: "1 h 30 min"',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                      color: Colors.red,
                                    )),
                              ),
                              validator: (value) {
                                if (value != null && value.length < 2) {
                                  return 'Ingresa un tiempo más exacto';
                                } else if (value != null && value.length > 15) {
                                  return 'Demasiado largo';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const Text(
                            "Ingredientes de tu receta",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // ingredient(0),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ingredient(index),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: ingredients.length,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Describe los pasos de tu receta",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, ind) {
                              return Column(
                                children: [
                                  steps(ind),
                                ],
                              );
                            },
                            separatorBuilder: (context, ind) => const Divider(),
                            itemCount: stepsMap.length,
                          ),

                          const SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onWillPop: () async {
              return false;
            },
          );
  }

  Widget ingredient(index) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: Row(
        children: [
          Flexible(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 80,
              child: TextFormField(
                  initialValue: ingredients[index],
                  enableSuggestions: true,
                  autocorrect: true,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "Ingredientes",
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    floatingLabelStyle: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 90, 90, 90),
                      fontSize: 15,
                    ),
                    hintText: 'Ej: "Arroz blanco"',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.green,
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                          color: Colors.red,
                        )),
                  ),
                  validator: (value) {
                    if (value != null && value.length < 3) {
                      return 'Demasiado corto';
                    } else if (value != null && value.length > 64) {
                      return 'Demasiado largo';
                    } else {
                      if (ingredients.length == index + 1) {
                        ingredients[index] = value;
                        // ignore: avoid_print
                        print(ingredients);
                      }
                      return null;
                    }
                  }),
            ),
          ),
          Visibility(
            visible: index + 1 == ingredients.length,
            child: SizedBox(
              width: 35,
              child: IconButton(
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.green,
                ),
                onPressed: () {
                  addIngredientControl();
                },
              ),
            ),
          ),
          Visibility(
            visible: index > 0 && index == ingredients.length - 1,
            child: SizedBox(
              width: 35,
              child: IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                onPressed: () {
                  removeIngredientControl(index - 1);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget steps(index) {
    int text = index + 1;
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.07,
            child: Text(
              text.toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Flexible(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 80,
              child: TextFormField(
                  enableSuggestions: true,
                  autocorrect: true,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "Pasos",
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    floatingLabelStyle: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 90, 90, 90),
                      fontSize: 15,
                    ),
                    hintText: 'Ej: "Vierte el arroz en agua hervida"',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.green,
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                          color: Colors.red,
                        )),
                  ),
                  validator: (value) {
                    if (value != null && value.length < 3) {
                      return 'Detalla más tus pasos';
                    } else if (value != null && value.length > 250) {
                      return 'Demasiado largo';
                    } else {
                      if (stepsMap.length == index + 1) {
                        stepsMap[text.toString()] = value;
                      }
                      return null;
                    }
                  }),
            ),
          ),
          Visibility(
            visible: index + 1 == stepsMap.length,
            child: SizedBox(
              width: 35,
              child: IconButton(
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.green,
                ),
                onPressed: () {
                  addStepsControl(index);
                },
              ),
            ),
          ),
          Visibility(
            visible: index > 0 && index == stepsMap.length - 1,
            child: SizedBox(
              width: 35,
              child: IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                onPressed: () {
                  removeStepsControl(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addIngredientControl() {
    showSnackBar(
        '¡Los cambios a ingredientes anteriores no se guardan!', context);
    setState(() {
      ingredients.add("");
    });
  }

  void removeIngredientControl(index) {
    setState(() {
      if (ingredients.isNotEmpty) {
        ingredients.removeAt(index);
      }
    });
  }

  void addStepsControl(index) {
    showSnackBar('¡Los cambios a pasos anteriores no se guardan!', context);
    int text = index + 2;
    setState(() {
      stepsMap[text.toString()] = "";
    });
  }

  void removeStepsControl(index) {
    int text = index + 1;
    setState(() {
      if (ingredients.isNotEmpty) {
        stepsMap.remove(text.toString());
      }
    });
  }
}
