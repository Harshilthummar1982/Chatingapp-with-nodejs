import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../datastore/data.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<Contact>? contacts;
  late var userdata = [];
  late List<String> users = [];
  int k = 1;
  @override
  void initState() {
    // TODO: implement initState

    getContact();
    Data.initializeSocket();
    // getChatData();
    Data.socket.emit('allUsers');
    Data.socket.on('getUsers', (data) {
      userdata = data;
      print("${userdata} =====");
      setState(() {});
    });
    getUsers();

    super.initState();
  }

  void getUsers() async {
    Data.initializeSocket();
    // getChatData();
    Data.socket.emit('allUsers');
    Data.socket.on('getUsers', (data) {
      userdata = data;
      setState(() {});
    });
  }

  void getContact() async {
    contacts = await FlutterContacts.getContacts(
        withProperties: true, withPhoto: true);
    setState(() {});
    print("--length of userda ${userdata.length} and conty ${contacts!.length}");
    if (userdata.isNotEmpty && contacts!.isNotEmpty) {

    comparision(userdata, contacts as List);
    }else{
      print("length of userda ${userdata.length} and conty ${contacts!.length}");
    }
    // for (int i = 0; i < contacts!.length; i++) {
    //   if (contacts![i].phones.isNotEmpty) {
    //     print(
    //         "${contacts![i].phones.first.number} Name:  ${contacts![i].name.first} ${contacts![i].name.last}");
    //   } else {
    //     print("not there");
    //   }
    // }
  }

  comparision(List first, List second) {
    for (var i = 0; i < first.length; i++) {
      for (var j = 0; j < second.length; j++) {
        if(second[j].phones.isNotEmpty){

            // print("drgdfg ${first[i]['mobile']} -- ${second[j].phones.first.number}");



        if (first[i]['mobile'].toString() == second[j].phones.first.number.toString()) {
          print("${first[i]['mobile']} -- ${second[j].phones.first.number}");
          // setState(() {
            users = second[j].phones.first.number.toString() as List<String>;
            
          // });
        }else{
          // print("---- ${first[i]['mobile']} -- ${second[j].phones.first.number}");
        }
        }
      }
    }
    print("This is users : $users");
    pri(users);
  }

  void pri(List user) {
    print("this is users list");
    for (var i = 0; i < user.length; i++) {
      print(user[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Contacts",
            style: TextStyle(color: Colors.blue),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 34, 41),
          elevation: 0,
        ),
        body: (contacts) == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: contacts!.length,
                itemBuilder: (BuildContext context, int index) {
                  Uint8List? image = contacts![index].photo;
                  String num = (contacts![index].phones.isNotEmpty)
                      ? (contacts![index].phones.first.number)
                      : "--";
                  return ListTile(
                      leading: (contacts![index].photo == null)
                          ? const CircleAvatar(child: Icon(Icons.person))
                          : CircleAvatar(backgroundImage: MemoryImage(image!)),
                      title: Text(
                          "${contacts![index].name.first} ${contacts![index].name.last}"),
                      subtitle: Text(num),
                      onTap: () {
                        if (contacts![index].phones.isNotEmpty) {
                          launch('tel: ${num}');
                        }
                      });
                },
              ));
  }
}
