import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_map_live/contohchat/firebasehelp.dart';
import 'package:google_map_live/contohchat/tammpilpesan.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chetscreen extends StatefulWidget {
  final String id;
  final String nama;

  const Chetscreen({Key key, this.id, this.nama}) : super(key: key);

  @override
  State<Chetscreen> createState() => _ChetscreenState();
}

class _ChetscreenState extends State<Chetscreen> {
  Service service = Service();
  var loginUser = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
  final storeMessage = FirebaseFirestore.instance;
  TextEditingController message = new TextEditingController();

  getCurrentUser() {
    final user = auth.currentUser;

    if (user != null) {
      loginUser = user;
    }
  }

  bool _isLoading = false;
  String idku = "";
  String id = "";
  int akses;
  String nama_lengkap1 = "";
  String nama_lengkap = "";
  String no_wa = "";
  String no_wa1 = "";

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

  var formatedTanggal =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  DateTime tanggal;
  var tanggalhariini = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();

    getProfiles();

    print("Ini Lah dia");
    print(widget.id);
    print(widget.nama);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        actions: [],
        title: Row(
          children: [
            Text(widget.nama),
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  reverse: true,
                  child: Container(
                      height: MediaQuery.of(context).size.height / 1.6,
                      child: tampilpesan(widget.id)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: TextField(
                          controller: message,
                          decoration: InputDecoration(hintText: "Tulis Pesan"),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          if (message.text.isNotEmpty) {
                            storeMessage.collection('pesanku').doc().set({
                              "msg": message.text.trim(),
                              "userid": idku,
                              "pengirim": nama_lengkap1,
                              //  "time": formatedTanggal,
                              "time": DateTime.now(),
                              "penerima": widget.id
                            });
                            message.clear();
                          }
                        },
                        icon: Icon(Icons.send))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  tampilpesan(String id) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pesanku')
          .orderBy("time", descending: true)
          .where("penerima", isEqualTo: "${id}")
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          reverse: true,
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, i) {
            QueryDocumentSnapshot x = snapshot.data.docs[i];

            return ListTile(
              title: Column(
                crossAxisAlignment: idku == x['userid']
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 40,
                      width: 255,
                      decoration: BoxDecoration(
                          color: idku == x['userid']
                              ? Colors.blueAccent[100].withOpacity(0.2)
                              : Colors.amber[100],
                          borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Center(child: Text(x['msg']))),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class Tampilpesan extends StatelessWidget {
  const Tampilpesan({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {}
}
