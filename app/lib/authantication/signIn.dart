import 'dart:convert';

import 'package:app/datastore/data.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool loding = false;
  @override
  void initState() {
    // TODO: implement initState
    Data.initializeSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Hotel"),
      // ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  //   image: DecorationImage(
                  //       image: AssetImage('assets/images/loginpage/food0.jpg'),
                  //       fit: BoxFit.cover),
                  ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    const Color(0xff161d27).withOpacity(0.9),
                    const Color(0xff161d27),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Welcome!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Time to get started, let's SignIn",
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    child:
                        // ------
                        TextFormField(
                      onChanged: (value) {
                        _email.text = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* Required';
                        }
                        return null;
                      },
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "User Name",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                        filled: true,
                        fillColor: const Color(0xff161d27),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                const BorderSide(color: Color(0xfffe9721))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                const BorderSide(color: Color(0xfffe9721))),
                      ),
                    ),
                    // -----
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* Required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _password.text = value;
                      },
                      obscureText: true,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                        filled: true,
                        fillColor: const Color(0xff161d27),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                const BorderSide(color: Color(0xfffe9721))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                const BorderSide(color: Color(0xfffe9721))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Forgot Password",
                    style: TextStyle(
                        color: Color(0xfffe9721),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 40, right: 40),
                      child: RaisedButton(
                        onPressed: () {
                          // String id = _email.text;
                          // String password = _password.toString();
                          // print("$id and $password");

                          setState(() {
                            loding = true;
                          });
                          Future.delayed(const Duration(seconds: 1), () {})
                              .then((value) {
                            final isValid = _formKey.currentState!.validate();

                            if (!isValid) {
                              setState(() {
                                loding = false;
                              });
                              return;
                            }
                            _formKey.currentState!.save();
                            var doc = {
                              "user": _email.text,
                              "password": _password.text
                            };

                            Data.socket.emit('signIn', jsonEncode(doc));

                            Data.socket.on('Done', (data) {
                              final snackBar = SnackBar(
                                content: Text('${data['Done']}'),
                              );
                              setState(() {
                                loding = false;
                                Data.user = _email.text;
                                Data.mobile = data['mobile'];
                                Data.uid = data['uid'];
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);

                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/homePage", (route) => false);
                            });
                            Data.socket.on('invalid', (data) {
                              final snackBar = SnackBar(
                                content: Text('${data['invalid']}'),
                              );
                              setState(() {
                                loding = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            });
                            Data.socket.on('err', (data) {
                              final snackBar = SnackBar(
                                content: Text('${data['err']}'),
                              );
                              setState(() {
                                loding = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            });
                          });
                        },
                        color: const Color(0xfffe9721),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: (loding == false)
                            ? const Text(
                                "SIGN IN",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )
                            : const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, "/signUp");
                        },
                        child: const Text(
                          //Aama website ni link aapvani chhe
                          "SignUp",
                          style: TextStyle(
                              color: Color(0xfffe9721),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
