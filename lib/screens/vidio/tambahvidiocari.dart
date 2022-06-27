import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:google_map_live/core/models/listvidiolokasicari.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/vidio/playvidio.dart';
import 'package:google_map_live/screens/vidio/uploadvidio.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:http/http.dart' as http;

class Allvidio extends StatefulWidget {
  @override
  _AllvidioState createState() => _AllvidioState();
}

class _AllvidioState extends State<Allvidio> {
  //Theme Data

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //Other Variables
  bool showPassword = false;

  //UI Variables
  OutlineInputBorder allTFBorder;
  double lat;
  double lon;

  var loadingvidio = false;
  final listvidio = new List<Listvidiocari>();

  var loadingdokter = false;

  List<Listvidiocari> _list = [];
  List<Listvidiocari> _search = [];

  getCurrentLocation() async {
    setState(() {
      loadingvidio = true;
    });

    _list.clear();
    setState(() {
      loadingdokter = true;
    });

    final responsee = await http.get(Uri.parse(RestApi.getvidio));
    if (responsee.statusCode == 200) {
      final datadokter = jsonDecode(responsee.body);
      print(datadokter);
      setState(() {
        for (Map i in datadokter) {
          _list.add(Listvidiocari.fromJson(i));
          loadingdokter = false;
        }
      });
    } else {
      setState(() {
        loadingdokter = false;
      });
    }
  }

  TextEditingController controller = new TextEditingController();
  _onsearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _list.forEach((f) {
      if (f.namalokasi.contains(text) || f.namalokasi.contains(text))
        _search.add(f);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _initUI() {
    allTFBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(color: Colors.blue, width: 1.5));
  }

    _hapus(int id) async {
    final response = await http.post(Uri.parse(RestApi.deletevidio), body: {
      "id": id.toString(),
    });
    final data = jsonDecode(response.body);
    print(data);
    String value = data['value'];
    if (value == "1") {
      pesan();
    } else {
      print("Data gagal");
    }
  }
  Future<void> pesan() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Delete Success',
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
                getCurrentLocation();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
                leading: new IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Container(
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, boxShadow: []),
                    child: new Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
                backgroundColor: Colors.green,
                title: Text("Search",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Kali',
                    ))),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  color: Color(0xffb6b6b6),
                                  offset: Offset(
                                    3,
                                    3,
                                  ),
                                ),
                              ],
                              borderRadius: BorderRadius.all(Radius.circular(
                                10,
                              ))),
                          height: 60,
                          padding: EdgeInsets.all(4.0),
                          margin: EdgeInsets.all(8.0),
                          child: new TextField(
                            controller: controller,
                            onChanged: _onsearch,
                            autofocus: true,
                            decoration: InputDecoration(
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                hintText: "Cari Vidio",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.clear();
                                    _onsearch('');
                                  },
                                  icon: Icon(Icons.search),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      style: BorderStyle.none,
                                    ))),
                          ),
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height / 1.8,
                            child: loadingdokter
                                ? Center()
                                : Container(
                                    child:
                                        _search.length != 0 ||
                                                controller.text.isNotEmpty
                                            ? ListView.builder(
                                                itemCount: _search.length,
                                                itemBuilder: (context, i) {
                                                  final dt = _search[i];

                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Playvidio(
                                                                      vidio: dt
                                                                          .vidio)));
                                                    },
                                                    child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        print("asdasd");
                                                      },
                                                      child: Container(
                                                          child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 7,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          Playvidio(
                                                                              vidio: dt.vidio)));
                                                            },
                                                            child: Container(
                                                              height: 60,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Color(
                                                                          0xffffffff),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          blurRadius:
                                                                              2,
                                                                          color:
                                                                              Color(0xffb6b6b6),
                                                                          offset:
                                                                              Offset(
                                                                            3,
                                                                            3,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(
                                                                        10,
                                                                      ))),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        9.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Judul Vidio",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Kali',
                                                                              fontSize: 15),
                                                                        ),
                                                                        Text(
                                                                            dt.namalokasi,
                                                                            style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: 'Kali',
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            _hapus(dt.id);
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.delete,
                                                                            size:
                                                                                40,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              15,
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => Uploadvidio(
                                                                                          id: dt.id,
                                                                                        )));
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.add_photo_alternate_outlined,
                                                                            size:
                                                                                40,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                    ),
                                                 ),
                                                  );
                                                })
                                            : ListView.builder(
                                                itemCount: _list.length,
                                                itemBuilder: (context, i) {
                                                  final dr = _list[i];

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        print("asdasd");
                                                      },
                                                      child: Container(
                                                          child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 7,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          Playvidio(
                                                                              vidio: dr.vidio)));
                                                            },
                                                            child: Container(
                                                              height: 60,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Color(
                                                                          0xffffffff),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          blurRadius:
                                                                              2,
                                                                          color:
                                                                              Color(0xffb6b6b6),
                                                                          offset:
                                                                              Offset(
                                                                            3,
                                                                            3,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(
                                                                        10,
                                                                      ))),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        9.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Judul Vidio",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Kali',
                                                                              fontSize: 15),
                                                                        ),
                                                                        Text(
                                                                            dr.namalokasi,
                                                                            style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: 'Kali',
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            _hapus(dr.id);
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.delete,
                                                                            size:
                                                                                40,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              15,
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => Uploadvidio(
                                                                                          id: dr.id,
                                                                                        )));
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.add_photo_alternate_outlined,
                                                                            size:
                                                                                40,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                    ),
                                                  );
                                                })))
                        //Column(children: newsList)
                      ],
                    ),
                  ),
                )
              ],
            )));
  }

  void showMessage({String message = "Something wrong", Duration duration}) {
    if (duration == null) {
      duration = Duration(seconds: 3);
    }
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: duration,
        content: Text(
          message,
        ),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}
