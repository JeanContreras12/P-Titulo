import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riesgo/widgets/fb_storage.dart';
import 'package:riesgo/widgets/reutilizable.dart';

class EditProfil extends StatefulWidget {
  final String uid;
  const EditProfil({Key? key, required this.uid}) : super(key: key);
  @override
  State<EditProfil> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  final _formKey = GlobalKey<FormState>();
  String? nombre;
  String? description;
  Uint8List? _image;
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

  void clearImage() {
    setState(() {
      _image = null;
    });
  }

  void postImage(String uid) async {
    setState(() {
      isLoading = true;
    });
    try {
      String photoUrl;
      if (_image != null) {
        photoUrl = await MetodosStorage()
            .SubirImagenAStorage('FotoPerfil', _image!, false);
      } else {
        photoUrl = userData['photoUrl'];
      }
      await FirestoreMethods()
          .ChangeProfilePic(uid, photoUrl, nombre, description);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
      showSnackBar('Editado', context);
      clearImage();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar('Error en la edicion de perfil', context);
    }
  }

  selectImage() async {
    Uint8List? im = await pickimage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
      print(_image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              title: const Text('Editar perfil '),
              titleTextStyle:
                  const TextStyle(color: Colors.black, fontSize: 20),
              actions: [
                TextButton(
                  onPressed: (() {
                    final isValidForm = _formKey.currentState!.validate();

                    if (isValidForm) {
                      postImage(FirebaseAuth.instance.currentUser!.uid);
                    }
                  }),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 30.0,
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 32,
                      ),
                      Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 64,
                                  //tiene que estar la imagen actual del usuario displayada aqui
                                  backgroundImage: MemoryImage(_image!),
                                )
                              : CircleAvatar(
                                  radius: 64,
                                  //tiene que estar la imagen actual del usuario displayada aqui
                                  backgroundImage:
                                      NetworkImage(userData['photoUrl']),
                                  backgroundColor: Colors.red,
                                ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: selectImage,
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.red,
                                  size: 35,
                                ),
                              ),
                              const Text(
                                'Cambia tu foto de perfil',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                      Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                                enableSuggestions: true,
                                autocorrect: true,
                                cursorColor: Colors.black,
                                initialValue: userData['username'],
                                decoration: const InputDecoration(
                                  labelText: 'Nombre',
                                  labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 125, 124, 124),
                                      fontSize: 20),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value != null && value.length < 4) {
                                    return 'Demasiado corto';
                                  } else if (value != null &&
                                      value.length > 15) {
                                    return 'Demasiado largo';
                                  } else {
                                    nombre = value;
                                    return null;
                                  }
                                }),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                                enableSuggestions: true,
                                autocorrect: true,
                                cursorColor: Colors.black,
                                initialValue: userData['description'],
                                decoration: const InputDecoration(
                                  labelText: 'Descripción',
                                  labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 125, 124, 124),
                                      fontSize: 20),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Demasiado corto';
                                  } else if (value != null &&
                                      value.length > 100) {
                                    return 'Demasiado largo';
                                  } else {
                                    description = value;
                                    return null;
                                  }
                                }),
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
}
