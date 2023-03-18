import 'package:flutter/material.dart';
import 'package:logic_test/utils/utils.dart';

import 'model/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Logic testing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

int dataPerPage = 15;

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      addDataToList();
      setState(() {});
      scrollController.addListener(() {
        if (scrollController.offset ==
            scrollController.position.maxScrollExtent) {
          addDataToList();

          setState(() {});
        }
      });
      textEditingController.addListener(() {
        if (textEditingController.text.isEmpty) {
          searchUser = userList;
          setState(() {});
        }
      });
    });
    super.initState();
  }

  int totalPageCount = userModel.length % dataPerPage == 0
      ? userModel.length ~/ dataPerPage
      : userModel.length ~/ dataPerPage + 1;

  List<UserModel> paginatedUsers = [];
  int currentPage = 0;
  final TextEditingController textEditingController = TextEditingController();
  List<UserModel> searchUser = userList;
  bool canAdd = true;
  addDataToList() async {
    int whereToEnd = ((currentPage + 1) * dataPerPage) - 1;
    int whereToStart = currentPage * dataPerPage;

    if (whereToStart < userModel.length) {
      for (var i = whereToStart; i <= whereToEnd; i++) {
        if (i < userModel.length) {
          paginatedUsers.add(userModel[i]);
        }
      }
      currentPage++;
      setState(() {});
    }
  }

  searchUserFromList() {
    searchUser = userList;
    setState(() {});
    try {
      List<UserModel> users = [];
      users.addAll(searchUser);
      if (textEditingController.text.isNotEmpty) {
        users.retainWhere((user) {
          String searchTerm = textEditingController.text.toLowerCase();
          String userName = user.name.toLowerCase();
          String userNum = user.address.toLowerCase();
          String userDescription = user.description.toLowerCase();
          String userCity = user.city.toLowerCase();
          return userName.contains(searchTerm) ||
              userNum.contains(searchTerm) ||
              userDescription.contains(searchTerm) ||
              userCity.contains(searchTerm);
        });
      }
      setState(() {
        searchUser = users;
      });
    } catch (e) {
      return;
    }
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: PreferredSize(
            preferredSize: Size(size.width, 60),
            child: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                      color: currentPage == 1 ? Colors.blue : Colors.orange,
                      onPressed: () {
                        setState(() {
                          currentPage = 0;
                        });
                      },
                      child: const Text("Search")),
                  MaterialButton(
                      color: currentPage == 0 ? Colors.blue : Colors.orange,
                      onPressed: () {
                        setState(() {
                          currentPage = 1;
                        });
                      },
                      child: const Text("Pagination"))
                ],
              ),
            ),
          ),
        ),
        body: currentPage == 0
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onSubmitted: ((value) {
                          searchUserFromList();
                        }),
                        onEditingComplete: (() {
                          searchUserFromList();
                        }),
                        controller: textEditingController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          hintText: "Search....",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 600,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchUser.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(searchUser[index].name.toUpperCase()),
                                  Text(searchUser[index].address.toUpperCase()),
                                  Text(searchUser[index].city.toUpperCase()),
                                  Text(searchUser[index]
                                      .description
                                      .toUpperCase()),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 640,
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 40),
                        controller: scrollController,
                        itemCount: paginatedUsers.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${paginatedUsers[index].name.toUpperCase()}($index)"),
                                Text(paginatedUsers[index]
                                    .address
                                    .toUpperCase()),
                                Text(paginatedUsers[index].city.toUpperCase()),
                                Text(paginatedUsers[index]
                                    .description
                                    .toUpperCase()),
                              ],
                            ),
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ));
  }
}
