import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_map_live/itemcard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:core';

class Chatgroup extends StatefulWidget {
  const Chatgroup({Key key}) : super(key: key);

  @override
  State<Chatgroup> createState() => _ChatgroupState();
}

class _ChatgroupState extends State<Chatgroup> {
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

  CollectionReference isipesan =
      FirebaseFirestore.instance.collection('pesangroup');
  String pengirim = "";

  Stream<QuerySnapshot<Map<String, dynamic>>> pesan = FirebaseFirestore.instance
      .collection('pesangroup')
      .orderBy("tanggal")
      .limit(1000)
      .snapshots();

  static var today = new DateTime.now();
  var formatedTanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime tanggal;
  var tanggalhariini = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfiles();

    print("ini tanggal hari ini");
    print(formatedTanggal.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              SingleChildScrollView(
                reverse: true,
                child: Container(
                  height: MediaQuery.of(context).size.width / 2.4,
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
                            Timestamp time =
                                snapshot.data.docs[index].data()['tanggal'];
                            DateTime now = time.toDate();
                            String formattedDate =
                                DateFormat('yyyy-MM-dd – kk:mm').format(now);
                            return ListTile(
                              title: Column(
                                crossAxisAlignment: idku ==
                                        snapshot.data.docs[index]
                                            .data()['userid']
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: idku ==
                                                  snapshot.data.docs[index]
                                                      .data()['userid']
                                              ? Colors.blueAccent[100]
                                                  .withOpacity(0.2)
                                              : Colors.amber[100],
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data.docs[index]
                                                  .data()["pesan"],
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Container(
                                              width: 255,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "Pengirim :",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        snapshot.data
                                                                .docs[index]
                                                                .data()[
                                                            "namapengirim"],
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    formattedDate,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            );

                            /*
                            return ListTile(
                              title: Column(
                                crossAxisAlignment: nama_lengkap1 ==
                                        snapshot.data.docs[index]
                                            .data()["namapengirim"]
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data.docs[index].data()["pesan"],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        snapshot.data.docs[index]
                                            .data()["namapengirim"],
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
              */
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: TextField(
                        controller: _pesancontroller,
                        decoration: InputDecoration(hintText: "Tulis Pesan"),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        isipesan.add({
                          'pesan': _pesancontroller.text,
                          'namapengirim': nama_lengkap1,
                          'userid': idku,
                          'tanggal': DateTime.now(),
                        });
                        setState(() {
                          _pesancontroller.text = '';
                        });
                      },
                      icon: Icon(Icons.send))
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
