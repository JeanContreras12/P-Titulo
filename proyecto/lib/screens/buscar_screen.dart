import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riesgo/screens/buscador_receta_screen.dart';
import 'package:riesgo/screens/recetas_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isloading = false;

  esperando() async {
    setState(() {
      isloading = true;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      isloading = false;
    });
  }

  final List<Map<String, dynamic>> gridMap = [
    {
      "images":
          "https://firebasestorage.googleapis.com/v0/b/titulo-a5fe7.appspot.com/o/catalogo%2Fcarnes.jpg?alt=media&token=dde05854-8b95-4214-92ec-d5383e9cb14b",
      "nombre": "carnes"
    },
    {
      "images":
          "https://firebasestorage.googleapis.com/v0/b/titulo-a5fe7.appspot.com/o/catalogo%2Fpastas.jpg?alt=media&token=53201831-3406-4dfc-9829-9d545467ded3",
      "nombre": "pastas"
    },
    {
      "images":
          "https://firebasestorage.googleapis.com/v0/b/titulo-a5fe7.appspot.com/o/catalogo%2Fpasteles.jpg?alt=media&token=cd741318-e441-4978-b145-e483a1e30a51",
      "nombre": "pasteles"
    },
    {
      "images":
          "https://firebasestorage.googleapis.com/v0/b/titulo-a5fe7.appspot.com/o/catalogo%2Fplato-de-mariscos.jpg?alt=media&token=d38e698b-9568-4373-b0d0-292593bdd65f",
      "nombre": "mariscos"
    },
    {
      "images":
          "https://firebasestorage.googleapis.com/v0/b/titulo-a5fe7.appspot.com/o/catalogo%2Fpostres.jpg?alt=media&token=1db9d4ad-83fc-4cbb-aaca-70efc16e1019",
      "nombre": "postres"
    },
    {
      "images":
          "https://firebasestorage.googleapis.com/v0/b/titulo-a5fe7.appspot.com/o/catalogo%2Fsin-gluten.jpg?alt=media&token=05d28e53-3791-4047-8c81-083cfdf517a1",
      "nombre": "sinGluten"
    },
    {
      "images":
          "https://firebasestorage.googleapis.com/v0/b/titulo-a5fe7.appspot.com/o/catalogo%2Fsin-lactosa.jpg?alt=media&token=274732e1-8833-4df6-a1fc-48114bbfaaf3",
      "nombre": "sin lactosa"
    },
    {
      "images":
          "https://firebasestorage.googleapis.com/v0/b/titulo-a5fe7.appspot.com/o/catalogo%2Fsopas.jpg?alt=media&token=3b9c1bab-c42c-45c7-aaf9-f2302acea949",
      "nombre": "sopas"
    },
    {
      "images":
          "https://firebasestorage.googleapis.com/v0/b/titulo-a5fe7.appspot.com/o/catalogo%2Fvegetarianas.jpeg?alt=media&token=56118805-b5af-434a-852b-4a04e5ebc2b2",
      "nombre": "vegetarianas"
    },
  ];

  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  bool buscando = false;
  @override
  void initState() {
    super.initState();
    esperando();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              fillColor: Colors.grey,
              filled: true,
              contentPadding: const EdgeInsets.all(13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              hintText: 'Buscar recetas por nombre',
              hintStyle: const TextStyle(color: Colors.black),
            ),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
        body: isShowUsers
            ? StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('buscador')
                    .snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            if (data['titulo']
                                .toString()
                                .toLowerCase()
                                .startsWith(
                                    searchController.text.toLowerCase())) {
                              return InkWell(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => BuscadorRecetaScreen(
                                      documento: (snapshot.data! as dynamic)
                                          .docs[index]['seccion'],
                                      titulo: (snapshot.data! as dynamic)
                                          .docs[index]['uid'],
                                    ),
                                  ),
                                ), //navegar a la receta
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(data['photoUrl']),
                                  ),
                                  title: Text(
                                    data['titulo'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                        );
                },
              ) //TERMINO DEL BUSCADOR
            : isloading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Catálogo de recetas',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        height: MediaQuery.of(context).size.height *
                            1.5, //problema con scroll
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 2.0,
                          ),
                          itemCount: 9,
                          itemBuilder: (BuildContext context, int index) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon: Image.network(
                                        "${gridMap.elementAt(index)['images']}",
                                        fit: BoxFit.cover,
                                      ),
                                      iconSize: 130,
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => RecetasScreen(
                                                nom:
                                                    "${gridMap.elementAt(index)['nombre']}"),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )

        // ListView(
        //     children: [
        //       SingleChildScrollView(
        //         child: Padding(
        //           padding: const EdgeInsets.all(25),
        //           child: Column(
        //             mainAxisSize: MainAxisSize.max,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               const Text(
        //                 'Catalogo de recetas',
        //                 style: TextStyle(
        //                     fontWeight: FontWeight.bold, fontSize: 25),
        //               ),
        //               const Divider(
        //                 color: Colors.black,
        //                 thickness: 2,
        //               ),
        //               const SizedBox(
        //                 height: 5,
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),

        //     ],
        //   ),
        );
  }
}
