import 'package:flutter/material.dart';

class Detailemergency extends StatefulWidget {
  final String foto;
  final String laporan;

  const Detailemergency({Key key, this.foto, this.laporan}) : super(key: key);

  @override
  State<Detailemergency> createState() => _DetailemergencyState();
}

class _DetailemergencyState extends State<Detailemergency> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: ListView(
          children: [
            Text(
              widget.laporan,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 350,
              width: double.infinity,
              child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'http://8.215.39.14/amarta/public/upload/event/' +
                          widget.foto)),
            )
          ],
        ),
      ),
    );
  }
}
