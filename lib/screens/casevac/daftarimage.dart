import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_map_live/core/models/listlihatimage.dart';
import 'package:google_map_live/core/models/listvidiolokasi.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/vidio/playvidio.dart';
import 'package:google_map_live/screens/vidio/uploadvidio.dart';
import 'package:http/http.dart' as http;

class Daftarimage extends StatefulWidget {
  final idimage;
  const Daftarimage({Key key, this.idimage}) : super(key: key);

  @override
  State<Daftarimage> createState() => _DaftarimageState();
}

class _DaftarimageState extends State<Daftarimage> {
  var loading = false;
  final listlokasi = new List<Listlihatimage>();

  tampinamalokasi() async {
    listlokasi.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(Uri.parse(RestApi.lihatimage),
        body: {"idimage": widget.idimage.toString()});

    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final p = new Listlihatimage(api['id'], api['image']);
        listlokasi.add(p);
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tampinamalokasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: listlokasi.length,
              itemBuilder: (context, i) {
                final data = listlokasi[i];

                return Container(
                  height: 350,
                  width: 50,
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    'http://8.215.39.14/amarta/public/upload/event/' +
                                        data.image)),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
