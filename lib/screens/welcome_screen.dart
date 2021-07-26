import 'package:flash_chat/components/padded_button.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {

  static String scrId = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      upperBound: 100,
      vsync: this,
    );
    controller.forward();
    controller.addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ["Flash Chat"],
                  speed: Duration(seconds: 1),
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            PaddedButton(
              btncolor: Colors.lightBlueAccent,
              btntext: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.scrId);
              },
            ),
            PaddedButton(
              btncolor: Colors.blueAccent,
              btntext: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.scrId);
              },
            ),
          ],
        ),
      ),
    );
  }
}
