import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_map_live/itemcard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Japri extends StatefulWidget {
  final idlawan;
  const Japri({Key key, this.idlawan}) : super(key: key);

  @override
  State<Japri> createState() => _JapriState();
}

class _JapriState extends State<Japri> {
  bool _isLoading = false;
  String idku = "";
  String id = "";
  int akses;
  String nama_lengkap1 = "";
  String nama_lengkap = "";
  String no_wa = "";
  String no_wa1 = "";
  TextEditingController _pesancontroller = new TextEditingController();
  Future<String> getProfiles() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getInt("id").toString();
    nama_lengkap = preferences.getString("nama_lengkap").toString();
    no_wa = preferences.getString("no_wa").toString();

    setState(() {
      _isLoading = false;
      idku = id;
      nama_lengkap1 = nama_lengkap;
      no_wa1 = no_wa;
    });
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference isipesan = FirebaseFirestore.instance.collection('pesan');
  String pengirim = "";

  Stream<QuerySnapshot<Map<String, dynamic>>> pesan = FirebaseFirestore.instance
      .collection('pesan')
      .where('idpenerima', isEqualTo: "11")
      .snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                height: 200,
                child: StreamBuilder(
                  stream: pesan,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Container(
                      child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  snapshot.data.docs[index].data()["pesan"],
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(width: 1.0),
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(-5, 0),
                      blurRadius: 15,
                      spreadRadius: 3)
                ]),
                width: double.infinity,
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: TextField(
                            controller: _pesancontroller,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              hintText: "Pesan",
                            ),
                          ),
                        ),
                        height: 60,
                        width: MediaQuery.of(context).size.width / 1.2,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15))),
                    InkWell(
                      onTap: () {
                        isipesan.add({
                          'pesan': _pesancontroller.text,
                          'idpenerima': widget.idlawan,
                          'idpengirim': idku,
                        });
                        setState(() {
                          _pesancontroller.text = '';
                        });
                      },
                      child: Container(
                        child: Icon(Icons.send, color: Colors.white),
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
