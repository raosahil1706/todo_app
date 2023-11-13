import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/custom/TodoCard.dart';
import 'package:todo_app/pages/AddToDo.dart';
import 'package:todo_app/pages/view_data.dart';
import 'package:todo_app/service/Auth_service.dart';

import 'SignUpPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();
  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          "Today's Schedule",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          const CircleAvatar(
            backgroundImage: AssetImage("assets/dp.jpg"),
          ),
          const SizedBox(
            width: 25,
          ),
        ],
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(35),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 22),
                child: Text(
                  "Monday 11",
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black87,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 32,
                color: Colors.white,
              ),
              label: "",
              //\title: Container(),
            ),
            BottomNavigationBarItem(
                icon: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const AddToDo()));
                  },
                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [
                          Colors.indigoAccent,
                          Colors.purple,
                        ])),
                    child: const Icon(
                      Icons.add,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                //  title: Container(),
                label: ""),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  size: 32,
                  color: Colors.white,
                ),
                //title: Container(),
                label: ""),
          ]),
      body: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  IconData iconData;
                  Color iconColor;
                  Map<String, dynamic> document =
                      snapshot.data.docs[index].data() as Map<String, dynamic>;
                  switch (document["Category"]) {
                    case "Work":
                      iconData = Icons.work;
                      iconColor = Colors.grey;
                      break;
                    case "WorkOut":
                      iconData = Icons.alarm;
                      iconColor = Colors.teal;
                      break;
                    case "Food":
                      iconData = Icons.local_grocery_store;
                      iconColor = Colors.blue;
                      break;
                    case "Design":
                      iconData = Icons.audiotrack;
                      iconColor = Colors.green;
                      break;
                    case "Run":
                      iconData = Icons.run_circle_outlined;
                      iconColor = Colors.red;
                      break;
                    default:
                      iconData = Icons.add;
                      iconColor = Colors.red;
                  }
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => ViewData(
                            document: document,
                            id: snapshot.data.docs[index].id,
                          ),
                        ),
                      );
                    },
                    child: TodoCard(
                      title: document["title"] == null
                          ? "Add a title "
                          : document['title'],
                      check: true,
                      iconBgColor: Colors.white,
                      iconColor: iconColor,
                      iconData: iconData,
                      time: "10 AM",
                    ),
                  );
                });
          }),
    );
  }
}


////////////
///
///IconButton(
              // onPressed: () async {
              //   await authClass.logout(context);
              //   Navigator.pushAndRemoveUntil(
              //       context,
              //       MaterialPageRoute(builder: (builder) => SignUpPage()),
              //       (route) => false);
              // },
              // icon: Icon(Icons.logout)),