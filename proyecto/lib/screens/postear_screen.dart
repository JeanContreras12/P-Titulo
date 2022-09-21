import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:riesgo/models/user_provider.dart';
import 'package:riesgo/controller/fb_storage.dart';
import 'package:riesgo/controller/reutilizable.dart';
import 'package:riesgo/models/user.dart' as model;

class PostearScreen extends StatefulWidget {
  String uid;
  PostearScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<PostearScreen> createState() => _PostearScreenState();
}

class _PostearScreenState extends State<PostearScreen> {
  var userData = {};
  Uint8List? _file;
  final TextEditingController _descriptionTextController =
      TextEditingController();

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
                      postImage(
                        user!.uid,
                        userData['username'],
                        user.photoUrl,
                      );
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
                    Column(
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 80,
                          child: TextField(
                            controller: _descriptionTextController,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              hintText: 'Título. Ej: "Arroz con pollo"',
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      width: 0, style: BorderStyle.none)),
                            ),
                            maxLines: 8,
                          ),
                        ),
                      ],
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
}
