// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NewUserSearch extends StatefulWidget {
  const NewUserSearch({super.key});

  @override
  State<NewUserSearch> createState() => _NewUserSearchState();
}

class _NewUserSearchState extends State<NewUserSearch> {
  TextEditingController searchController = TextEditingController();
  var focusNode = FocusNode();
  String name = "";
  bool isShowUsers = false;

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  // * Clear Text form field
  clearTextFormField() {
    setState(() {
      searchController.clear();
    });
  }

  Widget displayNoSearchResultScreen() {
    // final Orientation orientation = MediaQuery.of(context).orientation;
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: const [
          Icon(
            Icons.group,
            color: Colors.grey,
            size: 200,
          ),
          Text(
            "Search Users",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 40),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: TextField(
            controller: searchController,
            cursorColor: Colors.grey,
            focusNode: focusNode,
            onChanged: (value) {
              setState(() {
                isShowUsers = true;
              });
            },
            onSubmitted: (value) {
              isShowUsers = false;
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              prefixIcon: Icon(Icons.search,
                  color: focusNode.hasFocus ? Colors.grey : Colors.grey),
              suffixIcon: searchController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: clearTextFormField,
                      icon: Icon(Icons.close,
                          color:
                              focusNode.hasFocus ? Colors.grey : Colors.grey)),
              hintText: 'Search here..',
              fillColor: Colors.grey.withOpacity(0.4),
              filled: true,
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
        body: isShowUsers
            ? !focusNode.hasFocus
                ? displayNoSearchResultScreen()
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .where("listLetter",
                            arrayContains: searchController.text)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No results found.'));
                      } else {
                        // * Convertir la valeur saisie en minuscules
                        String searchQuery =
                            searchController.text.toLowerCase();

                        // * Filtrer les données en les comparant avec la valeur saisie en minuscules
                        List resultList = [];
                        List<QueryDocumentSnapshot> filteredDocs = snapshot
                            .data!.docs
                            .where((doc) => doc['listLetter']
                                .toString()
                                .toLowerCase()
                                .contains(searchQuery))
                            .toList();

                        return ListView.builder(
                          itemCount: filteredDocs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot data = filteredDocs[index];

                            return GestureDetector(
                              onTap: () => /*print(data["username"])*/
                                  Fluttertoast.showToast(msg: data["username"]),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    foregroundImage:
                                        NetworkImage(data["photoUrl"]),
                                  ),
                                  title: Text(data["username"]),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    })
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Posts")
                    .orderBy("datePublished", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return focusNode.hasFocus
                      ? Container()
                      : MasonryGridView.builder(
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            final post = snapshot.data!.docs[index].data();
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.network(post["postUrl"]),
                            );
                          },
                        );
                },
              ) /* FutureBuilder(
                future: FirebaseFirestore.instance.collection("Posts").get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child:  CircularProgressIndicator());
                  }
                  return StaggeredGrid.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children:  const [
                      StaggeredGridTile.count(
                        crossAxisCellCount: 2,
                        mainAxisCellCount: 2,
                        child: Text("index: 0"),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 2,
                        mainAxisCellCount: 1,
                        child: Text("index: 1"),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Text("index: 2"),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Text("index: 3"),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 4,
                        mainAxisCellCount: 2,
                        child: Text("index: 4"),
                      ),
                    ],
                  );
                },
              )*/
        );
  }
}
