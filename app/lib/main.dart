import 'package:app/screens/contecs.dart';
import 'package:app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'authantication/signIn.dart';
import 'authantication/signUp.dart';
import 'screens/drawer.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      // home:  MyHomePage(),
      initialRoute: '/signIn',
      routes: <String, WidgetBuilder>{
        '/signIn': (_) => const SignIn(),
        '/signUp': (_) => const SignUp(),
        '/homePage': (_) => const HomePage(),
        '/contects': (_) => const Contacts(),
        // '/MyDrawer': (_) =>  MyDrawer(),
        // '/chatPage': (_) => const ChatScreen(),
      },
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   //initalize the Socket.IO Client Object
//   // late IO.Socket socket;
//   // initializeSocket() {
//   //   socket = IO.io("http://192.168.29.202:3000", <String, dynamic>{
//   //     "transports": ["websocket"],
//   //     "autoConnect": true,
//   //   });

//   //   socket.connect(); //connect the Socket.IO Client to the Server

//   //   socket.onConnect((data) => {print("Connect ${socket.id}")});
//   //   //SOCKET EVENTS
//   //   // --> listening for connection

//   //   // socket.on('connect', (data) {
//   //   //   print("this is connected");
//   //   //   print(socket.connected);
//   //   // });

//   //   //listen for incoming messages from the Server.
//   //   socket.on('message', (data) {
//   //     print(data); //
//   //   });

//   //   //listens when the client is disconnected from the Server
//   //   socket.on('disconnect', (data) {
//   //     print('disconnect');
//   //   });
//   //   socket.on('possion-change', (data) {
//   //     print('possion-change');
//   //   });
//   //   socket.on('login', (data) {
//   //     debugPrint("login done");
//   //   });
//   // }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   initializeSocket(); //--> call the initializeSocket method in the initState of our app.
//   // }

//   // @override
//   // void dispose() {
//   //   socket
//   //       .disconnect(); // --> disconnects the Socket.IO client once the screen is disposed
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: GestureDetector(
//           onTap: () {
//             // print("this is press");
//             // // sendMessage(String message) {
//             // var doc = {"name": "ksjdnksj", "id": socket.id};
//             // socket.emit('possion-change', jsonEncode(doc));
//             // }
//           },
//           child: Container(
//             height: 100,
//             width: 100,
//             color: Colors.amber,
//             child: const Text("press"),
//           ),
//         ),
//       ),
//     );
//   }
// }
