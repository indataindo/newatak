import 'package:flutter/material.dart';

class DialogReport extends StatelessWidget {
  String title;
  BuildContext context;
  Function onSend;
  Function onSendFav;
  Function onSendBook;
  TextEditingController reportController;
  TextEditingController pilihanController;

  DialogReport(
      {this.title,
      this.context,
      this.onSend,
      this.onSendFav,
      this.onSendBook,
      this.reportController});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            controller: reportController,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16),
            maxLength: 200,
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: "",
              hintText: "Nama Lokasi",
            ),
          ),
     
      
        ],
      )),
      actions: <Widget>[
        FlatButton(
          onPressed: () => onSend(),
          child: Text("SHARE MAP", style: TextStyle()),
        ),

      ],
    );
  }
}
