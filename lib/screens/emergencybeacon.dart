import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Emergencybeacon extends StatefulWidget {
  const Emergencybeacon({Key key}) : super(key: key);

  @override
  State<Emergencybeacon> createState() => _EmergencybeaconState();
}

class _EmergencybeaconState extends State<Emergencybeacon> {
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
    print(nama_lengkap1);
  }

  var vidiourl;
  void pickvidio() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      setState(() {
        vidiourl = file.path;
      });
      print(vidiourl);
    } else {
      // User canceled the picker
    }
  }

  bool loading = false;

  Future<void> info() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Info Tersimpan',
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
                laporan.text = "";
                vidiourl = "";
              },
            ),
          ],
        );
      },
    );
  }

  TextEditingController laporan = new TextEditingController();
  TextEditingController nama = new TextEditingController();
  save() async {
    setState(() {
      loading = true;
    });

    final uri = Uri.parse(RestApi.tambahemergencybecon);
    var request = http.MultipartRequest("POST", uri);
    request.fields['iduser'] = idku;
    request.fields['nama'] = nama_lengkap1;
    request.fields['laporan'] = laporan.text;

    var uploadvidio = await http.MultipartFile.fromPath("foto", vidiourl);

    request.files.add(uploadvidio);
    var response = await request.send();

    if (response.statusCode == 200) {
      print("upload berhasil");
      setState(() {
        loading = false;
        info();
      });
    } else {
      print("upload tidak berhasil");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfiles();
    setState(() {
      nama.text = nama_lengkap1;
    });
    print(nama_lengkap1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("File Upload Inprogrees"),
                    CircularProgressIndicator(),
                  ],
                ),
              )
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              "Form Emergency Becon",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            TextFormField(
                              controller: laporan,
                              maxLines: 7,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.amber),
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2.0)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.yellow[300]),
                                ),
                                labelText: 'Laporan',
                                labelStyle: TextStyle(color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  pickvidio();
                                },
                                child: Text("Pick Image")),
                            SizedBox(
                              height: 10,
                            ),
                            Text(vidiourl != null ? vidiourl : "Select"),
                            Text("Upload vidio"),
                            ElevatedButton(
                                onPressed: () {
                                  save();
                                },
                                child: Text("Upload")),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }
}
