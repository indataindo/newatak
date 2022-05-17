import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_map_live/res/custom_colors.dart';
import 'package:google_map_live/screens/allkeranjang.dart';
import 'package:google_map_live/screens/alllocation.dart';
import 'package:google_map_live/screens/dasboard.dart';
import 'package:google_map_live/screens/navpage4.dart';
import 'package:google_map_live/screens/navpage5.dart';

class Navybuttom extends StatefulWidget {
  const Navybuttom({Key key}) : super(key: key);

  @override
  _NavybuttomState createState() => _NavybuttomState();
}

class _NavybuttomState extends State<Navybuttom> {
  int _currentIndex = 0;
  int _counter = 0;
  int _selectedIndex = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  PageController _controller = PageController();
  final List<Widget> _contentPages = <Widget>[
    Dashboard(),
    Alluser(),
    Alllocation(),
    Navpage4(),
    Navpage5(),
  ];

  void initState() {
    // set initial pages for navigation to home page
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(_handleTabSelection);

    super.initState();
    //ambilnomeradmin();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  List<Widget> _pages = [
    Dashboard(),
    Alluser(),
    //  Alllocation(),
    // Navpage4(),
    // Navpage5(),
  ];

  PageController _pageController = new PageController(initialPage: 0);
  DateTime timebackpress = DateTime.now();
  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        final different = DateTime.now().difference(timebackpress);
        final isExitWarning = different >= Duration(seconds: 1);
        timebackpress = DateTime.now();
        if (isExitWarning) {
          final message = 'Press again to exit';
          Fluttertoast.showToast(msg: message, fontSize: 18);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        body: Container(
          child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              children: _pages),
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                activeColor: CustomColors.firebaseOrange,
                inactiveColor: Colors.black,
                title: Text('Home'),
                icon: Icon(Icons.home)),
            BottomNavyBarItem(
                activeColor: CustomColors.firebaseYellow,
                inactiveColor: Colors.black,
                title: Text('Area'),
                icon: Icon(Icons.location_searching)),
/*
            BottomNavyBarItem(
                activeColor: CustomColors.firebaseAmber,
                inactiveColor: Colors.black,
                title: Text('Shop'),
                icon: Icon(CupertinoIcons.list_bullet_below_rectangle)),
            BottomNavyBarItem(
                activeColor: CustomColors.firebaseYellow,
                inactiveColor: Colors.black,
                title: Text('Account'),
                icon: Icon(Icons.manage_accounts_rounded)),
*/
          ],
        ),
      ));

  void _tapNav(index) {
    _currentIndex = index;
    _pageController.jumpToPage(index);

    // this unfocus is to prevent show keyboard in the text field
    FocusScope.of(context).unfocus();
  }

  _buildPage({IconData icon, String title, Color color}) {
    return Container(
      color: color,
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 100, color: Colors.white),
            Text(
              title.toString(),
              style: TextStyle(
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }
}
