import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_map_live/res/custom_colors.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/botomnavy.dart';
import 'package:google_map_live/signin4.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Registeruser extends StatefulWidget {
  @override
  _RegisteruserState createState() => _RegisteruserState();
}

class _RegisteruserState extends State<Registeruser> {
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;

  Color _underlineColor = Color(0xFFCCCCCC);
  Color _mainColor = Color(0xFF07ac12);
  Color _color1 = Color(0xFF515151);
  Color _color2 = Color(0xff777777);
  Color _color3 = Color(0xFFaaaaaa);

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController nowa = new TextEditingController();

  savePref(
    int value,
    id,
    String nama_lengkap,
    emel,
    no_wa,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt('value', value);
      preferences.setInt('id', id);
      preferences.setString('nama_lengkap', nama_lengkap);
      preferences.setString('email', emel);
      preferences.setString('no_wa', no_wa);
      preferences.commit();
    });
  }

  registrasi() async {
    print(email.text);
    print(password.text);

    final response = await http.post(Uri.parse(RestApi.register), body: {
      "email": email.text,
      "nama_lengkap": name.text,
      "no_wa": nowa.text,
      "password": password.text,
    });

    final data = jsonDecode(response.body);
    print(data);

    String value = data['value'];

    if (value == "1") {
      _pesanlogin();
    } else if (value == 5) {
      // _pesanterhubung();
    } else {
      // _pesangagallogin();
    }
  }

  Future<void> _pesanlogin() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Registratrion Success',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Signin4Page()));
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _requestpermision();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.firebaseNavy,
        body: Center(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //  Center(child: Im  age.asset('assets/867087.png', height: 130)),
                    SizedBox(height: 25),
                    Text('Register New User',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent.shade700)),
                    TextFormField(
                      controller: name,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.amber),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: _mainColor, width: 2.0)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: _underlineColor),
                        ),
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.amber),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: nowa,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: Colors.amber),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: _mainColor, width: 2.0)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: _underlineColor),
                        ),
                        labelText: 'No WhatsApp',
                        labelStyle: TextStyle(color: Colors.amber),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.amber),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: _mainColor, width: 2.0)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: _underlineColor),
                        ),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.amber),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: password,
                      obscureText: _obscureText,
                      style: TextStyle(color: Colors.amber),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.tealAccent.shade400, width: 2.0)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: _underlineColor),
                        ),
                        labelText: 'Password',
                        // labelStyle: TextStyle(color: _color2),
                        labelStyle: TextStyle(color: Colors.amber),
                        suffixIcon: IconButton(
                            icon: Icon(_iconVisible,
                                color: Colors.grey[400], size: 20),
                            onPressed: () {
                              _toggleObscureText();
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) =>
                                Colors.tealAccent.shade700,
                          ),
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          )),
                        ),
                        onPressed: () {
                          registrasi();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            'REGISTRATION',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        )),

                    /*
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: 'Click signup', toastLength: Toast.LENGTH_SHORT);
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                */
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  _requestpermision() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print("OK");
    } else if (status.isDenied) {
      _requestpermision();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
