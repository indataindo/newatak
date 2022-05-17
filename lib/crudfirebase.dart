import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_map_live/itemcard.dart';

class Crudfirebase extends StatefulWidget {
  const Crudfirebase({Key key}) : super(key: key);

  @override
  State<Crudfirebase> createState() => _CrudfirebaseState();
}

class _CrudfirebaseState extends State<Crudfirebase> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    Stream<QuerySnapshot<Map<String, dynamic>>> collectionstream =
        FirebaseFirestore.instance.collection('users').snapshots();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Firestore Demo'),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
              children: [
                Container(
                  height: 200,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: collectionstream,
                      builder: (context, snapshot) {
                        return Container(
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(snapshot.data.docs[index]
                                          .data()['name']),
                                      Text(snapshot.data.docs[index]
                                          .data()['age']
                                          .toString()),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      users
                                          .doc(snapshot.data.docs[index].id)
                                          .delete();
                                    },
                                    icon: Icon(Icons.delete),
                                  ));
                            },
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 150,
                )
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(-5, 0),
                        blurRadius: 15,
                        spreadRadius: 3)
                  ]),
                  width: double.infinity,
                  height: 130,
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(hintText: "Name"),
                            ),
                            TextField(
                              controller: ageController,
                              decoration: InputDecoration(hintText: "Age"),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 130,
                        width: 130,
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Colors.blue[900],
                            child: Text(
                              'Add Data',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              users.add({
                                'name': nameController.text,
                                'age': int.tryParse(ageController.text) ?? 0
                              });

                              nameController.text = '';
                              ageController.text = '';
                              Fluttertoast.showToast(msg: "User Berhasil Ditambah");
                            }),
                      )
                    ],
                  ),
                )),
          ],
        ));
  }


  
}
