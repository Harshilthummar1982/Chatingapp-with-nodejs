import 'dart:convert';
import 'dart:io';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app/screens/chatsc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../datastore/data.dart';
import 'chatScreen.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> key = GlobalKey();
  late var chats = [];
  late String roomId;
  late var userdata = [];

  void permissions() async {
    var status = await Permission.contacts.status;
    if (status.isDenied) {
      Permission.contacts.request();
    }
  }

  @override
  void initState() {
    permissions();
    // print("this is init home");
    // Data.initializeSocket();
    // // getChatData();
    // Data.socket.emit('allUsers');
    // Data.socket.on('getUsers', (data) {
    //   userdata = data;
    //   // print("${userdata} =====");
    //   setState(() {});
    // });
    getUsers();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('this dispose home');
    Data.socket.disconnect();
    Data.socket.destroy();
    Data.socket.dispose();

    super.dispose();
  }

  void Getsd() async {
    List<Contact> contacts = await ContactsService.getContacts();
// List<Item> phones =(await ContactsService.getContacts()).cast<Item>();
    // print("this is cone:  =>> $contacts");
  }

  void getUsers() async {
    Data.initializeSocket();
    // getChatData();
    Data.socket.emit('allUsers');
    Data.socket.on('getUsers', (data) {
      userdata = data;
      // print("${userdata} =====");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: const MyDrawer(),
        key: key,
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 0, 34, 41),
          onPressed: () {
            Navigator.pushNamed(context, '/contects');
          },
          child: const Icon(
            Icons.person_pin,
            size: 40,
          ),
        ),
        body: (userdata.isNotEmpty) ?  SingleChildScrollView(
          child: Stack(
            fit: StackFit.loose,
            children: [
              Container(
                color: Color.fromARGB(255, 0, 34, 41),
                height: 160,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: ((context) => MyDrawer())));
                          key.currentState!.openDrawer();
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        )),
                    const Spacer(),
                    Container(
                      margin: EdgeInsets.only(right: 50),
                      child: const Text(
                        "Massages",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 120),
                decoration: const BoxDecoration(
                    // color: Colors.amber,
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: userdata.length,
                        itemBuilder: ((context, index) {
                          return GestureDetector(
                            onTap: () async {
                              // print(Data.userData[index]['user']);
                              // print(Data.user);
                              getUsers();
                              var doc = {
                                "currentUser": Data.mobile,
                                "secondUser": userdata[index]['mobile'],
                              };

                              Data.socket.emit('findRoom', jsonEncode(doc));
                              Data.socket.on(
                                'roomID',
                                (data) {
                                  // print("room Id is : $data");
                                  setState(() {
                                    roomId = data;
                                  });
                                  if (roomId != null) {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => ChatScreen(
                                          roomId: roomId,
                                          secondUser: userdata[index]['mobile']
                                              .toString(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );

                              // Data.socket.on('chatData', (data){
                              //   print("this is chat data");
                              //   print(data);
                              //   setState(() {
                              //     chats = data;
                              //   });
                              // });
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(username:  Data.userData[index]['user'], chatData: chats,)));
                              // getChatData();
                            },
                            child: Container(
                              // margin: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  // color: Color.fromARGB(255, 149, 231, 242),
                                  color: Colors.white,
                                  // borderRadius: BorderRadius.circular(10.00),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.00),
                                      bottomRight: Radius.circular(10.00),
                                      topLeft: Radius.circular(30.00),
                                      bottomLeft: Radius.circular(30.00))),
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10),
                              height: 70,
                              width: MediaQuery.of(context).size.width - 30,
                              child: Row(
                                children: [
                                  ClipOval(
                                    //no need to provide border radius to make circular image
                                    child: Image.asset(
                                      "assets/photo.png",
                                      height: 70.0,
                                      width: 70.0,
                                      fit:
                                          BoxFit.cover, //change image fill type
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userdata[index]['mobile'].toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        const Text("this is last massage")
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Getsd();
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text('1'),
                                      ),
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFe0f2f1)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
              ),
            ],
          ),
        ) : const Center(
          child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 0, 34, 41),
                      ),
        ),
      
    );
  }
}



