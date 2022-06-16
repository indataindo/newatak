import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_map_live/restapi/restApi.dart';

import 'package:http/http.dart' as http;

class Uploadimages extends StatefulWidget {
  final int id;
  const Uploadimages({Key key, this.id}) : super(key: key);

  @override
  State<Uploadimages> createState() => _UploadimagesState();
}

class _UploadimagesState extends State<Uploadimages> {
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
                  'Upload Berhasil',
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
              },
            ),
          ],
        );
      },
    );
  }

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
                  'Upload Image Berhasil',
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
              },
            ),
          ],
        );
      },
    );
  }

  save() async {
    setState(() {
      loading = true;
    });

    final uri = Uri.parse(RestApi.uploadimage);
    var request = http.MultipartRequest("POST", uri);
    request.fields['idimage'] = widget.id.toString();
    var uploadvidio = await http.MultipartFile.fromPath("image", vidiourl);

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
    print("id image");
    print(widget.id);
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
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        pickvidio();
                      },
                      child: Text("Upload")),
                  Text(vidiourl != null ? vidiourl : "Select"),
                  Text("Upload image"),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        save();
                      },
                      child: Text("save")),
                ],
              ),
            ),
    );
  }
}
