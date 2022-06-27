import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_map_live/res/custom_colors.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/utils/database.dart';
import 'package:google_map_live/utils/validator.dart';
import 'package:google_map_live/widgets/custom_form_field.dart';

class Adduser extends StatefulWidget {
  const Adduser({Key key}) : super(key: key);

  @override
  State<Adduser> createState() => _AdduserState();
}

class _AdduserState extends State<Adduser> {
  bool _isProcessing = false;
  bool isloading = false;
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController namacontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  TextEditingController ulangipasswordcontroller = new TextEditingController();
  TextEditingController nowa = new TextEditingController();
//menampilkan pesan

  Future<void> _pesan() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Selamat Pendaftaran Anda Berhasil',
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

  Future<void> _pesanemail() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Email Sudah DI Gunakan',
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

  Future<void> _pesanwa() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'No WhatsApp Sudah DI Gunakan',
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

  Future<void> _pesanpassword() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Password Tidak Sama',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                setState(() {
                  isloading = false;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

//end pesan pesan
  //menyimpan data ke database

  simpan() async {
    print(emailcontroller.text);
    print(namacontroller.text);
    print(passwordcontroller.text);
    print(ulangipasswordcontroller.text);

    if (passwordcontroller.text != ulangipasswordcontroller.text) {
      // print("password tidak sama");
      _pesanpassword();
    } else {
      registrasi();
    }
  }

  registrasi() async {
    final response = await http.post(Uri.parse(RestApi.register), body: {
      "nama_lengkap": namacontroller.text,
      "email": emailcontroller.text,
      "password": passwordcontroller.text,
      "no_wa": nowa.text,
    });

    final data = jsonDecode(response.body);
    String value = data['value'];
    String pesan = data['message'];

    if (value == "1") {
      _pesan();

      setState(() {
        namacontroller.text = '';
        emailcontroller.text = '';
        passwordcontroller.text = '';
        ulangipasswordcontroller.text = '';
        nowa.text = '';
        isloading = false;
      });
    } else if (value == "2") {
      setState(() {
        isloading = false;
      });
      _pesanemail();
    } else {
      _pesanwa();
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.firebaseNavy,
        title: Text("Add User"),
      ),
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  bottom: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Email",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              color: Color(0xff737373),
                              offset: Offset(
                                1,
                                1,
                              ),
                            ),
                          ],
                          gradient: null,
                          borderRadius: BorderRadius.all(Radius.circular(
                            7,
                          ))),
                      child: TextFormField(
                        controller: emailcontroller,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(),
                            border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Password",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              color: Color(0xff737373),
                              offset: Offset(
                                1,
                                1,
                              ),
                            ),
                          ],
                          gradient: null,
                          borderRadius: BorderRadius.all(Radius.circular(
                            7,
                          ))),
                      child: TextFormField(
                        controller: passwordcontroller,
                        obscureText: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(),
                            border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Ulangi Password",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              color: Color(0xff737373),
                              offset: Offset(
                                1,
                                1,
                              ),
                            ),
                          ],
                          gradient: null,
                          borderRadius: BorderRadius.all(Radius.circular(
                            7,
                          ))),
                      child: TextFormField(
                        controller: ulangipasswordcontroller,
                        obscureText: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(),
                            border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Nama",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              color: Color(0xff737373),
                              offset: Offset(
                                1,
                                1,
                              ),
                            ),
                          ],
                          gradient: null,
                          borderRadius: BorderRadius.all(Radius.circular(
                            7,
                          ))),
                      child: TextFormField(
                        controller: namacontroller,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.people),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(),
                            border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    SizedBox(height: 24.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "No WhatsApp",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              color: Color(0xff737373),
                              offset: Offset(
                                1,
                                1,
                              ),
                            ),
                          ],
                          gradient: null,
                          borderRadius: BorderRadius.all(Radius.circular(
                            7,
                          ))),
                      child: TextFormField(
                        controller: nowa,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.people),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(),
                            border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      CustomColors.firebaseOrange,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    simpan();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: isloading
                        ? CircularProgressIndicator()
                        : Text(
                            'ADD USER',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.firebaseGrey,
                              letterSpacing: 2,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
