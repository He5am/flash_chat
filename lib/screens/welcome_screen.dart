// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, library_private_types_in_public_api, use_key_in_widget_constructors, deprecated_member_use, sort_child_properties_last, non_constant_identifier_names, unused_local_variable, unused_element, prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = "welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),

      vsync: this,
    );
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller!);

    controller!.forward();

    controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation!.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: controller!.value * 100,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Flash Chat',
                        textStyle: TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.black),
                        speed: Duration(milliseconds: 45))
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Button(
                colour: Colors.lightBlueAccent,
                onPressed: (){Navigator.pushNamed(context, LoginScreen.id);  },
                title: "Log In"),
            Button(colour: Colors.blueAccent, title: "Register", onPressed: (){Navigator.pushNamed(context, RegistrationScreen.id);})
          ],
        ),
      ),
    );
  }
}

