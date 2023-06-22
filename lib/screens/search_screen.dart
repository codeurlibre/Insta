// ignore_for_file: avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:instagram_clone_app/models/user.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  TextEditingController searchEditingController = TextEditingController();
  Future<QuerySnapshot>? futureSearchResults;
  String name = "";
  List searchResult = [];

  // * Control searching
  searchItem(String searchValue) async {
    // String searchValue = searchController.text.trim().toLowerCase();

    // * Get a reference to the collection you want to search in
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('Users');

    // * Define the search query
    QuerySnapshot querySnapshot = await collectionRef
        .where('username', isGreaterThanOrEqualTo: searchValue.trim().toLowerCase())
        .get();

    if (querySnapshot.size > 0) {
      setState(() {
        searchResult = querySnapshot.docs.map((e) => e.data()).toList();
      });

      print(searchResult);
    } else {
      print('No matching documents found.');
    }
  }

  /*controlSearching(String str) {
    Future<QuerySnapshot> allUsers = FirebaseFirestore.instance
        .collection('Users')
        .where("username", isGreaterThanOrEqualTo: str)
        .get();
    futureSearchResults = allUsers;
  }*/

  // * Clear Text form field
  clearTextFormField() {
    searchEditingController.clear();

  }

  AppBar searchPageHeader() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: TextFormField(
          controller: searchEditingController,
          style: const TextStyle(fontSize: 18, color: Colors.white),
          onFieldSubmitted: searchItem,
          onChanged: (value) {

              searchItem(value.trim().toLowerCase());

          },
          decoration: InputDecoration(
              filled: true,
              hintText: "Search here..",
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              /*prefix: const Icon(
              Icons.person_pin,
              color: Colors.white,
              size: 30,
            ),*/
              suffixIcon: IconButton(
                onPressed: clearTextFormField,
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
              ))),
    );
  }

  Container displayNoSearchResultScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
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
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 65),
            )
          ],
        ),
      ),
    );
  }

  displayUsersFoundScreen() {
    return FutureBuilder(
      future: futureSearchResults,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        }

        List searchUsersResult = [];
        for (var document in snapshot.data!.docs) {
          // forEach map
          UserModel eachUser =
              UserModel.fromJson(document.data() as Map<String, dynamic>);
          // UserResult userResult = UserResult(eachUser);
          searchUsersResult.add(eachUser);
          print(eachUser);
          print(searchUsersResult);
        }

        return ListView.builder(
          itemCount: searchUsersResult.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(3),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => print("Tapped"),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        backgroundImage:
                        NetworkImage(searchUsersResult[index]["photoUrl"]),
                      ),
                      title: Text(
                        searchUsersResult[index]["username"],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: searchPageHeader(),
      body: futureSearchResults == null
          ? displayNoSearchResultScreen()
          : displayUsersFoundScreen() /*displayUsersFoundScreen()*/,
    );
  }
}

// * User result
/*
class UserResult extends StatelessWidget {
  final UserModel eachUser;

  const UserResult(this.eachUser, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => print("Tapped"),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(search),
              ),
              title: Text(
                eachUser.username,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
*/
/*

class CloudFirestoreSearch extends StatefulWidget {
  const CloudFirestoreSearch({super.key});

  @override
  // _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
  State<CloudFirestoreSearch> createState() => _CloudFirestoreSearchState();
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  List<UserModel> allUsers = [];
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Card(
          child: TextField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (name != "" && name != null)
            ? FirebaseFirestore.instance
                .collection('Users')
                .where(
                  "username",
                )
                .snapshots()
            : FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            List<UserResult> searchUsersResult = [];
            snapshot.data!.docs.map((doc) {
              // =>
              UserModel myUser =
                  UserModel.fromJson(doc.data() as Map<String, dynamic>);
              UserResult userResult = UserResult(myUser);
              searchUsersResult.add(userResult);
            }).toList();
            return ListView */
/*.builder*//*
 (
                // itemCount: snapshot.data!.docs.length,
                */
/*itemBuilder*//*

                children: searchUsersResult);
          }
          return const Center(
            child: Text("Error"),
          );
        },
      ),
    );
  }
}
*/

/*

[
Card(
child: Row(
children: <Widget>[
Image.network(
my['photoUrl'],
width: 150,
height: 100,
fit: BoxFit.fill,
),
const SizedBox(
width: 25,
),
Text(
allUsers['username'],
style: const TextStyle(
fontWeight: FontWeight.w700,
fontSize: 20,
),
),
],
),
)
]*/
