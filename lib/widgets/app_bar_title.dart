import 'package:flutter/material.dart';
import 'package:google_map_live/res/custom_colors.dart';

class AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Amarta"),
        SizedBox(width: 8),
        Text(
          'Live-',
          style: TextStyle(
            color: CustomColors.firebaseYellow,
            fontSize: 18,
          ),
        ),
        Text(
          'Location',
          style: TextStyle(
            color: CustomColors.firebaseOrange,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
