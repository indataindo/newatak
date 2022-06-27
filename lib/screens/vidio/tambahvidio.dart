import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_map_live/core/models/listvidiolokasi.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/vidio/playvidio.dart';
import 'package:google_map_live/screens/vidio/uploadvidio.dart';
import 'package:http/http.dart' as http;

class Tambahvidio extends StatefulWidget {
  const Tambahvidio({Key key}) : super(key: key);

  @override
  State<Tambahvidio> createState() => _TambahvidioState();
}

class _TambahvidioState extends State<Tambahvidio> {
  var loading = false;
  final listlokasi = new List<Listvidiolokasi>();

  tampinamalokasi() async {
    listlokasi.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(RestApi.getvidio));

    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final p =
            new Listvidiolokasi(api['id'], api['namalokasi'], api['vidio']);
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

                if (data.vidio == "0") {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        trailing: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Uploadvidio(
                                          id: data.id,
                                        )));
                          },
                          child: Icon(
                            Icons.add_photo_alternate_rounded,
                            size: 35,
                          ),
                        ),
                        title: Text(
                          data.namalokasi,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(data.vidio),
                      ),
                    ),
                  );
                } else {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Playvidio(vidio: data.vidio)));
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          subtitle: Text(data.vidio),
                          title: Text(
                            data.namalokasi,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }
}
