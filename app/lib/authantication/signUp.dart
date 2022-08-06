import 'dart:convert';
import 'dart:math';
import 'package:app/datastore/data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  bool loding = false;
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  double _strength = 0;
  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");
  String _displayText = 'Please enter a password';

  String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  void _checkPassword(String value) {

    if (_password.text.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = 'Please enter you password';
      });
    } else if (_password.text.length < 6) {
      setState(() {
        _strength = 1 / 4;
        _displayText = 'Your password is too short';
      });
    } else if (_password.text.length < 8) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'Your password is acceptable but not strong';
      });
    } else {
      if (!letterReg.hasMatch(_password.text) ||
          !numReg.hasMatch(_password.text)) {
        setState(() {
          _strength = 3 / 4;
          _displayText = 'Your password is strong';
        });
      } else {
        setState(() {
          _strength = 1;
          _displayText = 'Your password is great';
        });
      }
    }
  }

  @override
  void initState() {
    Data.initializeSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(),
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
                    "Time to get started, let's SignUp",
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

                        TextFormField(
                      controller: _email,
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
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    child: TextFormField(
                      controller: _mobile,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* Required';
                        } else if (value.length != 10) {
                          return '* Enter Valid Number';
                        }
                        return null;
                      },
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "mobile no.",
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
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    child: TextFormField(
                      controller: _password,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '* Required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _checkPassword(value);
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
                  const SizedBox(height: 3),
                  Container(
                    margin: const EdgeInsets.only(left: 70, right: 70),
                    child: LinearProgressIndicator(
                      value: _strength,
                      backgroundColor: Colors.grey[300],
                      color: _strength <= 1 / 4
                          ? Colors.red
                          : _strength == 2 / 4
                              ? Colors.yellow
                              : _strength == 3 / 4
                                  ? Colors.blue
                                  : Colors.green,
                      minHeight: 5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    child: RaisedButton(
                      onPressed: _strength < 1 / 2
                          ? null
                          : () {
                              setState(() {
                                loding = true;
                              });
                              Future.delayed(const Duration(seconds: 1), () {})
                                  .then((value) {
                                final isValid =
                                    _formKey.currentState!.validate();
                                if (!isValid) {
                                  setState(() {
                                    loding = false;
                                  });
                                  return;
                                }
                                _formKey.currentState!.save();
                                String getUid = getRandomString(30);
                                var doc = {
                                  "user": _email.text,
                                  "mobile": int.parse(_mobile.text),
                                  "password": _password.text,
                                  "uid": getUid
                                };

                                Data.socket.emit('signUp', jsonEncode(doc));
                                Data.socket.on('Done', (data) {
                                  final snackBar = SnackBar(
                                    content: Text('${data['Done']}'),
                                  );
                                  setState(() {
                                    loding = false;
                                    Data.user = _email.text;
                                    Data.mobile = int.parse(_mobile.text);
                                    Data.uid = getUid;
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);

                                  Navigator.pushNamedAndRemoveUntil(
                                      context, "/homePage", (route) => false);
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
                              "SIGN UP",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          : const CircularProgressIndicator(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, "/signIn");
                        },
                        child: const Text(
                          "SignIn",
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
