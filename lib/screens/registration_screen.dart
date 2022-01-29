import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class RegistrationScreen extends StatefulWidget {
  static String id ='registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth= FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag:'logo',

                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                  email = value.toString().trim();
                  //Do something with the user input.
                },
                  decoration:KInputDecoration.copyWith(hintText: 'Enter your Email')

              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                    password = value.toString().trim();
                  //Do something with the user input.
                },
                  decoration:KInputDecoration.copyWith(hintText: 'Enter your Password')

              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.blueAccent,
                title: 'Register',
                onPressed: () async {
                  setState(() {
                    showSpinner=true;
                  });
                  print('email: $email');
                  print('password: $password');
                  try {
                    print('button pressed');
                   /// Navigator.pushNamed(context, ChatScreen .id);

                    final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                    if(newUser!=null){

                      setState(() {
                        showSpinner=false;
                      });
                      print('entered mtd');

                      Navigator.pushNamed(context, ChatScreen .id);
                    }


                  }catch(e){
                    print('errrrr****');
                    setState(() {
                      showSpinner=false;
                    });
                    print(e);
                  }
                  //Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
