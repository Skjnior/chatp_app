import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatp_app/screens/login_screen.dart';
import 'package:chatp_app/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'components/roundedboutton.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcom_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;


  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(seconds: 1), vsync: this, upperBound: 100.0);
    //controller = AnimationController(duration: Duration(seconds: 1), vsync: this, upperBound: 100.0);

   //animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);

    //animation = ColorTween(begin: Colors.red, end:  Colors.blue).animate(controller);

    controller.forward();
    //controller.reverse();

    //Pour voir le statut de notre animation et faire une animation continue
    /*animation.addStatusListener((status){
      if(status == AnimationStatus.completed){
        controller.reverse(from: 1.0);
      }
      else if(status == AnimationStatus.dismissed){
        controller.forward();
      }
      print(status);
    });*/

    //Pour voir la valeur de notre controller
    controller.addListener((){
      setState(() {});
      print(controller.value);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white.withOpacity(controller.value),
      //backgroundColor: animation.value,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
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
                      child: Image.asset('assets/images/logo.png'),
                      //height: 60.0,
                      //height: controller.value * 100,
                      height: controller.value,
                    ),
                  ),
                 TypewriterAnimatedTextKit(
                   text: ['Chat app'],
                   textStyle: const TextStyle(
                     fontSize: 45.0,
                     fontWeight: FontWeight.w900,
                   ),
                 ),
                 /// Incrémentation du pourcentage
                 /* const Text(
                    //'${controller.value.toInt()}%',
                    'Chat app',
                    style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),*/
                ],
              ),
              const SizedBox(
                height: 48.0,
              ),
              RoundedButton(
                title: "Connexion",
                colour: Colors.lightBlueAccent,
                onPressed: (){
                  Navigator.pushNamed(context, LoginScreen.id);
                  },
              ),
              RoundedButton(
                  title: "Inscription",
                  colour: Colors.blueAccent,
                  onPressed: (){
                    Navigator.pushNamed(context, RegistrationScreen.id);
              })
            ],
          ),
        ),
      ),
    );
  }
}
