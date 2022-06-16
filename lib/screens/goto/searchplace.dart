import 'package:flutter/material.dart';
import 'package:google_map_live/screens/goto/placeservice.dart';

class Searchplace extends StatefulWidget {
  @override
  _SearchplaceState createState() => _SearchplaceState();
}

class _SearchplaceState extends State<Searchplace> {
  final _destinationController = TextEditingController();
  PlaceApi _placeApi = PlaceApi.instance;
  bool buscando = false;
  List<Place> _predictions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  _inputOnChanged(String query) {
    if (query.trim().length > 2) {
      setState(() {
        buscando = true;
      });
      _search(query);
    } else {
      if (buscando || _predictions.length > 0) {
        setState(() {
          buscando = false;
          _predictions = [];
        });
      }
    }
  }

  _search(String query) {
    _placeApi
        .searchPredictions(query)
        .asStream()
        .listen((List<Place> predictions) {
      setState(() {
        buscando = false;
        _predictions = predictions ?? [];
        //  print('Resultados: ${predictions.length}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            buscando
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: _predictions.length,
                        itemBuilder: (_, i) {
                          final Place item = _predictions[i];
                          return ListTile(
                            onTap: () {
                              print("ini contoh lokasi");
                              print(item.description);
                            },
                            title: Text(item.description),
                            leading: Icon(Icons.location_on),
                          );
                        }))
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text(
        "Go To",
        style: TextStyle(
            fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {}),
      bottom: PreferredSize(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Column(
            children: [
              AddressInput(
                iconData: Icons.gps_fixed,
                hintText: "Lokasi ",
                enabled: false,
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  AddressInput(
                    controller: _destinationController,
                    iconData: Icons.place_sharp,
                    hintText: "Tujuan",
                    onChanged: this._inputOnChanged,
                  ),
                  InkWell(
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 28,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        preferredSize: Size.fromHeight(70),
      ),
    );
  }
}

class AddressInput extends StatelessWidget {
  final IconData iconData;
  final TextEditingController controller;
  final String hintText;
  final Function onTap;
  final bool enabled;
  final void Function(String) onChanged;

  const AddressInput({
    Key key,
    this.iconData,
    this.controller,
    this.hintText,
    this.onTap,
    this.enabled,
    this.onChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          this.iconData,
          size: 18,
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 35.0,
            width: MediaQuery.of(context).size.width / 1.4,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.grey[100],
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onTap: onTap,
              enabled: enabled,
              decoration: InputDecoration.collapsed(
                hintText: hintText,
              ),
            ),
          ),
        )
      ],
    );
  }
}
