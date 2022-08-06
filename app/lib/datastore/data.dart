import 'dart:convert';
import 'dart:math';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class Data {
// variables  ---------------------------------------------------

  static late IO.Socket socket;
  static var userData = [];
  static String user = 'Dhruv';
  static var connection;
  static var mobile = 8758745025;
  static String uid = '';
  
  

// functions ----------------------------------------------------
  static initializeSocket() {
    Data.socket = IO.io("http://192.168.104.103:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
    });
   var conne =  Data.socket.connect(); //connect the Socket.IO Client to the Server
    
  //  print("this is connection : ${conne.connected}");
    Data.socket.onConnect((data) => {print("Connect ${Data.socket.id}"),Data.connection = conne.connected,print("this is connection1 : ${Data.connection}")});
    
  }

  
}
