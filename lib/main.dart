import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_map_live/core/viewmodels/map_provider.dart';

import 'package:google_map_live/screens/login_screen.dart';
import 'package:google_map_live/wrapper.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

        return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MapProvider(),
        )
      ],
      child: MaterialApp(
        title: "Polymaker",
        theme: ThemeData(
          fontFamily: 'Proxima-Regular',
          accentColor: Colors.orange,
          primaryColor: Colors.orange
        ),
        debugShowCheckedModeBanner: false,
        home: Wrapperr(),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("data"),
    );
  }
}
