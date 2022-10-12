// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, library_private_types_in_public_api, use_key_in_widget_constructors, deprecated_member_use, sort_child_properties_last

import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '/constants.dart';
import '/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import '/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ProgressHUD(child: Builder(builder: (context)=>Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email =value;
                },
                decoration:
                KTextFiekdDecuration.copyWith(hintText: "Enter Your Email"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: KTextFiekdDecuration.copyWith(
                    hintText: "Enter Your Password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              Button(
                  colour: Colors.lightBlueAccent,
                  title: "Log In",
                  onPressed: ()async {
                    try{
                      final progress = ProgressHUD.of(context);
                      setState(() {
                        progress?.show();
                      });
                      final user =await _auth.signInWithEmailAndPassword(email: email!, password: password!);
                      if(user != null){
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                      setState(() {
                        progress?.dismiss();
                      });
                    }
                    catch(e)
                    {print(e);}
                  } ),
            ],
          ),
        ),

      ),
      ),
      ),
    );
  }
}
