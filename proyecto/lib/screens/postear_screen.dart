import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:riesgo/models/user.dart';
import 'package:riesgo/providers/user_provider.dart';
import 'package:riesgo/screens/inicio_screen.dart';
import 'package:riesgo/widgets/fb_storage.dart';
import 'package:riesgo/widgets/reutilizable.dart';
import 'package:riesgo/models/user.dart' as model;

class PostearScreen extends StatefulWidget {
  const PostearScreen({Key? key}) : super(key: key);

  @override
  State<PostearScreen> createState() => _PostearScreenState();
}

class _PostearScreenState extends State<PostearScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionTextController =
      TextEditingController();

  bool _isLoading = false;

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
            title: Text(
              'Elige el formato',
            ),
            children: [
              // SimpleDialogOption(
              //   padding: const EdgeInsets.all(20),
              //   child: const Text(
              //     'Toma una foto',
              //     style: TextStyle(fontSize: 16),
              //   ),
              //   onPressed: () async {
              //     Navigator.of(context).pop();
              //     Uint8List file = await pickimage(
              //       ImageSource.camera,
              //     );
              //     setState(() {
              //       _file = file;
              //     });
              //   },
              // ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Selecciona desde la galeria',
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
    final model.User? user = Provider.of<Userprovider>(context).getUser;

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectImage(context),
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
                    onPressed: (() => postImage(
                          user!.uid,
                          user.username,
                          user.photoUrl,
                        )),
                    child: const Text('Publicalo!'),
                  )
                ],
              ),
              body: Column(
                children: [
                  _isLoading
                      ? const LinearProgressIndicator()
                      : const Padding(
                          padding: EdgeInsets.only(top: 0),
                        ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          user!.photoUrl,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextField(
                          controller: _descriptionTextController,
                          decoration: const InputDecoration(
                            hintText: 'Describe los pasos para tu receta',
                            border: InputBorder.none,
                          ),
                          maxLines: 8,
                        ),
                      ),
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ],
              ),
            ),
            onWillPop: () async {
              return false;
            },
          );
  }
}
