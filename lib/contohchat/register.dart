import 'package:flutter/material.dart';
import 'package:google_map_live/contohchat/firebasehelp.dart';
//import 'package:google_map_live/contohchat/firebasehelpdart';
import 'package:google_map_live/mainchetdart';

class Daftar extends StatefulWidget {
  const Daftar({Key key}) : super(key: key);

  @override
  State<Daftar> createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> {
  Service service = Service();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("AMARTA"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Register"),
              TextField(
                controller: emailcontroller,
                decoration: InputDecoration(hintText: "Email"),
              ),
              TextField(
                controller: passwordcontroller,
                decoration: InputDecoration(hintText: "Password"),
              ),
              SizedBox(
                height: 100,
              ),
              TextButton(
                  onPressed: () {
                    if (emailcontroller.text.isNotEmpty &&
                        passwordcontroller.text.isNotEmpty) {
                      service.createUser(context, emailcontroller.text,
                          passwordcontroller.text);
                    } else {
                      service.error(context, "Field Register please not empty");
                    }
                  },
                  child: Text("Register")),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  },
                  child: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}
