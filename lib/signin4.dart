import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_map_live/res/custom_colors.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/botomnavy.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Signin4Page extends StatefulWidget {
  @override
  _Signin4PageState createState() => _Signin4PageState();
}

class _Signin4PageState extends State<Signin4Page> {
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;

  Color _underlineColor = Color(0xFFCCCCCC);
  Color _mainColor = Color(0xFF07ac12);
  Color _color1 = Color(0xFF515151);
  Color _color2 = Color(0xff777777);
  Color _color3 = Color(0xFFaaaaaa);

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

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
    final response = await http.post(Uri.parse(RestApi.login), body: {
      "email": email.text,
      "password": password.text,
    });

    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];

    String nama_lengkap = data['nama_lengkap'];
    String emel = data['email'];
    String nowa = data['no_wa'];
    int id = data['id'];
    if (value == 1) {
      setState(() {
        savePref(value, id, nama_lengkap, emel, nowa);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Navybuttom()));
      });
    } else if (value == 5) {
      _pesanterhubung();
    } else {
      _pesangagallogin();
    }
  }

  Future<void> _pesanterhubung() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Akun ada masih terhubung dengan perangkat lain',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pesangagallogin() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Email Dan Passwod Tidak Sama',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                //  Center(child: Image.asset('assets/867087.png', height: 130)),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                ),
                Text('Sign In',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent.shade700)),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.amber),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _mainColor, width: 2.0)),
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
                    labelStyle: TextStyle(color: _color2),
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
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) =>
                            Colors.tealAccent.shade700,
                      ),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      )),
                    ),
                    onPressed: () {
                      registrasi();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
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
