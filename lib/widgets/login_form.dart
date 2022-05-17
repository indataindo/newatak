import 'package:flutter/material.dart';
import 'package:google_map_live/res/custom_colors.dart';
import 'package:google_map_live/screens/botomnavy.dart';
import 'package:google_map_live/screens/dashboard_screen.dart';
import 'package:google_map_live/utils/database.dart';
import 'package:google_map_live/utils/validator.dart';

import 'custom_form_field.dart';

class LoginForm extends StatefulWidget {
  final FocusNode focusNode;

  const LoginForm({
    Key key,
     this.focusNode,
  }) : super(key: key);
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _uidController = TextEditingController();

  final _loginInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginInFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 24.0,
            ),
            child: Column(
              children: [
                CustomFormField(
                  controller: _uidController,
                  focusNode: widget.focusNode,
                  keyboardType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  validator: (value) => Validator.validateUserID(
                    uid: value,
                  ),
                  label: 'User ID',
                  hint: 'Enter your unique identifier',
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0),
            child: Container(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    CustomColors.firebaseOrange,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  widget.focusNode.unfocus();

                  if (_loginInFormKey.currentState.validate()) {
                    Database.userUid = _uidController.text;
                     Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => Navybuttom(),
                      ),
                    );


                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.firebaseGrey,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
