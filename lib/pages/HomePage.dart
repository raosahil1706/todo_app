import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/custom/TodoCard.dart';
import 'package:todo_app/pages/AddToDo.dart';
import 'package:todo_app/pages/view_data.dart';
import 'package:todo_app/service/Auth_service.dart';

import 'setting.dart';

// import 'SignUpPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();
  AuthClass authClass = AuthClass();
  List<Select> selected = [];
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
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(35),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Monday 11",
                      style: TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff8a32f1),
                        letterSpacing: 1,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        var instance =
                            FirebaseFirestore.instance.collection("Todo");
                        for (int i = 0; i < selected.length; i++) {
                          if (selected[i].checkValue) {
                            instance.doc(selected[i].id).delete();
                          }
                        }
                        // FirebaseFirestore.instance
                        //     .collection("Todo")
                        //     .doc(widget.id)
                        //     .delete()
                        //     .then((value) {
                        //   Navigator.pop(context);
                        // });
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black87,
          items: <BottomNavigationBarItem>[
             BottomNavigationBarItem(
              icon: InkWell(
                onTap: (){
Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => HomePage()));
                },
                child: Icon(
                  Icons.home,
                  size: 32,
                  color: Colors.white,
                ),
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
             BottomNavigationBarItem(
                icon: InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => setting()));
                  },
                  child: Icon(
                    Icons.settings,
                    size: 32,
                    color: Colors.white,
                  ),
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
                  selected.add(Select(
                      id: snapshot.data.docs[index].id, checkValue: false));
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
                      check: selected[index].checkValue,
                      iconBgColor: Colors.white,
                      iconColor: iconColor,
                      iconData: iconData,
                      time: "10 AM",
                      index: index,
                      onChange: onChange,
                    ),
                  );
                });
          }),
    );
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
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

class Select {
  String id;
  bool checkValue = false;
  Select({required this.checkValue, required this.id});
}
