import 'package:chatp_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants_chat.dart';
import 'chat_screen.dart';
import 'components/roundedboutton.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool isRegisted = false;



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
               Flexible(
                 child: Hero(
                   tag: 'logo',
                   child: Container(
                    height: 200.0,
                    child: Image.asset('assets/images/logo.png'),
                               ),
                 ),
               ),
              const SizedBox(
                height: 48.0,
              ),
               TextField(
                 keyboardType: TextInputType.emailAddress,
                 textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:  kTextFieldDecoration.copyWith(hintText: "Votre addresse mail")),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                  decoration:  kTextFieldDecoration.copyWith(hintText: "Votre mot de passe")),
              const SizedBox(
                height: 24.0,
              ),
              isRegisted ?
                  const Center(child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  )
                  )
                  : RoundedButton(
                  title: "S'inscrire",
                  colour: Colors.blue,
                  onPressed: ()async {
                    setState(() {
                      isRegisted = true;
                    });
                    try {
                      final newUser =  await _auth.createUserWithEmailAndPassword(email: email, password: password);
                      // ignore: unnecessary_null_comparison
                      if(newUser !=null) {
                        Navigator.pushNamed(context, LoginScreen.id);
                      }
                    }
                    catch (e) {
                      print(e);
                    }
                    finally {
                      setState(() {
                        isRegisted = false;
                      });
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
