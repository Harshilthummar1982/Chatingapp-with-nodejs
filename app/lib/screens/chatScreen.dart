// import 'dart:convert';

// import 'package:flutter/material.dart';

// import '../datastore/data.dart';
// import '../modul/chat.dart';

// class ChatScreen extends StatefulWidget {
//   final String roomId;
//   final String secondUser;

//   const ChatScreen({Key? key, required this.roomId, required this.secondUser})
//       : super(key: key);

//   @override
//   // State<ChatScreen> createState() => _ChatScreenState(username, chatData);
//   State<ChatScreen> createState() => _ChatScreenState(roomId, secondUser);
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final String roomId;
//   final String secondUser;
//   // _ChatScreenState(this.username, this.chatData);
//   late var chatData = [];
//   _ChatScreenState(this.roomId, this.secondUser);

//   late var roomData = {
//     'roomId': roomId,
//   };
//   @override
//   void initState() {
//     // print('this init chat');

//     Data.socket.emit('chatRoom', jsonEncode(roomData));
//     Data.socket.on('chatData', (data) {
//       // print("data ${data}");
//       chatData = data;
//       if (mounted) {
//         setState(() {});
//       }
//     });
//     super.initState();
//   }

//   refreseChat() {
//     Data.socket.emit('chatRoom', jsonEncode(roomData));
//     Data.socket.on('chatData', (data) {
//       // print("data ${data}");
//       chatData = data;
//       // if (mounted) {
//       setState(() {});
//       // }
//     });
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose

//     Data.socket.disconnect();
//     Data.socket.destroy();
//     Data.socket.dispose();
//     // print('this despose chat');

//     super.dispose();
//   }

//   // void getchat() {
//   //   Data.socket.on('chatData', (data) {
//   //     print("this is chat data");
//   //     print(data);
//   //     setState(() {
//   //       chats = data;
//   //     });
//   //   });
//   // }

//   Widget build(BuildContext context) {
//     // print("this is chat sc");
//     // print(chatData);
//     // getchat();
//     // initState();

//     // print("chat ${chatData}");
//     return Scaffold(
//       appBar: AppBar(
//           // leading: IconButton(
//           //   icon: Icon(Icons.arrow_back),
//           // onPressed: () {
//           //   Navigator.pop(context, true);
//           // },
//           // ),
//           centerTitle: true,
//           title: Text(secondUser),
//           backgroundColor: const Color.fromARGB(255, 0, 34, 41)),
//       body: SafeArea(
//         child: Container(
//           color: const Color(0xFFEAEFF2),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               Flexible(
//                 child: MediaQuery.removePadding(
//                   context: context,
//                   removeTop: true,
//                   child: ListView.builder(
//                     // controller: chatData.length,
//                     itemCount: chatData.length,
//                     physics: const BouncingScrollPhysics(),
//                     // reverse: chatData.isEmpty ? false : true,
//                     // itemCount: chatData.length,
//                     shrinkWrap: false,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Padding(
//                         padding: const EdgeInsets.only(
//                             top: 10, left: 10, bottom: 3),
//                         child: Container(
//                           margin: const EdgeInsets.only(right: 10, left: 70),
//                           height: 40,
//                           decoration: const BoxDecoration(
//                             color: Colors.amberAccent,
//                             borderRadius: BorderRadius.only(
//                               topRight: Radius.circular(10.00),
//                               bottomLeft: Radius.circular(10.00),

//                             )
//                           ),
//                           child: Align(
//                             alignment:
//                                 (chatData[index]['username'] == Data.user)
//                                     ? Alignment.centerRight
//                                     : Alignment.centerLeft,
//                             child: Padding(
//                               padding: const EdgeInsets.only(right:15.0),
//                               child: Text(
//                                 chatData[index]['message'],
//                                 style: TextStyle(fontSize: 14),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.only(
//                     bottom: 10, left: 20, right: 10, top: 5),
//                 child: Row(
//                   children: <Widget>[
//                     Flexible(
//                       child: Container(
//                         child: TextField(
//                           minLines: 1,
//                           maxLines: 5,
//                           controller: _messageController,
//                           textCapitalization: TextCapitalization.sentences,
//                           decoration: const InputDecoration.collapsed(
//                             hintText: "Type a message",
//                             hintStyle: TextStyle(
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 43,
//                       width: 42,
//                       child: FloatingActionButton(
//                         backgroundColor: const Color.fromARGB(255, 0, 34, 41),
//                         onPressed: () async {
//                           // print("onpressed....");
//                           if (_messageController.text.trim().isNotEmpty) {
//                             String message = _messageController.text.trim();

//                             Data.socket.emit(
//                                 "message",
//                                 ChatModel(
//                                   seen: false,
//                                   message: message,
//                                   username: Data.user,
//                                   to: secondUser,
//                                 ).toJson());

//                             _messageController.clear();
//                             // print("this is if");

//                           }
//                           refreseChat();
//                           // print("onpressed....222");
//                         },
//                         mini: true,
//                         child: Transform.rotate(
//                             angle: 5.79449,
//                             child: const Icon(Icons.send, size: 20)),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

import '../datastore/data.dart';
import '../modul/chat.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String secondUser;

  const ChatScreen({Key? key, required this.roomId, required this.secondUser})
      : super(key: key);

  @override
  // State<ChatScreen> createState() => _ChatScreenState(username, chatData);
  State<ChatScreen> createState() => _ChatScreenState(roomId, secondUser);
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String roomId;
  final String secondUser;
  // _ChatScreenState(this.username, this.chatData);
  late var chatData = [];
  _ChatScreenState(this.roomId, this.secondUser);

  late var roomData = {
    'roomId': roomId,
  };
  @override
  void initState() {
    // print('this init chat');

    Data.socket.emit('chatRoom', jsonEncode(roomData));
    Data.socket.on('chatData', (data) {
      // print("data ${data}");
      chatData = data;
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  refreseChat() {
    Data.socket.emit('chatRoom', jsonEncode(roomData));
    Data.socket.on('chatData', (data) {
      // print("data ${data}");
      chatData = data;
      // if (mounted) {
      setState(() {});
      // }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    Data.socket.disconnect();
    Data.socket.destroy();
    Data.socket.dispose();
    // print('this despose chat');

    super.dispose();
  }

  // void getchat() {
  //   Data.socket.on('chatData', (data) {
  //     print("this is chat data");
  //     print(data);
  //     setState(() {
  //       chats = data;
  //     });
  //   });
  // }

  Widget build(BuildContext context) {
    // print("this is chat sc");
    // print(chatData);
    // getchat();
    // initState();

    // print("chat ${chatData}");
    return Scaffold(
      appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back),
          // onPressed: () {
          //   Navigator.pop(context, true);
          // },
          // ),
          centerTitle: true,
          title: Text(secondUser),
          backgroundColor: const Color.fromARGB(255, 0, 34, 41)),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFEAEFF2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    // controller: chatData.length,
                    itemCount: chatData.length,
                    physics: const BouncingScrollPhysics(),
                    // reverse: chatData.isEmpty ? false : true,
                    // itemCount: chatData.length,
                    shrinkWrap: false,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChatBubble(
                          shadowColor: Colors.black,
                          alignment:
                              (chatData[index]['username'] == Data.user)
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                          clipper: ChatBubbleClipper(
                              type: (chatData[index]['username'] == Data.user)
                                  ? BubbleType.sendBubble
                                  : BubbleType.receiverBubble),
                          backGroundColor:
                              !(chatData[index]['username'] == Data.user)
                                  ? Color(0xffFCE7EC)
                                  : Color(0xff445A7A),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.55,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5, top: 2, bottom: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.5),
                                      // color: Colors.black,
                                      borderRadius:
                                          BorderRadius.circular(15)),
                                  child: Text(
                                    '${chatData[index]['message']}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: !(chatData[index]
                                                    ['username'] ==
                                                Data.user)
                                            ? Color(0xff635F60)
                                            : Colors.white,
                                        fontFamily: "BeViteReg",
                                        fontSize: 15.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                    bottom: 10, left: 20, right: 10, top: 5),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        child: TextField(
                          minLines: 1,
                          maxLines: 5,
                          controller: _messageController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration.collapsed(
                            hintText: "Type a message",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 43,
                      width: 42,
                      child: FloatingActionButton(
                        backgroundColor: const Color.fromARGB(255, 0, 34, 41),
                        onPressed: () async {
                          // print("onpressed....");
                          if (_messageController.text.trim().isNotEmpty) {
                            String message = _messageController.text.trim();

                            Data.socket.emit(
                                "message",
                                ChatModel(
                                  seen: false,
                                  message: message,
                                  username: Data.user,
                                  to: secondUser,
                                ).toJson());

                            _messageController.clear();
                            // print("this is if");

                          }
                          refreseChat();
                          // print("onpressed....222");
                        },
                        mini: true,
                        child: Transform.rotate(
                            angle: 5.79449,
                            child: const Icon(Icons.send, size: 20)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBubbleClipper extends CustomClipper<Path> {
  final BubbleType type;
  final double radius;

  ChatBubbleClipper({required this.type, this.radius = 35});

  @override
  Path getClip(Size size) {
    var path = Path();

    if (type == BubbleType.sendBubble) {
      path.addRRect(RRect.fromLTRBAndCorners(0, 0, size.width, size.height,
          topLeft: Radius.circular(radius),
          bottomLeft: Radius.circular(radius),
          bottomRight: Radius.circular(radius)));
    } else {
      path.addRRect(RRect.fromLTRBAndCorners(0, 0, size.width, size.height,
          topRight: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
          bottomLeft: Radius.circular(radius)));
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
