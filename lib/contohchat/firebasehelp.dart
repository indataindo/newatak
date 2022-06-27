import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_map_live/contohchat/chetscreen.dart';
import 'package:google_map_live/mainchetdart';

class Service {
  final auth = FirebaseAuth.instance;

  void createUser(context, email, password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Chetscreen()))
              });
    } catch (e) {
      error(context, e);
    }
  }

  void login(context, email, password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Chetscreen()))
              });
    } catch (e) {
      error(context, e);
    }
  }

  void sigout(context) async {
    try {
      await auth.signOut().then((value) => {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyApp()), (route) => false)
      });
    } catch (e) {}
  }

  void error(context, e) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.toString()),
          );
        });
  }
}
